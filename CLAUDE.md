# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Flutter is not on `PATH` — everything goes through FVM (`.fvmrc` pins the `stable` channel):

```sh
fvm flutter pub get
fvm flutter analyze                 # must be clean; it is today
fvm flutter test                    # ~109 tests, all passing
fvm flutter test test/core/jobs_provider_test.dart          # one file
fvm flutter test --plain-name "loadMore appends the next page"  # one test by name
fvm flutter run                     # needs a device; android/ and ios/ only
fvm dart format lib test
```

Code generation (Freezed + json_serializable). The generated `*.freezed.dart` and
`*.g.dart` files **are committed**, so regenerate and commit them whenever a model changes:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run build_runner watch --delete-conflicting-outputs
```

Localization is generated from `lib/l10n/*.arb` into `lib/l10n/app_localizations*.dart`,
which are **also committed**. `pubspec.yaml` sets `generate: true`, so a build regenerates
them; `fvm flutter gen-l10n` does it on its own.

`.env` (git-ignored, but bundled as a Flutter asset) must define `SUPABASE_URL` and
`SUPABASE_PUBLISHABLE_KEY`. `main.dart` fails with a `ConfigurationException` naming the
missing key rather than a null-check error.

## Architecture

Flutter + Riverpod 3 + GoRouter over a Supabase backend (Postgres table `jobs`, `profiles`,
and a `media` storage bucket). The domain is work orders — "jobs" — filed, worked, and
approved by supervisors and workers.

### Layout

`lib/core/` holds everything more than one feature uses; `lib/features/<name>/presentation/`
holds screens and widgets only that feature uses. Note the consequence: **the entire data
layer lives in `core/`** (`core/data/{models,repositories,sources}`), as do the shared
controllers (`core/presentation/controllers/`) and every job-rendering widget. A feature
directory is usually just screens plus its own widgets. Auth is the one feature with a model
and controller of its own.

### The data chain

`Screen → Provider → Repository → Source (abstract) → RemoteXSource (Supabase)`

The abstract source is the seam: its doc comments are the contract (what each method
throws, what a short page means, what the change feed guarantees), and tests substitute
`test/core/fake_jobs_source.dart` — an in-memory source that pages, filters, and searches the
way the real one is expected to — through `jobsRepositoryProvider`. Repositories are thin
pass-throughs and deliberately do not catch: exceptions travel to the presentation layer,
which picks user-facing copy **from the exception type, never from `message`** (see
`core/presentation/widgets/error_state.dart`, which distinguishes `NetworkException` as the
phone's problem from everything else as the app's).

Filtering, searching, paging, counting, and limiting all happen **at the database**, never
over a loaded list — a client-side filter over one page hides matches behind a scroll that
never reaches them, and counts over loaded pages report whatever the user scrolled past.

### Error taxonomy

`core/errors/exceptions.dart` is a sealed `AppException` hierarchy: `NetworkException`,
`OperationException`, `ParsingException`, `ConfigurationException`, `UnknownException`.
Two wrappers feed it, and code that talks to the backend should use both:

- `remoteRequest(description, request, {timeout})` — wraps every backend call with a deadline
  (20s, `uploadTimeout` 60s) and translates transport failures into `NetworkException`.
  `StorageException` and `AuthException` are deliberately re-thrown unchanged (a refusal, not
  a network failure); `AuthRetryableFetchException` *is* translated.
- `parsePayload(source, parse)` / `parseRows(source, rows, parse)` — row reading happens
  outside `remoteRequest` and fails as an `Error` (`TypeError` for a missing column,
  `ArgumentError` for an unmapped enum), which slips past every `on AppException`.
  `parseRows` skips individual unreadable rows but raises when *every* row fails, since that
  means the table no longer matches the model.

### Jobs: state machine and the change feed

`Job` (`core/data/models/job.dart`) is a Freezed class holding a sealed `JobState` union.
`JobStatus` is the flat discriminator for comparing/grouping; `JobAction` is the transition.
`Job.availableActions` and `Job.apply(action, actorId:, reason:)` are the single source of
truth for the lifecycle — an illegal move throws `StateError` in Dart rather than reaching the
database. Wire format lives in `JobStatusColumn.storedName` (`in_progress`, etc.), stored in a
JSONB `state` column as `{status, payload}` via `_JobStateConverter`; changing one of those
strings needs a migration. `json_serializable` is configured `field_rename: snake` in
`build.yaml`.

Realtime is a **change feed, not a snapshot feed**: `watchJobs()` emits `JobChange.upserted` /
`.removed` / `.desynced`, because the reads are filtered and paged at the source and none of
that can be re-derived from a pushed snapshot. `JobsNotifier` reconciles changes into loaded
pages (using `JobsQuery.matches`, a deliberate client-side mirror of the source's query, and
`_newestFirst`, a mirror of its `ORDER BY`) instead of refetching, so scroll position and later
pages survive. `.desynced` — emitted on every reconnect after the first, since Postgres does
not replay what it missed — triggers a refetch of the whole loaded window.

Derived providers (`recentJobsProvider`, `jobStatusCountsProvider`) each listen to
`jobChangesProvider` for themselves rather than being driven by `JobsNotifier`, because the
home screen watches them without ever building the paged list. The app's *own* writes
additionally invalidate them directly so the result lands before the socket confirms it.

`jobChangesProvider` is intentionally **not** auto-disposed (one socket for the whole app,
surviving tab changes); `AuthNotifier.logout` is what tears it down along with the cached jobs.

Both change feeds (`jobChangesProvider`, `notificationChangesProvider`) are `StreamNotifier`s
overriding `updateShouldNotify` to **always** notify, and must stay that way. Riverpod tells
listeners only when the new state differs from the old by `==`, so a feed that delivers the
same event twice — two `JobsDesynced()`, or any two events at all on the notifications feed,
whose payload is `void` — silently drops the second. That bug made every notification after
the channel's join event invisible until the app was restarted. A plain `StreamProvider` has
no hook to override, which is the only reason these are notifiers.

### Notifications

A supervisor is told when one of their workers files a job or submits one for approval.
`profiles.supervisor_id` (self-FK) is what routes it, and rows are written **only** by the
`jobs_notify_supervisor` trigger — there is no insert policy and no insert grant, so a client
cannot forge, skip, or misaddress one. Clients may write `read_at` and nothing else, enforced
by a column grant rather than RLS (RLS has no column scope).

The table stores **no user-facing text**: the app renders in en + ar, so a stored sentence
would be unreadable in the other locale. Rows carry `kind` + `job_id` + `actor_id` and the
widget composes the sentence.

Its feed is deliberately simpler than the jobs one — `Stream<void>`, not a change union. Jobs
reconcile events because refetching would discard scroll position and loaded pages; a capped
notification list has neither, so any event (a reconnect included) just means "ask again".
Unread count is a separate `count` query for the same reason `jobStatusCountsProvider` is:
the list is capped, so counting it would under-report.

The badge is `_NotificationsButton` in `main_scaffold.dart` — its own `ConsumerWidget` so a
count change rebuilds the button rather than the shell every screen sits under. A count that
failed to load shows no number rather than an error: the badge is an invitation, and the
error belongs on the screen behind it.

### Database schema

Lives in `supabase/migrations/*.sql` — the only version-controlled record of it. Neither the
`supabase` CLI nor `psql` is installed here, so migrations are applied through the Supabase
dashboard's SQL editor unless someone installs the CLI (`supabase db push`). Every statement
is written to be re-runnable (`if not exists`, `drop ... if exists`, and a guarded
`alter publication`).

One trap worth knowing: a policy on `profiles` that queries `profiles` recurses and aborts
with `42P17`. `public.supervisor_of(uuid)` is `security definer` precisely to break that —
use it instead of an inline subquery whenever a policy needs the supervisor relationship.

### Timestamps

Every instant crosses the wire as UTC via `core/data/models/instant.dart` (`UtcDateTime` /
`NullableUtcDateTime` converters, `instantToJson`/`instantFromJson`). `toIso8601String()` on a local `DateTime`
writes no zone at all and Postgres then reads that wall clock as UTC. On the way back the zone
suffix is detected in the *string*, because `DateTime.parse` flags only `…Z` as `isUtc`.
Relative times ("2h ago") come from `DateTimeExt.toRelativeTime`, driven by
`nowProvider` (a 30s ticking clock) so an open list does not freeze on "Just now".

### Media

Photos are captured on `CameraScreen`, uploaded on **save** (before the row is inserted, so no
row ever points at media that never arrived), and stored as a **bucket-relative** path
(`images/123.jpg`). The storage client adds the bucket prefix itself, so persisting the
prefixed key that `upload()` returns would double it. Reads go through `mediaUrlProvider`,
which signs a 1-hour URL and degrades to null (→ placeholder) rather than failing the screen.

### Auth and routing

`routerProvider` redirects on `authProvider.notifier.isAuthenticated()`, which reads the
Supabase session directly. `/`, `/jobs`, `/settings` sit inside a `ShellRoute` with the bottom
nav (`MainScaffold`); `/profile`, `/notifications`, `/jobs/new`, `/jobs/new/camera`,
`/jobs/:id` sit outside it deliberately, so they get a back button and no highlighted
destination. `/jobs/:id` takes the
job via `extra` as an optimisation but must work from the id alone — `extra` is lost on a deep
link or restored route, which is what `jobByIdProvider` exists for.

Row-level security decides which rows a user sees; queries never scope by user themselves.
The one leak, documented in `RemoteJobsSource.watchJobs`, is that Postgres sends only the key
with a deletion, so deletes reach every subscriber.

## Conventions

- **Comments explain why, not what.** The existing code documents the failure that motivated
  a decision (the timezone bug, the ordering tie-break, the doubled bucket prefix). Match that
  density and register — a new non-obvious choice deserves the same treatment; a self-evident
  line deserves nothing.
- **All user-facing strings go through `AppLocalizations`** (`lib/l10n/app_en.arb` +
  `app_ar.arb`). Arabic means RTL: `test/features/create_job_screen_test.dart` checks the
  create screen lays out in Arabic on a narrow viewport without overflowing. Enum display
  labels live in extensions next to the enum (`JobStatusLabel`, `UserRoleLabel`).
- **Colours come from `ColorScheme` roles**, never literals, so light/dark/high-contrast all
  follow. Per-status icons and colours are centralised in `JobStatusStyle.of`.
- **`riverpod_lint` is intentionally absent** — see the comment in `analysis_options.yaml`. It
  pins `analyzer <=8` through `custom_lint` while `json_serializable` needs `>=10`; adding a
  `plugins:` block silently enforces nothing. Do not "fix" this by re-adding it.
- Tests use `ProviderScope(overrides: […])` with `FakeJobsSource` and the fixtures in
  `test/core/job_fixtures.dart`, and wire real `GoRouter` routes so navigation is tested
  against where it actually lands.

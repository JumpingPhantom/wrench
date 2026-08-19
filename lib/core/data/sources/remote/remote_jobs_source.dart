import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/job_change.dart';
import 'package:wrench/core/data/parsing.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/remote_request.dart';
import 'package:wrench/core/network/supabase_client.dart';

/// Supabase-backed [JobsSource]: rows in the `jobs` table, media in
/// [mediaBucket].
///
/// Which rows come back is decided by row-level security rather than by any
/// filter here, so the queries below never scope by user themselves. The same
/// holds for [watchJobs], with one exception noted there.
class RemoteJobsSource implements JobsSource {
  static const mediaBucket = "media";
  static const _recentJobsLimit = 4;

  /// Topic the change feed subscribes to. `channel()` does not deduplicate by
  /// name, so a feed removes its own channel when it ends rather than leaving a
  /// second one on the socket for the next listener to trip over.
  static const _changesChannel = "public:jobs";

  /// Reads one window of the table, narrowed by status and search before it
  /// leaves the database.
  ///
  /// Ordered newest first, with the id breaking ties: two jobs sharing a
  /// timestamp have no order of their own, and Postgres is free to return them
  /// differently on each request — which in a paged list can show one row twice
  /// and skip another entirely.
  @override
  Future<List<Job>> getJobsPage({
    required int offset,
    required int limit,
    JobStatus? status,
    String? search,
  }) async {
    var query = client.from("jobs").select("*");

    if (status != null) {
      query = query.eq("state->>status", status.storedName);
    }

    final term = _searchTerm(search);

    if (term != null) {
      query = query.or("title.ilike.%$term%,location.ilike.%$term%");
    }

    final rows = await remoteRequest(
      "load jobs page at $offset",
      () => query
          .order("created_at", ascending: false)
          .order("id", ascending: false)
          .range(offset, offset + limit - 1),
    );

    return parseRows("jobs", rows, Job.fromJson);
  }

  /// Strips what `or()` reads as syntax before the term reaches it.
  ///
  /// The filter is assembled as a string, so a comma would start a new
  /// condition, a parenthesis would close the group, and `%` would widen the
  /// match — a search for "a,b" must not turn into a query the user did not
  /// ask for. Returns null when nothing searchable is left.
  String? _searchTerm(String? search) {
    final term = search?.replaceAll(RegExp(r'[,()%*\\]'), " ").trim();
    return term == null || term.isEmpty ? null : term;
  }

  @override
  Future<Job?> getJob(int id) async {
    final row = await remoteRequest(
      "load job $id",
      () => client.from("jobs").select("*").eq("id", id).maybeSingle(),
    );

    return row == null ? null : parsePayload("jobs", () => Job.fromJson(row));
  }

  /// Tallies statuses over a single column.
  ///
  /// One request returning just `state` beats five head-counts with a filter
  /// each, and the column is small enough that the saving is worth the rows.
  @override
  Future<Map<JobStatus, int>> getStatusCounts({String? createdBy}) async {
    var query = client.from("jobs").select("state");

    if (createdBy != null) {
      query = query.eq("created_by", createdBy);
    }

    final rows = await remoteRequest("count jobs by status", () => query);

    return parsePayload("jobs", () {
      final counts = {for (final status in JobStatus.values) status: 0};

      for (final row in rows) {
        final state = row["state"] as Map<String, dynamic>?;
        final status = JobStatusColumn.fromStored(state?["status"] as String?);

        if (status != null) counts[status] = counts[status]! + 1;
      }

      return counts;
    });
  }

  /// Applies [_recentJobsLimit] in the query rather than after the fact, so the
  /// request stays the same size however long the history gets.
  @override
  Future<List<Job>> getRecentJobs() async {
    // Postgres makes no ordering guarantee without an explicit ORDER BY, so
    // the limit below would otherwise return an arbitrary four rows.
    final rows = await remoteRequest(
      "load recent jobs",
      () => client
          .from("jobs")
          .select("*")
          .order("created_at", ascending: false)
          .order("id", ascending: false)
          .limit(_recentJobsLimit),
    );

    return parseRows("jobs", rows, Job.fromJson);
  }

  /// Changes to the `jobs` table, over a Supabase realtime channel.
  ///
  /// The channel is opened when the first listener arrives and torn down when
  /// the last one leaves, so nothing holds a socket open for a screen that is
  /// no longer watching.
  ///
  /// Row-level security applies here as it does to the queries above, with one
  /// exception: Postgres sends no row with a deletion, only the key, so a
  /// delete cannot be matched against a policy and reaches every subscriber.
  /// That leaks an id and the fact that something was removed. Nothing else.
  @override
  Stream<JobChange> watchJobs() {
    late final StreamController<JobChange> controller;
    RealtimeChannel? channel;

    // The first join is the feed starting; every later one is it coming back,
    // and Postgres does not replay what was committed while it was away. So the
    // second `subscribed` onwards is reported as a gap the listener must close
    // by fetching again.
    var joined = false;

    // Set while the feed is being taken down on purpose, so the statuses that
    // teardown produces are not reported as the connection failing.
    var closing = false;

    void open() {
      channel = client
          .channel(_changesChannel)
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "jobs",
            callback: (payload) => _emitChange(controller, payload),
          )
          .subscribe((status, error) {
            switch (status) {
              case RealtimeSubscribeStatus.subscribed:
                if (joined) controller.add(const JobChange.desynced());
                joined = true;
              case RealtimeSubscribeStatus.channelError:
              case RealtimeSubscribeStatus.timedOut:
              case RealtimeSubscribeStatus.closed:
                // Left to the client, which rejoins on its own. The rejoin is
                // what reports the gap, so there is nothing to emit here.
                if (closing) return;

                AppLogger.warning(
                  "Jobs change feed is ${status.name}"
                  "${error == null ? "" : ": $error"}",
                );
            }
          });
    }

    Future<void> close() async {
      final open = channel;
      channel = null;
      joined = false;
      closing = true;

      if (open != null) await client.removeChannel(open);

      closing = false;
    }

    controller = StreamController<JobChange>.broadcast(
      onListen: open,
      onCancel: close,
    );

    return controller.stream;
  }

  /// Turns one realtime payload into a [JobChange], or into nothing.
  ///
  /// A row that will not parse is logged and dropped rather than raised: the
  /// feed is the app's only notice that its jobs have gone stale, and one
  /// unreadable row must not take it down with it — the same rule [parseRows]
  /// applies to a page.
  void _emitChange(
    StreamController<JobChange> controller,
    PostgresChangePayload payload,
  ) {
    switch (payload.eventType) {
      case PostgresChangeEvent.insert:
      case PostgresChangeEvent.update:
        try {
          controller.add(
            JobChange.upserted(
              parsePayload("jobs", () => Job.fromJson(payload.newRecord)),
            ),
          );
        } on ParsingException catch (e) {
          AppLogger.error("Dropping an unreadable job from the change feed", e);
        }
      case PostgresChangeEvent.delete:
        // Only the key comes back with a deletion, and only when the table's
        // replica identity carries one. Without it there is no way to say which
        // job went, so the whole window is treated as suspect instead.
        final id = payload.oldRecord["id"];

        controller.add(
          id is int ? JobChange.removed(id) : const JobChange.desynced(),
        );
      case PostgresChangeEvent.all:
        // Never delivered: `all` is what a subscription asks for, not what an
        // event is.
        break;
    }
  }

  /// Inserts [job], rewriting [Job.mediaUrl] from the local capture path to the
  /// stored object path on the way through.
  @override
  Future<void> saveJob(Job job) async {
    final localPath = job.mediaUrl;

    // Upload before inserting: a job row pointing at media that never made it
    // to storage is worse than no row at all, since nothing retries it later.
    if (localPath != null) {
      job = job.copyWith(mediaUrl: await _uploadMedia(localPath));
    }

    await remoteRequest(
      "save job",
      () => client.from("jobs").insert(job.toJson()),
    );
  }

  /// Sends only the mutable columns; media is not re-uploaded here, so an
  /// update cannot replace a job's photo.
  @override
  Future<Job> updateJob(Job job) async {
    final id = job.id;

    if (id == null) {
      throw OperationException(
        message: "Cannot update a job that has never been saved",
      );
    }

    // Only the mutable columns are sent. Identity and provenance are fixed at
    // creation, and replaying them here would collide with any row-level
    // policy that (correctly) forbids reassigning a job's author.
    final payload = job.toJson()
      ..remove("id")
      ..remove("created_at")
      ..remove("created_by");

    final row = await remoteRequest(
      "update job $id",
      () => client.from("jobs").update(payload).eq("id", id).select().single(),
    );

    return parsePayload("jobs", () => Job.fromJson(row));
  }

  /// Uploads the captured file and returns its **bucket-relative** object path.
  ///
  /// [StorageFileApi.upload] returns a bucket-prefixed key ("media/images/..."),
  /// but every read path — `createSignedUrl` in particular — prefixes the
  /// bucket itself. Storing the returned key would double the prefix and make
  /// the media unreadable, so the path we uploaded to is what gets persisted.
  Future<String> _uploadMedia(String localPath) async {
    final objectPath =
        "images/${DateTime.now().millisecondsSinceEpoch}"
        "${p.extension(localPath)}";

    try {
      await remoteRequest(
        "upload job media",
        () => client.storage
            .from(mediaBucket)
            .upload(objectPath, File(localPath)),
        timeout: uploadTimeout,
      );

      return objectPath;
    } on StorageException catch (e, stackTrace) {
      AppLogger.error("Failed to upload job media", e, stackTrace);
      throw OperationException(message: e.message, stackTrace: stackTrace);
    }
  }

  /// Not implemented: jobs are cancelled through [updateJob] rather than
  /// removed, and nothing in the app deletes one yet.
  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError("deleteJob is not implemented yet");
  }
}

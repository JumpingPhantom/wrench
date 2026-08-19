import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/theme/job_status_style.dart';
import 'package:wrench/core/presentation/widgets/detail_row.dart';
import 'package:wrench/core/presentation/widgets/error_state.dart';
import 'package:wrench/core/presentation/widgets/job_image.dart';
import 'package:wrench/core/presentation/widgets/job_image_viewer.dart';
import 'package:wrench/core/presentation/widgets/job_status_chip.dart';
import 'package:wrench/core/presentation/widgets/relative_time.dart';
import 'package:wrench/core/presentation/widgets/section_card.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Resolves which job to show before handing off to [_JobDetailView].
///
/// Navigating from a list passes the job directly, but the route can also be
/// entered without one (a restored route, a deep link), and the list is paged,
/// so the job may not be loaded at all. [jobByIdProvider] covers both: the
/// loaded pages first, the source only when they come up empty.
class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.jobId, this.job});

  final int? jobId;
  final Job? job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final id = jobId ?? job?.id;

    if (id == null) {
      final passed = job;
      return passed == null
          ? _Message(text: l10n.jobNotFound, l10n: l10n)
          : _JobDetailView(job: passed);
    }

    final resolved = ref.watch(jobByIdProvider(id));

    // The looked-up copy wins over the one passed in `extra`, which is a fixed
    // snapshot: without this a state transition made elsewhere would not show
    // up until the route was reopened.
    final found = resolved.value ?? job;

    if (found != null) return _JobDetailView(job: found);

    // A lookup that failed is not a job that does not exist: saying "not found"
    // when the phone is offline sends the user looking for the wrong problem.
    return switch (resolved) {
      AsyncError(:final error) => _Message(
        l10n: l10n,
        child: ErrorState(
          error: error,
          onRetry: () => ref.invalidate(jobByIdProvider(id)),
        ),
      ),
      AsyncLoading() => _Message(
        l10n: l10n,
        child: const CircularProgressIndicator(),
      ),
      _ => _Message(text: l10n.jobNotFound, l10n: l10n),
    };
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.l10n, this.text, this.child});

  final AppLocalizations l10n;
  final String? text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetails)),
      body: Center(child: child ?? Text(text!)),
    );
  }
}

class _JobDetailView extends ConsumerStatefulWidget {
  const _JobDetailView({required this.job});

  final Job job;

  @override
  ConsumerState<_JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends ConsumerState<_JobDetailView> {
  bool _busy = false;

  /// The row a transition just returned.
  ///
  /// Held here because a job opened by deep link is not in the paged list, so
  /// there is nothing for the provider to update — without this the screen
  /// would still show the state the job just left.
  Job? _transitioned;

  Job get job => _transitioned ?? widget.job;

  @override
  void didUpdateWidget(_JobDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fresh data from the provider supersedes the local copy.
    if (widget.job != oldWidget.job) _transitioned = null;
  }

  /// Runs [action] against the backend, prompting first when it needs input.
  Future<void> _run(JobAction action) async {
    final l10n = AppLocalizations.of(context)!;
    String? reason;

    if (action == JobAction.cancel) {
      reason = await showDialog<String>(
        context: context,
        builder: (context) => const _CancelJobDialog(),
      );

      // A dismissed dialog is a decision not to cancel, not a failure.
      if (reason == null) return;
    }

    setState(() => _busy = true);

    try {
      final updated = await ref
          .read(jobsProvider.notifier)
          .applyAction(job, action, reason: reason);

      if (mounted) setState(() => _transitioned = updated);
    } on AppException {
      _showError(l10n.jobUpdateFailed);
    } catch (e, stackTrace) {
      // Nothing may leave this method uncaught: the button is busy until the
      // `finally` below runs, and an escaping error would leave it spinning.
      AppLogger.error("Unexpected failure applying $action", e, stackTrace);
      _showError(l10n.jobUpdateFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = JobStatusStyle.of(job.status, colors);
    final reason = job.cancellationReason;
    final actions = job.availableActions;

    // The advancing move, if the state has one. Cancelling is deliberately not
    // treated as a peer of it — see [_HeaderBar].
    JobAction? advance;
    for (final action in actions) {
      if (action != JobAction.cancel) advance = action;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HeaderBar(
            job: job,
            style: style,
            l10n: l10n,
            onCancel: actions.contains(JobAction.cancel) && !_busy
                ? () => _run(JobAction.cancel)
                : null,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList.list(
              children: [
                Text(
                  job.title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    JobStatusChip(status: job.status),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    RelativeTime(
                      timestamp: job.createdAt,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // A cancelled job left the track rather than finishing it, so
                // showing the steps would only claim progress it never made.
                if (reason != null)
                  SectionCard(
                    accent: colors.error,
                    title: l10n.cancellationReason,
                    child: _Cancellation(job: job, reason: reason, l10n: l10n),
                  )
                else
                  SectionCard(
                    title: l10n.progress,
                    child: Column(
                      children: [
                        _ProgressTrack(job: job, l10n: l10n),
                        if (advance != null)
                          _NextStep(
                            action: advance,
                            busy: _busy,
                            onPressed: () => _run(advance!),
                            l10n: l10n,
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),
                SectionCard(
                  title: l10n.details,
                  child: Column(children: _detailRows(l10n)),
                ),
                if (job.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SectionCard(
                    title: l10n.description,
                    child: Text(
                      job.description,
                      style: textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Location, who filed the job, and — where the state records one — who moved
  /// it last. Draft and staged name no actor, so they contribute no row.
  List<Widget> _detailRows(AppLocalizations l10n) {
    final rows = <Widget>[
      DetailRow(icon: Icons.location_on_outlined, label: job.location),
      DetailRow(
        icon: Icons.person_outline,
        label: l10n.createdBy(_userName(job.createdBy, l10n)),
      ),
    ];

    final actor = job.actorId;

    if (actor != null) {
      final name = _userName(actor, l10n);
      final label = switch (job.status) {
        JobStatus.inProgress => l10n.startedBy(name),
        JobStatus.finished => l10n.approvedBy(name),
        JobStatus.cancelled => l10n.cancelledBy(name),
        JobStatus.draft || JobStatus.staged => null,
      };

      if (label != null) {
        rows.add(DetailRow(icon: Icons.how_to_reg_outlined, label: label));
      }
    }

    return [
      for (var i = 0; i < rows.length; i++) ...[
        if (i > 0) const SizedBox(height: 14),
        rows[i],
      ],
    ];
  }

  /// A user's display name, falling back to a placeholder while the profile
  /// list loads or when it cannot be resolved at all.
  String _userName(String id, AppLocalizations l10n) {
    return ref
        .watch(userByIdProvider(id))
        .when(
          data: (user) => user?.fullName ?? l10n.unknownUser,
          loading: () => "…",
          error: (_, _) => l10n.unknownUser,
        );
  }
}

/// The one move that carries the job forward, attached to the track it moves it
/// along.
///
/// It sits inside the progress card rather than in a bar at the foot of the
/// screen so the button reads as the next step on the track above it, and so
/// the destructive move is nowhere near it.
class _NextStep extends StatelessWidget {
  const _NextStep({
    required this.action,
    required this.busy,
    required this.onPressed,
    required this.l10n,
  });

  final JobAction action;
  final bool busy;
  final VoidCallback onPressed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // The button wears the colour of the state it moves the job into, so the
    // status the job is about to take is visible before it is taken.
    final next = JobStatusStyle.of(action.outcome, colors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            children: [
              Expanded(child: Divider(color: colors.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  l10n.nextStep,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colors.outlineVariant)),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: busy ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: next.accent,
              foregroundColor: next.onAccent,
              shape: const StadiumBorder(),
              textStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: busy
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: next.onAccent,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(next.icon, size: 20),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          action.label(l10n),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// Collapsing header: the job photo where there is one, and a wash of the
/// status colour where there is not.
///
/// The bar keeps a solid background of its own because [FlexibleSpaceBar] fades
/// the photo out as it collapses — without one, the title would end up over
/// bare surface in whatever colour suited the photo.
class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.job,
    required this.style,
    required this.l10n,
    this.onCancel,
  });

  final Job job;
  final JobStatusStyle style;
  final AppLocalizations l10n;

  /// Cancelling lives up here, one step removed, rather than beside the button
  /// that advances the job: it is the one move that cannot be undone, and a
  /// pair of side-by-side buttons invites hitting the wrong one.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final path = job.mediaUrl;

    return SliverAppBar(
      pinned: true,
      expandedHeight: path == null ? 140 : 280,
      // Matching the full-screen viewer's black chrome, so opening the photo
      // and coming back is one continuous surface rather than two.
      backgroundColor: path == null ? style.container : Colors.black,
      foregroundColor: path == null ? style.onContainer : Colors.white,
      title: Text(l10n.jobDetails),
      actions: [
        if (onCancel != null)
          PopupMenuButton<void>(
            tooltip: l10n.cancelJob,
            itemBuilder: (context) => [
              PopupMenuItem<void>(
                onTap: onCancel,
                child: Row(
                  children: [
                    Icon(Icons.block, size: 20, color: colors.error),
                    const SizedBox(width: 12),
                    Text(l10n.cancelJob, style: TextStyle(color: colors.error)),
                  ],
                ),
              ),
            ],
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: path == null
            ? _StatusWash(style: style, colors: colors)
            : _Photo(path: path, l10n: l10n),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.path, required this.l10n});

  final String path;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: l10n.viewPhoto,
      child: GestureDetector(
        onTap: () => showJobImage(context, path),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: jobImageHeroTag(path),
              child: JobImage(path: path, height: double.infinity),
            ),
            // Scrims at both ends: the top one carries the toolbar, the bottom
            // one keeps the photo from running flat into the content below.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent, Colors.black26],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stand-in header for a job with no photo: the status colour, washed across
/// the bar behind an oversized copy of its icon.
class _StatusWash extends StatelessWidget {
  const _StatusWash({required this.style, required this.colors});

  final JobStatusStyle style;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [style.container, colors.surface],
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: Icon(
            style.icon,
            size: 110,
            color: style.accent.withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}

/// The lifecycle as a track: where the job has been, where it is, what is left.
///
/// Only the current state carries a timestamp (see [Job.stateChangedAt]), so
/// the steps behind it are marked as passed without claiming to know when.
class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.job, required this.l10n});

  static const _steps = [
    JobStatus.draft,
    JobStatus.inProgress,
    JobStatus.staged,
    JobStatus.finished,
  ];

  final Job job;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final current = _steps.indexOf(job.status);
    final changedAt = job.stateChangedAt;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _steps.length; i++)
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 34,
                      child: Row(
                        children: [
                          _Connector(show: i > 0, done: i <= current),
                          _Node(
                            status: _steps[i],
                            done: i < current,
                            current: i == current,
                          ),
                          _Connector(
                            show: i < _steps.length - 1,
                            done: i < current,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _steps[i].label(l10n),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: i <= current
                            ? colors.onSurface
                            : colors.onSurfaceVariant.withValues(alpha: 0.6),
                        fontWeight: i == current
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _TimeRow(
          icon: Icons.schedule,
          color: colors.onSurfaceVariant,
          timestamp: job.createdAt,
          prefix: l10n.created,
        ),
        if (changedAt != null) ...[
          const SizedBox(height: 8),
          _TimeRow(
            icon: JobStatusStyle.of(job.status, colors).icon,
            color: JobStatusStyle.of(job.status, colors).accent,
            timestamp: changedAt,
            prefix: job.status.label(l10n),
          ),
        ],
      ],
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({
    required this.status,
    required this.done,
    required this.current,
  });

  final JobStatus status;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = JobStatusStyle.of(status, colors);
    final reached = done || current;
    final size = current ? 34.0 : 28.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: reached ? style.container : Colors.transparent,
        border: Border.all(
          color: current
              ? style.accent
              : colors.outlineVariant.withValues(alpha: done ? 0 : 1),
          width: current ? 2 : 1,
        ),
      ),
      // A step still ahead gets a plain dot rather than its own icon: the
      // finished step's icon is a tick, and showing it early would read as a
      // job that is already done.
      child: reached
          ? Icon(
              done ? Icons.check : style.icon,
              size: current ? 18 : 15,
              color: style.onContainer,
            )
          : Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.outlineVariant,
                ),
              ),
            ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.show, required this.done});

  final bool show;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        height: 2,
        color: !show
            ? Colors.transparent
            : done
            ? colors.primary
            : colors.outlineVariant,
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.icon,
    required this.color,
    required this.timestamp,
    this.prefix,
  });

  final IconData icon;
  final Color color;
  final DateTime timestamp;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: RelativeTime(
            timestamp: timestamp,
            prefix: prefix,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

/// Why a cancelled job ended, and when.
class _Cancellation extends StatelessWidget {
  const _Cancellation({
    required this.job,
    required this.reason,
    required this.l10n,
  });

  final Job job;
  final String reason;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cancelledAt = job.stateChangedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reason,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
        ),
        if (cancelledAt != null) ...[
          const SizedBox(height: 12),
          _TimeRow(
            icon: Icons.schedule,
            color: colors.error,
            timestamp: cancelledAt,
          ),
        ],
      ],
    );
  }
}

/// Collects the reason a job is being cancelled.
///
/// The reason is required by [Job.apply], and it is the only record of why a
/// job ended this way, so the dialog will not close without one.
class _CancelJobDialog extends StatefulWidget {
  const _CancelJobDialog();

  @override
  State<_CancelJobDialog> createState() => _CancelJobDialogState();
}

class _CancelJobDialogState extends State<_CancelJobDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(Icons.block, color: colors.error),
      title: Text(l10n.cancelJob),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cancelJobPrompt),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              onFieldSubmitted: (_) => _confirm(),
              decoration: InputDecoration(
                labelText: l10n.cancelReasonLabel,
                hintText: l10n.cancelReasonHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.reasonRequired
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.keepJob),
        ),
        FilledButton(
          onPressed: _confirm,
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
          ),
          child: Text(l10n.cancelJob),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/job_image.dart';
import 'package:wrench/core/presentation/widgets/job_image_viewer.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/features/home/presentation/controllers/home_provider.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Resolves which job to show before handing off to [_JobDetailView].
///
/// Navigating from a list passes the job directly, but the route can also be
/// entered without one (a restored route, a deep link), so the id from the path
/// is used to look the job up in the already-loaded list.
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

    final jobs = ref.watch(jobsProvider);

    // The list's copy wins over the one passed in `extra`, which is a fixed
    // snapshot: without this a state transition made on this screen would not
    // show up until the route was reopened.
    final resolved = _find(jobs.value, id) ?? job;

    if (resolved != null) return _JobDetailView(job: resolved);

    return jobs.isLoading
        ? _Message(l10n: l10n, child: const CircularProgressIndicator())
        : _Message(text: l10n.jobNotFound, l10n: l10n);
  }

  Job? _find(List<Job>? jobs, int id) {
    for (final candidate in jobs ?? const <Job>[]) {
      if (candidate.id == id) return candidate;
    }
    return null;
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

  Job get job => widget.job;

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
      await ref
          .read(jobsProvider.notifier)
          .applyAction(job, action, reason: reason);

      // Home reads its own copy of the list, so without this its counters and
      // recent-jobs card keep showing the status this job just left.
      ref.invalidate(homeProvider);
    } on AppException {
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaPath = job.mediaUrl;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetails)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mediaPath != null) ...[
              _Media(path: mediaPath, l10n: l10n),
              const SizedBox(height: 16),
            ],
            Text(
              job.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    job.statusLabel(l10n),
                    style: textTheme.labelSmall,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Text(
                  job.createdAt.toRelativeTime(l10n),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow(icon: Icons.location_on_outlined, label: job.location),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.person_outline,
              label: l10n.createdBy(_userName(job.createdBy, l10n)),
            ),
            ..._stateDetails(l10n),
            const SizedBox(height: 24),
            Text(
              l10n.description,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(job.description, style: textTheme.bodyLarge),
          ],
        ),
      ),
      bottomNavigationBar: _ActionBar(
        actions: job.availableActions,
        busy: _busy,
        onSelected: _run,
        l10n: l10n,
      ),
    );
  }

  /// Rows describing how the job reached its current state — who moved it and,
  /// for a cancelled job, why. Draft and staged record neither, so they add
  /// nothing here.
  List<Widget> _stateDetails(AppLocalizations l10n) {
    final actor = job.actorId;
    final reason = job.cancellationReason;
    final rows = <Widget>[];

    if (actor != null) {
      final name = _userName(actor, l10n);
      final label = switch (job.status) {
        JobStatus.inProgress => l10n.startedBy(name),
        JobStatus.finished => l10n.approvedBy(name),
        JobStatus.cancelled => l10n.cancelledBy(name),
        JobStatus.draft || JobStatus.staged => null,
      };

      if (label != null) {
        rows
          ..add(const SizedBox(height: 12))
          ..add(_DetailRow(icon: Icons.how_to_reg_outlined, label: label));
      }
    }

    if (reason != null) {
      rows
        ..add(const SizedBox(height: 12))
        ..add(
          _DetailRow(
            icon: Icons.block_outlined,
            label: "${l10n.cancellationReason}: $reason",
          ),
        );
    }

    return rows;
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

/// The job photo, tappable to open full screen.
class _Media extends StatelessWidget {
  const _Media({required this.path, required this.l10n});

  final String path;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: l10n.viewPhoto,
      child: GestureDetector(
        onTap: () => showJobImage(context, path),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Hero(
            tag: jobImageHeroTag(path),
            child: JobImage(path: path, height: 200),
          ),
        ),
      ),
    );
  }
}

/// Bottom bar offering the transitions legal from the job's current state.
///
/// Renders nothing at all for a terminal job, so a finished or cancelled job
/// shows no bar rather than a row of disabled buttons.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.actions,
    required this.busy,
    required this.onSelected,
    required this.l10n,
  });

  final Set<JobAction> actions;
  final bool busy;
  final ValueChanged<JobAction> onSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final canCancel = actions.contains(JobAction.cancel);

    JobAction? advance;
    for (final action in actions) {
      if (action != JobAction.cancel) advance = action;
    }

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        spacing: 12,
        children: [
          if (canCancel)
            Expanded(
              child: OutlinedButton(
                onPressed: busy ? null : () => onSelected(JobAction.cancel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                ),
                child: Text(JobAction.cancel.label(l10n)),
              ),
            ),
          if (advance != null)
            Expanded(
              child: FilledButton(
                onPressed: busy ? null : () => onSelected(advance!),
                child: busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(advance.label(l10n)),
              ),
            ),
        ],
      ),
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

    return AlertDialog(
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
                border: const OutlineInputBorder(),
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
        FilledButton(onPressed: _confirm, child: Text(l10n.cancelJob)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

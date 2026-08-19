import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/detail_row.dart';
import 'package:wrench/core/presentation/widgets/section_card.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_form_fields.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_photo_section.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Filing a job, one question at a time: what it is, where it is, and what it
/// looks like.
///
/// Three steps rather than one long form because the three answers come from
/// different places — the first is typed, the second is picked, the third is
/// photographed — and a step can refuse to advance without its answer, which is
/// how a required field gets to say so at the moment it is missing.
///
/// The screen also owns the save. It used to pop a [Job] back to the jobs list
/// and let that screen store it, which meant a failed photo upload was reported
/// on a screen the user had already left, with the draft and the photo gone.
class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  static const _stepCount = 3;

  final _pageController = PageController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  int _step = 0;
  String? _location;
  File? _photo;
  bool _saving = false;
  String? _saveError;

  /// Set when a step is asked to advance without its answers, so a field stays
  /// quiet until the user has actually claimed to be done with it.
  bool _showErrors = false;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  String get _title => _titleController.text.trim();

  String get _description => _descriptionController.text.trim();

  bool get _isDirty =>
      _title.isNotEmpty ||
      _description.isNotEmpty ||
      _location != null ||
      _photo != null;

  /// The photo step has nothing required in it, so it is always complete — its
  /// button files the job rather than moving on.
  bool _isComplete(int step) => switch (step) {
    0 => _title.isNotEmpty && _description.isNotEmpty,
    1 => _location != null,
    _ => true,
  };

  void _goTo(int step) {
    setState(() {
      _step = step;
      _showErrors = false;
    });
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPrimaryAction() {
    if (!_isComplete(_step)) {
      setState(() => _showErrors = true);

      if (_step == 0) {
        (_title.isEmpty ? _titleFocus : _descriptionFocus).requestFocus();
      }
      return;
    }

    if (_step == _stepCount - 1) {
      _submit();
      return;
    }

    _goTo(_step + 1);
  }

  Future<void> _openCamera() async {
    final result = await context.push<File>('/jobs/new/camera');

    if (result != null && mounted) {
      setState(() => _photo = result);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.read(currentUserIdProvider);

    if (currentUser == null) {
      setState(() => _saveError = l10n.notSignedIn);
      return;
    }

    setState(() {
      _saving = true;
      _saveError = null;
    });

    final job = Job(
      title: _title,
      description: _description,
      location: _location!,
      mediaUrl: _photo?.path,
      createdAt: DateTime.now().toUtc(),
      createdBy: currentUser,
      state: JobState.draft(),
    );

    try {
      await ref.read(jobsProvider.notifier).saveJob(job);
    } on OperationException {
      // The job itself never reached the table, so everything the user entered
      // is still the only copy of it: keep the form standing and let the button
      // try again.
      _reportFailure(l10n.photoUploadFailed);
      return;
    } on AppException {
      _reportFailure(l10n.jobSaveFailed);
      return;
    } catch (e, stackTrace) {
      // The button stays busy until something clears it, so nothing may leave
      // this method uncaught — an unnamed failure would spin forever.
      AppLogger.error("Unexpected failure saving the job", e, stackTrace);
      _reportFailure(l10n.jobSaveFailed);
      return;
    }

    if (mounted) context.pop(true);
  }

  void _reportFailure(String message) {
    if (!mounted) return;

    setState(() {
      _saving = false;
      _saveError = message;
    });
  }

  /// Back means the previous step until there is no previous step, and only
  /// then leaving — with a warning if anything would be lost.
  Future<void> _handleBack() async {
    if (_saving) return;

    if (_step > 0) {
      _goTo(_step - 1);
      return;
    }

    if (!_isDirty) {
      if (mounted) context.pop();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unsavedChanges),
        content: Text(l10n.discardJobDraft),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );

    if ((discard ?? false) && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Held outside the scrolling step so a failure cannot end up below the
    // fold, under the very button the user is about to press again.
    final saveError = _saveError;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleBack,
          ),
          title: Text(l10n.createJob),
          titleTextStyle: textTheme.titleLarge,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  children: [
                    Text(
                      l10n.stepOf(_step + 1, _stepCount),
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _StepTrack(
                      current: _step,
                      labels: [l10n.stepJob, l10n.location, l10n.photo],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  // The track and the buttons say where the user is; a swipe
                  // that slid past an unanswered step would contradict both.
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _jobStep(l10n),
                    _locationStep(l10n),
                    _photoStep(l10n),
                  ],
                ),
              ),
              if (saveError != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SectionCard(
                    accent: colors.error,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 20,
                          color: colors.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            saveError,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              _Footer(
                onBack: _step > 0 ? _handleBack : null,
                onPrimary: _onPrimaryAction,
                busy: _saving,
                label: _step == _stepCount - 1
                    ? l10n.createJobAction
                    : l10n.next,
                icon: _step == _stepCount - 1 ? Icons.check : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobStep(AppLocalizations l10n) {
    final missing = _showErrors ? l10n.requiredField : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _Heading(l10n.whatNeedsDoing),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.jobTitle,
          child: TitleField(
            controller: _titleController,
            focusNode: _titleFocus,
            l10n: l10n,
            onChanged: (_) => setState(() {}),
            errorText: _title.isEmpty ? missing : null,
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.description,
          child: DescriptionField(
            controller: _descriptionController,
            focusNode: _descriptionFocus,
            l10n: l10n,
            onChanged: (_) => setState(() {}),
            errorText: _description.isEmpty ? missing : null,
          ),
        ),
      ],
    );
  }

  Widget _locationStep(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _Heading(l10n.whereIsIt),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.chooseLocation,
          child: LocationPicker(
            selected: _location,
            onSelected: (location) => setState(() {
              _location = location;
              _showErrors = false;
            }),
            errorText: _showErrors && _location == null
                ? l10n.requiredField
                : null,
          ),
        ),
      ],
    );
  }

  Widget _photoStep(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _Heading(l10n.photo, note: l10n.optional),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.addPhoto,
          child: PhotoSection(
            photo: _photo,
            onCapture: _openCamera,
            onRemove: () => setState(() => _photo = null),
            l10n: l10n,
          ),
        ),
        const SizedBox(height: 16),
        // The answers from the steps behind, each one a way back to the step it
        // came from: this is the last screen before the job is filed, and the
        // first two steps are no longer on show.
        SectionCard(
          title: l10n.reviewJob,
          child: Column(
            children: [
              DetailRow(
                icon: Icons.title,
                label: _title,
                onTap: () => _goTo(0),
              ),
              const SizedBox(height: 14),
              DetailRow(
                icon: Icons.location_on_outlined,
                label: _location ?? "",
                onTap: () => _goTo(1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The question a step is asking, in the screen-title style the job detail
/// screen uses for a job's name.
class _Heading extends StatelessWidget {
  const _Heading(this.text, {this.note});

  final String text;

  /// A qualifier beside the question — "Optional", on the step that has nothing
  /// required in it.
  final String? note;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final note = this.note;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            text,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        if (note != null) ...[
          const SizedBox(width: 10),
          Text(
            note,
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// How far in the user is: the steps behind ticked off, the one they are on
/// numbered, the ones ahead still blank.
///
/// Built to the same measurements as the job detail screen's lifecycle track,
/// so the two read as one idea in two places.
class _StepTrack extends StatelessWidget {
  const _StepTrack({required this.current, required this.labels});

  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 34,
                  child: Row(
                    children: [
                      _Connector(show: i > 0, done: i <= current),
                      _Node(index: i, current: current),
                      _Connector(
                        show: i < labels.length - 1,
                        done: i < current,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 1,
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
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.index, required this.current});

  final int index;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final done = index < current;
    final isCurrent = index == current;
    final size = isCurrent ? 34.0 : 28.0;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done || isCurrent ? colors.primaryContainer : Colors.transparent,
        border: Border.all(
          color: isCurrent
              ? colors.primary
              : colors.outlineVariant.withValues(alpha: done ? 0 : 1),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: switch ((done, isCurrent)) {
        (true, _) => Icon(
          Icons.check,
          size: 15,
          color: colors.onPrimaryContainer,
        ),
        (_, true) => Text(
          "${index + 1}",
          style: textTheme.labelMedium?.copyWith(
            color: colors.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
        _ => Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.outlineVariant,
          ),
        ),
      },
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

/// The pair of moves available at any point in the wizard, held at the foot of
/// the screen so the answer to "what now" never scrolls away.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.onBack,
    required this.onPrimary,
    required this.busy,
    required this.label,
    required this.icon,
  });

  /// Null on the first step, where there is nothing to go back to.
  final VoidCallback? onBack;
  final VoidCallback onPrimary;
  final bool busy;
  final String label;

  /// The tick on the final step; the others get a direction arrow instead.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final onBack = this.onBack;
    // Arrows do not mirror themselves, and these ones point the way the wizard
    // moves.
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              if (onBack != null) ...[
                SizedBox(
                  height: 54,
                  child: TextButton.icon(
                    onPressed: busy ? null : onBack,
                    icon: Icon(
                      rtl ? Icons.arrow_forward : Icons.arrow_back,
                      size: 18,
                    ),
                    label: Text(l10n.back),
                    style: TextButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      textStyle: textTheme.titleSmall,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: busy ? null : onPrimary,
                    style: FilledButton.styleFrom(
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
                              color: colors.onPrimary,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                icon ??
                                    (rtl
                                        ? Icons.arrow_back
                                        : Icons.arrow_forward),
                                size: 18,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

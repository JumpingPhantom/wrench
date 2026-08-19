import 'package:flutter/material.dart';
import 'package:wrench/core/constants/job_locations.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The look every input on the create-job form wears.
///
/// One helper rather than a decoration per field: three copies of the same
/// twenty lines had already drifted apart once — the description field had
/// quietly lost its error border, so the one field that could not report a
/// problem was the one the form silently refused to submit without.
InputDecoration jobFieldDecoration(
  BuildContext context, {
  required String hintText,
  String? errorText,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  ),
}) {
  final colors = Theme.of(context).colorScheme;

  OutlineInputBorder border([BorderSide side = BorderSide.none]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: side,
    );
  }

  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: colors.onSurfaceVariant.withValues(alpha: 0.6),
    ),
    errorText: errorText,
    filled: true,
    fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.3),
    alignLabelWithHint: true,
    border: border(),
    enabledBorder: border(
      BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
    ),
    focusedBorder: border(BorderSide(color: colors.primary, width: 1.5)),
    errorBorder: border(BorderSide(color: colors.error)),
    focusedErrorBorder: border(BorderSide(color: colors.error, width: 1.5)),
    contentPadding: contentPadding,
  );
}

/// What the job is called, in one line.
class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.l10n,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AppLocalizations l10n;
  final ValueChanged<String> onChanged;

  /// Shown under the field once the step has been asked to advance without it.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: jobFieldDecoration(
        context,
        hintText: l10n.jobTitleHint,
        errorText: errorText,
      ),
    );
  }
}

/// The long half of the story, in as many lines as it takes.
class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.l10n,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AppLocalizations l10n;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      minLines: 4,
      maxLines: 6,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: jobFieldDecoration(
        context,
        hintText: l10n.describeTheIssue,
        errorText: errorText,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

/// Where the job is, as a choice out of [jobLocations] rather than a text box.
///
/// The chips are the whole vocabulary: a place that is not here cannot be filed
/// against, which is the point — it is the only way a typo stops being possible.
class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.errorText,
  });

  final String? selected;
  final ValueChanged<String> onSelected;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final errorText = this.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final location in jobLocations)
              _LocationChip(
                label: location,
                selected: location == selected,
                onSelected: () => onSelected(location),
              ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            errorText,
            style: textTheme.bodySmall?.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}

/// One place, wearing the primary role once it is the chosen one — the same
/// chip treatment the jobs list uses for its status filters.
class _LocationChip extends StatelessWidget {
  const _LocationChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ChoiceChip(
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(),
      backgroundColor: colors.surfaceContainerLow,
      selectedColor: colors.primaryContainer,
      side: BorderSide(
        color: selected
            ? Colors.transparent
            : colors.outlineVariant.withValues(alpha: 0.5),
      ),
      avatar: selected
          ? Icon(
              Icons.location_on,
              size: 16,
              color: colors.onPrimaryContainer,
            )
          : null,
      label: Text(
        label,
        style: textTheme.labelLarge?.copyWith(
          color: selected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

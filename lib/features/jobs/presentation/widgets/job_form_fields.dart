import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.submitted,
    required this.l10n,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool submitted;
  final AppLocalizations l10n;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = submitted && controller.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.jobTitle,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: l10n.jobTitleHint,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            errorText: hasError ? l10n.requiredField : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.l10n,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 6,
          minLines: 4,
          textInputAction: TextInputAction.newline,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: l10n.describeTheIssue,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

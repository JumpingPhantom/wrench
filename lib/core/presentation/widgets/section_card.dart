import 'package:flutter/material.dart';

/// The panel every grouped block on a job surface sits in.
///
/// Deliberately flat — a tinted fill and a hairline instead of elevation — so
/// several of them can stack down a screen without the page turning into a pile
/// of floating shadows.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.accent,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;

  /// Optional heading, rendered above [child] in the section-label style shared
  /// with the rest of the app.
  final String? title;

  /// Tints the fill and the border, for a section that carries a status of its
  /// own (a cancellation, say). Defaults to the neutral surface treatment.
  final Color? accent;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = this.accent;
    final heading = title;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: accent == null
            ? colors.surfaceContainerLow
            : accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (accent ?? colors.outlineVariant).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null) ...[
            Text(
              heading,
              style: textTheme.labelLarge?.copyWith(
                color: accent ?? colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

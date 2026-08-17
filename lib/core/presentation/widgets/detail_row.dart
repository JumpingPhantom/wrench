import 'package:flutter/material.dart';

/// One labelled line inside a [SectionCard], with its icon in a tile of its own
/// so a column of them lines up however long the labels run.
///
/// Shared by the job detail screen, settings and profile: a fact, a setting and
/// an action all read as the same kind of row, which is what keeps those three
/// screens looking like one app.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.tint,
  });

  final IconData icon;
  final String label;

  /// Trailing text, for a row that states a setting's current answer.
  final String? value;

  /// Makes the row tappable and adds a chevron.
  final VoidCallback? onTap;

  /// Colours the icon and label, for a destructive row such as signing out.
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tint = this.tint;
    final value = this.value;

    final row = Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: tint == null
                ? colors.surfaceContainerHighest
                : tint.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: tint ?? colors.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: tint),
          ),
        ),
        if (value != null) ...[
          const SizedBox(width: 8),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        if (onTap != null) ...[
          const SizedBox(width: 4),
          Icon(
            // Chevrons do not mirror themselves, and this one points the way
            // the row opens.
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left
                : Icons.chevron_right,
            size: 20,
            color: colors.onSurfaceVariant,
          ),
        ],
      ],
    );

    if (onTap == null) return row;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: row,
      ),
    );
  }
}

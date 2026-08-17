import 'package:flutter/material.dart';
import 'package:wrench/core/data/models/job.dart';

/// How a [JobStatus] is drawn, wherever it appears.
///
/// Every job surface — list cards, chips, filter chips, the detail header —
/// reads its icon and colours from here, so one status looks the same on all of
/// them and a new status has to be described only once.
///
/// The colours are [ColorScheme] roles rather than fixed values, so they follow
/// the light, dark and high-contrast variants of the theme instead of fighting
/// them.
class JobStatusStyle {
  const JobStatusStyle({
    required this.icon,
    required this.accent,
    required this.onAccent,
    required this.container,
    required this.onContainer,
  });

  /// Resolves the style for [status] against the theme's [colors].
  factory JobStatusStyle.of(JobStatus status, ColorScheme colors) {
    return switch (status) {
      // Draft is the one status with nothing at stake yet, so it stays neutral
      // and lets the active ones carry the colour.
      JobStatus.draft => JobStatusStyle(
        icon: Icons.edit_note,
        accent: colors.outline,
        onAccent: colors.surface,
        container: colors.surfaceContainerHighest,
        onContainer: colors.onSurfaceVariant,
      ),
      JobStatus.inProgress => JobStatusStyle(
        icon: Icons.bolt,
        accent: colors.primary,
        onAccent: colors.onPrimary,
        container: colors.primaryContainer,
        onContainer: colors.onPrimaryContainer,
      ),
      JobStatus.staged => JobStatusStyle(
        icon: Icons.hourglass_top,
        accent: colors.tertiary,
        onAccent: colors.onTertiary,
        container: colors.tertiaryContainer,
        onContainer: colors.onTertiaryContainer,
      ),
      // The fixed pair rather than secondaryContainer: in the light scheme that
      // container is the same value as primaryContainer, which would leave
      // finished and in-progress wearing one colour between them.
      JobStatus.finished => JobStatusStyle(
        icon: Icons.check_circle,
        accent: colors.secondary,
        onAccent: colors.onSecondary,
        container: colors.secondaryFixedDim,
        onContainer: colors.onSecondaryFixed,
      ),
      JobStatus.cancelled => JobStatusStyle(
        icon: Icons.block,
        accent: colors.error,
        onAccent: colors.onError,
        container: colors.errorContainer,
        onContainer: colors.onErrorContainer,
      ),
    };
  }

  /// Style for the current theme, for callers that already have a [context].
  factory JobStatusStyle.from(BuildContext context, JobStatus status) {
    return JobStatusStyle.of(status, Theme.of(context).colorScheme);
  }

  final IconData icon;

  /// For marks that sit directly on the page — a card's edge, a track's line,
  /// an icon on a plain surface — where a container fill would be too heavy.
  final Color accent;

  /// For anything drawn on top of [accent], such as a filled button's label.
  final Color onAccent;

  /// Fill for badges and chips, with [onContainer] for whatever sits on top.
  final Color container;
  final Color onContainer;
}

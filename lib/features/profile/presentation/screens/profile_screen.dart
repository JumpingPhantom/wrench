import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/detail_row.dart';
import 'package:wrench/core/presentation/widgets/error_state.dart';
import 'package:wrench/core/presentation/widgets/job_status_pill.dart';
import 'package:wrench/core/presentation/widgets/section_card.dart';
import 'package:wrench/features/auth/presentation/controllers/auth_provider.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The signed-in user: who they are, what their jobs add up to, and the two
/// account actions the app actually supports.
///
/// Editing and avatars are still not built; the note at the foot says so rather
/// than offering controls that do nothing.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: switch (ref.watch(currentUserProvider)) {
        AsyncData(value: final user?) => _ProfileBody(user: user, l10n: l10n),
        // A profile that loaded and held nobody is a different answer from one
        // that never loaded: only the second is worth retrying.
        AsyncData() => Center(child: Text(l10n.unknownUser)),
        AsyncError(:final error) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(usersProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.user, required this.l10n});

  final User user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final counts = ref.watch(jobStatusCountsProvider(user.id)).value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _Identity(user: user, l10n: l10n),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.yourJobs,
          child: counts == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : _StatusTotals(counts: counts, l10n: l10n),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.account,
          child: Column(
            children: [
              DetailRow(
                icon: Icons.settings_outlined,
                label: l10n.settings,
                onTap: () => context.push('/settings'),
              ),
              const SizedBox(height: 6),
              DetailRow(
                icon: Icons.logout,
                label: l10n.signOut,
                tint: colors.error,
                onTap: () => _confirmSignOut(context, ref),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.profileComingSoon,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  /// Signing out throws away the session, so it asks first.
  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final colors = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.logout, color: colors.error),
        title: Text(l10n.signOut),
        content: Text(l10n.signOutPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    ref.read(authProvider.notifier).logout();
    // The router only re-checks the session when it is asked to navigate, so
    // leaving is explicit rather than a consequence of the state change.
    context.go('/login');
  }
}

/// Name, role and initials, over a wash of the app's own colour.
class _Identity extends StatelessWidget {
  const _Identity({required this.user, required this.l10n});

  final User user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer, colors.surfaceContainerLow],
        ),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colors.primary,
            // Initials rather than `user.avatarUrl`: nothing writes that column
            // yet, so its storage convention is still undecided.
            child: Text(
              _initials,
              style: textTheme.headlineSmall?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.role == UserRole.supervisor
                      ? Icons.verified_user_outlined
                      : Icons.handyman_outlined,
                  size: 15,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  user.role.label(l10n),
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Up to two initials, falling back to a neutral glyph for a blank name.
  String get _initials {
    final parts = user.fullName.trim().split(RegExp(r'\s+'))
      ..removeWhere((part) => part.isEmpty);

    if (parts.isEmpty) return "?";

    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }
}

/// This user's jobs, counted by status.
///
/// Statuses nobody has any of are left out: a row of zeroes says less than the
/// two or three numbers that are actually about this person's work.
class _StatusTotals extends StatelessWidget {
  const _StatusTotals({required this.counts, required this.l10n});

  final Map<JobStatus, int> counts;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final present = [
      for (final status in JobStatus.values)
        if ((counts[status] ?? 0) > 0) status,
    ];

    if (present.isEmpty) {
      return Text(
        l10n.noJobsFound,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final status in present)
          JobStatusPill(
            status: status,
            label: "${counts[status]} ${status.label(l10n)}",
          ),
      ],
    );
  }
}

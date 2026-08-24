import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/presentation/controllers/notifications_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/empty_state.dart';
import 'package:wrench/core/presentation/widgets/error_state.dart';
import 'package:wrench/core/presentation/widgets/relative_time.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// What the supervisor has been told, newest first.
///
/// Pushed from the app bar rather than selected from the nav bar, so it wants a
/// back button and no destination highlighted underneath it — the same reason
/// the profile route sits outside the shell.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          // Offered only when it would do something. A permanently visible
          // control that is usually a no-op teaches people to ignore it.
          if (unread > 0)
            TextButton(
              onPressed: () => _markAllRead(context, ref, l10n),
              child: Text(l10n.markAllRead),
            ),
        ],
      ),
      body: switch (notifications) {
        AsyncData(value: final entries) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(notificationsProvider);
            await ref.read(notificationsProvider.future);
          },
          // Still a scrollable when empty, or there would be nothing for the
          // pull-to-refresh gesture to grab — the same reason the jobs list
          // keeps one under its own empty state.
          child: entries.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: EmptyState(
                        icon: Icons.notifications_none,
                        title: l10n.noNotifications,
                        message: l10n.noNotificationsHint,
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  itemCount: entries.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) => _NotificationCard(
                    notification: entries[index],
                    l10n: l10n,
                  ),
                ),
        ),
        AsyncError(:final error) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// The user asked for this one, so a failure is said out loud rather than
  /// leaving the button looking like it did nothing.
  Future<void> _markAllRead(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      await ref.read(notificationsProvider.notifier).markAllRead();
    } on AppException {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.somethingWentWrong)));
    }
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification, required this.l10n});

  final AppNotification notification;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final unread = !notification.isRead;

    // Resolved from the cached profile list rather than a lookup per row, so a
    // screenful of notifications is still one request. A profile that is gone,
    // or hidden by row-level security, renders as the fallback rather than
    // taking the row down.
    final actorId = notification.actorId;
    final actor = actorId == null
        ? null
        : ref.watch(userByIdProvider(actorId)).value;

    return Material(
      color: unread
          ? colors.primaryContainer.withValues(alpha: 0.35)
          : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _open(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, size: 22, color: colors.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.kind.line(
                        l10n,
                        actor?.fullName ?? l10n.unknownUser,
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RelativeTime(
                      timestamp: notification.createdAt,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData get _icon => switch (notification.kind) {
    NotificationKind.jobCreated => Icons.note_add_outlined,
    NotificationKind.jobSubmitted => Icons.assignment_turned_in_outlined,
  };

  /// Marks the notification read and opens the job it is about.
  ///
  /// The read is not awaited: it is a write nobody is waiting on, and holding
  /// the navigation until the backend answers would make a tap feel broken on a
  /// slow connection. A failure leaves the row unread, which is the honest
  /// outcome and self-correcting — the next tap tries again.
  void _open(BuildContext context, WidgetRef ref) {
    if (!notification.isRead) {
      unawaited(
        ref
            .read(notificationsProvider.notifier)
            .markRead(notification.id)
            .catchError((Object error) {
              AppLogger.error(
                "Could not mark notification ${notification.id} read",
                error,
              );
            }),
      );
    }

    context.push('/jobs/${notification.jobId}');
  }
}

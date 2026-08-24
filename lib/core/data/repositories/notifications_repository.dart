import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/sources/notifications_source.dart';

/// The app's entry point for notifications.
///
/// Everything that reads or marks one goes through here, so where they live
/// stays a decision of [source] alone. Exceptions from the source are left to
/// propagate: the presentation layer turns them into user-facing copy.
class NotificationsRepository {
  final NotificationsSource source;

  NotificationsRepository({required this.source});

  /// The most recent notifications, newest first.
  Future<List<AppNotification>> getRecent({
    int limit = NotificationsSource.defaultLimit,
  }) => source.getRecent(limit: limit);

  /// How many are unread, counted at the source rather than over the list.
  Future<int> unreadCount() => source.unreadCount();

  /// A signal that the stored notifications changed, so callers can ask again.
  Stream<void> watch() => source.watch();

  /// Marks one notification read.
  Future<void> markRead(int id) => source.markRead(id);

  /// Marks every unread notification read.
  Future<void> markAllRead() => source.markAllRead();
}

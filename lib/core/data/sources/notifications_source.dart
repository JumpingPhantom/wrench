import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// Where a user's notifications are read from and marked read.
///
/// Implementations own the transport, not the rules: they translate their own
/// failures into an [AppException] so callers never have to know whether a
/// notification came from the network or a cache.
///
/// Every method here is scoped to the signed-in user by the store itself. No
/// method takes a recipient, and none should: a caller that could ask for
/// somebody else's notifications is a caller that can leak them.
abstract class NotificationsSource {
  /// How many notifications a single read returns.
  ///
  /// A feed is read from the top and stops being interesting long before it
  /// stops being long, so it is capped rather than paged.
  static const defaultLimit = 50;

  /// The most recent notifications, newest first, capped at [limit].
  ///
  /// Throws [NetworkException] if they cannot be read.
  Future<List<AppNotification>> getRecent({int limit = defaultLimit});

  /// How many notifications are unread.
  ///
  /// Counted at the source rather than over the list above, which under-reports
  /// the moment there are more unread than [defaultLimit] -- the same reason
  /// the job status totals are counted at the source rather than over the pages
  /// loaded so far.
  ///
  /// Throws [NetworkException] if the count cannot be read.
  Future<int> unreadCount();

  /// Signals that the stored notifications changed, for as long as it is
  /// listened to.
  ///
  /// Carries no payload, unlike the jobs feed. That one reports *what* changed
  /// because its reads are filtered and paged at the source, and reconciling an
  /// event beats refetching a list whose scroll position and later pages would
  /// be thrown away. Neither applies to a short capped feed, so this says only
  /// that something moved and the listener asks again.
  ///
  /// A reconnect is reported the same way as a change: the feed cannot say what
  /// it missed while it was away, and "ask again" is the answer to both.
  Stream<void> watch();

  /// Marks one notification read. Marking an already-read one changes nothing.
  ///
  /// Throws [NetworkException] if the write is rejected.
  Future<void> markRead(int id);

  /// Marks every unread notification read.
  ///
  /// Throws [NetworkException] if the write is rejected.
  Future<void> markAllRead();
}

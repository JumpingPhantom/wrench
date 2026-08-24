import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/repositories/notifications_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_notifications_source.dart';

/// Where every notification read and write in the app goes.
///
/// Public so tests can substitute a repository over a fake source: the notifier
/// below is worth exercising for real, and it has no other seam.
final notificationsRepositoryProvider = Provider((ref) {
  return NotificationsRepository(source: RemoteNotificationsSource());
});

/// A signal that the stored notifications changed, as it happens.
///
/// One feed for the whole app rather than one per screen: it is a socket, and
/// every view below wants the same events off it. Deliberately not auto-
/// disposed for the same reason -- the channel should survive moving between
/// tabs. [AuthNotifier.logout] is what closes it.
class NotificationChanges extends StreamNotifier<void> {
  @override
  Stream<void> build() => ref.watch(notificationsRepositoryProvider).watch();

  /// Every delivered event counts, including one indistinguishable from the
  /// last -- which, on a feed carrying no payload, is all of them.
  ///
  /// Riverpod tells listeners only when the new state differs from the old by
  /// `==`, and each event here arrives as the same `AsyncData<void>(null)` as
  /// the one before it. The channel emits on joining, so that first event used
  /// up the only state change there was ever going to be: every notification
  /// after it was read as nothing having happened, and the list and the badge
  /// stopped moving until the app was restarted.
  @override
  bool updateShouldNotify(AsyncValue<void> previous, AsyncValue<void> next) =>
      true;
}

/// A notifier rather than a [StreamProvider] only so [updateShouldNotify]
/// above has somewhere to live; there is no state here beyond the feed.
final notificationChangesProvider =
    StreamNotifierProvider<NotificationChanges, void>(NotificationChanges.new);

/// Refetches this provider whenever the change feed reports anything.
///
/// Both views below are read whole from the source, so there is nothing in
/// either to patch: the only way to know the newest notifications, or how many
/// are unread, is to ask again.
extension _RefetchOnChange on Ref {
  void refetchOnNotificationChange() {
    listen(notificationChangesProvider, (_, next) {
      // Only a delivered event counts. An [AsyncError] carries the last value
      // forward with it, and refetching over a feed that has just failed helps
      // nobody.
      if (next case AsyncData()) invalidateSelf();
    });
  }
}

/// The most recent notifications, newest first, and the moves that mark them
/// read.
///
/// A notifier rather than a bare [FutureProvider] only because the writes need
/// somewhere to live. There is no page state here -- unlike the jobs list, this
/// one is capped rather than paged, so it holds nothing across a rebuild that a
/// refetch could not produce again.
class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  // Resolved per call rather than cached in a field. Riverpod keeps the same
  // notifier instance across rebuilds, so `build` runs more than once on this
  // object -- anything assigned there has to tolerate being assigned again.
  NotificationsRepository get _repository =>
      ref.read(notificationsRepositoryProvider);

  @override
  Future<List<AppNotification>> build() {
    // Registered here, where Riverpod tears it down and sets it up again on
    // each rebuild, so repeated invalidation does not stack up subscriptions.
    ref.refetchOnNotificationChange();
    return _repository.getRecent();
  }

  /// Marks one notification read.
  Future<void> markRead(int id) async {
    await _repository.markRead(id);
    _refresh();
  }

  /// Marks every unread notification read.
  Future<void> markAllRead() async {
    await _repository.markAllRead();
    _refresh();
  }

  /// Refreshes what the write is visible in, rather than waiting for the feed.
  ///
  /// For the same reason a saved job reloads the list itself: the tap happened
  /// on this device and should land now, not a round trip later. The feed's
  /// echo of the same update arrives at the same answer, so paying for it twice
  /// costs one cheap query and no correctness.
  void _refresh() {
    ref.invalidateSelf();
    ref.invalidate(unreadNotificationCountProvider);
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      NotificationsNotifier.new,
    );

/// How many notifications are unread, for the badge.
///
/// A count query rather than a filter over [notificationsProvider], whose list
/// is capped: counting it would stop being true the moment somebody has more
/// unread than the cap, and it would stop being true by under-reporting, which
/// is the direction nobody notices.
final unreadNotificationCountProvider = FutureProvider<int>((ref) {
  ref.refetchOnNotificationChange();
  return ref.watch(notificationsRepositoryProvider).unreadCount();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/repositories/notifications_repository.dart';
import 'package:wrench/core/data/sources/notifications_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/notifications_provider.dart';

import 'fake_notifications_source.dart';

void main() {
  late FakeNotificationsSource source;

  ProviderContainer containerFor(
    List<AppNotification> notifications, {
    bool retry = true,
  }) {
    source = FakeNotificationsSource(notifications);
    final container = ProviderContainer(
      // Riverpod retries a failed provider on its own, on a backoff. A test
      // about what the feed recovers has to be the only thing recovering it.
      retry: retry ? null : (_, _) => null,
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(
          NotificationsRepository(source: source),
        ),
      ],
    );
    addTearDown(source.dispose);
    addTearDown(container.dispose);
    return container;
  }

  /// Reads both providers with listeners attached, so they stay alive and the
  /// change feed they subscribe to stays subscribed.
  Future<ProviderContainer> loaded(
    List<AppNotification> notifications, {
    bool retry = true,
  }) async {
    final container = containerFor(notifications, retry: retry);
    container.listen(notificationsProvider, (_, _) {});
    container.listen(unreadNotificationCountProvider, (_, _) {});
    await container.read(notificationsProvider.future);
    await container.read(unreadNotificationCountProvider.future);
    return container;
  }

  /// Lets the feed's event reach its listener.
  ///
  /// The stream delivers on a microtask, so `emit` returns before anything has
  /// invalidated -- without this a read still answers from the cached value and
  /// the refetch looks like it never happened.
  Future<void> pump() => Future<void>.delayed(Duration.zero);

  group("notificationsProvider", () {
    test("reads the newest notifications first", () async {
      final container = await loaded([
        notificationWith(id: 1),
        notificationWith(id: 3),
        notificationWith(id: 2),
      ]);

      final ids = container
          .read(notificationsProvider)
          .value!
          .map((entry) => entry.id)
          .toList();

      expect(ids, [3, 2, 1]);
    });

    test("refetches when the feed reports a change", () async {
      final container = await loaded([notificationWith(id: 1)]);

      expect(source.recentRequests, hasLength(1));

      source.notifications = [notificationWith(id: 2), ...source.notifications];
      source.emit();
      await pump();
      await container.read(notificationsProvider.future);

      expect(source.recentRequests, hasLength(2));
      expect(container.read(notificationsProvider).value, hasLength(2));
    });

    test("refetches on a second event as well as the first", () async {
      // The feed carries no payload, so every event it delivers is identical to
      // the one before it. Riverpod's default "did the state change?" reads two
      // of those as nothing having happened -- and since the channel emits on
      // joining, that made every notification after the join silent until the
      // app was restarted.
      final container = await loaded([notificationWith(id: 1)]);

      source.emit();
      await pump();
      await container.read(notificationsProvider.future);

      expect(source.recentRequests, hasLength(2));

      source.notifications = [notificationWith(id: 2), ...source.notifications];
      source.emit();
      await pump();
      await container.read(notificationsProvider.future);

      expect(source.recentRequests, hasLength(3));
      expect(container.read(notificationsProvider).value, hasLength(2));
    });

    test("reports a dead network rather than an empty list", () async {
      final container = containerFor([notificationWith(id: 1)], retry: false);
      source.readError = NetworkException(message: "down");

      await expectLater(
        container.read(notificationsProvider.future),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group("unreadNotificationCountProvider", () {
    test("counts at the source rather than over the capped list", () async {
      // More unread than a single read returns: a count derived from the list
      // would report the cap and quietly under-report the rest.
      const beyondCap = NotificationsSource.defaultLimit + 10;

      final container = await loaded([
        for (var id = 1; id <= beyondCap; id++) notificationWith(id: id),
      ]);

      expect(
        container.read(notificationsProvider).value,
        hasLength(NotificationsSource.defaultLimit),
      );
      expect(container.read(unreadNotificationCountProvider).value, beyondCap);
    });

    test("ignores notifications that have been read", () async {
      final container = await loaded([
        notificationWith(id: 1, read: true),
        notificationWith(id: 2),
      ]);

      expect(container.read(unreadNotificationCountProvider).value, 1);
    });

    test("refetches when the feed reports a change", () async {
      final container = await loaded([notificationWith(id: 1)]);

      expect(source.countRequests, 1);

      source.emit();
      await pump();
      await container.read(unreadNotificationCountProvider.future);

      expect(source.countRequests, 2);
    });

    test("refetches on a second event as well as the first", () async {
      final container = await loaded([notificationWith(id: 1)]);

      source.emit();
      await pump();
      await container.read(unreadNotificationCountProvider.future);

      expect(source.countRequests, 2);

      source.emit();
      await pump();
      await container.read(unreadNotificationCountProvider.future);

      expect(source.countRequests, 3, reason: "the badge must keep counting");
    });

    test("a failed feed does not trigger a refetch", () async {
      // Riverpod retries a failed provider on its own, on a backoff, which
      // would recover the feed underneath the assertion below.
      final container = await loaded([notificationWith(id: 1)], retry: false);

      expect(source.countRequests, 1);

      // An AsyncError carries the last value forward with it. Refetching over a
      // feed that has just failed helps nobody, so nothing should move.
      source.emitError(NetworkException(message: "down"));
      await pump();

      expect(container.read(notificationChangesProvider).hasError, isTrue);

      expect(source.countRequests, 1);
      expect(source.recentRequests, hasLength(1));
    });
  });

  group("marking read", () {
    test("lands without waiting for the feed to echo it", () async {
      final container = await loaded([
        notificationWith(id: 1),
        notificationWith(id: 2),
      ]);

      expect(container.read(unreadNotificationCountProvider).value, 2);

      await container.read(notificationsProvider.notifier).markRead(1);
      await container.read(notificationsProvider.future);
      await container.read(unreadNotificationCountProvider.future);

      expect(container.read(unreadNotificationCountProvider).value, 1);
      final byId = {
        for (final entry in container.read(notificationsProvider).value!)
          entry.id: entry,
      };

      expect(byId[1]!.isRead, isTrue);
      expect(byId[2]!.isRead, isFalse);
    });

    test("marking all read clears the count", () async {
      final container = await loaded([
        notificationWith(id: 1),
        notificationWith(id: 2),
        notificationWith(id: 3, read: true),
      ]);

      expect(container.read(unreadNotificationCountProvider).value, 2);

      await container.read(notificationsProvider.notifier).markAllRead();
      await container.read(unreadNotificationCountProvider.future);

      expect(container.read(unreadNotificationCountProvider).value, 0);
    });

    test("a rejected write leaves the list alone", () async {
      final container = await loaded([notificationWith(id: 1)]);
      source.writeError = NetworkException(message: "down");

      await expectLater(
        container.read(notificationsProvider.notifier).markRead(1),
        throwsA(isA<NetworkException>()),
      );

      expect(container.read(unreadNotificationCountProvider).value, 1);
    });
  });
}

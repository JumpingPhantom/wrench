import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/repositories/notifications_repository.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/notifications_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/empty_state.dart';
import 'package:wrench/core/presentation/widgets/error_state.dart';
import 'package:wrench/core/presentation/screens/main_scaffold.dart';
import 'package:wrench/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../core/fake_notifications_source.dart';

final _worker = User(
  id: "worker-1",
  fullName: "Ahmed",
  role: UserRole.worker,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

Widget _app(FakeNotificationsSource source, {Locale? locale}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: "/jobs/:id",
        builder: (context, state) =>
            Scaffold(body: Text("job ${state.pathParameters['id']}")),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      notificationsRepositoryProvider.overrideWithValue(
        NotificationsRepository(source: source),
      ),
      usersProvider.overrideWith((ref) async => [_worker]),
    ],
    child: MaterialApp.router(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    ),
  );
}

Future<AppLocalizations> _l10n([String code = "en"]) =>
    AppLocalizations.delegate.load(Locale(code));

void main() {
  group("NotificationsScreen", () {
    testWidgets("says there is nothing rather than showing blank space", (
      tester,
    ) async {
      final l10n = await _l10n();
      final source = FakeNotificationsSource([]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text(l10n.noNotifications), findsOneWidget);
    });

    testWidgets("names who did what, newest first", (tester) async {
      final l10n = await _l10n();
      final source = FakeNotificationsSource([
        notificationWith(id: 1),
        notificationWith(id: 2, kind: NotificationKind.jobSubmitted),
      ]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      expect(find.text(l10n.notificationJobSubmitted("Ahmed")), findsOneWidget);
      expect(find.text(l10n.notificationJobCreated("Ahmed")), findsOneWidget);
    });

    testWidgets("an actor with no readable profile still renders", (
      tester,
    ) async {
      final l10n = await _l10n();
      final source = FakeNotificationsSource([
        notificationWith(id: 1).copyWith(actorId: "someone-hidden-by-rls"),
      ]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      expect(
        find.text(l10n.notificationJobCreated(l10n.unknownUser)),
        findsOneWidget,
      );
    });

    testWidgets("a notification arriving lands on the open screen", (
      tester,
    ) async {
      // The same defect as the bell's, on the list: an open screen has to grow
      // as its owner's workers file jobs, not on the next launch.
      final l10n = await _l10n();
      final source = FakeNotificationsSource([notificationWith(id: 1)]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      // The channel's join, before anything has changed.
      source.emit();
      await tester.pumpAndSettle();

      source.notifications = [
        ...source.notifications,
        notificationWith(id: 2, kind: NotificationKind.jobSubmitted),
      ];
      source.emit();
      await tester.pumpAndSettle();

      expect(find.text(l10n.notificationJobSubmitted("Ahmed")), findsOneWidget);
    });

    testWidgets("offers a retry rather than a spinner with the network down", (
      tester,
    ) async {
      final source = FakeNotificationsSource([notificationWith(id: 1)]);
      source.readError = NetworkException(message: "down");
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
    });

    testWidgets("mark all read is offered only while something is unread", (
      tester,
    ) async {
      final l10n = await _l10n();
      final source = FakeNotificationsSource([
        notificationWith(id: 1),
        notificationWith(id: 2, read: true),
      ]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      expect(find.text(l10n.markAllRead), findsOneWidget);

      await tester.tap(find.text(l10n.markAllRead));
      await tester.pumpAndSettle();

      expect(find.text(l10n.markAllRead), findsNothing);
    });

    testWidgets("tapping one opens the job it is about", (tester) async {
      final source = FakeNotificationsSource([notificationWith(id: 5)]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.text("job 5"), findsOneWidget);
      expect(source.notifications.single.isRead, isTrue);
    });

    testWidgets("lays out in Arabic on a narrow screen without overflowing", (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final source = FakeNotificationsSource([
        notificationWith(id: 1),
        notificationWith(id: 2, kind: NotificationKind.jobSubmitted),
      ]);
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(source, locale: const Locale("ar")));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group("the app bar bell", () {
    Widget scaffolded(FakeNotificationsSource source) {
      final router = GoRouter(
        routes: [
          ShellRoute(
            builder: (context, state, child) => MainScaffold(child: child),
            routes: [
              GoRoute(
                path: "/",
                builder: (context, state) => const SizedBox.shrink(),
              ),
            ],
          ),
          GoRoute(
            path: "/notifications",
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      );

      return ProviderScope(
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(
            NotificationsRepository(source: source),
          ),
          usersProvider.overrideWith((ref) async => [_worker]),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(useMaterial3: true),
          routerConfig: router,
        ),
      );
    }

    testWidgets("carries the unread count", (tester) async {
      final source = FakeNotificationsSource([
        notificationWith(id: 1),
        notificationWith(id: 2),
        notificationWith(id: 3, read: true),
      ]);
      addTearDown(source.dispose);

      await tester.pumpWidget(scaffolded(source));
      await tester.pumpAndSettle();

      expect(find.text("2"), findsOneWidget);
    });

    testWidgets("counts up as notifications arrive, without a restart", (
      tester,
    ) async {
      // The reported defect, from the outside: a supervisor sitting on a screen
      // watched the bell stay put while their workers filed jobs, and only saw
      // the number move after quitting the app.
      final source = FakeNotificationsSource([notificationWith(id: 1)]);
      addTearDown(source.dispose);

      await tester.pumpWidget(scaffolded(source));
      await tester.pumpAndSettle();

      expect(find.text("1"), findsOneWidget);

      // Standing in for the realtime channel's join, which emits before any row
      // has changed -- the event that used to leave the feed looking settled.
      source.emit();
      await tester.pumpAndSettle();

      source.notifications = [...source.notifications, notificationWith(id: 2)];
      source.emit();
      await tester.pumpAndSettle();

      expect(find.text("2"), findsOneWidget);
      expect(find.text("1"), findsNothing);
    });

    testWidgets("wears no number when there is nothing to catch up on", (
      tester,
    ) async {
      final source = FakeNotificationsSource([
        notificationWith(id: 1, read: true),
      ]);
      addTearDown(source.dispose);

      await tester.pumpWidget(scaffolded(source));
      await tester.pumpAndSettle();

      final badge = tester.widget<Badge>(find.byType(Badge));

      expect(badge.isLabelVisible, isFalse);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets("a count that will not load shows no number, not an error", (
      tester,
    ) async {
      final source = FakeNotificationsSource([notificationWith(id: 1)]);
      source.readError = NetworkException(message: "down");
      addTearDown(source.dispose);

      await tester.pumpWidget(scaffolded(source));
      await tester.pumpAndSettle();

      expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);
    });

    testWidgets("opens the notifications screen", (tester) async {
      final l10n = await _l10n();
      final source = FakeNotificationsSource([notificationWith(id: 1)]);
      addTearDown(source.dispose);

      await tester.pumpWidget(scaffolded(source));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text(l10n.notifications), findsOneWidget);
    });
  });
}

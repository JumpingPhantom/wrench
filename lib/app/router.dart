import 'package:go_router/go_router.dart';
import 'package:wrench/features/home/presentation/screens/home_screen.dart';
import 'package:wrench/features/settings/presentation/screens/main_settings_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'settings',
          builder: (context, state) => const MainSettingsScreen(),
        ),
      ],
    ),
  ],
);

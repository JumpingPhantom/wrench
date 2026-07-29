import 'package:go_router/go_router.dart';
import 'package:wrench/core/widgets/subordinate_scaffold.dart';
import 'package:wrench/core/widgets/supervisor_scaffold.dart';
import 'package:wrench/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:wrench/features/home/presentation/screens/home_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:wrench/features/settings/presentation/screens/main_settings_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        //FIXME: figure out this later
        bool isSupervisor = true;

        return isSupervisor
            ? SupervisorScaffold(child: child)
            : SubordinateScaffold();
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/jobs',
          builder: (context, state) => const JobsScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const MainSettingsScreen(),
        ),
      ],
    ),
  ],
);

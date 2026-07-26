import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/widgets/subordinate_scaffold.dart';
import 'package:wrench/core/widgets/supervisor_scaffold.dart';
import 'package:wrench/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:wrench/features/home/presentation/screens/home_screen.dart';
import 'package:wrench/features/requests/presentation/screens/requests_screen.dart';
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
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    ),
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/requests',
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    ),
            child: const RequestsScreen(),
          ),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    ),
            child: const AnalyticsScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutCirc,
                      ).animate(animation),
                      child: child,
                    ),
            child: const MainSettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);

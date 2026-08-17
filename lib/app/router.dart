import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/screens/main_scaffold.dart';
import 'package:wrench/features/auth/presentation/screens/login_screen.dart';
import 'package:wrench/features/auth/presentation/controllers/auth_provider.dart';
import 'package:wrench/features/home/presentation/screens/home_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/camera_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/create_job_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/job_detail_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:wrench/features/settings/presentation/screens/main_settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated();
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/jobs',
            builder: (context, state) {
              final filterParam = state.uri.queryParameters['filter'];
              return JobsScreen(initialFilter: filterParam);
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const MainSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/jobs/new',
        builder: (context, state) => const CreateJobScreen(),
      ),
      GoRoute(
        path: '/jobs/new/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/jobs/:id',
        builder: (context, state) {
          // `extra` is only present when navigating from a list; it is lost on
          // a restored or deep-linked route, so the id is the reliable input
          // and the job travels as an optimisation.
          final extra = state.extra;

          return JobDetailScreen(
            jobId: int.tryParse(state.pathParameters['id'] ?? ''),
            job: extra is Job ? extra : null,
          );
        },
      ),
    ],
  );
});

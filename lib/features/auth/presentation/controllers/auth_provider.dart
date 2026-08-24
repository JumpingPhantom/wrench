import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/network/remote_request.dart';
import 'package:wrench/core/network/supabase_client.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/notifications_provider.dart';
import 'package:wrench/features/auth/data/models/auth_state.dart';

class AuthNotifier extends Notifier<AppAuthState> {
  @override
  AppAuthState build() {
    return const AppAuthState.initial();
  }

  bool isAuthenticated() {
    return client.auth.currentUser != null;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AppAuthState.loading();

    if (email.isEmpty || password.isEmpty) {
      state = const AppAuthState.error(
        message: 'Email and password are required',
      );
      return;
    }

    try {
      await remoteRequest(
        "sign in",
        () => client.auth.signInWithPassword(email: email, password: password),
      );
    } on AuthException catch (e) {
      state = AppAuthState.error(message: e.message);
      return;
    } on AppException catch (e) {
      // Without the deadline the request carries, a phone holding a connection
      // that goes nowhere leaves this notifier in `loading` — and the sign-in
      // button spinning — until the platform gives up minutes later.
      state = AppAuthState.error(message: e.message, offline: true);
      return;
    }

    state = AppAuthState.authenticated(userId: client.auth.currentUser!.id);
  }

  void logout() {
    client.auth.signOut();
    state = const AppAuthState.initial();

    // The jobs held in memory are this session's, and the realtime channel
    // behind them is subscribed as this session's user. Both are dropped here
    // rather than left for the next sign-in to notice, so the next user does
    // not open the app onto the last one's work while their own loads.
    ref.invalidate(jobChangesProvider);
    ref.invalidate(jobsProvider);
    ref.invalidate(recentJobsProvider);
    ref.invalidate(jobStatusCountsProvider);

    // Notifications are addressed to one recipient and the channel carrying
    // them is subscribed as this session's user, so they are dropped here for
    // the same reason: the next person to sign in must not open the app onto
    // the last one's.
    ref.invalidate(notificationChangesProvider);
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }

  void authenticate() {
    if (!isAuthenticated()) return;
    state = AppAuthState.authenticated(userId: client.auth.currentUser!.id);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppAuthState>(() {
  return AuthNotifier();
});

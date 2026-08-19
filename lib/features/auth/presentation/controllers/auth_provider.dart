import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/network/remote_request.dart';
import 'package:wrench/core/network/supabase_client.dart';
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
  }

  void authenticate() {
    if (!isAuthenticated()) return;
    state = AppAuthState.authenticated(userId: client.auth.currentUser!.id);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppAuthState>(() {
  return AuthNotifier();
});

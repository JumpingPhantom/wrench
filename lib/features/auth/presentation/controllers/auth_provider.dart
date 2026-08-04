import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/features/auth/data/models/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();

    // TODO: Replace with actual authentication logic
    // This is a placeholder that simulates authentication
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      state = const AuthState.error(message: 'Email and password are required');
      return;
    }

    // Simulate successful login
    state = const AuthState.authenticated(userId: 'user-123');
  }

  void logout() {
    state = const AuthState.initial();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

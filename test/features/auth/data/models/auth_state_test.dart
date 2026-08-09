import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/auth/data/models/auth_state.dart';

void main() {
  group('AppAuthState', () {
    test('creates all variants', () {
      expect(const AppAuthState.initial(), isA<AuthInitial>());
      expect(const AppAuthState.loading(), isA<AuthLoading>());
      expect(
        const AppAuthState.authenticated(userId: 'u1'),
        isA<AuthAuthenticated>(),
      );
      expect(const AppAuthState.error(message: 'boom'), isA<AuthError>());
    });

    test('carries userId and message payloads', () {
      const authenticated = AppAuthState.authenticated(userId: 'u1');
      const error = AppAuthState.error(message: 'boom');

      expect((authenticated as AuthAuthenticated).userId, 'u1');
      expect((error as AuthError).message, 'boom');
    });

    test('equals when the same variant and payload', () {
      expect(
        const AppAuthState.authenticated(userId: 'u1'),
        const AppAuthState.authenticated(userId: 'u1'),
      );
      expect(
        const AppAuthState.authenticated(userId: 'u1'),
        isNot(const AppAuthState.authenticated(userId: 'u2')),
      );
    });
  });
}

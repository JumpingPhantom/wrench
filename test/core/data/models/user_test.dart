import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses a supervisor role from its JSON value', () {
      final user = User.fromJson({
        'id': 'u1',
        'fullName': 'Jane Supervisor',
        'role': 'supervisor',
        'avatarUrl': 'https://example.com/a.png',
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-02T00:00:00.000Z',
      });

      expect(user.id, 'u1');
      expect(user.fullName, 'Jane Supervisor');
      expect(user.role, UserRole.supervisor);
      expect(user.avatarUrl, 'https://example.com/a.png');
      expect(user.createdAt, DateTime.utc(2026, 1, 1));
      expect(user.updatedAt, DateTime.utc(2026, 1, 2));
    });

    test('parses a worker role and null avatar', () {
      final user = User.fromJson({
        'id': 'u2',
        'fullName': 'John Worker',
        'role': 'worker',
        'avatarUrl': null,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-01T00:00:00.000Z',
      });

      expect(user.role, UserRole.worker);
      expect(user.avatarUrl, isNull);
    });
  });

  group('User JSON round-trip', () {
    test('preserves all fields', () {
      final user = User.fromJson({
        'id': 'u1',
        'fullName': 'Jane Supervisor',
        'role': 'supervisor',
        'avatarUrl': null,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-02T00:00:00.000Z',
      });

      final decoded = User.fromJson(user.toJson());

      expect(decoded, user);
    });
  });
}

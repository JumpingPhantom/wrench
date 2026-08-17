// `show` keeps gotrue's own User type from colliding with the app's model.
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/sources/users_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';

/// Supabase-backed [UsersSource]: profiles from the `profiles` table, identity
/// from the auth session.
class RemoteUsersSource extends UsersSource {
  /// Reads every readable row of `profiles`; row-level security, not this
  /// query, decides which those are.
  @override
  Future<List<User>> getUsers() async {
    try {
      final rows = await client.from("profiles").select("*");

      return rows.map(User.fromJson).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error("Failed to load users", e, stackTrace);
      throw NetworkException(message: e.message, stackTrace: stackTrace);
    }
  }

  /// Read straight off the cached session, so this is synchronous and never
  /// hits the network.
  @override
  String? get currentUserId => client.auth.currentUser?.id;
}

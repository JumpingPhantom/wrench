// `show` keeps gotrue's own User type from colliding with the app's model.
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/sources/users_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteUsersSource extends UsersSource {
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

  @override
  String? get currentUserId => client.auth.currentUser?.id;
}

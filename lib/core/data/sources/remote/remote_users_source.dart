import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/parsing.dart';
import 'package:wrench/core/data/sources/users_source.dart';
import 'package:wrench/core/network/remote_request.dart';
import 'package:wrench/core/network/supabase_client.dart';

/// Supabase-backed [UsersSource]: profiles from the `profiles` table, identity
/// from the auth session.
class RemoteUsersSource extends UsersSource {
  /// Reads every readable row of `profiles`; row-level security, not this
  /// query, decides which those are, and [parseRows] decides which of those the
  /// app can make sense of.
  @override
  Future<List<User>> getUsers() async {
    final rows = await remoteRequest(
      "load users",
      () => client.from("profiles").select("*"),
    );

    return parseRows("profiles", rows, User.fromJson);
  }

  /// Read straight off the cached session, so this is synchronous and never
  /// hits the network.
  @override
  String? get currentUserId => client.auth.currentUser?.id;
}

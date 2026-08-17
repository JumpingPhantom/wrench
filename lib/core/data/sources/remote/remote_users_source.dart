import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/sources/users_source.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteUsersSource extends UsersSource {
  @override
  Future<List<User>> getUsers() async {
    final queryResponse = await client.from("profiles").select("*");
    final users = queryResponse.toList().map((e) => User.fromJson(e)).toList();

    return users;
  }

  @override
  String? get currentUserId => client.auth.currentUser?.id;
}

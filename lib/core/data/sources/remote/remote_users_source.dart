import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/sources/users_source.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteUsersSource extends UsersSource {
  @override
  Future<User?> getUserById(String id) async {
    final response = await client
        .from("profiles")
        .select("full_name")
        .eq("full_name", id)
        .maybeSingle();

    if (response == null) return null;

    return User.fromJson(response);
  }

  @override
  Future<List<User>> getUsers() async {
    final queryResponse = await client.from("profiles").select("*");
    final users = queryResponse.toList().map((e) => User.fromJson(e)).toList();

    return users;
  }
}

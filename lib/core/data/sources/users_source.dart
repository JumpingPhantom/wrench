import 'package:wrench/core/data/models/user.dart';

abstract class UsersSource {
  Future<List<User>> getUsers();
  Future<User?> getUserById(String id);
  String? currentUserId;
}

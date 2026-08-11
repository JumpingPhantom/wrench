import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/sources/users_source.dart';

class UsersRepository {
  UsersRepository({required this.source});

  final UsersSource source;

  Future<List<User>> getUsers() => source.getUsers();
  Future<User?> getUserById(String id) => source.getUserById(id);
  String? get currentUserId => source.currentUserId;
}

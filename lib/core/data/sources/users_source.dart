import 'package:wrench/core/data/models/user.dart';

abstract class UsersSource {
  Future<List<User>> getUsers();

  /// Id of the signed-in user, or null when there is no session.
  String? get currentUserId;
}

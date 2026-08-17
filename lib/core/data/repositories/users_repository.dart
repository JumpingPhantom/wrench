import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/sources/users_source.dart';

/// The app's entry point for user profiles and the current session.
class UsersRepository {
  UsersRepository({required this.source});

  final UsersSource source;

  /// Every profile the app can attribute work to.
  Future<List<User>> getUsers() => source.getUsers();

  /// Id of the signed-in user, or null when there is no session.
  String? get currentUserId => source.currentUserId;
}

import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// Where user profiles and the current session are read from.
abstract class UsersSource {
  /// Every profile the app can attribute work to.
  ///
  /// Fetched as a whole rather than one lookup per id, because screens resolve
  /// names for whole lists of jobs at a time.
  ///
  /// Throws [NetworkException] if the profiles cannot be read.
  Future<List<User>> getUsers();

  /// Id of the signed-in user, or null when there is no session.
  ///
  /// Read from the session rather than the profile table, so it stays available
  /// even if profiles fail to load.
  String? get currentUserId;
}

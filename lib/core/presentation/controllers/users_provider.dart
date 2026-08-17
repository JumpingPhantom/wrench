import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/repositories/users_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_users_source.dart';
import 'package:wrench/core/data/sources/users_source.dart';

final _sourceProvider = Provider<UsersSource>((ref) {
  return RemoteUsersSource();
});

final _repositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(source: ref.watch(_sourceProvider));
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  return ref.watch(_repositoryProvider).getUsers();
});

/// Looks a user up in the cached [usersProvider] list.
///
/// Resolves to null once the list has loaded without a match — a profile can
/// be missing because it was deleted or is hidden by row-level security, so
/// callers must render a fallback rather than assume a hit.
final userByIdProvider = Provider.family<AsyncValue<User?>, String>((ref, id) {
  return ref.watch(usersProvider).whenData((users) {
    final matches = users.where((user) => user.id == id);
    return matches.isEmpty ? null : matches.first;
  });
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(_repositoryProvider).currentUserId;
});

/// The signed-in user's profile, or null when nobody is signed in or the
/// session's id has no matching row in `profiles`.
final currentUserProvider = Provider<AsyncValue<User?>>((ref) {
  final id = ref.watch(currentUserIdProvider);

  if (id == null) return const AsyncData(null);

  return ref.watch(userByIdProvider(id));
});

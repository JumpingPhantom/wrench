import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/repositories/users_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_users_source.dart';
import 'package:wrench/core/data/sources/users_source.dart';

final _sourceProvider = Provider<UsersSource>((ref) {
  return RemoteUsersSource();
});

final _repositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(source: ref.read(_sourceProvider));
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  return ref.watch(_repositoryProvider).getUsers();
});

final currentUserIdProvider = Provider((ref) {
  return ref.read(_repositoryProvider).currentUserId;
});

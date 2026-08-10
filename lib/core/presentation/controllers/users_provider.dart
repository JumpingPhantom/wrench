import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/repositories/users_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_users_source.dart';
import 'package:wrench/core/data/sources/users_source.dart';

final _sourceProvider = Provider<UsersSource>((ref) {
  return RemoteUsersSource();
});

final _repositoryProvider = Provider<UsersRepository>((ref) {
  final source = ref.read(_sourceProvider);
  return UsersRepository(source: source);
});

final usersProvider = FutureProvider<List<User>>((ref) {
  final repository = ref.watch(_repositoryProvider);
  return repository.getUsers();
});

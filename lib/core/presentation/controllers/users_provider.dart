import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/repositories/users_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_users_source.dart';

final _repositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(source: RemoteUsersSource());
});

class UsersNotifier extends AsyncNotifier<List<User>> {
  late final UsersRepository _usersRepository;

  @override
  Future<List<User>> build() async {
    _usersRepository = ref.read(_repositoryProvider);

    return _usersRepository.getUsers();
  }

  Future<User?> getUserById(String id) async {
    return _usersRepository.getUserById(id);
  }

  String? get currentUserId => _usersRepository.currentUserId;
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(
  () => UsersNotifier(),
);

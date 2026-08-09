import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/home/data/repositories/home_repository.dart';
import 'package:wrench/features/home/data/sources/remote/remote_home_source.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

final _sourceProvider = Provider<HomeSource>((ref) => RemoteHomeSource());

final _repositoryProvider = Provider<HomeRepository>((ref) {
  final source = ref.watch(_sourceProvider);
  return HomeRepository(source);
});

final homeProvider = FutureProvider<List<Job>>((ref) {
  final repository = ref.watch(_repositoryProvider);
  return repository.getRecentJobs();
});

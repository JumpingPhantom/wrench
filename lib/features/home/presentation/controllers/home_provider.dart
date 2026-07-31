import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/home/data/repositories/home_repository.dart';
import 'package:wrench/features/home/data/sources/local/local_home_source.dart';
import 'package:wrench/features/home/data/sources/source.dart';

final _sourceProvider = Provider<Source>((ref) => LocalHomeSource());

final _repositoryProvider = Provider<HomeRepository>((ref) {
  final source = ref.watch(_sourceProvider);
  return HomeRepository(source);
});

final homeProvider = FutureProvider<List<Job>>((ref) {
  final repository = ref.watch(_repositoryProvider);
  return repository.getRecentJobs();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/jobs/data/repositories/job_repository.dart';
import 'package:wrench/features/jobs/data/sources/local/local_job_source.dart';
import 'package:wrench/features/jobs/data/sources/source.dart';

final _sourceProvider = Provider<Source>((ref) {
  return LocalJobSource();
});

final _repositoryProvider = Provider<JobRepository>((ref) {
  final source = ref.watch(_sourceProvider);
  return JobRepository(source: source);
});

final jobsProvider = FutureProvider<List<Job>>((ref) {
  final repository = ref.watch(_repositoryProvider);
  return repository.getAll();
});

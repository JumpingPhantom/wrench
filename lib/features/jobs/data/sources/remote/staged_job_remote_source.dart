import 'package:wrench/core/models/staged_job_model.dart';
import 'package:wrench/features/jobs/data/sources/staged_job_source.dart';

class StagedJobRemoteSource implements StagedJobSource {
  @override
  Future<List<StagedJobModel>> getAllStagedJobs() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveStagedJob(StagedJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteStagedJob(StagedJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

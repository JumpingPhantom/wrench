import 'package:wrench/core/models/job_model.dart';
import 'package:wrench/features/jobs/data/sources/job_source.dart';

class JobRemoteSource implements JobSource {
  @override
  Future<List<JobModel>> getAllJobs() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveJob(JobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteJob(JobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

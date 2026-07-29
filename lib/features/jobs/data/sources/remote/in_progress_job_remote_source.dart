import 'package:wrench/core/models/in_progress_job_model.dart';
import 'package:wrench/features/jobs/data/sources/in_progress_job_source.dart';

class InProgressJobRemoteSource implements InProgressJobSource {
  @override
  Future<List<InProgressJobModel>> getAllInProgressJobs() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveInProgressJob(InProgressJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteInProgressJob(InProgressJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

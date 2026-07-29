import 'package:wrench/core/models/finished_job_model.dart';
import 'package:wrench/features/jobs/data/sources/finished_job_source.dart';

class FinishedJobRemoteSource implements FinishedJobSource {
  @override
  Future<List<FinishedJobModel>> getAllFinishedJobs() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveFinishedJob(FinishedJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteFinishedJob(FinishedJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

import 'package:wrench/core/models/rejected_job_model.dart';
import 'package:wrench/features/jobs/data/sources/rejected_job_source.dart';

class RejectedJobRemoteSource implements RejectedJobSource {
  @override
  Future<List<RejectedJobModel>> getAllRejectedJobs() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveRejectedJob(RejectedJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteRejectedJob(RejectedJobModel job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

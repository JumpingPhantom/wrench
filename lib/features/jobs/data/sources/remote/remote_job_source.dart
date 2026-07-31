import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/jobs/data/sources/source.dart';

class JobRemoteSource implements Source {
  @override
  Future<List<Job>> getAllJobs() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveJob(Job job) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

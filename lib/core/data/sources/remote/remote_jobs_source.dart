import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/network/supabase_client.dart';
import 'package:wrench/core/utils.dart';

class RemoteJobsSource implements JobsSource {
  @override
  Future<List<Job>> getAllJobs() async {
    final jobs = jobsFromDB(await client.from("jobs").select("*"));

    return jobs;
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

import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/network/supabase_client.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

class RemoteHomeSource implements HomeSource {
  @override
  Future<List<Job>> getRecentJobs() async {
    final recentJobs = (await client.from("jobs").select("*").limit(4))
        .map((j) => Job.fromJson(j))
        .toList();

    return recentJobs;
  }
}

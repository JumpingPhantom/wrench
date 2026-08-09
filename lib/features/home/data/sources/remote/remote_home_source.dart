import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/network/supabase_client.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

class RemoteHomeSource implements HomeSource {
  @override
  Future<List<Job>> getRecentJobs() async {
    final recentJobs = jobsFromDB(
      await client
          .from("jobs")
          .select("*")
          .limit(4)
          .order("created_at", ascending: false),
    );

    return recentJobs;
  }
}

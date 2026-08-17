import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

class RemoteHomeSource implements HomeSource {
  static const _recentJobsLimit = 4;

  @override
  Future<List<Job>> getRecentJobs() async {
    try {
      // Postgres makes no ordering guarantee without an explicit ORDER BY, so
      // the limit below would otherwise return an arbitrary four rows.
      final rows = await client
          .from("jobs")
          .select("*")
          .order("created_at", ascending: false)
          .limit(_recentJobsLimit);

      return rows.map(Job.fromJson).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error("Failed to load recent jobs", e, stackTrace);
      throw NetworkException(message: e.message, stackTrace: stackTrace);
    }
  }
}

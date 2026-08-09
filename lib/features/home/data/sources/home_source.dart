import 'package:wrench/core/data/models/job.dart';

abstract class HomeSource {
  Future<List<Job>> getRecentJobs();
}

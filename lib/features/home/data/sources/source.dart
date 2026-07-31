import 'package:wrench/core/models/job.dart';

abstract class Source {
  Future<List<Job>> getRecentJobs();
}

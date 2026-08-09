import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

class LocalHomeSource implements HomeSource {
  @override
  Future<List<Job>> getRecentJobs() {
    // TODO: implement getRecentJobs
    throw UnimplementedError();
  }
}

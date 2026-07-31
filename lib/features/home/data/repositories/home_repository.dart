import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/home/data/sources/source.dart';

class HomeRepository {
  final Source _source;

  HomeRepository(this._source);

  Future<List<Job>> getRecentJobs() {
    return _source.getRecentJobs();
  }
}

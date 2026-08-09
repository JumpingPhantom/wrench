import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

class HomeRepository {
  final HomeSource _source;

  HomeRepository(this._source);

  Future<List<Job>> getRecentJobs() {
    return _source.getRecentJobs();
  }
}

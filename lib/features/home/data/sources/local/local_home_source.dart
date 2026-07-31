import 'package:wrench/core/models/job.dart';
import 'package:wrench/core/utils/dummy_db.dart';
import 'package:wrench/features/home/data/sources/source.dart';

class LocalHomeSource implements Source {
  @override
  Future<List<Job>> getRecentJobs() {
    final sortedJobs = DummyDb.instance.allJobs.take(4).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Future.value(sortedJobs);
  }
}

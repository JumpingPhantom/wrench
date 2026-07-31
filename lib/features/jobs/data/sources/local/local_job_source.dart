import 'package:wrench/core/models/job.dart';
import 'package:wrench/core/utils/dummy_db.dart';
import 'package:wrench/features/jobs/data/sources/source.dart';

class LocalJobSource implements Source {
  @override
  Future<List<Job>> getAllJobs() async {
    return List.unmodifiable(DummyDb.instance.allJobs);
  }

  @override
  Future<void> saveJob(Job job) async {
    DummyDb.instance.allJobs.add(job);
  }

  @override
  Future<void> deleteJob(Job job) async {
    DummyDb.instance.allJobs.remove(job);
  }
}

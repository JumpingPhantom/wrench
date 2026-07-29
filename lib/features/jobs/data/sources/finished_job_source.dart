import 'package:wrench/core/models/finished_job_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class FinishedJobSource {
  Future<List<FinishedJobModel>> getAllFinishedJobs();
  Future<void> saveFinishedJob(FinishedJobModel job);
  Future<void> deleteFinishedJob(FinishedJobModel job);
}

class FinishedJobLocalSource implements FinishedJobSource {
  @override
  Future<List<FinishedJobModel>> getAllFinishedJobs() async {
    return List.unmodifiable(Seed.finishedJobs);
  }

  @override
  Future<void> saveFinishedJob(FinishedJobModel job) async {
    final index = Seed.finishedJobs.indexWhere((e) => e == job);
    if (index >= 0) {
      Seed.finishedJobs[index] = job;
    } else {
      Seed.finishedJobs.add(job);
    }
  }

  @override
  Future<void> deleteFinishedJob(FinishedJobModel job) async {
    Seed.finishedJobs.remove(job);
  }
}

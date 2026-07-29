import 'package:wrench/core/models/staged_job_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class StagedJobSource {
  Future<List<StagedJobModel>> getAllStagedJobs();
  Future<void> saveStagedJob(StagedJobModel job);
  Future<void> deleteStagedJob(StagedJobModel job);
}

class StagedJobLocalSource implements StagedJobSource {
  @override
  Future<List<StagedJobModel>> getAllStagedJobs() async {
    return List.unmodifiable(Seed.stagedJobs);
  }

  @override
  Future<void> saveStagedJob(StagedJobModel job) async {
    final index = Seed.stagedJobs.indexWhere((e) => e == job);
    if (index >= 0) {
      Seed.stagedJobs[index] = job;
    } else {
      Seed.stagedJobs.add(job);
    }
  }

  @override
  Future<void> deleteStagedJob(StagedJobModel job) async {
    Seed.stagedJobs.remove(job);
  }
}

import 'package:wrench/core/models/in_progress_job_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class InProgressJobSource {
  Future<List<InProgressJobModel>> getAllInProgressJobs();
  Future<void> saveInProgressJob(InProgressJobModel job);
  Future<void> deleteInProgressJob(InProgressJobModel job);
}

class InProgressJobLocalSource implements InProgressJobSource {
  @override
  Future<List<InProgressJobModel>> getAllInProgressJobs() async {
    return List.unmodifiable(Seed.inProgressJobs);
  }

  @override
  Future<void> saveInProgressJob(InProgressJobModel job) async {
    final index = Seed.inProgressJobs.indexWhere((e) => e == job);
    if (index >= 0) {
      Seed.inProgressJobs[index] = job;
    } else {
      Seed.inProgressJobs.add(job);
    }
  }

  @override
  Future<void> deleteInProgressJob(InProgressJobModel job) async {
    Seed.inProgressJobs.remove(job);
  }
}

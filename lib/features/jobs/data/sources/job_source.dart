import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/models/job_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class JobSource {
  Future<List<JobModel>> getAllJobs();
  Future<void> saveJob(JobModel job);
  Future<void> deleteJob(JobModel job);
}

class JobLocalSource implements JobSource {
  @override
  Future<List<JobModel>> getAllJobs() async {
    return List.unmodifiable(Seed.jobs);
  }

  @override
  Future<void> saveJob(JobModel job) async {
    if (Seed.jobs.contains(job)) return;

    Seed.jobs.add(job);
  }

  @override
  Future<void> deleteJob(JobModel job) async {
    // if (!Seed.jobs.contains(job)) {
    //   OperationException(message: "Job not found").throwSelf();
    // }

    // Seed.jobs.remove(job);
    // }

    // testing:
    OperationException(message: "Job not found").throwSelf();
  }
}

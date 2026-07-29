import 'package:wrench/core/models/rejected_job_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class RejectedJobSource {
  Future<List<RejectedJobModel>> getAllRejectedJobs();
  Future<void> saveRejectedJob(RejectedJobModel job);
  Future<void> deleteRejectedJob(RejectedJobModel job);
}

class RejectedJobLocalSource implements RejectedJobSource {
  @override
  Future<List<RejectedJobModel>> getAllRejectedJobs() async {
    return List.unmodifiable(Seed.rejectedJobs);
  }

  @override
  Future<void> saveRejectedJob(RejectedJobModel job) async {
    final index = Seed.rejectedJobs.indexWhere((e) => e == job);
    if (index >= 0) {
      Seed.rejectedJobs[index] = job;
    } else {
      Seed.rejectedJobs.add(job);
    }
  }

  @override
  Future<void> deleteRejectedJob(RejectedJobModel job) async {
    Seed.rejectedJobs.remove(job);
  }
}

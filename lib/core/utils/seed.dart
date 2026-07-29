import 'package:wrench/core/models/finished_job_model.dart';
import 'package:wrench/core/models/in_progress_job_model.dart';
import 'package:wrench/core/models/job_model.dart';
import 'package:wrench/core/models/rejected_job_model.dart';
import 'package:wrench/core/models/staged_job_model.dart';

class Seed {
  static final List<JobModel> jobs = [
    const JobModel(
      title: 'Fix leaking pipe under sink',
      description: 'Water leaking from the kitchen sink pipe joint.',
      mediaUrl: 'https://example.com/photos/leak.jpg',
    ),
    const JobModel(
      title: 'Replace HVAC air filter',
      description: 'Quarterly replacement of air conditioning filter.',
      mediaUrl: 'https://example.com/photos/hvac.jpg',
    ),
    const JobModel(
      title: 'Repair garage door sensor',
      description: 'Garage door reverses before closing — sensor misalignment.',
      mediaUrl: 'https://example.com/photos/garage.jpg',
    ),
    const JobModel(
      title: 'Paint the hallway',
      description: 'Fresh coat of paint needed in the main hallway.',
      mediaUrl: 'https://example.com/photos/hallway.jpg',
    ),
    const JobModel(
      title: 'Install smart thermostat',
      description: 'Upgrade to a programmable smart thermostat.',
      mediaUrl: 'https://example.com/photos/thermostat.jpg',
    ),
    const JobModel(
      title: 'Replace bathroom exhaust fan',
      description: 'Old fan is noisy and inefficient.',
      mediaUrl: 'https://example.com/photos/exhaust.jpg',
    ),
  ];

  static final List<InProgressJobModel> inProgressJobs = [
    InProgressJobModel(
      job: jobs[2],
      approvedBy: 'Mike Foreman',
      createdAt: DateTime(2026, 7, 20),
      workers: ['Alice Torres', 'Bob Chen'],
    ),
    InProgressJobModel(
      job: jobs[3],
      approvedBy: 'Mike Foreman',
      createdAt: DateTime(2026, 7, 22),
      workers: ['Diana Park'],
    ),
  ];

  static final List<StagedJobModel> stagedJobs = [
    StagedJobModel(
      job: inProgressJobs[0],
      stagedBy: 'Alice Torres',
      stagedAt: DateTime(2026, 7, 23),
    ),
  ];

  static final List<FinishedJobModel> finishedJobs = [
    FinishedJobModel(
      job: stagedJobs[0],
      finishedAt: DateTime(2026, 7, 23),
      finishedBy: 'Alice Torres',
      reviewer: 'Mike Foreman',
      comments: 'Sensor realigned and tested — works perfectly.',
    ),
  ];

  static final List<RejectedJobModel> rejectedJobs = [
    RejectedJobModel(
      job: jobs[5],
      rejectedBy: 'Mike Foreman',
      rejectedAt: DateTime(2026, 7, 21),
      reason: 'Out of scope — requires licensed electrician.',
    ),
  ];

  static Seed? _instance;
  static Seed get instance {
    _instance ??= Seed._();
    return _instance!;
  }

  Seed._();
}

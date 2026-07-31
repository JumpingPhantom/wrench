import 'package:wrench/core/models/job.dart';

class DummyDb {
  final List<Job> _jobs;

  DummyDb({required List<Job> jobs}) : _jobs = jobs;

  List<Job> get allJobs => _jobs;

  static DummyDb? _instance;
  static DummyDb get instance {
    _instance ??= DummyDb(
      jobs: [
        Job(
          id: '1',
          title: 'Job 1',
          description: 'Job 1 description',
          createdAt: DateTime.now(),
          createdBy: 'Person 1',
          state: JobState.draft(),
          location: 'Location 1',
        ),
        Job(
          id: '2',
          title: 'Job 2',
          description: 'Job 2 description',
          createdAt: DateTime.now(),
          createdBy: 'Person 2',
          state: JobState.inProgress(
            startedAt: DateTime.now(),
            startedBy: 'Person 1',
          ),
          location: 'Location 2',
        ),
        Job(
          id: '3',
          title: 'Job 3',
          description: 'Job 3 description',
          createdAt: DateTime.now(),
          createdBy: 'Person 3',
          state: JobState.finished(
            approvedBy: 'Person 3',
            finishedAt: DateTime.now(),
          ),
          location: 'Location 3',
        ),
        Job(
          id: '4',
          title: 'Job 4',
          description: 'Job 4 description',
          createdAt: DateTime.now(),
          createdBy: 'Person 1',
          state: JobState.staged(stagedAt: DateTime.now()),
          location: 'Location 4',
        ),
      ],
    );
    return _instance!;
  }
}

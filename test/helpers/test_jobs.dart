import 'package:wrench/core/data/models/job.dart';

Job buildJob({
  String id = 'job-1',
  String title = 'Fix leaking pipe in Zone 4',
  String description = 'Replace the damaged section of pipe.',
  String location = 'Zone 4, Building A',
  DateTime? createdAt,
  String createdBy = 'user-1',
  JobState state = const JobState.draft(),
  String? mediaUrl,
}) {
  return Job(
    id: id,
    title: title,
    description: description,
    location: location,
    createdAt: createdAt ?? DateTime(2026, 8, 1, 10, 0),
    createdBy: createdBy,
    state: state,
    mediaUrl: mediaUrl,
  );
}

List<Job> buildJobs() {
  return [
    buildJob(
      id: 'job-1',
      title: 'Fix leaking pipe',
      location: 'Zone 4, Building A',
      state: JobState.staged(stagedAt: DateTime(2026, 8, 1)),
    ),
    buildJob(
      id: 'job-2',
      title: 'Install new fuse box',
      location: 'Zone 1, Ground Floor',
      state: JobState.inProgress(
        startedBy: 'user-2',
        startedAt: DateTime(2026, 8, 2),
      ),
    ),
    buildJob(
      id: 'job-3',
      title: 'Repaint hallway',
      location: 'Zone 2, Floor 3',
      state: JobState.finished(
        approvedBy: 'user-3',
        finishedAt: DateTime(2026, 8, 3),
      ),
    ),
  ];
}

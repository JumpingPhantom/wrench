import 'package:wrench/core/models/finished_task_model.dart';
import 'package:wrench/core/models/in_progress_task_model.dart';
import 'package:wrench/core/models/proposal_task_model.dart';
import 'package:wrench/core/models/rejected_task_model.dart';
import 'package:wrench/core/models/staged_task_model.dart';

class Seed {
  static final List<ProposalTaskModel> proposals = [
    const ProposalTaskModel(
      title: 'Fix leaking pipe under sink',
      description: 'Water leaking from the kitchen sink pipe joint.',
      mediaUrl: 'https://example.com/photos/leak.jpg',
    ),
    const ProposalTaskModel(
      title: 'Replace HVAC air filter',
      description: 'Quarterly replacement of air conditioning filter.',
      mediaUrl: 'https://example.com/photos/hvac.jpg',
    ),
    const ProposalTaskModel(
      title: 'Repair garage door sensor',
      description: 'Garage door reverses before closing — sensor misalignment.',
      mediaUrl: 'https://example.com/photos/garage.jpg',
    ),
    const ProposalTaskModel(
      title: 'Paint the hallway',
      description: 'Fresh coat of paint needed in the main hallway.',
      mediaUrl: 'https://example.com/photos/hallway.jpg',
    ),
    const ProposalTaskModel(
      title: 'Install smart thermostat',
      description: 'Upgrade to a programmable smart thermostat.',
      mediaUrl: 'https://example.com/photos/thermostat.jpg',
    ),
    const ProposalTaskModel(
      title: 'Replace bathroom exhaust fan',
      description: 'Old fan is noisy and inefficient.',
      mediaUrl: 'https://example.com/photos/exhaust.jpg',
    ),
  ];

  static final List<InProgressTaskModel> inProgressTasks = [
    InProgressTaskModel(
      proposal: proposals[2],
      approvedBy: 'Mike Foreman',
      createdAt: DateTime(2026, 7, 20),
      workers: ['Alice Torres', 'Bob Chen'],
    ),
    InProgressTaskModel(
      proposal: proposals[3],
      approvedBy: 'Mike Foreman',
      createdAt: DateTime(2026, 7, 22),
      workers: ['Diana Park'],
    ),
  ];

  static final List<StagedTaskModel> stagedTasks = [
    StagedTaskModel(
      task: inProgressTasks[0],
      stagedBy: 'Alice Torres',
      stagedAt: DateTime(2026, 7, 23),
    ),
  ];

  static final List<FinishedTaskModel> finishedTasks = [
    FinishedTaskModel(
      task: stagedTasks[0],
      finishedAt: DateTime(2026, 7, 23),
      finishedBy: 'Alice Torres',
      reviewer: 'Mike Foreman',
      comments: 'Sensor realigned and tested — works perfectly.',
    ),
  ];

  static final List<RejectedTaskModel> rejectedTasks = [
    RejectedTaskModel(
      task: proposals[5],
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

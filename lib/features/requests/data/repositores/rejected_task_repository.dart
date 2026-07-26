import 'package:wrench/core/models/proposal_task_model.dart';
import 'package:wrench/core/models/rejected_task_model.dart';
import 'package:wrench/features/requests/data/sources/proposal_task_source.dart';
import 'package:wrench/features/requests/data/sources/rejected_task_source.dart';

class RejectedTaskRepository {
  final RejectedTaskSource source;
  final ProposalTaskSource proposalSource;

  RejectedTaskRepository({required this.source, required this.proposalSource});

  Future<List<RejectedTaskModel>> getAll() => source.getAllRejectedTasks();
  Future<void> delete(RejectedTaskModel task) =>
      source.deleteRejectedTask(task);

  Future<void> reject(
    ProposalTaskModel proposal,
    String rejectedBy,
    String reason,
  ) async {
    final rejected = RejectedTaskModel(
      task: proposal,
      rejectedBy: rejectedBy,
      rejectedAt: DateTime.now(),
      reason: reason,
    );
    await source.saveRejectedTask(rejected);
    await proposalSource.deleteProposal(proposal);
  }
}

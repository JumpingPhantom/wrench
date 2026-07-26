import 'package:wrench/core/models/in_progress_task_model.dart';
import 'package:wrench/core/models/proposal_task_model.dart';
import 'package:wrench/features/requests/data/sources/in_progress_task_source.dart';
import 'package:wrench/features/requests/data/sources/proposal_task_source.dart';

class InProgressTaskRepository {
  final InProgressTaskSource source;
  final ProposalTaskSource proposalSource;

  InProgressTaskRepository({
    required this.source,
    required this.proposalSource,
  });

  Future<List<InProgressTaskModel>> getAll() => source.getAllInProgressTasks();
  Future<void> delete(InProgressTaskModel task) =>
      source.deleteInProgressTask(task);

  Future<void> approve(
    ProposalTaskModel proposal,
    String approvedBy,
    List<String> workers,
  ) async {
    final task = InProgressTaskModel(
      proposal: proposal,
      approvedBy: approvedBy,
      createdAt: DateTime.now(),
      workers: workers,
    );
    await source.saveInProgressTask(task);
    await proposalSource.deleteProposal(proposal);
  }
}

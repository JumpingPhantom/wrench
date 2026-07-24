import 'package:wrench/features/repairs/data/models/proposal_task_model.dart';
import 'package:wrench/features/repairs/data/sources/proposal_task_source.dart';

class ProposalTaskRepository {
  final ProposalTaskSource source;

  ProposalTaskRepository({required this.source});

  Future<List<ProposalTaskModel>> getAll() => source.getAllProposals();
  Future<void> save(ProposalTaskModel proposal) =>
      source.saveProposal(proposal);
  Future<void> delete(ProposalTaskModel proposal) =>
      source.deleteProposal(proposal);
}

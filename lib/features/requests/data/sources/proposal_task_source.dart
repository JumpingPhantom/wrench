import 'package:wrench/core/models/proposal_task_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class ProposalTaskSource {
  Future<List<ProposalTaskModel>> getAllProposals();
  Future<void> saveProposal(ProposalTaskModel proposal);
  Future<void> deleteProposal(ProposalTaskModel proposal);
}

class ProposalTaskLocalSource implements ProposalTaskSource {
  @override
  Future<List<ProposalTaskModel>> getAllProposals() async {
    return List.unmodifiable(Seed.proposals);
  }

  @override
  Future<void> saveProposal(ProposalTaskModel proposal) async {
    // final index = Seed.proposals.indexWhere((e) => e.title == proposal.title);
    // if (index >= 0) {
    //   Seed.proposals[index] = proposal;
    // } else {
    //   Seed.proposals.add(proposal);
    // }
  }

  @override
  Future<void> deleteProposal(ProposalTaskModel proposal) async {
    Seed.proposals.remove(proposal);
  }
}

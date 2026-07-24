import 'package:wrench/features/repairs/data/models/proposal_task_model.dart';
import 'package:wrench/features/repairs/data/sources/proposal_task_source.dart';

class ProposalTaskRemoteSource implements ProposalTaskSource {
  @override
  Future<List<ProposalTaskModel>> getAllProposals() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveProposal(ProposalTaskModel proposal) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteProposal(ProposalTaskModel proposal) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

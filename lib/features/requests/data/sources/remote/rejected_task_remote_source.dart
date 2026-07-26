import 'package:wrench/core/models/rejected_task_model.dart';
import 'package:wrench/features/requests/data/sources/rejected_task_source.dart';

class RejectedTaskRemoteSource implements RejectedTaskSource {
  @override
  Future<List<RejectedTaskModel>> getAllRejectedTasks() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveRejectedTask(RejectedTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteRejectedTask(RejectedTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

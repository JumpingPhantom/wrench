import 'package:wrench/features/repairs/data/models/staged_task_model.dart';
import 'package:wrench/features/repairs/data/sources/staged_task_source.dart';

class StagedTaskRemoteSource implements StagedTaskSource {
  @override
  Future<List<StagedTaskModel>> getAllStagedTasks() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveStagedTask(StagedTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteStagedTask(StagedTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

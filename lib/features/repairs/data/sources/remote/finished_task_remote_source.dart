import 'package:wrench/features/repairs/data/models/finished_task_model.dart';
import 'package:wrench/features/repairs/data/sources/finished_task_source.dart';

class FinishedTaskRemoteSource implements FinishedTaskSource {
  @override
  Future<List<FinishedTaskModel>> getAllFinishedTasks() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveFinishedTask(FinishedTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteFinishedTask(FinishedTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

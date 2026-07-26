import 'package:wrench/core/models/in_progress_task_model.dart';
import 'package:wrench/features/requests/data/sources/in_progress_task_source.dart';

class InProgressTaskRemoteSource implements InProgressTaskSource {
  @override
  Future<List<InProgressTaskModel>> getAllInProgressTasks() async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> saveInProgressTask(InProgressTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }

  @override
  Future<void> deleteInProgressTask(InProgressTaskModel task) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}

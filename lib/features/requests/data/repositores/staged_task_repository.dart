import 'package:wrench/core/models/in_progress_task_model.dart';
import 'package:wrench/core/models/staged_task_model.dart';
import 'package:wrench/features/requests/data/sources/in_progress_task_source.dart';
import 'package:wrench/features/requests/data/sources/staged_task_source.dart';

class StagedTaskRepository {
  final StagedTaskSource source;
  final InProgressTaskSource inProgressSource;

  StagedTaskRepository({required this.source, required this.inProgressSource});

  Future<List<StagedTaskModel>> getAll() => source.getAllStagedTasks();
  Future<void> delete(StagedTaskModel task) => source.deleteStagedTask(task);

  Future<void> stage(InProgressTaskModel task, String stagedBy) async {
    final staged = StagedTaskModel(
      task: task,
      stagedBy: stagedBy,
      stagedAt: DateTime.now(),
    );
    await source.saveStagedTask(staged);
    await inProgressSource.deleteInProgressTask(task);
  }
}

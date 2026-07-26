import 'package:wrench/core/models/finished_task_model.dart';
import 'package:wrench/core/models/staged_task_model.dart';
import 'package:wrench/features/requests/data/sources/finished_task_source.dart';
import 'package:wrench/features/requests/data/sources/staged_task_source.dart';

class FinishedTaskRepository {
  final FinishedTaskSource source;
  final StagedTaskSource stagedSource;

  FinishedTaskRepository({required this.source, required this.stagedSource});

  Future<List<FinishedTaskModel>> getAll() => source.getAllFinishedTasks();
  Future<void> delete(FinishedTaskModel task) =>
      source.deleteFinishedTask(task);

  Future<void> finish(
    StagedTaskModel task,
    String finishedBy,
    String reviewer,
    String comments,
  ) async {
    final finished = FinishedTaskModel(
      task: task,
      finishedAt: DateTime.now(),
      finishedBy: finishedBy,
      reviewer: reviewer,
      comments: comments,
    );
    await source.saveFinishedTask(finished);
    await stagedSource.deleteStagedTask(task);
  }
}

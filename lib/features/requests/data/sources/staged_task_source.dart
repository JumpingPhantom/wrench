import 'package:wrench/core/models/staged_task_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class StagedTaskSource {
  Future<List<StagedTaskModel>> getAllStagedTasks();
  Future<void> saveStagedTask(StagedTaskModel task);
  Future<void> deleteStagedTask(StagedTaskModel task);
}

class StagedTaskLocalSource implements StagedTaskSource {
  @override
  Future<List<StagedTaskModel>> getAllStagedTasks() async {
    return List.unmodifiable(Seed.stagedTasks);
  }

  @override
  Future<void> saveStagedTask(StagedTaskModel task) async {
    final index = Seed.stagedTasks.indexWhere((e) => e == task);
    if (index >= 0) {
      Seed.stagedTasks[index] = task;
    } else {
      Seed.stagedTasks.add(task);
    }
  }

  @override
  Future<void> deleteStagedTask(StagedTaskModel task) async {
    Seed.stagedTasks.remove(task);
  }
}

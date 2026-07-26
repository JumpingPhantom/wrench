import 'package:wrench/core/models/finished_task_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class FinishedTaskSource {
  Future<List<FinishedTaskModel>> getAllFinishedTasks();
  Future<void> saveFinishedTask(FinishedTaskModel task);
  Future<void> deleteFinishedTask(FinishedTaskModel task);
}

class FinishedTaskLocalSource implements FinishedTaskSource {
  @override
  Future<List<FinishedTaskModel>> getAllFinishedTasks() async {
    return List.unmodifiable(Seed.finishedTasks);
  }

  @override
  Future<void> saveFinishedTask(FinishedTaskModel task) async {
    final index = Seed.finishedTasks.indexWhere((e) => e == task);
    if (index >= 0) {
      Seed.finishedTasks[index] = task;
    } else {
      Seed.finishedTasks.add(task);
    }
  }

  @override
  Future<void> deleteFinishedTask(FinishedTaskModel task) async {
    Seed.finishedTasks.remove(task);
  }
}

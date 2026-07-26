import 'package:wrench/core/models/in_progress_task_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class InProgressTaskSource {
  Future<List<InProgressTaskModel>> getAllInProgressTasks();
  Future<void> saveInProgressTask(InProgressTaskModel task);
  Future<void> deleteInProgressTask(InProgressTaskModel task);
}

class InProgressTaskLocalSource implements InProgressTaskSource {
  @override
  Future<List<InProgressTaskModel>> getAllInProgressTasks() async {
    return List.unmodifiable(Seed.inProgressTasks);
  }

  @override
  Future<void> saveInProgressTask(InProgressTaskModel task) async {
    final index = Seed.inProgressTasks.indexWhere((e) => e == task);
    if (index >= 0) {
      Seed.inProgressTasks[index] = task;
    } else {
      Seed.inProgressTasks.add(task);
    }
  }

  @override
  Future<void> deleteInProgressTask(InProgressTaskModel task) async {
    Seed.inProgressTasks.remove(task);
  }
}

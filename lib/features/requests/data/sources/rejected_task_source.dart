import 'package:wrench/core/models/rejected_task_model.dart';
import 'package:wrench/core/utils/seed.dart';

abstract class RejectedTaskSource {
  Future<List<RejectedTaskModel>> getAllRejectedTasks();
  Future<void> saveRejectedTask(RejectedTaskModel task);
  Future<void> deleteRejectedTask(RejectedTaskModel task);
}

class RejectedTaskLocalSource implements RejectedTaskSource {
  @override
  Future<List<RejectedTaskModel>> getAllRejectedTasks() async {
    return List.unmodifiable(Seed.rejectedTasks);
  }

  @override
  Future<void> saveRejectedTask(RejectedTaskModel task) async {
    final index = Seed.rejectedTasks.indexWhere((e) => e == task);
    if (index >= 0) {
      Seed.rejectedTasks[index] = task;
    } else {
      Seed.rejectedTasks.add(task);
    }
  }

  @override
  Future<void> deleteRejectedTask(RejectedTaskModel task) async {
    Seed.rejectedTasks.remove(task);
  }
}

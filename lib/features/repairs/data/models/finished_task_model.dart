import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/features/repairs/data/models/staged_task_model.dart';

part 'finished_task_model.freezed.dart';
part 'finished_task_model.g.dart';

@freezed
abstract class FinishedTaskModel with _$FinishedTaskModel {
  const factory FinishedTaskModel({
    required StagedTaskModel task,
    required DateTime finishedAt,
    required String finishedBy,
    required String reviewer,
    required String comments,
  }) = _FinishedTaskModel;

  factory FinishedTaskModel.fromJson(Map<String, dynamic> json) =>
      _$FinishedTaskModelFromJson(json);
}

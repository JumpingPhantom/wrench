import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/models/in_progress_task_model.dart';

part 'staged_task_model.freezed.dart';
part 'staged_task_model.g.dart';

@freezed
abstract class StagedTaskModel with _$StagedTaskModel {
  const factory StagedTaskModel({
    required InProgressTaskModel task,
    required String stagedBy,
    required DateTime stagedAt,
  }) = _StagedTaskModel;

  factory StagedTaskModel.fromJson(Map<String, dynamic> json) =>
      _$StagedTaskModelFromJson(json);
}

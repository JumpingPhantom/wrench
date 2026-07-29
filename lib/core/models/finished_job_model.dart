import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/models/staged_job_model.dart';

part 'finished_job_model.freezed.dart';
part 'finished_job_model.g.dart';

@freezed
abstract class FinishedJobModel with _$FinishedJobModel {
  const factory FinishedJobModel({
    required StagedJobModel job,
    required DateTime finishedAt,
    required String finishedBy,
    required String reviewer,
    required String comments,
  }) = _FinishedJobModel;

  factory FinishedJobModel.fromJson(Map<String, dynamic> json) =>
      _$FinishedJobModelFromJson(json);
}

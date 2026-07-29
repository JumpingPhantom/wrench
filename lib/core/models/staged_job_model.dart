import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/models/in_progress_job_model.dart';

part 'staged_job_model.freezed.dart';
part 'staged_job_model.g.dart';

@freezed
abstract class StagedJobModel with _$StagedJobModel {
  const factory StagedJobModel({
    required InProgressJobModel job,
    required String stagedBy,
    required DateTime stagedAt,
  }) = _StagedJobModel;

  factory StagedJobModel.fromJson(Map<String, dynamic> json) =>
      _$StagedJobModelFromJson(json);
}

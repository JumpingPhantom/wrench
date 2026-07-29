import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/models/job_model.dart';

part 'rejected_job_model.freezed.dart';
part 'rejected_job_model.g.dart';

@freezed
abstract class RejectedJobModel with _$RejectedJobModel {
  const factory RejectedJobModel({
    required JobModel job,
    required String rejectedBy,
    required DateTime rejectedAt,
    required String reason,
  }) = _RejectedJobModel;

  factory RejectedJobModel.fromJson(Map<String, dynamic> json) =>
      _$RejectedJobModelFromJson(json);
}

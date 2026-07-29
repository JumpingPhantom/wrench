import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/models/job_model.dart';

part 'in_progress_job_model.freezed.dart';
part 'in_progress_job_model.g.dart';

@freezed
abstract class InProgressJobModel with _$InProgressJobModel {
  const factory InProgressJobModel({
    required JobModel job,
    required String approvedBy,
    required DateTime createdAt,
    required List<String> workers,
  }) = _InProgressJobModel;

  factory InProgressJobModel.fromJson(Map<String, dynamic> json) =>
      _$InProgressJobModelFromJson(json);
}

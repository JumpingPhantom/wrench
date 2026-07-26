import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/models/proposal_task_model.dart';

part 'rejected_task_model.freezed.dart';
part 'rejected_task_model.g.dart';

@freezed
abstract class RejectedTaskModel with _$RejectedTaskModel {
  const factory RejectedTaskModel({
    required ProposalTaskModel task,
    required String rejectedBy,
    required DateTime rejectedAt,
    required String reason,
  }) = _RejectedTaskModel;

  factory RejectedTaskModel.fromJson(Map<String, dynamic> json) =>
      _$RejectedTaskModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/features/repairs/data/models/proposal_task_model.dart';

part 'in_progress_task_model.freezed.dart';
part 'in_progress_task_model.g.dart';

@freezed
abstract class InProgressTaskModel with _$InProgressTaskModel {
  const factory InProgressTaskModel({
    required ProposalTaskModel proposal,
    required String approvedBy,
    required DateTime createdAt,
    required List<String> workers,
  }) = _InProgressTaskModel;

  factory InProgressTaskModel.fromJson(Map<String, dynamic> json) =>
      _$InProgressTaskModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'proposal_task_model.freezed.dart';
part 'proposal_task_model.g.dart';

@freezed
abstract class ProposalTaskModel with _$ProposalTaskModel {
  const factory ProposalTaskModel({
    required String title,
    required String description,
    required String mediaUrl,
  }) = _ProposalTaskModel;

  factory ProposalTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ProposalTaskModelFromJson(json);
}

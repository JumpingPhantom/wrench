// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_progress_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InProgressTaskModel _$InProgressTaskModelFromJson(Map<String, dynamic> json) =>
    _InProgressTaskModel(
      proposal: ProposalTaskModel.fromJson(
        json['proposal'] as Map<String, dynamic>,
      ),
      approvedBy: json['approvedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      workers: (json['workers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$InProgressTaskModelToJson(
  _InProgressTaskModel instance,
) => <String, dynamic>{
  'proposal': instance.proposal,
  'approvedBy': instance.approvedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'workers': instance.workers,
};

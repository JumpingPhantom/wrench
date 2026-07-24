// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejected_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RejectedTaskModel _$RejectedTaskModelFromJson(Map<String, dynamic> json) =>
    _RejectedTaskModel(
      task: ProposalTaskModel.fromJson(json['task'] as Map<String, dynamic>),
      rejectedBy: json['rejectedBy'] as String,
      rejectedAt: DateTime.parse(json['rejectedAt'] as String),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$RejectedTaskModelToJson(_RejectedTaskModel instance) =>
    <String, dynamic>{
      'task': instance.task,
      'rejectedBy': instance.rejectedBy,
      'rejectedAt': instance.rejectedAt.toIso8601String(),
      'reason': instance.reason,
    };

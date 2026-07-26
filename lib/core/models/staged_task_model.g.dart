// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staged_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StagedTaskModel _$StagedTaskModelFromJson(Map<String, dynamic> json) =>
    _StagedTaskModel(
      task: InProgressTaskModel.fromJson(json['task'] as Map<String, dynamic>),
      stagedBy: json['stagedBy'] as String,
      stagedAt: DateTime.parse(json['stagedAt'] as String),
    );

Map<String, dynamic> _$StagedTaskModelToJson(_StagedTaskModel instance) =>
    <String, dynamic>{
      'task': instance.task,
      'stagedBy': instance.stagedBy,
      'stagedAt': instance.stagedAt.toIso8601String(),
    };

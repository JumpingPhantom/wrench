// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinishedTaskModel _$FinishedTaskModelFromJson(Map<String, dynamic> json) =>
    _FinishedTaskModel(
      task: StagedTaskModel.fromJson(json['task'] as Map<String, dynamic>),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      finishedBy: json['finishedBy'] as String,
      reviewer: json['reviewer'] as String,
      comments: json['comments'] as String,
    );

Map<String, dynamic> _$FinishedTaskModelToJson(_FinishedTaskModel instance) =>
    <String, dynamic>{
      'task': instance.task,
      'finishedAt': instance.finishedAt.toIso8601String(),
      'finishedBy': instance.finishedBy,
      'reviewer': instance.reviewer,
      'comments': instance.comments,
    };

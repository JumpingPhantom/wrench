// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinishedJobModel _$FinishedJobModelFromJson(Map<String, dynamic> json) =>
    _FinishedJobModel(
      job: StagedJobModel.fromJson(json['job'] as Map<String, dynamic>),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      finishedBy: json['finishedBy'] as String,
      reviewer: json['reviewer'] as String,
      comments: json['comments'] as String,
    );

Map<String, dynamic> _$FinishedJobModelToJson(_FinishedJobModel instance) =>
    <String, dynamic>{
      'job': instance.job,
      'finishedAt': instance.finishedAt.toIso8601String(),
      'finishedBy': instance.finishedBy,
      'reviewer': instance.reviewer,
      'comments': instance.comments,
    };

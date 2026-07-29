// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staged_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StagedJobModel _$StagedJobModelFromJson(Map<String, dynamic> json) =>
    _StagedJobModel(
      job: InProgressJobModel.fromJson(json['job'] as Map<String, dynamic>),
      stagedBy: json['stagedBy'] as String,
      stagedAt: DateTime.parse(json['stagedAt'] as String),
    );

Map<String, dynamic> _$StagedJobModelToJson(_StagedJobModel instance) =>
    <String, dynamic>{
      'job': instance.job,
      'stagedBy': instance.stagedBy,
      'stagedAt': instance.stagedAt.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejected_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RejectedJobModel _$RejectedJobModelFromJson(Map<String, dynamic> json) =>
    _RejectedJobModel(
      job: JobModel.fromJson(json['job'] as Map<String, dynamic>),
      rejectedBy: json['rejectedBy'] as String,
      rejectedAt: DateTime.parse(json['rejectedAt'] as String),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$RejectedJobModelToJson(_RejectedJobModel instance) =>
    <String, dynamic>{
      'job': instance.job,
      'rejectedBy': instance.rejectedBy,
      'rejectedAt': instance.rejectedAt.toIso8601String(),
      'reason': instance.reason,
    };

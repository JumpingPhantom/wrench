// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_progress_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InProgressJobModel _$InProgressJobModelFromJson(Map<String, dynamic> json) =>
    _InProgressJobModel(
      job: JobModel.fromJson(json['job'] as Map<String, dynamic>),
      approvedBy: json['approvedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      workers: (json['workers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$InProgressJobModelToJson(_InProgressJobModel instance) =>
    <String, dynamic>{
      'job': instance.job,
      'approvedBy': instance.approvedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'workers': instance.workers,
    };

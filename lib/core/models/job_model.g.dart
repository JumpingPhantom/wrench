// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobModel _$JobModelFromJson(Map<String, dynamic> json) => _JobModel(
  title: json['title'] as String,
  description: json['description'] as String,
  mediaUrl: json['mediaUrl'] as String,
);

Map<String, dynamic> _$JobModelToJson(_JobModel instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'mediaUrl': instance.mediaUrl,
};

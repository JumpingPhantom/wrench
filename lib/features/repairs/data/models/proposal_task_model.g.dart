// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProposalTaskModel _$ProposalTaskModelFromJson(Map<String, dynamic> json) =>
    _ProposalTaskModel(
      title: json['title'] as String,
      description: json['description'] as String,
      mediaUrl: json['mediaUrl'] as String,
    );

Map<String, dynamic> _$ProposalTaskModelToJson(_ProposalTaskModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'mediaUrl': instance.mediaUrl,
    };

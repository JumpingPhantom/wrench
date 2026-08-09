// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Job _$JobFromJson(Map<String, dynamic> json) => _Job(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String,
  state: JobState.fromJson(json['state'] as Map<String, dynamic>),
  mediaUrl: json['mediaUrl'] as String?,
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'createdAt': instance.createdAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'state': instance.state,
  'mediaUrl': instance.mediaUrl,
};

_Draft _$DraftFromJson(Map<String, dynamic> json) =>
    _Draft($type: json['runtimeType'] as String?);

Map<String, dynamic> _$DraftToJson(_Draft instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};

_InProgress _$InProgressFromJson(Map<String, dynamic> json) => _InProgress(
  startedBy: json['startedBy'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  workers: (json['workers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$InProgressToJson(_InProgress instance) =>
    <String, dynamic>{
      'startedBy': instance.startedBy,
      'startedAt': instance.startedAt.toIso8601String(),
      'workers': instance.workers,
      'runtimeType': instance.$type,
    };

_Staged _$StagedFromJson(Map<String, dynamic> json) => _Staged(
  stagedAt: DateTime.parse(json['stagedAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$StagedToJson(_Staged instance) => <String, dynamic>{
  'stagedAt': instance.stagedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

_Finished _$FinishedFromJson(Map<String, dynamic> json) => _Finished(
  approvedBy: json['approvedBy'] as String,
  finishedAt: DateTime.parse(json['finishedAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FinishedToJson(_Finished instance) => <String, dynamic>{
  'approvedBy': instance.approvedBy,
  'finishedAt': instance.finishedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

_Cancelled _$CancelledFromJson(Map<String, dynamic> json) => _Cancelled(
  reason: json['reason'] as String,
  cancelledAt: DateTime.parse(json['cancelledAt'] as String),
  cancelledBy: json['cancelledBy'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CancelledToJson(_Cancelled instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'cancelledAt': instance.cancelledAt.toIso8601String(),
      'cancelledBy': instance.cancelledBy,
      'runtimeType': instance.$type,
    };

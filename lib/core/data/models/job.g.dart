// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Job _$JobFromJson(Map<String, dynamic> json) => _Job(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  createdBy: json['created_by'] as String,
  state: const _JobStateConverter().fromJson(
    json['state'] as Map<String, dynamic>,
  ),
  mediaUrl: json['media_url'] as String?,
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'id': ?instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'created_at': instance.createdAt.toIso8601String(),
  'created_by': instance.createdBy,
  'state': const _JobStateConverter().toJson(instance.state),
  'media_url': instance.mediaUrl,
};

_Draft _$DraftFromJson(Map<String, dynamic> json) =>
    _Draft($type: json['runtimeType'] as String?);

Map<String, dynamic> _$DraftToJson(_Draft instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};

_InProgress _$InProgressFromJson(Map<String, dynamic> json) => _InProgress(
  startedBy: json['started_by'] as String,
  startedAt: DateTime.parse(json['started_at'] as String),
  workers: (json['workers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$InProgressToJson(_InProgress instance) =>
    <String, dynamic>{
      'started_by': instance.startedBy,
      'started_at': instance.startedAt.toIso8601String(),
      'workers': instance.workers,
      'runtimeType': instance.$type,
    };

_Staged _$StagedFromJson(Map<String, dynamic> json) => _Staged(
  stagedAt: DateTime.parse(json['staged_at'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$StagedToJson(_Staged instance) => <String, dynamic>{
  'staged_at': instance.stagedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

_Finished _$FinishedFromJson(Map<String, dynamic> json) => _Finished(
  approvedBy: json['approved_by'] as String,
  finishedAt: DateTime.parse(json['finished_at'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FinishedToJson(_Finished instance) => <String, dynamic>{
  'approved_by': instance.approvedBy,
  'finished_at': instance.finishedAt.toIso8601String(),
  'runtimeType': instance.$type,
};

_Cancelled _$CancelledFromJson(Map<String, dynamic> json) => _Cancelled(
  reason: json['reason'] as String,
  cancelledAt: DateTime.parse(json['cancelled_at'] as String),
  cancelledBy: json['cancelled_by'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$CancelledToJson(_Cancelled instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'cancelled_at': instance.cancelledAt.toIso8601String(),
      'cancelled_by': instance.cancelledBy,
      'runtimeType': instance.$type,
    };

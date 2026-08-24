// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: (json['id'] as num).toInt(),
      recipientId: json['recipient_id'] as String,
      actorId: json['actor_id'] as String?,
      jobId: (json['job_id'] as num).toInt(),
      kind: $enumDecode(_$NotificationKindEnumMap, json['kind']),
      createdAt: const UtcDateTime().fromJson(json['created_at'] as String),
      readAt: const NullableUtcDateTime().fromJson(json['read_at'] as String?),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipient_id': instance.recipientId,
      'actor_id': instance.actorId,
      'job_id': instance.jobId,
      'kind': _$NotificationKindEnumMap[instance.kind]!,
      'created_at': const UtcDateTime().toJson(instance.createdAt),
      'read_at': const NullableUtcDateTime().toJson(instance.readAt),
    };

const _$NotificationKindEnumMap = {
  NotificationKind.jobCreated: 'job_created',
  NotificationKind.jobSubmitted: 'job_submitted',
};

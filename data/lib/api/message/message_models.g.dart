// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiThreadImpl _$$ApiThreadImplFromJson(Map<String, dynamic> json) =>
    _$ApiThreadImpl(
      id: json['id'] as String,
      space_id: json['space_id'] as String,
      admin_id: json['admin_id'] as String,
      member_ids: (json['member_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      archived_for: (json['archived_for'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      created_at: (json['created_at'] as num?)?.toInt(),
      last_message: json['last_message'] as String?,
      last_message_at: const ServerTimestampConverter()
          .fromJson(json['last_message_at'] as Timestamp?),
    );

Map<String, dynamic> _$$ApiThreadImplToJson(_$ApiThreadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space_id': instance.space_id,
      'admin_id': instance.admin_id,
      'member_ids': instance.member_ids,
      'archived_for': instance.archived_for,
      'created_at': instance.created_at,
      'last_message': instance.last_message,
      'last_message_at':
          const ServerTimestampConverter().toJson(instance.last_message_at),
    };

_$ApiThreadMessageImpl _$$ApiThreadMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiThreadMessageImpl(
      id: json['id'] as String,
      thread_id: json['thread_id'] as String,
      sender_id: json['sender_id'] as String,
      message: json['message'] as String,
      seen_by:
          (json['seen_by'] as List<dynamic>).map((e) => e as String).toList(),
      archived_for: (json['archived_for'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      created_at: const ServerTimestampConverter()
          .fromJson(json['created_at'] as Timestamp?),
    );

Map<String, dynamic> _$$ApiThreadMessageImplToJson(
        _$ApiThreadMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'thread_id': instance.thread_id,
      'sender_id': instance.sender_id,
      'message': instance.message,
      'seen_by': instance.seen_by,
      'archived_for': instance.archived_for,
      'created_at':
          const ServerTimestampConverter().toJson(instance.created_at),
    };

_$ThreadInfoImpl _$$ThreadInfoImplFromJson(Map<String, dynamic> json) =>
    _$ThreadInfoImpl(
      thread: ApiThread.fromJson(json['thread'] as Map<String, dynamic>),
      threadMessage: (json['threadMessage'] as List<dynamic>)
          .map((e) => ApiThreadMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>)
          .map((e) => ApiUserInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ThreadInfoImplToJson(_$ThreadInfoImpl instance) =>
    <String, dynamic>{
      'thread': instance.thread.toJson(),
      'threadMessage': instance.threadMessage.map((e) => e.toJson()).toList(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };

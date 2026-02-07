// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  senderId: json['sender_id'] as String,
  senderName: json['sender_name'] as String?,
  content: json['content'] as String,
  messageType: json['message_type'] as String? ?? 'text',
  mediaUrl: json['media_url'] as String?,
  isRead: json['is_read'] as bool? ?? false,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'content': instance.content,
      'message_type': instance.messageType,
      'media_url': instance.mediaUrl,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };

WSMessage _$WSMessageFromJson(Map<String, dynamic> json) => WSMessage(
  type: json['type'] as String,
  conversationId: json['conversation_id'] as String,
  senderId: json['sender_id'] as String?,
  content: json['content'] as String?,
  messageType: json['message_type'] as String?,
  mediaUrl: json['media_url'] as String?,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$WSMessageToJson(WSMessage instance) => <String, dynamic>{
  'type': instance.type,
  'conversation_id': instance.conversationId,
  'sender_id': instance.senderId,
  'content': instance.content,
  'message_type': instance.messageType,
  'media_url': instance.mediaUrl,
  'timestamp': instance.timestamp,
};

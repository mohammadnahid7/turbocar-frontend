/// Message Model
/// Represents a single chat message
library;

import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @JsonKey(name: 'sender_id')
  final String senderId;
  @JsonKey(name: 'sender_name')
  final String? senderName;
  final String content;
  @JsonKey(name: 'message_type')
  final String messageType; // text, image, file
  @JsonKey(name: 'media_url')
  final String? mediaUrl;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'created_at')
  final String createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.content,
    this.messageType = 'text',
    this.mediaUrl,
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  /// Parse createdAt to DateTime
  DateTime get timestamp => DateTime.parse(createdAt);

  /// Check if this message is from the current user
  bool isFromMe(String currentUserId) => senderId == currentUserId;
}

/// WebSocket message for real-time communication
@JsonSerializable()
class WSMessage {
  final String type; // message, typing, read_receipt
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @JsonKey(name: 'sender_id')
  final String? senderId;
  final String? content;
  @JsonKey(name: 'message_type')
  final String? messageType;
  @JsonKey(name: 'media_url')
  final String? mediaUrl;
  final String? timestamp;

  WSMessage({
    required this.type,
    required this.conversationId,
    this.senderId,
    this.content,
    this.messageType,
    this.mediaUrl,
    this.timestamp,
  });

  factory WSMessage.fromJson(Map<String, dynamic> json) =>
      _$WSMessageFromJson(json);

  Map<String, dynamic> toJson() => _$WSMessageToJson(this);

  /// Create a text message
  factory WSMessage.text({
    required String conversationId,
    required String content,
  }) {
    return WSMessage(
      type: 'message',
      conversationId: conversationId,
      content: content,
      messageType: 'text',
    );
  }

  /// Create a typing indicator
  factory WSMessage.typing({required String conversationId}) {
    return WSMessage(type: 'typing', conversationId: conversationId);
  }

  /// Create a read receipt
  factory WSMessage.readReceipt({
    required String conversationId,
    required String messageId,
  }) {
    return WSMessage(
      type: 'read_receipt',
      conversationId: conversationId,
      content: messageId,
    );
  }
}

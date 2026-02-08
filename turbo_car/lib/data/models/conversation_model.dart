/// Conversation Model
/// Represents a chat conversation between users
library;

import 'package:json_annotation/json_annotation.dart';
import 'message_model.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  final String id;
  @JsonKey(name: 'car_id')
  final String? carId;
  @JsonKey(name: 'car_title')
  final String? carTitle;
  @JsonKey(name: 'car_image_url')
  final String? carImageUrl;
  @JsonKey(name: 'car_price')
  final double? carPrice;
  final List<ParticipantModel> participants;
  @JsonKey(name: 'last_message')
  final MessageModel? lastMessage;
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final Map<String, dynamic>? metadata;

  ConversationModel({
    required this.id,
    this.carId,
    this.carTitle,
    this.carImageUrl,
    this.carPrice,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,

    required this.updatedAt,
    this.metadata,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

  /// Get the other participant (for 1-on-1 chats)
  ParticipantModel? getOtherParticipant(String currentUserId) {
    return participants.firstWhere(
      (p) => p.userId != currentUserId,
      orElse: () => participants.first,
    );
  }

  /// Create a copy with updated fields
  ConversationModel copyWith({
    String? id,
    String? carId,
    String? carTitle,
    String? carImageUrl,
    double? carPrice,
    List<ParticipantModel>? participants,
    MessageModel? lastMessage,
    int? unreadCount,
    String? createdAt,
    String? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      carTitle: carTitle ?? this.carTitle,
      carImageUrl: carImageUrl ?? this.carImageUrl,
      carPrice: carPrice ?? this.carPrice,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

@JsonSerializable()
class ParticipantModel {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  ParticipantModel({required this.userId, this.fullName, this.avatarUrl});

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantModelToJson(this);
}

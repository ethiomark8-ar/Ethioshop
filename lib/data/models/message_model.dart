import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ethioshop/domain/entities/message_entity.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Message Model - Data layer representation for serialization
/// Converts between Firestore documents and Domain entities
@freezed
class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required String type,
    required DateTime timestamp,
    @JsonKey(defaultValue: false) bool isRead,
    @JsonKey(defaultValue: false) bool isDelivered,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in document
    return json;
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: MessageType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MessageType.text,
      ),
      timestamp: timestamp,
      isRead: isRead,
      isDelivered: isDelivered,
      imageUrl: imageUrl,
      metadata: metadata,
    );
  }
}

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required List<String> participants,
    String? lastMessage,
    String? lastMessageType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  factory ConversationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversationModel.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in document
    return json;
  }
}
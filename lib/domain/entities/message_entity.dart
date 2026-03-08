import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

/// Message Entity - Domain layer representation for P2P chat
/// Pure Dart class, no Flutter dependencies
@freezed
class MessageEntity with _$MessageEntity {
  const MessageEntity._();

  const factory MessageEntity({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required MessageType type,
    required DateTime timestamp,
    bool isRead,
    bool isDelivered,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) = _MessageEntity;

  bool get isText => type == MessageType.text;
  bool get isImage => type == MessageType.image;
  bool get isFromCurrentUser => senderId == receiverId; // Will be set properly in use case
}

enum MessageType {
  text,
  image,
  system,
}

extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
      case MessageType.system:
        return 'System';
    }
  }
}

@freezed
class ConversationEntity with _$ConversationEntity {
  const factory ConversationEntity({
    required String id,
    required String participantId,
    required String participantName,
    required String participantAvatar,
    MessageEntity? lastMessage,
    int unreadCount,
    DateTime? updatedAt,
  }) = _ConversationEntity;

  bool get hasUnreadMessages => unreadCount > 0;
}
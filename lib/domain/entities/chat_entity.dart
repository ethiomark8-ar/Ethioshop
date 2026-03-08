import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final Map<String, String?> participantAvatars;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
  final bool isActive;

  const ChatEntity({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    required this.participantAvatars,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
    this.isActive = true,
  });

  String get otherParticipantId => 
      participantIds.length == 2 
          ? participantIds.first 
          : participantIds.first;

  @override
  List<Object?> get props => [
        id,
        participantIds,
        participantNames,
        participantAvatars,
        lastMessage,
        unreadCount,
        updatedAt,
        isActive,
      ];
}

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final String? attachmentUrl;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    this.attachmentUrl,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        content,
        type,
        attachmentUrl,
        isRead,
        createdAt,
        readAt,
      ];
}

enum MessageType {
  text,
  image,
  product,
  system,
}

extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.product:
        return 'product';
      case MessageType.system:
        return 'system';
    }
  }
}
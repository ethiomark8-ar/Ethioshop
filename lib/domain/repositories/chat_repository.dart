import 'package:dartz/dartz.dart';
import '../entities/chat_entity.dart';
import '../failures/failure.dart';

abstract class ChatRepository {
  // Chat Operations
  Future<Either<Failure, List<ChatEntity>>> getChats();

  Future<Either<Failure, ChatEntity>> getChatById(String chatId);

  Future<Either<Failure, ChatEntity>> getOrCreateChat({
    required String otherUserId,
  });

  Future<Either<Failure, void>> markChatAsRead(String chatId);

  // Message Operations
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String chatId,
    int? limit,
    String? lastMessageId,
  });

  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? attachmentUrl,
  });

  Future<Either<Failure, void>> markMessageAsRead({
    required String messageId,
  });

  Future<Either<Failure, String>> uploadMessageAttachment({
    required String chatId,
    required String filePath,
  });

  // Typing Indicators
  Future<Either<Failure, void>> setTypingStatus({
    required String chatId,
    required bool isTyping,
  });

  // Streams
  Stream<List<ChatEntity>> get chatsStream;
  Stream<List<MessageEntity>> getMessagesStream(String chatId);
  Stream<Map<String, bool>> getTypingStatusStream(String chatId);
}
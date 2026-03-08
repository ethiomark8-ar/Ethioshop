import 'package:dartz/dartz.dart';
import 'package:ethioshop/core/error/failures.dart';
import 'package:ethioshop/data/datasources/firebase/chat_firebase_datasource.dart';
import 'package:ethioshop/data/models/message_model.dart';
import 'package:ethioshop/domain/entities/message_entity.dart';
import 'package:ethioshop/domain/repositories/chat_repository.dart';
import 'dart:io';

/// Chat Repository Implementation
/// Data layer - Implements domain interface using Firebase datasource
class ChatRepositoryImpl implements ChatRepository {
  final ChatFirebaseDatasource _chatDatasource;

  // Current user ID - would be injected from auth repository
  String? _currentUserId;

  ChatRepositoryImpl(this._chatDatasource);

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  String get _userId => _currentUserId ?? '';

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final querySnapshot = await _chatDatasource.getConversations(
        userId: _userId,
      );

      final conversations = <ConversationEntity>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final participants = data['participants'] as List;
        
        // Get the other participant
        final otherParticipantId = participants.firstWhere(
          (id) => id != _userId,
          orElse: () => '',
        );

        // In a real implementation, you'd fetch user details
        // This is simplified
        conversations.add(ConversationEntity(
          id: doc.id,
          participantId: otherParticipantId,
          participantName: 'User', // Would fetch from Firestore
          participantAvatar: '',
          lastMessage: null, // Would parse from lastMessage field
          unreadCount: 0, // Would calculate from unread messages
          updatedAt: data['updatedAt']?.toDate(),
        ));
      }

      return Right(conversations);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId) async {
    try {
      final querySnapshot = await _chatDatasource.getMessages(
        conversationId: conversationId,
      );

      final messages = querySnapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc).toEntity())
          .toList();

      return Right(messages);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendTextMessage({
    required String receiverId,
    required String content,
  }) async {
    try {
      final conversationId = await _chatDatasource.getOrCreateConversation(
        currentUserId: _userId,
        otherUserId: receiverId,
      );

      final docRef = await _chatDatasource.sendMessage(
        conversationId: conversationId,
        senderId: _userId,
        receiverId: receiverId,
        content: content,
        type: MessageType.text.name,
      );

      final updatedData = {
        'id': docRef.id,
        'conversationId': conversationId,
        'senderId': _userId,
        'receiverId': receiverId,
        'content': content,
        'type': MessageType.text.name,
        'timestamp': DateTime.now(),
        'isRead': false,
        'isDelivered': false,
      };

      final messageModel = MessageModel.fromJson(updatedData);
      return Right(messageModel.toEntity());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendImageMessage({
    required String receiverId,
    required String imagePath,
  }) async {
    try {
      final conversationId = await _chatDatasource.getOrCreateConversation(
        currentUserId: _userId,
        otherUserId: receiverId,
      );

      // Upload image
      final imageUrl = await _chatDatasource.uploadChatImage(
        imageFile: File(imagePath),
        conversationId: conversationId,
      );

      final docRef = await _chatDatasource.sendMessage(
        conversationId: conversationId,
        senderId: _userId,
        receiverId: receiverId,
        content: 'Image',
        type: MessageType.image.name,
        imageUrl: imageUrl,
      );

      final updatedData = {
        'id': docRef.id,
        'conversationId': conversationId,
        'senderId': _userId,
        'receiverId': receiverId,
        'content': 'Image',
        'type': MessageType.image.name,
        'timestamp': DateTime.now(),
        'isRead': false,
        'isDelivered': false,
        'imageUrl': imageUrl,
      };

      final messageModel = MessageModel.fromJson(updatedData);
      return Right(messageModel.toEntity());
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String conversationId) async {
    try {
      await _chatDatasource.markMessagesAsRead(
        conversationId: conversationId,
        receiverId: _userId,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await _chatDatasource.deleteMessage(messageId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getOrCreateConversation(String participantId) async {
    try {
      final conversationId = await _chatDatasource.getOrCreateConversation(
        currentUserId: _userId,
        otherUserId: participantId,
      );
      return Right(conversationId);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> watchMessages(String conversationId) {
    return _chatDatasource.watchMessages(conversationId).map((snapshot) {
      try {
        final messages = snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc).toEntity())
            .toList();
        return Right(messages);
      } catch (e) {
        return Left(Failure.unknown(message: e.toString()));
      }
    });
  }

  @override
  Stream<Either<Failure, List<ConversationEntity>>> watchConversations() {
    return _chatDatasource.watchConversations(_userId).map((snapshot) {
      try {
        final conversations = <ConversationEntity>[];

        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final participants = data['participants'] as List;
          
          final otherParticipantId = participants.firstWhere(
            (id) => id != _userId,
            orElse: () => '',
          );

          conversations.add(ConversationEntity(
            id: doc.id,
            participantId: otherParticipantId,
            participantName: 'User',
            participantAvatar: '',
            lastMessage: null,
            unreadCount: 0,
            updatedAt: data['updatedAt']?.toDate(),
          ));
        }

        return Right(conversations);
      } catch (e) {
        return Left(Failure.unknown(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _chatDatasource.getUnreadCount(_userId);
      return Right(count);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadChatImage(String imagePath) async {
    try {
      // This would need a conversation ID, so it's handled in sendImageMessage
      return Left(Failure.unknown(message: 'Use sendImageMessage instead'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
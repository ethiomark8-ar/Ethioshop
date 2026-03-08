import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/// Firebase Chat Datasource
/// Data layer - Handles all chat-related Firebase operations
class ChatFirebaseDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ChatFirebaseDatasource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference get _conversationsCollection =>
      _firestore.collection('conversations');

  CollectionReference get _messagesCollection =>
      _firestore.collection('messages');

  /// Get or create conversation ID between two users
  Future<String> getOrCreateConversation({
    required String currentUserId,
    required String otherUserId,
  }) async {
    // Try to find existing conversation
    final query = await _conversationsCollection
        .where('participants', arrayContains: currentUserId)
        .get();

    for (final doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final participants = data['participants'] as List;
      if (participants.contains(otherUserId) && participants.length == 2) {
        return doc.id;
      }
    }

    // Create new conversation
    final docRef = await _conversationsCollection.add({
      'participants': [currentUserId, otherUserId],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
    });

    return docRef.id;
  }

  /// Get messages for a conversation
  Future<QuerySnapshot> getMessages({
    required String conversationId,
    int? limit,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _messagesCollection
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.get();
  }

  /// Stream messages for real-time updates
  Stream<QuerySnapshot> watchMessages(String conversationId) {
    return _messagesCollection
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Send message
  Future<DocumentReference> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required String type,
    String? imageUrl,
  }) async {
    final docRef = await _messagesCollection.add({
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'isDelivered': false,
      if (imageUrl != null) 'imageUrl': imageUrl,
    });

    // Update conversation metadata
    await _conversationsCollection.doc(conversationId).update({
      'lastMessage': content,
      'lastMessageType': type,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef;
  }

  /// Stream conversations for current user
  Stream<QuerySnapshot> watchConversations(String userId) {
    return _conversationsCollection
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  /// Get conversations for current user
  Future<QuerySnapshot> getConversations({
    required String userId,
    int? limit,
  }) async {
    Query query = _conversationsCollection
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String receiverId,
  }) async {
    final messages = await _messagesCollection
        .where('conversationId', isEqualTo: conversationId)
        .where('receiverId', isEqualTo: receiverId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in messages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Delete message
  Future<void> deleteMessage(String messageId) async {
    await _messagesCollection.doc(messageId).delete();
  }

  /// Get unread message count
  Future<int> getUnreadCount(String userId) async {
    final snapshot = await _messagesCollection
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    return snapshot.size;
  }

  /// Upload chat image
  Future<String> uploadChatImage({
    required File imageFile,
    required String conversationId,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'chats/$conversationId/$timestamp.jpg';

    try {
      final ref = _storage.ref().child(fileName);
      final uploadTask = ref.putFile(imageFile);

      await uploadTask;

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload chat image: ${e.toString()}');
    }
  }
}
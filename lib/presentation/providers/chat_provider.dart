import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_entity.dart';

// Chat State
class ChatState {
  final List<ChatEntity> chats;
  final ChatEntity? currentChat;
  final List<MessageEntity> messages;
  final bool isLoading;
  final String? error;
  final bool hasMoreMessages;

  const ChatState({
    this.chats = const [],
    this.currentChat,
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.hasMoreMessages = true,
  });

  ChatState copyWith({
    List<ChatEntity>? chats,
    ChatEntity? currentChat,
    List<MessageEntity>? messages,
    bool? isLoading,
    String? error,
    bool? hasMoreMessages,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      currentChat: currentChat ?? this.currentChat,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
    );
  }

  int get unreadCount => chats.fold(0, (sum, chat) => sum + chat.unreadCount);
}

// Chat Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;

  ChatNotifier(this.ref) : super(const ChatState()) {
    _loadMockChats();
  }

  void _loadMockChats() {
    // Mock chats for development
    final mockChats = [
      ChatEntity(
        id: 'chat_1',
        participantIds: const ['user_123', 'seller_1'],
        participantNames: const {'user_123': 'Abebe Bikila', 'seller_1': 'Ethiopian Coffee House'},
        participantImages: const {
          'user_123': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
          'seller_1': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=100',
        },
        lastMessage: 'Thank you for your order! Your coffee will be shipped tomorrow.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
        lastMessageSenderId: 'seller_1',
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        productId: 'prod_1',
        productName: 'Ethiopian Coffee - Yirgacheffe',
      ),
      ChatEntity(
        id: 'chat_2',
        participantIds: const ['user_123', 'seller_2'],
        participantNames: const {'user_123': 'Abebe Bikila', 'seller_2': 'Habesha Crafts'},
        participantImages: const {
          'user_123': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
          'seller_2': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=100',
        },
        lastMessage: 'The traditional dress is ready for pickup.',
        lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
        lastMessageSenderId: 'seller_2',
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        productId: 'prod_4',
        productName: 'Handwoven Ethiopian Dress',
      ),
      ChatEntity(
        id: 'chat_3',
        participantIds: const ['user_123', 'seller_3'],
        participantNames: const {'user_123': 'Abebe Bikila', 'seller_3': 'Abyssinia Spices'},
        participantImages: const {
          'user_123': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
          'seller_3': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=100',
        },
        lastMessage: 'Do you have berbere spice in bulk?',
        lastMessageAt: DateTime.now().subtract(const Duration(days: 3)),
        lastMessageSenderId: 'user_123',
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        productId: 'prod_3',
        productName: 'Ethiopian Spices Set',
      ),
    ];

    state = state.copyWith(chats: mockChats);
  }

  Future<void> loadChatMessages(String chatId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Find the chat
      final chat = state.chats.firstWhere((c) => c.id == chatId);

      // Mock messages
      final mockMessages = _getMockMessages(chatId);

      state = state.copyWith(
        currentChat: chat,
        messages: mockMessages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load messages: $e',
      );
    }
  }

  List<MessageEntity> _getMockMessages(String chatId) {
    final now = DateTime.now();

    if (chatId == 'chat_1') {
      return [
        MessageEntity(
          id: 'msg_1',
          chatId: 'chat_1',
          senderId: 'user_123',
          content: 'Hello! I\'m interested in your Yirgacheffe coffee. What\'s the origin?',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 5)),
        ),
        MessageEntity(
          id: 'msg_2',
          chatId: 'chat_1',
          senderId: 'seller_1',
          content: 'Welcome! Our Yirgacheffe coffee is sourced directly from the Yirgacheffe region in southern Ethiopia. It\'s known for its bright acidity and floral notes.',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 5, minutes: 5)),
        ),
        MessageEntity(
          id: 'msg_3',
          chatId: 'chat_1',
          senderId: 'user_123',
          content: 'That sounds great! How much is 1kg?',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 4)),
        ),
        MessageEntity(
          id: 'msg_4',
          chatId: 'chat_1',
          senderId: 'seller_1',
          content: '1kg is 450 ETB. We also have a special offer: buy 2kg and get 10% off!',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 4, minutes: 10)),
        ),
        MessageEntity(
          id: 'msg_5',
          chatId: 'chat_1',
          senderId: 'user_123',
          content: 'Perfect! I\'ll place an order for 2kg.',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 3)),
        ),
        MessageEntity(
          id: 'msg_6',
          chatId: 'chat_1',
          senderId: 'seller_1',
          content: 'Thank you for your order! Your coffee will be shipped tomorrow.',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
      ];
    } else if (chatId == 'chat_2') {
      return [
        MessageEntity(
          id: 'msg_7',
          chatId: 'chat_2',
          senderId: 'user_123',
          content: 'Hi, I\'m interested in the handwoven dress. Can I see more photos?',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 10)),
        ),
        MessageEntity(
          id: 'msg_8',
          chatId: 'chat_2',
          senderId: 'seller_2',
          content: 'Of course! Here are some additional photos.',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 10, minutes: 15)),
        ),
        MessageEntity(
          id: 'msg_9',
          chatId: 'chat_2',
          senderId: 'seller_2',
          content: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400',
          type: MessageType.image,
          imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400',
          createdAt: now.subtract(const Duration(days: 10, minutes: 14)),
        ),
        MessageEntity(
          id: 'msg_10',
          chatId: 'chat_2',
          senderId: 'user_123',
          content: 'Beautiful! I\'ll order it now.',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 9)),
        ),
        MessageEntity(
          id: 'msg_11',
          chatId: 'chat_2',
          senderId: 'seller_2',
          content: 'The traditional dress is ready for pickup.',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ];
    } else {
      return [
        MessageEntity(
          id: 'msg_12',
          chatId: 'chat_3',
          senderId: 'user_123',
          content: 'Do you have berbere spice in bulk?',
          type: MessageType.text,
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      ];
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    try {
      final newMessage = MessageEntity(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        chatId: chatId,
        senderId: 'user_123',
        content: content,
        type: type,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      // Add message to list
      final updatedMessages = [...state.messages, newMessage];

      // Update chat's last message
      final updatedChats = state.chats.map((chat) {
        if (chat.id == chatId) {
          return chat.copyWith(
            lastMessage: content,
            lastMessageAt: DateTime.now(),
            lastMessageSenderId: 'user_123',
            updatedAt: DateTime.now(),
          );
        }
        return chat;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        chats: updatedChats,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to send message: $e');
    }
  }

  Future<void> createChat({
    required String sellerId,
    required String sellerName,
    String? sellerImage,
    String? productId,
    String? productName,
  }) async {
    // Check if chat already exists
    final existingChat = state.chats.where((chat) =>
      chat.participantIds.contains(sellerId) &&
      (productId == null || chat.productId == productId)
    ).firstOrNull;

    if (existingChat != null) {
      state = state.copyWith(currentChat: existingChat);
      await loadChatMessages(existingChat.id);
      return;
    }

    // Create new chat
    final newChat = ChatEntity(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      participantIds: ['user_123', sellerId],
      participantNames: {
        'user_123': 'Abebe Bikila',
        sellerId: sellerName,
      },
      participantImages: {
        'user_123': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        if (sellerImage != null) sellerId: sellerImage,
      },
      lastMessage: '',
      lastMessageAt: DateTime.now(),
      lastMessageSenderId: 'user_123',
      unreadCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      productId: productId,
      productName: productName,
    );

    state = state.copyWith(
      chats: [newChat, ...state.chats],
      currentChat: newChat,
      messages: [],
    );
  }

  Future<void> markAsRead(String chatId) async {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(unreadCount: 0);
      }
      return chat;
    }).toList();

    state = state.copyWith(chats: updatedChats);
  }

  void clearCurrentChat() {
    state = state.copyWith(currentChat: null, messages: []);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});

// Chat by ID provider
final chatByIdProvider = Provider.family<ChatEntity?, String>((ref, chatId) {
  final chats = ref.watch(chatProvider).chats;
  try {
    return chats.firstWhere((c) => c.id == chatId);
  } catch (e) {
    return null;
  }
});

// Unread message count provider
final unreadMessageCountProvider = Provider<int>((ref) {
  return ref.watch(chatProvider).unreadCount;
});

// Messages for current chat provider
final currentChatMessagesProvider = Provider<List<MessageEntity>>((ref) {
  return ref.watch(chatProvider).messages;
});
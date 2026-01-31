/// Chat Repository
/// Handles chat-related operations
library;

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  // Fetch chats
  Future<List<ChatModel>> fetchChats() async {
    try {
      return await _apiService.getChats();
    } catch (e) {
      rethrow;
    }
  }

  // Fetch messages with a user
  Future<List<ChatModel>> fetchMessages(String userId) async {
    try {
      return await _apiService.getMessagesWithUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  // Send message (placeholder - will be implemented with socket)
  Future<void> sendMessage(String userId, String message) async {
    // TODO: Implement with socket service
    throw UnimplementedError(
      'Send message will be implemented with socket service',
    );
  }
}

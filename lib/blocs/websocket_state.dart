import '../../models/chat_message.dart';

class WebSocketState {
  final List<ChatMessage> messages;

  WebSocketState({required this.messages});

  WebSocketState copyWith({List<ChatMessage>? messages}) {
    return WebSocketState(
      messages: messages ?? this.messages,
    );
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/chat_message.dart';
import '../service/websocket_service.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketService _service;
  late final StreamSubscription _subscription;

  WebSocketBloc(this._service) : super(WebSocketState(messages: [])) {
    on<ConnectWebSocket>(_onConnect);
    on<SendWebSocketMessage>(_onSend);
    on<ReceiveWebSocketMessage>(_onReceive);

    add(ConnectWebSocket());
  }

  void _onConnect(ConnectWebSocket event, Emitter<WebSocketState> emit) {
    _service.connect('wss://echo.websocket.org/');
    _subscription = _service.messageStream.listen(
      (message) => add(ReceiveWebSocketMessage(message)),
    );
  }

  void _onSend(SendWebSocketMessage event, Emitter<WebSocketState> emit) {
    _service.sendMessage(event.message);
    final updated = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(text: event.message, type: MessageType.sent));
    emit(state.copyWith(messages: updated));
  }

  void _onReceive(ReceiveWebSocketMessage event, Emitter<WebSocketState> emit) {
    final updated = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(text: event.message, type: MessageType.received));
    emit(state.copyWith(messages: updated));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _service.disconnect();
    return super.close();
  }
}

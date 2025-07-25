abstract class WebSocketEvent {}

class ConnectWebSocket extends WebSocketEvent {}

class SendWebSocketMessage extends WebSocketEvent {
  final String message;
  SendWebSocketMessage(this.message);
}

class ReceiveWebSocketMessage extends WebSocketEvent {
  final String message;
  ReceiveWebSocketMessage(this.message);
}

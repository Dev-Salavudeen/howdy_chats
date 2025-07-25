import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketService {
  Stream<String> get messageStream;
  void connect(String url);
  void sendMessage(String message);
  void disconnect();
}

class WebSocketServiceImpl implements WebSocketService {
  late WebSocketChannel _channel;
  final _messageController = StreamController<String>.broadcast();

  @override
  Stream<String> get messageStream => _messageController.stream;

  @override
  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen(
          (message) => _messageController.add(message),
      onError: (error) => _messageController.addError(error),
    );
  }

  @override
  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  @override
  void disconnect() {
    _channel.sink.close();
    _messageController.close();
  }
}

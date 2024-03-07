import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class MessageSender {
  late Uri uri;
  late WebSocketChannel _channel;

  MessageSender(this.uri) {
    _channel = WebSocketChannel.connect(uri);
  }

  void sendMessage(String message) {
    _channel.sink.add(jsonEncode({'message': message}));
  }

  void dispose() {
    _channel.sink.close();
  }
}

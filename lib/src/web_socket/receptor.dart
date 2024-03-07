import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class MessageReceiver {
  late Uri uri;
  late WebSocketChannel _channel;
  late StreamSubscription _subscription;

  MessageReceiver(this.uri);

  void startListening() {
    _channel = WebSocketChannel.connect(uri);
    _subscription = _channel.stream.listen((message) {
      print('Mensaje recibido: $message');
    });
  }

  void dispose() {
    _subscription.cancel();
    _channel.sink.close();
  }
}
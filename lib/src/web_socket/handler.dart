// import 'dart:async';
// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageHandler extends StatefulWidget {
  const MessageHandler({super.key});

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  late WebSocketChannel _channel;
  final _messages = <String>[];

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://echo.websocket.org'));
    _channel.stream.listen((message) {
      setState(() {
        print(message);
        _messages.add(message);
      });
    });
  }

  void sendMessage(String message) {
    print(message);
    _channel.sink.add(jsonEncode({'message': message}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Sender & Receiver'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          TextField(
            onSubmitted: sendMessage,
            decoration: const InputDecoration(
              labelText: 'Send Message',
              contentPadding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}

// import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketScreen10 extends StatefulWidget {
  const WebSocketScreen10({
    super.key,
  });

  @override
  State<WebSocketScreen10> createState() => _WebSocketScreen10State();
}

class _WebSocketScreen10State extends State<WebSocketScreen10> {
  late WebSocketChannel _channel;
  late StreamSubscription subscription;
  final TextEditingController _controller = TextEditingController();
  final String title = 'Web Socket Channel Demo';
  final List<String> _messages = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.events'),
    );

    setState(() {
      isConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Sent Messages:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) _messages.add(snapshot.data);

                return Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_messages[index]),
                      );
                    },
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed: _sendMessage,
                  tooltip: 'Send message',
                  child: const Icon(Icons.send),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed: _clearMessages,
                  tooltip: 'Clear sent messages',
                  child: const Icon(Icons.clear),
                ),
              ),
            ),
            Center(
              child: isConnected
                  ? const Text('WebSocket connection is active')
                  : const Text('WebSocket connection is closed'),
            ),
          ],
        ),
      ),
    );
  }

  void listen() {
    _channel.stream.listen((message) {
      _channel.sink.add('received!');
      _channel.sink.close(status.goingAway);
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    isConnected = false;
    super.dispose();
  }
}

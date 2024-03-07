import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOScreen extends StatefulWidget {
  const SocketIOScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SocketIOScreenState createState() => _SocketIOScreenState();
}

class _SocketIOScreenState extends State<SocketIOScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  var isConnected = false;

  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      setState(() {
        isConnected = true;
      });
      print('Conectado');
    });

    socket.on('disconnect', (_) {
      setState(() {
        isConnected = false;
      });
      print('Desconectado');
    });

    socket.on('chat', (message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket.IO Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]),
                    );
                  },
                ),
              ),
              Center(
                child: isConnected
                    ? const Text('Socket.IO connection is active')
                    : const Text('Socket.IO connection is closed'),
              ),
              FloatingActionButton(
                onPressed: _sendMessage,
                tooltip: 'Clear sent messages',
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (isConnected && _controller.text.isNotEmpty) {
      socket.emit('chat', _controller.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }
}

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
  Map marketSetData = {};
  List markets = [];

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      setState(() {
        isConnected = true;
      });
    });

    socket.on('disconnect', (_) {
      setState(() {
        isConnected = false;
      });
    });

    socket.on('match-summary', (message) {
      setState(() {
        messages.add(message);
      });
    });

    socket.on('market-set', (data) {
      setState(() {
        marketSetData = data;
        markets = data['markets'];
        messages.add('Data: ${data['markets']}');
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
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: messages.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(messages[index]),
              //       );
              //     },
              //   ),
              // ),
              Text('Event ID: ${marketSetData['eventId']}'),
              Expanded(
                child: ListView.builder(
                  itemCount: markets.length,
                  itemBuilder: (context, index) {
                    final market = markets[index];

                    return ExpansionTile(
                      title: Text('Market ID: ${market['id']}'),
                      subtitle: Text('Name: ${market['name']}'),
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Status: ${market['status']}'),
                                  Text('Date: ${market['eventData']}'),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: market['marketType']
                                              ['selections']
                                          .length,
                                      itemBuilder:
                                          (contextSelection, indexSelection) {
                                        final selection = market['marketType']
                                            ['selections'][indexSelection];
                                        // return Text('Name: ${selection['name']}');

                                        return ExpansionTile(
                                            title: Text(
                                                'Selection ID: ${selection['id']}'),
                                            subtitle: Text(
                                                'Name: ${selection['name']}'),
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                            'Status: ${selection['status']}'),
                                                        Text(
                                                            'Competitor ID: ${selection['competitorId']}'),
                                                        Text(
                                                            'Competitor ID: ${selection['numerator']}')
                                                      ]))
                                            ]);
                                      }),
                                ]))
                      ],
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: markets.length,
              //     itemBuilder: (context, index) {
              //       return Column(children: <Widget>[
              //         Expanded(
              //             child: ListView.builder(
              //                 itemCount: markets[index]['selections'].length,
              //                 itemBuilder: (context, indexSelection) {
              //                   return ListTile(
              //                     title: Text(markets[index]['selections']
              //                             [indexSelection]
              //                         .name),
              //                   );
              //                 }))
              //       ]);
              //     },
              //   ),
              // ),
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

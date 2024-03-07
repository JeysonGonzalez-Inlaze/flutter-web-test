import 'package:flutter/foundation.dart';

class SentMessagesModel extends ChangeNotifier {
  final List<String> _messages = [];

  List get sentMessages => _messages;

  void add(String message) {
    print('message ${message}');
    _messages.add(message);
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  void clear() {
    _messages.clear();
  }
}

import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<String> chats = [
    "Hii, How are you",
    "I am fine, How about you ...",
  ];

  void addChat(String val) {
    chats.add(val);
    notifyListeners();
  }
}

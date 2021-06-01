import 'package:flutter/material.dart';
import 'package:list_animation/models/message_model.dart';

class MqttState with ChangeNotifier {
  final _messages = <MessageModel>[];

  List<MessageModel> get messages => _messages;

  void addMessage(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }
}

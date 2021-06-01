import 'dart:developer';

import 'package:list_animation/models/message_model.dart';
import 'package:list_animation/state/mqtt_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttService({
    this.host,
    this.port,
    this.topic,
    this.userName,
    this.password,
    this.state,
  });
  final String? host;
  final int? port;
  final String? topic;
  final String? userName;
  final String? password;
  final MqttState? state;
  late MqttServerClient _client;

  Future<bool> initializedMqtt() async {
    _client = MqttServerClient(host!, 'taylan')
      ..port = port!
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected
      ..onSubscribed = onSubscribed;
    final mqttMsg = MqttConnectMessage()
        .withClientIdentifier('taylanyildz')
        .withWillTopic('withWillTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    log('Connecting....');
    _client.connectionMessage = mqttMsg;
    return await connectionMqtt();
  }

  Future<bool> connectionMqtt() async {
    try {
      await _client.connect(
        userName,
        password,
      );
      return true;
    } catch (e) {
      _client.disconnect();
      log(e.toString());
      return false;
    }
  }

  Future<void> disconnectionMQTT() async {
    try {
      _client.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  void onConnected() {
    print('Connected');
    listenServer();
  }

  void listenServer() {
    try {
      _client.subscribe(topic!, MqttQos.atLeastOnce);
      _client.updates!.listen((dynamic t) {
        final MqttPublishMessage recMess = t[0].payload;
        final message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
        print('message id : ${recMess.variableHeader?.messageIdentifier}');
        print('message : $message');
        int id = recMess.variableHeader!.messageIdentifier!;
        String h = DateTime.now().hour.toString();
        String m = DateTime.now().minute.toString();
        state!.addMessage(
            MessageModel(id: id, message: message, dateTime: h + ':' + m));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void publish(String? message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message!);
    _client.publishMessage(topic!, MqttQos.atLeastOnce, builder.payload!);
    builder.clear();
  }

  void onDisconnected() {
    log('disconnect');
  }

  void onSubscribed(String? topic) {
    log('subscribe');
  }
}

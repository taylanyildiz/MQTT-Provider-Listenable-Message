import 'package:flutter/material.dart';
import 'package:list_animation/state/mqtt_state.dart';
import 'package:provider/provider.dart';
import 'screens/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MqttState(),
      child: MaterialApp(
        title: 'Flutter MQTT Publish Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(title: 'Flutter MQTT Publish'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:list_animation/screens/screen.dart';
import 'package:list_animation/services/mqtt_service.dart';
import 'package:list_animation/state/mqtt_state.dart';
import 'package:list_animation/widgets/widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _inputInitialized();
  }

  void _inputInitialized() {
    _formKey = GlobalKey();
    for (var i = 0; i < 3; i++) {
      _textControllers.add(TextEditingController());
      _focusNode.add(FocusNode());
    }
  }

  late GlobalKey<FormState> _formKey;
  final _textControllers = <TextEditingController>[];
  final _focusNode = <FocusNode>[];
  final _labels = <String>[
    'Host',
    'Port',
    'Topic',
  ];

  late MqttService _service;

  String? host;
  String? port;
  String? topic;

  void connectMqtt(MqttState model) async {
    final check = _formKey.currentState!.validate();
    if (check) {
      host = _textControllers[0].text;
      port = _textControllers[1].text;
      topic = _textControllers[2].text;
      _service = MqttService(
        state: model,
        host: host,
        port: int.parse(port!),
        topic: topic,
      );
      if (await _service.initializedMqtt())
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(service: _service),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttState>(
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(widget.title!),
              centerTitle: true,
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                InputText(
                  formKey: _formKey,
                  labels: _labels,
                  textControllers: _textControllers,
                  focusNodes: _focusNode,
                ),
                Positioned(
                  bottom: 50.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    child: MaterialButton(
                      onPressed: () => connectMqtt(model),
                      child: Text('Connection'),
                      color: Colors.red,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

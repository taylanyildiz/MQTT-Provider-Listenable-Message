import 'package:flutter/material.dart';
import 'package:list_animation/services/mqtt_service.dart';
import 'package:list_animation/state/mqtt_state.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final MqttService service;
  const MessageScreen({
    Key? key,
    required this.service,
  }) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
  }

  late TextEditingController _textController;

  Widget _sendMessageBuilder() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              decoration: InputDecoration.collapsed(hintText: 'Send Message'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              color: Colors.white,
              onPressed: () {
                String mes = _textController.text;
                widget.service.publish(mes);
                _textController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBuilder(BuildContext context, int index, MqttState model) {
    final isMe = model.messages[index].id != 0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      margin: isMe
          ? EdgeInsets.fromLTRB(80, 10.0, 0.0, 10.0)
          : EdgeInsets.fromLTRB(0.0, 10.0, 80.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 20.0 : 0.0),
            bottomLeft: Radius.circular(isMe ? 20.0 : 0.0),
            topRight: Radius.circular(isMe ? 0.0 : 20.0),
            bottomRight: Radius.circular(isMe ? 0.0 : 20.0),
          )),
      child: Column(
        children: [
          Align(
            alignment: !isMe ? Alignment.topRight : Alignment.topLeft,
            child: Text(
              model.messages[index].dateTime.toString(),
              style: TextStyle(
                color: Colors.red,
                fontSize: 13.0,
              ),
            ),
          ),
          Text(
            model.messages[index].message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttState>(
      builder: (context, model, child) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            leading: SizedBox.shrink(),
            elevation: 0.0,
            title: Text('Messages'),
            centerTitle: true,
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await widget.service.disconnectionMQTT();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      itemCount: model.messages.length,
                      itemBuilder: (context, index) =>
                          _messageBuilder(context, index, model)),
                ),
              ),
              _sendMessageBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

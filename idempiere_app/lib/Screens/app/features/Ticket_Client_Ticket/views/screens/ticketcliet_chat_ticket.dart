import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/chatlogjson.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class TicketClientChat extends StatefulWidget {
  const TicketClientChat({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TicketClientChat> {
  List<types.Message> _messages = [];
  final _user = types.User(
      id: '06c33e8b-e835-4736-80f4-63f44b66666c',
      firstName: GetStorage().read('username'));
  //final _helpDesk = const types.User(id: "12345", firstName: "Supporto");

  getLog() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/R_RequestUpdate?\$filter=R_Request_ID eq ${Get.arguments["ticketid"]} and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = ChatLogJson.fromJson(jsonDecode(response.body));
      for (var i = 0; i < json.rowcount!; i++) {
        var msg = types.TextMessage(
            author: GetStorage().read('user') ==
                    json.records![i].createdBy?.identifier
                ? _user
                : types.User(
                    id: randomString(),
                    firstName:
                        json.records![i].createdBy?.identifier ?? "Unknown"),
            id: randomString(),
            text: json.records![i].result!);
        _addMessage(msg);
      }
    } else {
      //print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    _messages = [];
    getLog();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    final msg = jsonEncode({"Result": message.text});

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/windows/request/${Get.arguments["ticketid"]}');

    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      _addMessage(textMessage);
    } else {
      //print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Expanded(child: Text("Ticket ${Get.arguments["ticketid"]} Chat")),
      ),
      body: SafeArea(
        bottom: false,
        child: Chat(
          showUserNames: true,
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      ),
    );
  }
}

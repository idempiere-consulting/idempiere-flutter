import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/chatlogjson.dart';
import 'package:photo_view/photo_view.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid

class TicketInternalImage extends StatefulWidget {
  const TicketInternalImage({Key? key}) : super(key: key);

  @override
  State<TicketInternalImage> createState() => TicketInternalImageState();
}

class TicketInternalImageState extends State<TicketInternalImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attachment"),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: MemoryImage(base64Decode(Get.arguments['base64'])),
        ),
      ),
    );
  }
}

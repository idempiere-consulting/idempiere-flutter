import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text("Attachment".tr),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: PhotoView(
          imageProvider: MemoryImage(base64Decode(Get.arguments['base64'])),
        ),
      ),
    );
  }
}

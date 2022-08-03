import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

/// example widget showing how to use signature widget
class PrintPOSScreen extends StatefulWidget {
  const PrintPOSScreen({Key? key}) : super(key: key);

  @override
  PrintPOSState createState() => PrintPOSState();
}

class PrintPOSState extends State<PrintPOSScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Signature'.tr),
        ),
      ),
      body: ListView(
        children: <Widget>[],
      ),
    );
  }
}

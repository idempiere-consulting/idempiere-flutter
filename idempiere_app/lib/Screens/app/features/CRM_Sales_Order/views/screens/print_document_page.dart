//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
/* import 'package:get_storage/get_storage.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http; */

/// example widget showing how to use signature widget
class PrintDocumentScreen extends StatefulWidget {
  const PrintDocumentScreen({Key? key}) : super(key: key);

  @override
  PrintDocumentState createState() => PrintDocumentState();
}

class PrintDocumentState extends State<PrintDocumentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Print'.tr),
        ),
      ),
      body: ListView(
        children: const <Widget>[],
      ),
    );
  }
}

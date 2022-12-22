// ignore_for_file: prefer_typing_uninitialized_variables

//import 'dart:developer';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/anomaly_image.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';

class AttachmentList extends StatefulWidget {
  const AttachmentList({Key? key}) : super(key: key);

  @override
  State<AttachmentList> createState() => _AttachmentListState();
}

class _AttachmentListState extends State<AttachmentList> {
  getRecordAttachments() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_nc/${Get.arguments["id"]}/attachments');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var image64 = base64.encode(response.bodyBytes);
      Get.to(const AnomalyImage(), arguments: {"base64": image64});
    }
  }

  @override
  void initState() {
    super.initState();
    getRecordAttachments();
  }

  // static String _displayStringForOption(Records option) => option.name!;

  // static int _setIdForOption(Records option) => option.id!;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('View Attachments'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                //editAnomaly(isConnected);
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

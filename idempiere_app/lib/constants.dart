import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

//colors
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

//padding
const kDefaultPadding = 20.0;

//size breakpoints
const kTabletBreakPoint = 768.0;
const kDesktopBreakPoint = 1050.0;
const kPhoneBreakPoint = 514.0;
const kSideMenuWidth = 300.0;

class PostCall {
  final int id;
  final String url;
  String call;

  PostCall({
    required this.id,
    required this.url,
    required this.call,
  });
}

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

Future<bool> checkLoginConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

emptyAPICallStak() {
  emptyEditAPICallStack();
  emptyPostCallStack();
  emptyDeleteCallStack();
}

emptyPostCallStack() {
  if (GetStorage().read('postCallList') != null &&
      (GetStorage().read('postCallList')).isEmpty == false) {
    List<dynamic> list = GetStorage().read('postCallList');
    String authorization = 'Bearer ' + GetStorage().read('token');

    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((element) async {
      var json = jsonDecode(element);
      var url = Uri.parse(json["url"]);

      // ignore: unused_local_variable
      var response = await http.post(
        url,
        body: element,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      list.remove(element);
    });
    GetStorage().write('postCallList', list);
    Get.snackbar(
      "Done!".tr,
      "Records saved locally have been synchronized!".tr,
      icon: const Icon(
        Icons.cloud_upload,
        color: Colors.green,
      ),
    );
  }
}

emptyEditAPICallStack() {
  if (GetStorage().read('storedEditAPICalls') != null &&
      (GetStorage().read('storedEditAPICalls')).isEmpty == false) {
    Map calls = GetStorage().read('storedEditAPICalls');
    String authorization = 'Bearer ' + GetStorage().read('token');
    calls.forEach((call, msg) async {
      var url = Uri.parse(call);
      print(url);
      print(msg);
      // ignore: unused_local_variable
      var response = await http.put(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      calls.remove(call);
    });

    GetStorage().write('storedEditAPICalls', calls);

    Get.snackbar(
      "Done!".tr,
      "Records saved locally have been synchronized!".tr,
      icon: const Icon(
        Icons.cloud_upload,
        color: Colors.green,
      ),
    );
  }
}

emptyDeleteCallStack() {
  if (GetStorage().read('deleteCallList') != null &&
      (GetStorage().read('deleteCallList')).isEmpty == false) {
    List<dynamic> list = GetStorage().read('deleteCallList');
    String authorization = 'Bearer ' + GetStorage().read('token');

    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((element) async {
      var json = jsonDecode(element);
      var url = Uri.parse(json["url"]);
      //print(element);
      //print(json["url"]);

      // ignore: unused_local_variable
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      list.remove(element);
    });
    GetStorage().write('deleteCallList', list);
    Get.snackbar(
      "Done!".tr,
      "Records saved locally have been synchronized!".tr,
      icon: const Icon(
        Icons.cloud_upload,
        color: Colors.green,
      ),
    );
  }
}

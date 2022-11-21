import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/constants.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

/// example widget showing how to use signature widget
class SignatureWorkOrderScreen extends StatefulWidget {
  const SignatureWorkOrderScreen({Key? key}) : super(key: key);

  @override
  SignatureWorkOrderState createState() => SignatureWorkOrderState();
}

class SignatureWorkOrderState extends State<SignatureWorkOrderScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    // ignore: avoid_print
    onDrawStart: () => print('onDrawStart called!'),
    // ignore: avoid_print
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Signature'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                setState(() => _controller.undo());
              },
              icon: const Icon(Icons.undo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var data = await _controller.toPngBytes();
                var image64 = base64.encode(data!);
                final ip = GetStorage().read('ip');
                final protocol = GetStorage().read('protocol');
                String authorization = 'Bearer ' + GetStorage().read('token');
                final msg = jsonEncode(
                    {"name": "customersignature.jpg", "data": image64});
                var url = Uri.parse('$protocol://' +
                    ip +
                    '/api/v1/models/mp_ot/${Get.arguments["id"]}/attachments');

                var isConnected = await checkConnection();

                if (isConnected) {
                  emptyAPICallStak();
                  var response = await http.post(
                    url,
                    body: msg,
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': authorization,
                    },
                  );
                  if (response.statusCode == 201) {
                    //print("done!");
                    Get.back();
                    Get.snackbar(
                      "Done!".tr,
                      "The record has been created".tr,
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    );
                  } else {
                    if (kDebugMode) {
                      print(response.body);
                    }
                    Get.snackbar(
                      "Error!".tr,
                      "Record not created".tr,
                      icon: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  }
                } else {
                  //record.offlineId = GetStorage().read('postCallId');
                  List<dynamic> list = [];
                  if (GetStorage().read('postCallList') == null) {
                    var call = jsonEncode({
                      "offlineid": GetStorage().read('postCallId'),
                      "url": '$protocol://' +
                          ip +
                          '/api/v1/models/mp_maintain/${Get.arguments["id"]}/attachments',
                      "name": "clientsignature.jpg",
                      "data": image64
                    });

                    list.add(call);
                  } else {
                    list = GetStorage().read('postCallList');
                    var call = jsonEncode({
                      "offlineid": GetStorage().read('postCallId'),
                      "url": '$protocol://' +
                          ip +
                          '/api/v1/models/mp_maintain/${Get.arguments["id"]}/attachments',
                      "name": "clientsignature.jpg",
                      "data": image64
                    });
                    list.add(call);
                  }
                  GetStorage()
                      .write('postCallId', GetStorage().read('postCallId') + 1);
                  GetStorage().write('postCallList', list);
                  Get.back();
                  Get.snackbar(
                    "Saved!".tr,
                    "The record has been saved locally waiting for internet connection"
                        .tr,
                    icon: const Icon(
                      Icons.save,
                      color: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          /* Container(
                height: 300,
                child: const Center(
                  child: Text('Big container to test scrolling issues'),
                ),
              ), */
          //SIGNATURE CANVAS
          Signature(
            controller: _controller,
            height: size.height * 0.92,
            width: double.infinity,
            backgroundColor: Colors.white,
          ),
          //OK AND CLEAR BUTTONS
          /* Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SHOW EXPORTED IMAGE IN NEW ROUTE
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final Uint8List? data = await _controller.toPngBytes();
                      if (data != null) {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(),
                                body: Center(
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: Image.memory(data),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.undo());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.redo());
                  },
                ),
                //CLEAR CANVAS
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                ),
              ],
            ),
          ), */
          /* Container(
                height: 300,
                child: const Center(
                  child: Text('Big container to test scrolling issues'),
                ),
              ), */
        ],
      ),
    );
  }
}

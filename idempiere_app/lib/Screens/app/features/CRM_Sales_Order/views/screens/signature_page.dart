import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

/// example widget showing how to use signature widget
class SignatureSalesOrderScreen extends StatefulWidget {
  const SignatureSalesOrderScreen({Key? key}) : super(key: key);

  @override
  SignatureSalesOrderState createState() => SignatureSalesOrderState();
}

class SignatureSalesOrderState extends State<SignatureSalesOrderScreen> {
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
                // ignore: unused_local_variable
                var image64 = base64.encode(data!);
                /* GetStorage().write('SignatureWorkOrderResource', image64);
                Get.find<MaintenanceMpResourceSheetController>()
                    .flagSign
                    .value = true;
                Get.back(); */

                final ip = GetStorage().read('ip');
                String authorization = 'Bearer ${GetStorage().read('token')}';

                final msg =
                    jsonEncode({"name": "signature.jpg", "data": image64});

                final protocol = GetStorage().read('protocol');
                var url = Uri.parse(
                    '$protocol://$ip/api/v1/models/C_Order/${Get.arguments["id"]}/attachments');

                var response = await http.post(
                  url,
                  body: msg,
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                    'Authorization': authorization,
                  },
                );
                if (response.statusCode == 200 || response.statusCode == 201) {
                  Get.back();
                  Get.snackbar(
                    "Signed!".tr,
                    "Sales Order has been signed".tr,
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                  );
                } else {
                  Get.snackbar(
                    "Error!".tr,
                    "Sales Order not signed".tr,
                    icon: const Icon(
                      Icons.error,
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

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Production_Order/models/productionorder_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/models/userpreferences_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class EditProdutionOrder extends StatefulWidget {
  const EditProdutionOrder({Key? key}) : super(key: key);

  @override
  State<EditProdutionOrder> createState() => _EditProdutionOrderState();
}

class _EditProdutionOrderState extends State<EditProdutionOrder> {
  Future<void> getProductionOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Production?\$filter= M_Production_ID eq ${args["id"]} and DocStatus neq \'CO\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = ProductionOrderJson.fromJson(jsonDecode(response.body));

      setState(() {
        documentNoFieldController.text = json.records![0].documentNo ?? "";
        productFieldController.text =
            json.records![0].mProductID?.identifier ?? "";
        productionFieldController.text =
            json.records![0].productionQty.toString();
        actualFieldController.text = json.records![0].qtyPost.toString();
      });
      movementDate = json.records![0].movementDate ?? "0";
      locatorId = json.records![0].mLocatorID?.id ?? 0;
      getWarehouse(json.records![0].mLocatorID?.id);

      //print(trx.rowcount);
      //print(response.body);
    }
  }

  getWarehouse(int? locator) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Locator?\$filter= M_Locator_ID eq $locator');
    if (locator != null) {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //print(response.body);
        var json = jsonDecode(response.body);
        warehouseId = json["records"][0]["M_Warehouse_ID"]["id"];
        //print(warehouseId);
        //controller.getSalesOrders();
        //print("done!");
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
  }

  declareFinishedProduct(int qty) async {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(DateTime.now());
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "record-id": args["id"],
      "model-name": "M_Production",
      "MovementDate": formattedDate,
      "C_DocTypeInv_ID": {
        "id": pref.records![0].lITDocTypeProdDeclarationID?.id
      },
      "Qty": qty
    });
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/processes/endproductdeclaration');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    print(response.body);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200 && res["isError"] == false) {
      //controller.getSalesOrders();
      //print("done!");
      //print(response.body);
      Get.snackbar(
        "Done!",
        "Processed: Declare End Product",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!",
        "Couldn't process Declare End Product",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  pickingComponents(int qty) async {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(DateTime.now());
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "record-id": args["id"],
      "model-name": "M_Production",
      "MovementDate": formattedDate,
      "C_DocTypeMov_ID": {"id": pref.records![0].lITDocTypeProdPickingID?.id},
      "Qty": qty
    });
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/processes/runpickingcomponents');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    var res = jsonDecode(response.body);
    if (response.statusCode == 200 && res["isError"] == false) {
      //controller.getSalesOrders();
      getProductionOrder();
      //print("done!");
      //print(response.body);
      Get.snackbar(
        "Done!",
        "Processed: Picking Components",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!",
        "Couldn't process Picking Components",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  pickingAndRelease(int qty) async {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(DateTime.now());
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "record-id": args["id"],
      "model-name": "M_Production",
      "MovementDate": formattedDate,
      "C_DocTypeMov_ID": {"id": pref.records![0].lITDocTypeProdPickingID?.id},
      "C_DocTypeInv_ID": {
        "id": pref.records![0].lITDocTypeProdDeclarationID?.id
      },
      "LIT_IsPickingEndDeclaration": true,
      "Qty": qty
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/processes/runpickingcomponentsendproddeclaration');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    var res = jsonDecode(response.body);
    if (response.statusCode == 200 && res["isError"] == false) {
      //controller.getSalesOrders();
      //print("done!");
      print(response.body);
      Get.snackbar(
        "Done!",
        "Processed: Picking and Release",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!",
        res["summary"] ?? "Couldn't process Picking and Release",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  getUsetPreferences() async {
    const filename = "userpreferences";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    pref = UserPreferencesJson.fromJson(jsonDecode(file.readAsStringSync()));
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var documentNoFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var productFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var productionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var actualFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;

  UserPreferencesJson pref = UserPreferencesJson(records: []);

  var warehouseId = 0;
  var locatorId = 0;
  var docId = 0;
  var movementDate = "0";

  @override
  void initState() {
    super.initState();
    getUsetPreferences();
    docId = args["docType"];
    documentNoFieldController = TextEditingController();
    productFieldController = TextEditingController();
    productionFieldController = TextEditingController();
    actualFieldController = TextEditingController();
    qtyFieldController = TextEditingController();
    qtyFieldController.text = "0";
    getProductionOrder();
    //getWarehouse();
  }

  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Production Order'),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: documentNoFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Document N°',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Product',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity in Production',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: actualFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Actual Quantity',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 8,
                  /* buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                  children: [
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: const Text("Declare Finished Product"),
                        onPressed: () async {
                          //declareFinishedProduct();
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                declareFinishedProduct(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text("Picking Components"),
                        onPressed: () {
                          //pickingComponents();
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                pickingComponents(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("Picking and Release"),
                        onPressed: () {
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                pickingAndRelease(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                          //editTask("NY");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: documentNoFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Document N°',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: productFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Product',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: productionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity in Production',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: actualFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Actual Quantity',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 8,
                  /* buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                  children: [
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: const Text("Declare Finished Product"),
                        onPressed: () async {
                          //declareFinishedProduct();
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                declareFinishedProduct(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text("Picking Components"),
                        onPressed: () {
                          //pickingComponents();
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                pickingComponents(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("Picking and Release"),
                        onPressed: () {
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                pickingAndRelease(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                          //editTask("NY");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: documentNoFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Document N°',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: productFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Product',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: productionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity in Production',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: actualFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Actual Quantity',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 8,
                  /* buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                  children: [
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: const Text("Declare Finished Product"),
                        onPressed: () async {
                          //declareFinishedProduct();
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                declareFinishedProduct(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text("Picking Components"),
                        onPressed: () {
                          //pickingComponents();
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                pickingComponents(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("Picking and Release"),
                        onPressed: () {
                          Get.defaultDialog(
                              title: 'Quantity',
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: qtyFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                pickingAndRelease(
                                    int.parse(qtyFieldController.text));
                                qtyFieldController.text = "0";
                              },
                              onCancel: () {});
                          //editTask("NY");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

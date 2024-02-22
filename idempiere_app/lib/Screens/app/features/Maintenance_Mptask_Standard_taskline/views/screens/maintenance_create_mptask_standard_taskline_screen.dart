import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_task_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_mptask_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

class CreateMaintenanceStandardMptask extends StatefulWidget {
  const CreateMaintenanceStandardMptask({Key? key}) : super(key: key);

  @override
  State<CreateMaintenanceStandardMptask> createState() =>
      _CreateMaintenanceStandardMptaskState();
}

class _CreateMaintenanceStandardMptaskState
    extends State<CreateMaintenanceStandardMptask> {
  createWorkOrder(bool isConnected) async {
    const filename = "workordertask";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    final protocol = GetStorage().read('protocol');
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": productId},
      "Qty": double.parse(qtyFieldController.text),
      "Description": descriptionFieldController.text,
      "C_UOM_ID": {"id": 100},
      "ResourceQty": double.parse(resourceQtyFieldController.text),
      "QtyEntered": double.parse(qtyEnteredFieldController.text),
      "PriceList": double.parse(priceListFieldController.text),
      "PriceEntered": double.parse(priceEnteredFieldController.text),
    });

    WorkOrderTaskLocalJson trx =
        WorkOrderTaskLocalJson.fromJson(jsonDecode(file.readAsStringSync()));
    MProductID prod = MProductID(id: productId, identifier: productName);
    TRecords record = TRecords(
      mProductID: prod,
      qty: double.parse(qtyFieldController.text),
      description: descriptionFieldController.text,
      qtyEntered: double.parse(qtyEnteredFieldController.text),
      resourceQty: double.parse(resourceQtyFieldController.text),
    );

    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/work-order-extinguisher/tabs/${"work-order-maintenance".tr}/${Get.arguments["id"]}/${"tasks".tr}');
    if (isConnected) {
      if (kDebugMode) {
        print(msg);
      }
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
        if (kDebugMode) {
          print(response.body);
        }
        TRecords res =
            TRecords.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        trx.records!.add(res);
        //trx.rowcount = trx.rowcount! + 1;
        var data = jsonEncode(trx.toJson());
        file.writeAsStringSync(data);
        /* setState(() {
          saveFlag = false;
        });
        syncWorkOrder(); */
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
      record.offlineId = GetStorage().read('postCallId');
      List<dynamic> list = [];
      if (GetStorage().read('postCallList') == null) {
        var call = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": '$protocol://$ip/api/v1/models/MP_OT_Task',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "M_Product_ID": {"id": productId},
          "Qty": double.parse(qtyFieldController.text),
          "Description": descriptionFieldController.text,
          "C_UOM_ID": {"id": 100},
          "ResourceQty": double.parse(resourceQtyFieldController.text),
          "QtyEntered": double.parse(qtyEnteredFieldController.text),
        });

        list.add(call);
      } else {
        list = GetStorage().read('postCallList');
        var call = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": '$protocol://$ip/api/v1/models/MP_OT_Task',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "M_Product_ID": {"id": productId},
          "Qty": double.parse(qtyFieldController.text),
          "Description": descriptionFieldController.text,
          "C_UOM_ID": {"id": 100},
          "ResourceQty": double.parse(resourceQtyFieldController.text),
          "QtyEntered": double.parse(qtyEnteredFieldController.text),
        });
        list.add(call);
      }
      GetStorage().write('postCallId', GetStorage().read('postCallId') + 1);
      GetStorage().write('postCallList', list);
      Get.snackbar(
        "Saved!".tr,
        "The record has been saved locally waiting for internet connection".tr,
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
      trx.records!.add(record);
      //trx.rowcount = trx.rowcount! + 1;
      var data = jsonEncode(trx.toJson());
      file.writeAsStringSync(data);
    }
    Get.find<MaintenanceMptaskLineController>().getWorkOrders();
  }

  Future<List<Records>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    /* for (var i = 0; i < jsonResources.records!.length; i++) {
      if (((jsonResources.records![i].mProductCategoryID?.identifier ?? "")
          .contains((Get.arguments["id"] as String).tr))) {
        print(jsonResources.records![i].mProductCategoryID?.identifier);
      }
    } */

    //print(jsonResources.records!.length);

    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  /* void fillFields() {
    nameFieldController.text = args["name"];
    bPartnerFieldController.text = args["bpName"];
    phoneFieldController.text = args["Tel"];
    mailFieldController.text = args["eMail"];
    //dropdownValue = args["leadStatus"];
    salesrepValue = args["salesRep"];
    //salesRepFieldController.text = args["salesRep"];
  } */

  //dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var qtyEnteredFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var resourceQtyFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var priceEnteredFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var priceListFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var resourceFieldController;
  String dropdownValue = "";
  String salesrepValue = "";
  String businessPartnerValue = "";
  String date = "";
  String docId = "";
  String resourceName = "";
  String bPLocation = "";
  int productId = 0;
  String productName = "";

  @override
  void initState() {
    super.initState();
    descriptionFieldController = TextEditingController();
    qtyFieldController = TextEditingController(text: "1");
    qtyEnteredFieldController = TextEditingController(text: "1");
    resourceQtyFieldController = TextEditingController(text: "1");
    priceEnteredFieldController = TextEditingController(text: "0.0");
    priceListFieldController = TextEditingController(text: "0.0");
  }

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add WorkOrder Task'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                createWorkOrder(isConnected);
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return "${option.value}_${option.name}"
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = selection.id!;
                                    productName = selection.name!;
                                    descriptionFieldController.text =
                                        selection.description;
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      qtyFieldController.text =
                          (double.parse(resourceQtyFieldController.text) *
                                  double.parse(qtyEnteredFieldController.text))
                              .toString();
                    },
                    controller: resourceQtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'N° Technicians'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      qtyFieldController.text =
                          (double.parse(resourceQtyFieldController.text) *
                                  double.parse(qtyEnteredFieldController.text))
                              .toString();
                    },
                    controller: qtyEnteredFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Total Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceEnteredFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.price_check),
                      border: const OutlineInputBorder(),
                      labelText: 'Price'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceListFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.price_check),
                      border: const OutlineInputBorder(),
                      labelText: 'Prezzo Listino'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return "${option.value}_${option.name}"
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = selection.id!;
                                    productName = selection.name!;
                                    descriptionFieldController.text =
                                        selection.description;
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      qtyFieldController.text =
                          (double.parse(resourceQtyFieldController.text) *
                                  double.parse(qtyEnteredFieldController.text))
                              .toString();
                    },
                    controller: resourceQtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'N° Technicians'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      qtyFieldController.text =
                          (double.parse(resourceQtyFieldController.text) *
                                  double.parse(qtyEnteredFieldController.text))
                              .toString();
                    },
                    controller: qtyEnteredFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Total Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceEnteredFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.price_check),
                      border: const OutlineInputBorder(),
                      labelText: 'Price'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceListFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.price_check),
                      border: const OutlineInputBorder(),
                      labelText: 'Prezzo Listino'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return "${option.value}_${option.name}"
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = selection.id!;
                                    productName = selection.name!;
                                    descriptionFieldController.text =
                                        selection.description;
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      qtyFieldController.text =
                          (double.parse(resourceQtyFieldController.text) *
                                  double.parse(qtyEnteredFieldController.text))
                              .toString();
                    },
                    controller: resourceQtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'N° Technicians'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      qtyFieldController.text =
                          (double.parse(resourceQtyFieldController.text) *
                                  double.parse(qtyEnteredFieldController.text))
                              .toString();
                    },
                    controller: qtyEnteredFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Total Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceEnteredFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.price_check),
                      border: const OutlineInputBorder(),
                      labelText: 'Price'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceListFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.price_check),
                      border: const OutlineInputBorder(),
                      labelText: 'Prezzo Listino'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

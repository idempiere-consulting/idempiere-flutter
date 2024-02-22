// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_mptask_standard_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_task_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_mptask_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

class EditMaintenanceStandardMptaskLine extends StatefulWidget {
  const EditMaintenanceStandardMptaskLine({Key? key}) : super(key: key);

  @override
  State<EditMaintenanceStandardMptaskLine> createState() =>
      _EditMaintenanceStandardMptaskLineState();
}

class _EditMaintenanceStandardMptaskLineState
    extends State<EditMaintenanceStandardMptaskLine> {
  /* deleteWorkOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' + ip + '/api/v1/models/mp_ot/${args["id"]}');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //Get.find<MaintenanceMptaskController>().getWorkOrders();
      //print("done!");
      Get.back();
      Get.back();
      Get.snackbar(
        "Done!".tr,
        "The record has been erased".tr,
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Errore!",
        "Il record non è stato cancellato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  } */

  editWorkOrderTask(bool isConnected) async {
    //print(now);

    const filename = "workordertask";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "Description": descriptionFieldController.text,
      "ResourceQty": double.parse(qtyFieldController.text),
      "QtyEntered": double.parse(qtyEnteredFieldController.text),
      "Qty": double.parse(resourceQtyFieldController.text),
      "M_Product_ID": {"id": productId},
      "PriceList": double.parse(priceListFieldController.text),
      "PriceEntered": double.parse(priceEnteredFieldController.text),
    });

    WorkOrderTaskLocalJson trx =
        WorkOrderTaskLocalJson.fromJson(jsonDecode(file.readAsStringSync()));

    if (Get.arguments["id"] != null && offline == -1) {
      trx.records![Get.arguments["index"]].description =
          descriptionFieldController.text;
      trx.records![Get.arguments["index"]].resourceQty =
          double.parse(resourceQtyFieldController.text);
      trx.records![Get.arguments["index"]].qtyEntered =
          double.parse(qtyEnteredFieldController.text);
      trx.records![Get.arguments["index"]].qty =
          double.parse(qtyFieldController.text);
      trx.records![Get.arguments["index"]].mProductID =
          MProductID(id: productId, identifier: productName);

      var url = Uri.parse(
          '$protocol://$ip/api/v1/models/mp_ot_task/${Get.arguments["id"]}');
      if (isConnected) {
        emptyAPICallStak();
        var response = await http.put(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          var data = jsonEncode(trx.toJson());
          file.writeAsStringSync(data);
          Get.find<MaintenanceStandardMptaskLineController>().getWorkOrders();
          //print("done!");
          //Get.back();
          Get.snackbar(
            "Fatto!",
            "Il record è stato modificato",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        } else {
          print(response.body);
          //print(response.statusCode);
          Get.snackbar(
            "Errore!",
            "Il record non è stato modificato",
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      } else {
        var data = jsonEncode(trx.toJson());
        //GetStorage().write('workOrderSync', data);
        file.writeAsStringSync(data);
        Get.find<MaintenanceStandardMptaskLineController>().getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['$protocol://$ip/api/v1/models/mp_ot_task/${Get.arguments["id"]}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['$protocol://$ip/api/v1/models/mp_ot_task/${Get.arguments["id"]}'] =
              msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.red,
          ),
        );
      }
    }

    if (offline != -1) {
      List<dynamic> list = GetStorage().read('postCallList');

      for (var i = 0; i < list.length; i++) {
        var json = jsonDecode(list[i]);
        if (json["offlineid"] == Get.arguments?["offlineid"]) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];
          var adorg = json["AD_Org_ID"];
          var adclient = json["AD_Client_ID"];
          //var product = json["M_Product_ID"];
          var resourceQty = json["ResourceQty"];
          var qtyEntered = json["QtyEntered"];
          var uom = json["C_UOM_ID"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "AD_Org_ID": adorg,
            "AD_Client_ID": adclient,
            "MP_OT_ID": {"id": args["MPOTId"]},
            "M_Product_ID": {"id": productId},
            "Description": descriptionFieldController.text,
            "ResourceQty": double.parse(qtyFieldController.text),
            "QtyEntered": double.parse(qtyEnteredFieldController.text),
            "Qty": double.parse(resourceQtyFieldController.text),
            "C_UOM_ID": uom,
          });

          list.removeAt(i);
          list.add(call);
          GetStorage().write('postCallList', list);
          Get.snackbar(
            "Salvato!",
            "Il record è stato salvato localmente in attesa di connessione internet.",
            icon: const Icon(
              Icons.save,
              color: Colors.red,
            ),
          );
        }
      }
    }
  }

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  final json = {
    "types": [
      {"id": "NS", "name": "NS".tr},
      {"id": "IP", "name": "IP".tr},
      {"id": "ST", "name": "ST".tr},
      {"id": "CO", "name": "CO".tr},
    ]
  };

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

    return jsonResources.records!
        .where((element) => element.lITIsContract ?? false)
        .toList();

    //print(list[0].eMail);

    //print(json.);
  }

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  late List<Types> dropDownList;
  String dropdownValue = "";

  dynamic args = Get.arguments;

  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var qtyEnteredFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var resourceQtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var productFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var priceEnteredFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var priceListFieldController;

  var offline = -1;

  var productId = 0;
  // ignore: prefer_typing_uninitialized_variables
  var productName;

  @override
  void initState() {
    dropdownValue = args["completed"] ?? "NS";
    dropDownList = getTypes()!;
    super.initState();
    descriptionFieldController =
        TextEditingController(text: args["description"] ?? "");
    qtyFieldController =
        TextEditingController(text: args["resourceQty"] ?? "1.0");
    qtyEnteredFieldController =
        TextEditingController(text: args["qtyEntered"] ?? "1.0");
    resourceQtyFieldController =
        TextEditingController(text: args["Qty"] ?? "1");
    offline = Get.arguments["offlineid"] ?? -1;
    productFieldController =
        TextEditingController(text: Get.arguments["prod"] ?? "");
    productName = Get.arguments["prod"] ?? "";
    productId = Get.arguments["prodId"] ?? 0;
    priceEnteredFieldController =
        TextEditingController(text: Get.arguments['priceEntered']);
    priceListFieldController =
        TextEditingController(text: Get.arguments['priceList']);
    //getDocType();
    //getResourceName();
    //getAllResources();
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit WorkOrder'),
        ),
        actions: [
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Eliminazione record",
                  middleText: "Sicuro di voler eliminare il record?",
                  backgroundColor: const Color.fromRGBO(38, 40, 55, 1),
                  //titleStyle: TextStyle(color: Colors.white),
                  //middleTextStyle: TextStyle(color: Colors.white),
                  textConfirm: "Elimina",
                  textCancel: "Annulla",
                  cancelTextColor: Colors.white,
                  confirmTextColor: Colors.white,
                  buttonColor: const Color.fromRGBO(31, 29, 44, 1),
                  barrierDismissible: false,
                  onConfirm: () {
                    //deleteWorkOrder();
                  },
                  //radius: 50,
                );
                //editLead();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ), */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                editWorkOrderTask(isConnected);
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Product'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
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
                                initialValue:
                                    TextEditingValue(text: productName),
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
                                    productName = selection.name;
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Product'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
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
                                initialValue:
                                    TextEditingValue(text: productName),
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
                                    productName = selection.name;
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Product'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
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
                                initialValue:
                                    TextEditingValue(text: productName),
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
                                    productName = selection.name;
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

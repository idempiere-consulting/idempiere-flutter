import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/views/screens/crm_shipmentline_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';

class CreateShipmentline extends StatefulWidget {
  const CreateShipmentline({Key? key}) : super(key: key);

  @override
  State<CreateShipmentline> createState() => _CreateShipmentlineState();
}

class _CreateShipmentlineState extends State<CreateShipmentline> {
  createShipment() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "QtyEntered": int.parse(qtyFieldController.text),
      "Description": descriptionFieldController.text,
      "IsSelected": checkboxState,
      "M_Product_ID": {"id": productId},
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_UOM_ID": {"id": 100},
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/windows/shipment-customer/tabs/${"shipment".tr}/${Get.arguments["id"]}/${"shipment-line".tr}'); //shipment   shipment-line
    //print(msg);
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      print(response.body);
      Get.back();
      Get.find<CRMShipmentlineController>().getShipmentlines();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Record not updated".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  deleteShipmentLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/m_inoutline/${args["id"]}');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMShipmentlineController>().getShipmentlines();
      Get.back();
      Get.back();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been deleted".tr,
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
        "Record not deleted".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  windowsAAA() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/windows/shipment-customer/tabs/shipment/${Get.arguments["id"]}/shipment-line');
    //print(msg);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
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

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var checkboxState;

  var productId;
  var productName;

  @override
  void initState() {
    super.initState();
    qtyFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    qtyFieldController.text = "1";
    descriptionFieldController.text = "";
    checkboxState = false;
    productId = 0;
    productName = "";
  }

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit ShipmentLine'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createShipment();
                //windowsAAA();
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
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                                    productId = selection.id;
                                    productName =
                                        _displayStringForOption(selection);
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
                    //maxLines: 5,
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CheckboxListTile(
                    title: Text('Selected'.tr),
                    value: checkboxState,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxState = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
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
                    //maxLines: 5,
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity Planned'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CheckboxListTile(
                    title: Text('Selected'.tr),
                    value: checkboxState,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxState = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
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
                    //maxLines: 5,
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity Planned'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CheckboxListTile(
                    title: Text('Selected'.tr),
                    value: checkboxState,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxState = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
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

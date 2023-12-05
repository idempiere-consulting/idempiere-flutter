import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/storageonhand_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory_Line/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory_Lot_Line/views/screens/supplychain_inventory_lot_line_screen.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CreateSupplychainInventoryLotLine extends StatefulWidget {
  const CreateSupplychainInventoryLotLine({Key? key}) : super(key: key);

  @override
  State<CreateSupplychainInventoryLotLine> createState() =>
      _CreateSupplychainInventoryLotLineState();
}

class _CreateSupplychainInventoryLotLineState
    extends State<CreateSupplychainInventoryLotLine> {
  Future<List<Records>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());
    var jsonResources = ProductJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getInstAttr(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_storageonhand?\$filter=M_Product_ID eq $id and QtyOnHand gt 0 and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        attrFieldAvailable = false;
        attrFieldVisible = false;
      });
      attrList = StorageOnHandJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (attrList.rowcount! > 0) {
        attrList.records!
            .removeWhere((element) => element.mAttributeSetInstanceID?.id == 0);
        SOORecords record = SOORecords(
            mAttributeSetInstanceID:
                MAttributeSetInstance2ID(id: 0, identifier: ""));
        attrList.records!.add(record);

        setState(() {
          attrFieldAvailable = true;
          attrFieldVisible = true;
        });
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> createInventoryLine(int type) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/windows/${"physical-inventory".tr}/tabs/${"inventory-count".tr}/${Get.arguments["id"]}/${"inventory-count-line".tr}/');
    //print(url.toString());
    // physical-inventory/conteggio-inventario-if00/tabs/
    // physical-inventory/tabs/inventory-count/1000008/
    // inventory-count-line/
    // 1000008
    // 1000159

    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Locator_ID": warehouseId,
      "M_Product_ID": productValue,
      "QtyCount": double.parse(quantityFieldController.text),
      "Description": descriptionFieldController.text,
      "InventoryType": "D"
    });
    if (instAttrId > 0) {
      msg = jsonEncode({
        "AD_Org_ID": {"id": GetStorage().read("organizationid")},
        "AD_Client_ID": {"id": GetStorage().read("clientid")},
        "M_Locator_ID": warehouseId,
        "M_Product_ID": productValue,
        "QtyCount": double.parse(quantityFieldController.text),
        "Description": descriptionFieldController.text,
        "InventoryType": "D",
        "M_AttributeSetInstance_ID": {"id": instAttrId},
      });
    }
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
      Get.find<SupplychainInventoryLotLineController>().getInventoryLines();
      switch (type) {
        case 0:
          Get.back();
          Get.to(const CreateSupplychainInventoryLotLine(), arguments: {
            "id": Get.arguments["id"],
            "warehouseId": Get.arguments["warehouseId"]
          });
          break;

        default:
      }

      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
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
        print(utf8.decode(response.bodyBytes));
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
  }

  //dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var quantityFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;

  var instAttrId = 0;

  // ignore: prefer_typing_uninitialized_variables
  var attrValue;

  var attrFieldVisible = false;

  var attrFieldAvailable = false;

  var warehouseId = "1000000";
  String productValue = "";
  late FocusNode focusNode;
  late StorageOnHandJson attrList;

  /* late WarehouseJson trx; */

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    warehouseId = Get.arguments["warehouseId"].toString();
    quantityFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    //initialValue = const TextEditingValue(text: '');
    attrFieldVisible = false;
    attrFieldAvailable = false;
    attrValue = "0";
    //getWarehouses();
    //fillFields();
    //createInventoryLine();
    //getAllProducts();
  }

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  //static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Inventory Inline'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createInventoryLine(0);
              },
              icon: const Icon(
                Icons.playlist_add,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createInventoryLine(1);
              },
              icon: const Icon(
                Icons.save_as,
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
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  //print('hallo');
                                  instAttrId = 0;
                                  getInstAttr(selection.id!);
                                  setState(() {
                                    productValue = selection.id.toString();
                                    focusNode.requestFocus();
                                    //print('hallo');
                                  });

                                  //print(productValue);
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
                    focusNode: focusNode,
                    controller: quantityFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Quantity Count".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Description".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Attribute Instance".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: attrFieldAvailable
                        ? DropdownButton(
                            value: attrValue as String,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              instAttrId = int.parse(newValue!);
                              setState(() {
                                attrValue = newValue;
                              });
                              if (kDebugMode) {
                                print(newValue);
                              }
                            },
                            items: attrList.records!
                                .map((list) {
                                  return DropdownMenuItem<String>(
                                    value: list.mAttributeSetInstanceID?.id
                                        .toString(),
                                    child: Text(
                                      list.mAttributeSetInstanceID
                                              ?.identifier ??
                                          "???",
                                    ),
                                  );
                                })
                                .toSet()
                                .toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
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
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    productValue = selection.id.toString();
                                    focusNode.requestFocus();
                                  });

                                  //print(productValue);
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
                    focusNode: focusNode,
                    controller: quantityFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Quantity Count".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Description".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
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
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    productValue = selection.id.toString();
                                    focusNode.requestFocus();
                                  });

                                  //print(productValue);
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
                    focusNode: focusNode,
                    controller: quantityFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Quantity Count".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Description".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
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

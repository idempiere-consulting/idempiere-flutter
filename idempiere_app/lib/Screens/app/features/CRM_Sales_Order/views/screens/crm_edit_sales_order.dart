import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

//models
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/doctype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/bplocation_json.dart';

//screens
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';


class CRMEditSalesOrder extends StatefulWidget {
  const CRMEditSalesOrder({Key? key}) : super(key: key);

  @override
  State<CRMEditSalesOrder> createState() => _CRMEditSalesOrderState();
}

class _CRMEditSalesOrderState extends State<CRMEditSalesOrder> {

  EditSalesOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      //"bPartner": bPartnerFieldController.text,
      "DocumentNo": docNoFieldController.text,
      "C_DocTypeTarget_ID": {'id': int.parse(dropdownDocType)},
      'C_BPartner_Location_ID': {'id': int.parse(dropdownBPLocation)}
    });
  final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://'  + ip + '/api/v1/models/C_Order/${args["id"]}');
    //print(msg);
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //toAsk
      Get.find<CRMSalesOrderController>().getSalesOrders();
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

  deleteCustomer() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/ad_user/${args["id"]}');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMSalesOrderController>().getSalesOrders();
      //print("done!");
      Get.back();
      Get.back();
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
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

  Future<List<DTRecords>> getAllDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/C_DocType?\$filter= DocBaseType eq \'SOO\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = DocTypeJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load BP Groups");
    }

    //print(response.body);
  }

  Future<List<BPLRecords>> getBPLocations() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/C_BPartner_Location?\$filter= C_BPartner_ID eq ${(bPartnerId)} and IsShipTo eq Y and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BPLocationJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load BP Groups");
    }

    //print(response.body);
  }

  void fillFields() {
    bPartnerFieldController.text = args["bPartner"] ?? "";
    docNoFieldController.text = args["docNo"] ?? "";
    //salesRepFieldController.text = args["salesRep"];
  }


  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var docNoFieldController;
  //String dropdownValue = "";
  //var bPartnerValue = "";
  late TextEditingValue bPName ;
  /* int bPartnerId = Get.arguments['bPartnerId'] ?? 0;
  int bPartnerAddressId = Get.arguments['bPAddressId'] ?? 0; */
  String dropdownDocType = "";
  String dropdownBPLocation = "";
  int bPartnerId = Get.arguments['bPartnerId'] ?? 0;

  @override
  void initState() {
    //dropdownValue = (args["C_BP_Group_ID"]).toString();
    dropdownDocType = (args["docTypeTargetId"]).toString();
    dropdownBPLocation = (args["BPartnerLocationId"]).toString();
    //bPName = TextEditingValue(text: Get.arguments['bPartner']);
    super.initState();
    bPartnerFieldController = TextEditingController();
    docNoFieldController = TextEditingController();
    //bPGroupController = TextEditingController();
    fillFields();
    getBPLocations();
    //getAllDocType();    
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Sales Order'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Record deletion".tr,
                  middleText: "Are you sure to delete the record?".tr,
                  backgroundColor: const Color.fromRGBO(38, 40, 55, 1),
                  //titleStyle: TextStyle(color: Colors.white),
                  //middleTextStyle: TextStyle(color: Colors.white),
                  textConfirm: "Delete".tr,
                  textCancel: "Cancel".tr,
                  cancelTextColor: Colors.white,
                  confirmTextColor: Colors.white,
                  buttonColor: const Color.fromRGBO(31, 29, 44, 1),
                  barrierDismissible: false,
                  onConfirm: () {
                    deleteCustomer();
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                EditSalesOrder();
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
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'DocumentNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      'Document Type'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllDocType(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<DTRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownDocType,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownDocType = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      'Business Partner Location'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getBPLocations(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPLRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownBPLocation,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownBPLocation = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'DocumentNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      'Document Type'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllDocType(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<DTRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownDocType,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownDocType = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      'Business Partner Location'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getBPLocations(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPLRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownBPLocation,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownBPLocation = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'DocumentNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      'Document Type'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllDocType(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<DTRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownDocType,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownDocType = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      'Business Partner Location'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getBPLocations(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPLRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownBPLocation,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownBPLocation = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
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
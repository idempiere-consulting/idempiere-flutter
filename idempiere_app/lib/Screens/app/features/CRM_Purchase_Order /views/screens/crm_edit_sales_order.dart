import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Purchase_Order%20/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

//models
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/doctype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/bplocation_json.dart';

//screens
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/constants.dart';

class CRMEditPurchaseOrder extends StatefulWidget {
  const CRMEditPurchaseOrder({Key? key}) : super(key: key);

  @override
  State<CRMEditPurchaseOrder> createState() => _CRMEditPurchaseOrderState();
}

class _CRMEditPurchaseOrderState extends State<CRMEditPurchaseOrder> {
  editSalesOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      //"bPartner": bPartnerFieldController.text,
      "DocumentNo": docNoFieldController.text,
      "C_DocTypeTarget_ID": {'id': int.parse(dropdownDocType)},
      'C_BPartner_Location_ID': {'id': int.parse(dropdownBPLocation)},
      'IsPaid': isPaid,
      'PaymentRule': paymentRuleId,
      'TotalLines': double.parse(amountFieldController.text),
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/C_Order/${args["id"]}');
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
      Get.find<CRMPurchaseOrderController>().getSalesOrders();
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
      if (kDebugMode) {
        print(response.body);
      }
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
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user/${args["id"]}');
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
        "The record has been deleted".tr,
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
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

  Future<List<DTRecords>> getAllDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= DocBaseType eq \'SOO\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location?\$filter= C_BPartner_ID eq ${(bPartnerId)} and IsShipTo eq Y and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

  Future<void> getPaymentRules() async {
    setState(() {
      pRuleAvailable = false;
    });

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 195');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pRules =
          PaymentRuleJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      setState(() {
        pRuleAvailable = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
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

  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var amountFieldController;
  //String dropdownValue = "";
  //var bPartnerValue = "";
  late TextEditingValue bPName;
  /* int bPartnerId = Get.arguments['bPartnerId'] ?? 0;
  int bPartnerAddressId = Get.arguments['bPAddressId'] ?? 0; */
  String dropdownDocType = "";
  String dropdownBPLocation = "";
  int bPartnerId = Get.arguments['bPartnerId'] ?? 0;
  bool isPaid = false;
  String paymentRuleId = "K";
  bool pRuleAvailable = false;
  late PaymentRuleJson pRules;

  @override
  void initState() {
    isPaid = args['isPaid'] ?? false;
    pRuleAvailable = false;
    paymentRuleId = args["PruleId"] ?? "K";
    //dropdownValue = (args["C_BP_Group_ID"]).toString();
    dropdownDocType = (args["docTypeTargetId"]).toString();
    dropdownBPLocation = (args["BPartnerLocationId"]).toString();
    //bPName = TextEditingValue(text: Get.arguments['bPartner']);
    super.initState();
    bPartnerFieldController = TextEditingController();
    docNoFieldController = TextEditingController();
    businessPartnerFieldController =
        TextEditingController(text: args['bPartnerName']);
    amountFieldController = TextEditingController(text: args["amt"] ?? "0");
    //bPGroupController = TextEditingController();
    fillFields();
    getPaymentRules();
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
                editSalesOrder();
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
                      prefixIcon: const Icon(Icons.note_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'DocumentNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: businessPartnerFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.note_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'Business Partner'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Document Type'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Business Partner Location'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Rule".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: pRuleAvailable
                      ? DropdownButton(
                          value: paymentRuleId,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            paymentRuleId = newValue!;

                            //print(dropdownValue);
                          },
                          items: pRules.records!.map((list) {
                            return DropdownMenuItem<String>(
                              value: list.value,
                              child: Text(
                                list.name.toString(),
                              ),
                            );
                          }).toList(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Paid'.tr),
                  value: isPaid,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isPaid = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    controller: amountFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.note_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'Net Amount'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      prefixIcon: const Icon(Icons.note_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'DocumentNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Document Type'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Business Partner Location'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                      prefixIcon: const Icon(Icons.note_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'DocumentNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Document Type'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Business Partner Location'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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

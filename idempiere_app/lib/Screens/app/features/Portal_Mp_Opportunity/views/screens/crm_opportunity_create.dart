import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/opportunitystatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class CreateOpportunity extends StatefulWidget {
  const CreateOpportunity({Key? key}) : super(key: key);

  @override
  State<CreateOpportunity> createState() => _CreateOpportunityState();
}

class _CreateOpportunityState extends State<CreateOpportunity> {
  saveOpportunity() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_SalesStage_ID": {"id": int.parse(dropdownValue)},
      "SalesRep_ID": {"identifier": salesrepValue},
      "M_Product_ID": {"id": productId},
      "OpportunityAmt": double.parse(amtFieldController.text),
      "C_BPartner_ID": {"id": bPId},
      "Description": descriptionFieldController.text,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/C_Opportunity/');
    //print(msg);
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMOpportunityController>().getOpportunities();
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

  Future<List<OSRecords>> getAllOpportunityStatuses() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_SalesStage?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = OppurtunityStatusJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead statuses");
    }

    //print(response.body);
  }

  Future<void> getSaleStageDefault() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_SalesStage?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')} and IsDefault eq Y');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = OppurtunityStatusJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);
      setState(() {
        dropdownValue = json.records![0].id.toString();
        flag = true;
      });
    } else {
      //throw Exception("Failed to load lead statuses");
      if (kDebugMode) {
        print(response.body);
      }
    }

    //print(response.body);
  }

  Future<List<CRecords>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<PRecords>> getAllProducts() async {
    //print(response.body);
    var jsondecoded = jsonDecode(GetStorage().read('productSync'));
    var jsonResources = ProductJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBPs() async {
    //print(response.body);
    var jsondecoded = jsonDecode(GetStorage().read('businessPartnerSync'));
    var jsonResources = BusinessPartnerJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  void fillFields() {
    nameFieldController.text = "";
    bPartnerFieldController.text = "";
    amtFieldController.text = "0";
    //dropdownValue = args["leadStatus"];
    salesrepValue = "";
    //salesRepFieldController.text = args["salesRep"];
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var amtFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var phoneFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var mailFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;

  String dropdownOpportunityValuedropdownValue = "";
  String salesrepValue = "";
  String businessPartnerValue = "";
  String dropdownOpportunityValue = "";
  String date = "";
  String image64 = "";
  String imageName = "";
  late String dropdownValue = "";
  int productId = 0;
  int bPId = 0;
  late TextEditingValue bPName;
  late TextEditingValue productName;
  bool flag = false;

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    mailFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    //dropdownValue = (Get.arguments['SaleStageID']).toString();
    productName = const TextEditingValue(text: "");
    bPName = const TextEditingValue(text: "");
    businessPartnerValue = "";
    dropdownOpportunityValue = "1000001";
    date = "";
    amtFieldController = TextEditingController();
    image64 = "";
    imageName = "";
    dropdownValue = "";
    flag = false;
    fillFields();
    getAllOpportunityStatuses();
    getAllBPs();
    getSaleStageDefault();
  }

  static String _displayStringForOption(CRecords option) => option.name!;
  static String _displayProductStringForOption(PRecords option) => option.name!;
  static String _displayBPStringForOption(BPRecords option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Create Opportunity'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                saveOpportunity();
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
                      "Business Partner".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                //initialValue: bPName,
                                displayStringForOption:
                                    _displayBPStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<BPRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((BPRecords option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (BPRecords selection) {
                                  setState(() {
                                    bPId = selection.id!;
                                    //productName = selection.name;
                                  });
                                  //print(bPId);

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
                    controller: amtFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'OpportunityAmt'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<PRecords>(
                                //initialValue: productName,
                                displayStringForOption:
                                    _displayProductStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<PRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((PRecords option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (PRecords selection) {
                                  setState(() {
                                    productId = selection.id!;
                                    //productName = selection.name;
                                  });
                                  //print(productId);

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
                      prefixIcon: const Icon(Icons.message),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 3,
                    maxLines: 4,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesRep".tr,
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
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<CRecords>(
                                initialValue: TextEditingValue(
                                    text: GetStorage().read('user')),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((CRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    salesrepValue =
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesStage".tr,
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
                    future: getAllOpportunityStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<OSRecords>> snapshot) =>
                        snapshot.hasData && flag
                            ? DropdownButton(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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
                      "Business Partner".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                //initialValue: bPName,
                                displayStringForOption:
                                    _displayBPStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<BPRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((BPRecords option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (BPRecords selection) {
                                  setState(() {
                                    bPId = selection.id!;
                                    //productName = selection.name;
                                  });
                                  //print(bPId);

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
                    controller: amtFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'OpportunityAmt'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<PRecords>(
                                //initialValue: productName,
                                displayStringForOption:
                                    _displayProductStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<PRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((PRecords option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (PRecords selection) {
                                  setState(() {
                                    productId = selection.id!;
                                    //productName = selection.name;
                                  });
                                  //print(productId);

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
                      prefixIcon: const Icon(Icons.message),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 3,
                    maxLines: 4,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesRep".tr,
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
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<CRecords>(
                                initialValue: TextEditingValue(
                                    text: GetStorage().read('user')),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((CRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    salesrepValue =
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesStage".tr,
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
                    future: getAllOpportunityStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<OSRecords>> snapshot) =>
                        snapshot.hasData && flag
                            ? DropdownButton(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Business Partner".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                //initialValue: bPName,
                                displayStringForOption:
                                    _displayBPStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<BPRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((BPRecords option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (BPRecords selection) {
                                  setState(() {
                                    bPId = selection.id!;
                                    //productName = selection.name;
                                  });
                                  //print(bPId);

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
                    controller: amtFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'OpportunityAmt'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<PRecords>(
                                //initialValue: productName,
                                displayStringForOption:
                                    _displayProductStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<PRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((PRecords option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (PRecords selection) {
                                  setState(() {
                                    productId = selection.id!;
                                    //productName = selection.name;
                                  });
                                  //print(productId);

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
                      prefixIcon: const Icon(Icons.message),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 3,
                    maxLines: 4,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesRep".tr,
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
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<CRecords>(
                                initialValue: TextEditingValue(
                                    text: GetStorage().read('user')),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((CRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    salesrepValue =
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesStage".tr,
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
                    future: getAllOpportunityStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<OSRecords>> snapshot) =>
                        snapshot.hasData && flag
                            ? DropdownButton(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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

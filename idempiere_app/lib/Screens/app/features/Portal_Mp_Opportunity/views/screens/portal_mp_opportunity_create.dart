import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/campaign_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/opportunitystatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Opportunity/views/screens/portal_mp_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class PortalMPCreateOpportunity extends StatefulWidget {
  const PortalMPCreateOpportunity({Key? key}) : super(key: key);

  @override
  State<PortalMPCreateOpportunity> createState() =>
      _PortalMPCreateOpportunityState();
}

class _PortalMPCreateOpportunityState extends State<PortalMPCreateOpportunity> {
  saveOpportunity() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    String expectedCloseDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 7)));

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_SalesStage_ID": {"id": int.parse(dropdownValue)},
      "SalesRep_ID": {"id": Get.arguments["salesRepId"]},
      "M_Product_ID": {"id": productId},
      "OpportunityAmt": double.parse(amtFieldController.text),
      "C_BPartner_ID": {"id": Get.arguments["businessPartnerId"]},
      "Description": descriptionFieldController.text,
      "Probability": double.parse(probabilityFieldController.text),
      "Comments": noteFieldController.text,
      "ExpectedCloseDate": expectedCloseDate,
      "C_Currency_ID": {"id": 102},
    };

    if (campaignId != 0) {
      msg.addAll({
        "C_Campaign_ID": {"id": campaignId},
      });
    }
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/C_Opportunity/');
    //print(msg);
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      Get.find<PortalMpOpportunityController>().getOpportunities();
      Get.back();
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
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= DateLastLogin neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(await file.readAsString());
    var jsonResources = ProductJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBPs() async {
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(await file.readAsString());
    var jsonResources = BusinessPartnerJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<CPRecords>> getAllCampaigns() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/c_campaign');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonsectors = CampaignJSON.fromJson(jsondecoded);

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load campaigns");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  void fillFields() {
    nameFieldController.text = "";
    amtFieldController.text = "0";
    //dropdownValue = args["leadStatus"];
    salesrepValue = GetStorage().read('user');
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
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var noteFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var productFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var probabilityFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var salesRepFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var campaignFieldController;

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
  int campaignId = 0;
  late TextEditingValue bPName;
  late TextEditingValue productName;
  bool flag = false;

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController(text: "");
    descriptionFieldController = TextEditingController();
    noteFieldController = TextEditingController(text: "");
    probabilityFieldController = TextEditingController(text: "0");
    salesRepFieldController =
        TextEditingController(text: Get.arguments["salesRepName"]);
    productFieldController = TextEditingController(text: "");
    campaignFieldController = TextEditingController(text: "");
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
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? TextField(
                                readOnly: true,
                                controller: salesRepFieldController,
                                decoration: InputDecoration(
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  labelText: "SalesRep".tr,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  isDense: true,
                                  fillColor: Theme.of(context).cardColor,
                                ),
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
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: productFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.shopping_bag),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Product'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.value}_${element.name}")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                    subtitle: Text(suggestion.value ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  productId = suggestion.id!;
                                  productFieldController.text = suggestion.name;
                                  //productName = selection.name;
                                },
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
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<BPRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: bPartnerFieldController,
                                  //autofocus: true,
                                  /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.handshake_outlined),
                                    border: OutlineInputBorder(),
                                    labelText: 'Business Partner',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  bPId = suggestion.id!;
                                  bPartnerFieldController.text =
                                      suggestion.name;
                                  //productName = selection.name;
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
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: productFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.shopping_bag),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Product'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.value}_${element.name}")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                    subtitle: Text(suggestion.value ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  productId = suggestion.id!;
                                  productFieldController.text = suggestion.name;
                                  //productName = selection.name;
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
                    controller: probabilityFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.percent),
                      border: const OutlineInputBorder(),
                      labelText: 'Probability'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: amtFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payment),
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
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<CRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: salesRepFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.person_outline),
                                    border: const OutlineInputBorder(),
                                    labelText: 'SalesRep'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  salesrepValue = suggestion.name!;
                                  salesRepFieldController.text =
                                      suggestion.name;
                                  //productName = selection.name;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllCampaigns(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<CPRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: campaignFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.abc),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Campaign'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  campaignId = suggestion.id!;
                                  campaignFieldController.text =
                                      suggestion.name;
                                  //productName = selection.name;
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
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<BPRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: bPartnerFieldController,
                                  //autofocus: true,
                                  /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.handshake_outlined),
                                    border: OutlineInputBorder(),
                                    labelText: 'Business Partner',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  bPId = suggestion.id!;
                                  bPartnerFieldController.text =
                                      suggestion.name;
                                  //productName = selection.name;
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
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: productFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.shopping_bag),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Product'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.value}_${element.name}")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                    subtitle: Text(suggestion.value ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  productId = suggestion.id!;
                                  productFieldController.text = suggestion.name;
                                  //productName = selection.name;
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
                    controller: probabilityFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.percent),
                      border: const OutlineInputBorder(),
                      labelText: 'Probability'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: amtFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payment),
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
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<CRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: salesRepFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.person_outline),
                                    border: const OutlineInputBorder(),
                                    labelText: 'SalesRep'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  salesrepValue = suggestion.name!;
                                  salesRepFieldController.text =
                                      suggestion.name;
                                  //productName = selection.name;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllCampaigns(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<CPRecords>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: campaignFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.abc),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Campaign'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  campaignId = suggestion.id!;
                                  campaignFieldController.text =
                                      suggestion.name;
                                  //productName = selection.name;
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

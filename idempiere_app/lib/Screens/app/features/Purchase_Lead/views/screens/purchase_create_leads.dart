import 'dart:convert';
//import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/campaign_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/sector_json.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Lead/views/screens/purchase_lead_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class CreatePurchaseLead extends StatefulWidget {
  const CreatePurchaseLead({Key? key}) : super(key: key);

  @override
  State<CreatePurchaseLead> createState() => _CreatePurchaseLeadState();
}

class _CreatePurchaseLeadState extends State<CreatePurchaseLead> {
  createLead() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    var json = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "Note": noteFieldController.text,
      "BPName": bPartnerFieldController.text,
      "Phone": phoneFieldController.text,
      "EMail": mailFieldController.text,
      "URL": urlFieldController.text,
      "IsVendorLead": true,
      "LeadStatus": {"id": dropdownValue},
    };

    if (salesrepValue != "") {
      json.addAll({
        "SalesRep_ID": {"identifier": salesrepValue},
      });
    }
    if (sectorValue != "") {
      json.addAll({
        "lit_IndustrySector_ID": {"id": int.parse(sectorValue)},
      });
    }
    if (sizeDropdownValue != "") {
      json.addAll({
        "lit_LeadSize_ID": {"id": int.parse(sizeDropdownValue)},
      });
    }
    if (campaignDropdownValue != "") {
      json.addAll({
        "C_Campaign_ID": {"id": int.parse(campaignDropdownValue)},
      });
    }

    if (sourceDropdownValue != "") {
      json.addAll({
        "LeadSource": {"id": sourceDropdownValue},
      });
    }

    //print(jsonEncode(json));
    /* final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Name": nameFieldController.text,
      "BPName": bPartnerFieldController.text,
      "Phone": phoneFieldController.text,
      "EMail": mailFieldController.text,
      "URL": urlFieldController.text,
      "SalesRep_ID": {"identifier": salesrepValue},
      "LeadStatus": {"id": dropdownValue},
      "IsSalesLead": true
    }); */
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user/');
    //print(msg);
    var response = await http.post(
      url,
      body: jsonEncode(json),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      Get.find<PurchaseLeadController>().getLeads();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.statusCode);
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

  Future<List<LSRecords>> getAllLeadStatuses() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 53416 ');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = LeadStatusJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead statuses");
    }

    //print(response.body);
  }

  Future<List<Records>> getAllSalesRep() async {
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

  Future<List<JRecords>> getAllSectors() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_IndustrySector');
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

      var jsonsectors = SectorJSON.fromJson(jsondecoded);

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load sectors");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<CRecords>> getAllCampaigns() async {
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

  Future<List<CRecords>> getAllLeadSizes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_LeadSize');
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

  Future<List<LSRecords>> getAllLeadSources() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_ref_list?\$filter= AD_Reference_ID eq 53415 ');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json = LeadStatusJson.fromJson(jsonDecode(response.body));

      return json.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load campaigns");
    }

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
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var phoneFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var mailFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var urlFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var noteFieldController;

  late TextEditingController salesRepFieldController;

  String dropdownValue = "";
  String campaignDropdownValue = "";
  String salesrepValue = "";
  String sourceDropdownValue = "";
  String sizeDropdownValue = "";
  String sectorValue = "";

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    mailFieldController = TextEditingController();
    urlFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    noteFieldController = TextEditingController();
    dropdownValue = "N";
    sourceDropdownValue = "";
    campaignDropdownValue = "";
    salesRepFieldController =
        TextEditingController(text: GetStorage().read("user"));
    salesrepValue = GetStorage().read("user");
    sectorValue = "";
    sizeDropdownValue = "";
    //fillFields();
    //getAllLeadStatuses();
    //getAllSectors();
    //getAllCampaigns();
    getAllLeadSources();
  }

  static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Lead'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createLead();
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
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
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
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Phone'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: mailFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: urlFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                      labelText: 'Website',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<Records>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  //autofocus: true,
                                  controller: salesRepFieldController,
                                  decoration: InputDecoration(
                                    labelText: 'SalesRep'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    //isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
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
                                  setState(() {
                                    salesrepValue = suggestion.name!;
                                    salesRepFieldController.text =
                                        suggestion.name!;
                                  });
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSectors(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<JRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Sector'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Sector".tr),
                                  value: sectorValue == "" ? null : sectorValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sectorValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadSizes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Lead Size'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Size".tr),
                                  value: sizeDropdownValue == ""
                                      ? null
                                      : sizeDropdownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sizeDropdownValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllCampaigns(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Campaign'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Campaign".tr),
                                  value: campaignDropdownValue == ""
                                      ? null
                                      : campaignDropdownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      campaignDropdownValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadSources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Lead Source'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text('Select a Lead Source'.tr),
                                  value: sourceDropdownValue == ""
                                      ? null
                                      : sourceDropdownValue,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,

                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sourceDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'LeadStatus'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  value: dropdownValue,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  //style: const TextStyle(color: Colors.deepPurple),
                                  /* underline: Container(
                                                    height: 2,
                                                    color: Colors.deepPurpleAccent,
                                                  ), */
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: /* <String>[
                                    'Chiuso',
                                    'Convertito',
                                    'In Lavoro',
                                    'Nuovo'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()*/
                                      snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
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
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
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
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Phone'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: mailFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: urlFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                      labelText: 'Website',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<Records>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  //autofocus: true,
                                  controller: salesRepFieldController,
                                  decoration: InputDecoration(
                                    labelText: 'SalesRep'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    //isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
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
                                  setState(() {
                                    salesrepValue = suggestion.name!;
                                    salesRepFieldController.text =
                                        suggestion.name!;
                                  });
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSectors(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<JRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Sector'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Sector".tr),
                                  value: sectorValue == "" ? null : sectorValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sectorValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadSizes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Lead Size'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Size".tr),
                                  value: sizeDropdownValue == ""
                                      ? null
                                      : sizeDropdownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sizeDropdownValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllCampaigns(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Campaign'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Campaign".tr),
                                  value: campaignDropdownValue == ""
                                      ? null
                                      : campaignDropdownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      campaignDropdownValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadSources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Lead Source'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text('Select a Lead Source'.tr),
                                  value: sourceDropdownValue == ""
                                      ? null
                                      : sourceDropdownValue,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,

                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sourceDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'LeadStatus'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  value: dropdownValue,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  //style: const TextStyle(color: Colors.deepPurple),
                                  /* underline: Container(
                                                    height: 2,
                                                    color: Colors.deepPurpleAccent,
                                                  ), */
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: /* <String>[
                                    'Chiuso',
                                    'Convertito',
                                    'In Lavoro',
                                    'Nuovo'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()*/
                                      snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
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
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
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
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Phone'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: mailFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: urlFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                      labelText: 'Website',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<Records>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  //autofocus: true,
                                  controller: salesRepFieldController,
                                  decoration: InputDecoration(
                                    labelText: 'SalesRep'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    //isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
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
                                  setState(() {
                                    salesrepValue = suggestion.name!;
                                    salesRepFieldController.text =
                                        suggestion.name!;
                                  });
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSectors(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<JRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Sector'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Sector".tr),
                                  value: sectorValue == "" ? null : sectorValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sectorValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadSizes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Lead Size'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Size".tr),
                                  value: sizeDropdownValue == ""
                                      ? null
                                      : sizeDropdownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sizeDropdownValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllCampaigns(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Campaign'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Campaign".tr),
                                  value: campaignDropdownValue == ""
                                      ? null
                                      : campaignDropdownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      campaignDropdownValue = newValue!;
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadSources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Lead Source'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text('Select a Lead Source'.tr),
                                  value: sourceDropdownValue == ""
                                      ? null
                                      : sourceDropdownValue,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,

                                  onChanged: (String? newValue) {
                                    setState(() {
                                      sourceDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllLeadStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'LeadStatus'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  //isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  value: dropdownValue,
                                  //icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  //style: const TextStyle(color: Colors.deepPurple),
                                  /* underline: Container(
                                                    height: 2,
                                                    color: Colors.deepPurpleAccent,
                                                  ), */
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: /* <String>[
                                    'Chiuso',
                                    'Convertito',
                                    'In Lavoro',
                                    'Nuovo'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()*/
                                      snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                ),
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

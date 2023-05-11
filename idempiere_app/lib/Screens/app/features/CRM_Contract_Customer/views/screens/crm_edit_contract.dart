import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/views/screens/crm_contact_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/views/screens/crm_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract_Customer/views/screens/crm_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_term_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CRMEditContractCustomer extends StatefulWidget {
  const CRMEditContractCustomer({Key? key}) : super(key: key);

  @override
  State<CRMEditContractCustomer> createState() =>
      _CRMEditContractCustomerState();
}

class _CRMEditContractCustomerState extends State<CRMEditContractCustomer> {
  editContract() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    Map<String, dynamic> msg = {
      "Name": nameFieldController.text,
      "DocumentNo": docNoFieldController.text,
      "Description": descriptionFieldController.text,
      "validfromdate": "${dateFrom}T00:00:00Z",
      "validtodate": "${dateTo}T00:00:00Z",
      "FrequencyNextDate": frequencyNextDate,
    };

    if (businessPartnerId > 0) {
      msg.addAll({
        "C_BPartner_ID": {"id": businessPartnerId}
      });
    }

    if (frequencyTypeId != "0") {
      msg.addAll({
        "FrequencyType": {"id": frequencyTypeId}
      });
    }

    if (paymentTermId != "0") {
      msg.addAll({
        'C_PaymentTerm_ID': {'id': int.parse(paymentTermId)}
      });
    }

    if (paymentRuleId != "0") {
      msg.addAll({
        'PaymentRule': {'id': paymentRuleId}
      });
    }

    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/C_Contract/${args["id"]}');
    //print(msg);
    var response = await http.put(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMContractCustomerController>().getContracts();
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

  /* deleteLead() async {
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
      Get.find<CRMContactBPController>().getContacts();
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
      Get.snackbar(
        "Error!".tr,
        "Record not updated".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  } */

  Future<List<LSRecords>> getAllContractFrequencyTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 283');
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
      throw Exception("Failed to load frequency types");
    }

    //print(response.body);
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<PTRecords>> getPaymentTerms() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_PaymentTerm?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = PaymentTermsJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      return json.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load payment terms");
    }
  }

  Future<List<PRRecords>> getPaymentRules() async {
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
      var json =
          PaymentRuleJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return json.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load payment rules");
    }
  }

  dynamic args = Get.arguments;
  late TextEditingController docNoFieldController;
  int businessPartnerId = 0;
  late TextEditingController bpFieldController;

  late TextEditingController nameFieldController;
  late TextEditingController descriptionFieldController;
  String dateFrom = "";
  String dateTo = "";
  String frequencyNextDate = "";
  String frequencyTypeId = "0";
  String paymentTermId = "0";
  String paymentRuleId = "0";
  // ignore: prefer_typing_uninitialized_variables

  @override
  void initState() {
    super.initState();
    docNoFieldController = TextEditingController(text: args['docNo'] ?? "");
    businessPartnerId = args['businessPartnerId'] ?? 0;
    bpFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    nameFieldController = TextEditingController(text: args['name'] ?? "");
    descriptionFieldController =
        TextEditingController(text: args['description'] ?? "");
    dateFrom = args['dateFrom'].substring(0, 10);
    dateTo = args['dateTo'].substring(0, 10);
    frequencyNextDate = args['frequencyNextDate'] ?? "";
    frequencyTypeId = args['frequencyTypeId'] ?? "0";
    paymentTermId = (args['paymentTermId'] ?? 0).toString();
    paymentRuleId = args['paymentRuleId'] ?? "0";
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Contract'.tr),
        ),
        actions: [
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Record deletion".tr,
                  middleText: "Are you sure you want to delete the record?".tr,
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
                    deleteLead();
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
              onPressed: () {
                editContract();
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
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<BPRecords>(
                                direction: AxisDirection.up,
                                //getImmediateSuggestions: true,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        businessPartnerId = 0;
                                      });
                                    }
                                  },
                                  controller: bpFieldController,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'Business Partner'.tr,
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
                                  bpFieldController.text = suggestion.name!;
                                  businessPartnerId = suggestion.id!;
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
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
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
                  child: DateTimePicker(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Valid Date from'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    type: DateTimePickerType.date,
                    initialValue: args['dateFrom'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        dateFrom = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Valid Date to'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    type: DateTimePickerType.date,
                    initialValue: args['dateTo'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        dateTo = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Frequency Next Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    type: DateTimePickerType.date,
                    initialValue: args['frequencyNextDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        frequencyNextDate = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllContractFrequencyTypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Document Type'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Frequency Type".tr),
                                  isExpanded: true,
                                  value: frequencyTypeId == "0"
                                      ? null
                                      : frequencyTypeId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      frequencyTypeId = newValue as String;
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
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getPaymentTerms(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Payment Term'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Payment Term".tr),
                                  isExpanded: true,
                                  value: paymentTermId == "0"
                                      ? null
                                      : paymentTermId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      paymentTermId = newValue as String;
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
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getPaymentRules(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Payment Rule'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",
                                  isDense: true,
                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text("Select a Payment Rule".tr),
                                  isExpanded: true,
                                  value: paymentRuleId == "0"
                                      ? null
                                      : paymentRuleId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      paymentRuleId = newValue as String;
                                    });

                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.value,
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
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
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

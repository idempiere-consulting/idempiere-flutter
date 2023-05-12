import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/views/screens/crm_invoice_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_term_json.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Invoice/views/screens/crm_invoice_screen.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

//models
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/doctype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/bplocation_json.dart';

//screens
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/constants.dart';

class PurchaseEditInvoice extends StatefulWidget {
  const PurchaseEditInvoice({Key? key}) : super(key: key);

  @override
  State<PurchaseEditInvoice> createState() => _PurchaseEditInvoiceState();
}

class _PurchaseEditInvoiceState extends State<PurchaseEditInvoice> {
  editInvoice() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    Map<String, dynamic> msg = {
      "Description": descriptionFieldController.text,
    };

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
        Uri.parse('$protocol://$ip/api/v1/models/C_Invoice/${args["id"]}');
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
      Get.find<PurchaseInvoiceController>().getInvoices();
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
  String paymentTermId = "0";
  String paymentRuleId = "0";
  late TextEditingController descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  // ignore: prefer_typing_uninitialized_variables

  @override
  void initState() {
    super.initState();
    descriptionFieldController =
        TextEditingController(text: args['description'] ?? "");
    paymentTermId = (args['paymentTermId'] ?? 0).toString();
    paymentRuleId = args['paymentRuleId'] ?? "0";
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Invoice'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                editInvoice();
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
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
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
              children: [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
        ),
      ),
    );
  }
}

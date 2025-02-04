import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/campaign_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/sector_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/models/maintaincardline_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CreateMaintainCardRow extends StatefulWidget {
  final Function getMaintainCardLines;
  const CreateMaintainCardRow({Key? key, required this.getMaintainCardLines})
      : super(key: key);

  @override
  State<CreateMaintainCardRow> createState() => _CreateMaintainCardRowState();
}

class _CreateMaintainCardRowState extends State<CreateMaintainCardRow> {
  createMaintainCardRow() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    var json = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": productId},
      "QtyBOM": double.parse(qtyBOM.text),
      "C_UOM_ID": {"id": 100},
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "ValidFrom": dateFrom,
      "ValidTo": dateTo,
      "LIT_ProductCard_ID": {"id": args["cardId"]}
    };

    if (productToId > 0) {
      json.addAll({
        "M_Product_To_ID": {"id": productId},
        "Qty": int.parse(qtyFieldController.text)
      });
    }

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/LIT_ProductCardLine/');
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
      print(response.statusCode);
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

  Future<List<PRecords>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    //print(jsonResources.records!.length);

    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  late TextEditingController lineNoFieldController;

  var args = Get.arguments;
  late TextEditingController productName;
  int productId = 0;
  late TextEditingController qtyBOM;
  late TextEditingController nameFieldController;
  late TextEditingController descriptionFieldController;
  late TextEditingController productToName;
  int productToId = 0;
  late TextEditingController qtyFieldController;
  String dateFrom = "";
  String dateTo = "";

  @override
  void initState() {
    super.initState();
    lineNoFieldController = TextEditingController(text: "0");
    productName = TextEditingController();
    productId = 0;
    qtyBOM = TextEditingController(text: "1.0");
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    productToName = TextEditingController();
    productToId = 0;
    qtyFieldController = TextEditingController(text: "0");
    dateFrom = "";
    dateTo = "";
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
          child: Text('Add Row'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //createMaintainCardRow();
                createMaintainCardRow();
                widget.getMaintainCardLines();
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
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: lineNoFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Line N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        productId = 0;
                                      });
                                    }
                                  },
                                  controller: productName,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'Product'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.name}_${element.value}")
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
                                  productName.text = suggestion.name!;
                                  productId = suggestion.id!;
                                  if (suggestion.mProductToID != null) {
                                    productToName.text =
                                        suggestion.mProductToID!.identifier!;

                                    productToId = suggestion.mProductToID!.id!;
                                  }
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: qtyBOM,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Qty'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        productToId = 0;
                                      });
                                    }
                                  },
                                  controller: productToName,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'To Product'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.name}_${element.value}")
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
                                  qtyFieldController.text = "1";
                                  productToName.text = suggestion.name!;
                                  productToId = suggestion.id!;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Qty'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 2.5),
                          child: DateTimePicker(
                            locale: Locale('language'.tr, 'LANGUAGE'.tr),
                            decoration: InputDecoration(
                              labelText: 'Date From'.tr,
                              //filled: true,
                              border: const OutlineInputBorder(
                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                  ),
                              prefixIcon: const Icon(Icons.event),
                              //hintText: "search..",
                              isDense: true,
                              //fillColor: Theme.of(context).cardColor,
                            ),

                            type: DateTimePickerType.date,
                            initialValue: dateFrom,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            timeLabelText: 'Date From'.tr,
                            icon: const Icon(Icons.event),
                            onChanged: (val) {
                              setState(() {
                                dateFrom = val;
                              });
                            },
                            validator: (val) {
                              //print(val);
                              return null;
                            },
                            // ignore: avoid_print
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 2.5),
                          child: DateTimePicker(
                            locale: Locale('language'.tr, 'LANGUAGE'.tr),
                            decoration: InputDecoration(
                              labelText: 'Date To'.tr,
                              //filled: true,
                              border: const OutlineInputBorder(
                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                  ),
                              prefixIcon: const Icon(Icons.event),
                              //hintText: "search..",
                              isDense: true,
                              //fillColor: Theme.of(context).cardColor,
                            ),

                            type: DateTimePickerType.date,
                            initialValue: dateTo,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            timeLabelText: 'Date To'.tr,
                            icon: const Icon(Icons.event),
                            onChanged: (val) {
                              setState(() {
                                dateTo = val;
                              });
                            },
                            validator: (val) {
                              //print(val);
                              return null;
                            },
                            // ignore: avoid_print
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
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
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: lineNoFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Line N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        productId = 0;
                                      });
                                    }
                                  },
                                  controller: productName,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'Product'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.name}_${element.value}")
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
                                  productName.text = suggestion.name!;
                                  productId = suggestion.id!;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: qtyBOM,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Qty'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        productToId = 0;
                                      });
                                    }
                                  },
                                  controller: productToName,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'To Product'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.name}_${element.value}")
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
                                  qtyFieldController.text = "1";
                                  productToName.text = suggestion.name!;
                                  productToId = suggestion.id!;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Qty'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 2.5),
                          child: DateTimePicker(
                            locale: Locale('language'.tr, 'LANGUAGE'.tr),
                            decoration: InputDecoration(
                              labelText: 'Date From'.tr,
                              //filled: true,
                              border: const OutlineInputBorder(
                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                  ),
                              prefixIcon: const Icon(Icons.event),
                              //hintText: "search..",
                              isDense: true,
                              //fillColor: Theme.of(context).cardColor,
                            ),

                            type: DateTimePickerType.date,
                            initialValue: dateFrom,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            timeLabelText: 'Date From'.tr,
                            icon: const Icon(Icons.event),
                            onChanged: (val) {
                              setState(() {
                                dateFrom = val;
                              });
                            },
                            validator: (val) {
                              //print(val);
                              return null;
                            },
                            // ignore: avoid_print
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 2.5),
                          child: DateTimePicker(
                            locale: Locale('language'.tr, 'LANGUAGE'.tr),
                            decoration: InputDecoration(
                              labelText: 'Date To'.tr,
                              //filled: true,
                              border: const OutlineInputBorder(
                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                  ),
                              prefixIcon: const Icon(Icons.event),
                              //hintText: "search..",
                              isDense: true,
                              //fillColor: Theme.of(context).cardColor,
                            ),

                            type: DateTimePickerType.date,
                            initialValue: dateTo,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            timeLabelText: 'Date To'.tr,
                            icon: const Icon(Icons.event),
                            onChanged: (val) {
                              setState(() {
                                dateTo = val;
                              });
                            },
                            validator: (val) {
                              //print(val);
                              return null;
                            },
                            // ignore: avoid_print
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
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
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: lineNoFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Line N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        productId = 0;
                                      });
                                    }
                                  },
                                  controller: productName,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'Product'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.name}_${element.value}")
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
                                  productName.text = suggestion.name!;
                                  productId = suggestion.id!;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: qtyBOM,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Qty'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        productToId = 0;
                                      });
                                    }
                                  },
                                  controller: productToName,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'To Product'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      ("${element.name}_${element.value}")
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
                                  qtyFieldController.text = "1";
                                  productToName.text = suggestion.name!;
                                  productToId = suggestion.id!;
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Qty'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 2.5),
                          child: DateTimePicker(
                            locale: Locale('language'.tr, 'LANGUAGE'.tr),
                            decoration: InputDecoration(
                              labelText: 'Date From'.tr,
                              //filled: true,
                              border: const OutlineInputBorder(
                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                  ),
                              prefixIcon: const Icon(Icons.event),
                              //hintText: "search..",
                              isDense: true,
                              //fillColor: Theme.of(context).cardColor,
                            ),

                            type: DateTimePickerType.date,
                            initialValue: dateFrom,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            timeLabelText: 'Date From'.tr,
                            icon: const Icon(Icons.event),
                            onChanged: (val) {
                              setState(() {
                                dateFrom = val;
                              });
                            },
                            validator: (val) {
                              //print(val);
                              return null;
                            },
                            // ignore: avoid_print
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 2.5),
                          child: DateTimePicker(
                            locale: Locale('language'.tr, 'LANGUAGE'.tr),
                            decoration: InputDecoration(
                              labelText: 'Date To'.tr,
                              //filled: true,
                              border: const OutlineInputBorder(
                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                  ),
                              prefixIcon: const Icon(Icons.event),
                              //hintText: "search..",
                              isDense: true,
                              //fillColor: Theme.of(context).cardColor,
                            ),

                            type: DateTimePickerType.date,
                            initialValue: dateTo,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            timeLabelText: 'Date To'.tr,
                            icon: const Icon(Icons.event),
                            onChanged: (val) {
                              setState(() {
                                dateTo = val;
                              });
                            },
                            validator: (val) {
                              //print(val);
                              return null;
                            },
                            // ignore: avoid_print
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
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

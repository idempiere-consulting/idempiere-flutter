import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/views/screens/crm_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Purchase_Contract/views/screens/crm_contract_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class PurchaseFilterContract extends StatefulWidget {
  const PurchaseFilterContract({Key? key}) : super(key: key);

  @override
  State<PurchaseFilterContract> createState() => _PurchaseFilterContractState();
}

class _PurchaseFilterContractState extends State<PurchaseFilterContract> {
  applyFilters() {
    if (businessPartnerId > 0) {
      Get.find<PurchaseContractController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<PurchaseContractController>().businessPartnerFilter = "";
    }

    if (docNoFieldController.text != "") {
      Get.find<PurchaseContractController>().docNoFilter =
          " and contains(DocumentNo,'${docNoFieldController.text}')";
    } else {
      Get.find<PurchaseContractController>().docNoFilter = "";
    }

    if (docTypeId != "0") {
      Get.find<PurchaseContractController>().docTypeFilter =
          " and C_DocTypeTarget_ID eq $docTypeId";
    } else {
      Get.find<PurchaseContractController>().docTypeFilter = "";
    }

    Get.find<PurchaseContractController>().businessPartnerId.value =
        businessPartnerId;

    if (businessPartnerId > 0) {
      Get.find<PurchaseContractController>().businessPartnerName =
          bpSearchFieldController.text;
    } else {
      Get.find<PurchaseContractController>().businessPartnerName = "";
    }
    Get.find<PurchaseContractController>().docNoValue.value =
        docNoFieldController.text;
    Get.find<PurchaseContractController>().docTypeId.value = docTypeId;

    Get.find<PurchaseContractController>().getContracts();
    Get.back();
  }

  saveFilters() {
    if (businessPartnerId > 0) {
      GetStorage().write('PurchaseContract_businessPartnerFilter',
          " and C_BPartner_ID eq $businessPartnerId");
    } else {
      GetStorage().write('PurchaseContract_businessPartnerFilter', "");
    }

    if (docNoFieldController.text != "") {
      GetStorage().write('PurchaseContract_docNoFilter',
          " and contains(DocumentNo,'${docNoFieldController.text}')");
    } else {
      GetStorage().write('PurchaseContract_docNoFilter', "");
    }

    if (docTypeId != "0") {
      GetStorage().write(
          'PurchaseContract_docTypeFilter', " and C_DocType_ID eq $docTypeId");
    } else {
      GetStorage().write('PurchaseContract_docTypeFilter', "");
    }

    GetStorage().write('PurchaseContract_businessPartnerId', businessPartnerId);
    GetStorage().write(
        'PurchaseContract_businessPartnerName', bpSearchFieldController.text);
    GetStorage().write('PurchaseContract_docNo', docNoFieldController.text);
    GetStorage().write('PurchaseContract_docTypeId', docTypeId);
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

  Future<List<Records>> getAllContractDocTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= (DocBaseType eq \'CDA\' or DocBaseType eq \'CDV\') and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);
      //print(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      jsonContacts.records!.add(Records(id: 0, name: "All".tr));

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load doc types");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  dynamic args = Get.arguments;

  int businessPartnerId = 0;
  late TextEditingController bpSearchFieldController;
  late TextEditingController docNoFieldController;
  String docTypeId = "0";

  @override
  void initState() {
    super.initState();
    bpSearchFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    businessPartnerId = args['businessPartnerId'] ?? 0;
    docNoFieldController = TextEditingController(text: args['docNo'] ?? "");
    docTypeId = (args["docTypeId"] ?? 0).toString();
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: applyFilters, child: Text('Apply Filters'.tr)),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              tooltip: 'reset filters',
              onPressed: () {
                setState(() {
                  businessPartnerId = 0;
                  bpSearchFieldController.text = "";
                  docNoFieldController.text = "";
                  docTypeId = "0";
                });
              },
              icon: const Icon(
                MaterialSymbols.filter_alt_off,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              tooltip: 'save filters',
              onPressed: saveFilters,
              icon: const Icon(
                MaterialSymbols.bookmark,
              ),
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Text('Filters'.tr),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller: bpSearchFieldController,
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
                                        isDense: true,
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
                                      bpSearchFieldController.text =
                                          suggestion.name!;
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
                        controller: docNoFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'DocumentNo'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: getAllContractDocTypes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
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
                                      hint: Text("Select a Lead Size".tr),
                                      isExpanded: true,
                                      value: docTypeId == "" ? null : docTypeId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          docTypeId = newValue as String;
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
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller: bpSearchFieldController,
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
                                        isDense: true,
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
                                      bpSearchFieldController.text =
                                          suggestion.name!;
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
                        controller: docNoFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'DocumentNo'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: getAllContractDocTypes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
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
                                      hint: Text("Select a Lead Size".tr),
                                      isExpanded: true,
                                      value: docTypeId == "" ? null : docTypeId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          docTypeId = newValue as String;
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
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller: bpSearchFieldController,
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
                                        isDense: true,
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
                                      bpSearchFieldController.text =
                                          suggestion.name!;
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
                        controller: docNoFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'DocumentNo'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: getAllContractDocTypes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
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
                                      hint: Text("Select a Lead Size".tr),
                                      isExpanded: true,
                                      value: docTypeId == "" ? null : docTypeId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          docTypeId = newValue as String;
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
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Contract/views/screens/portal_mp_contract_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

class PortalMPFilterContract extends StatefulWidget {
  const PortalMPFilterContract({Key? key}) : super(key: key);

  @override
  State<PortalMPFilterContract> createState() => _PortalMPFilterContractState();
}

class _PortalMPFilterContractState extends State<PortalMPFilterContract> {
  applyFilters() {
    if (docNoFieldController.text != "") {
      Get.find<PortalMpContractController>().docNoFilter =
          " and contains(DocumentNo,'${docNoFieldController.text}')";
    } else {
      Get.find<PortalMpContractController>().docNoFilter = "";
    }

    if (docTypeId != "0") {
      Get.find<PortalMpContractController>().docTypeFilter =
          " and C_DocTypeTarget_ID eq $docTypeId";
    } else {
      Get.find<PortalMpContractController>().docTypeFilter = "";
    }

    Get.find<PortalMpContractController>().docNoValue.value =
        docNoFieldController.text;
    Get.find<PortalMpContractController>().docTypeId.value = docTypeId;

    Get.find<PortalMpContractController>().getContracts();
    Get.back();
  }

  saveFilters() {
    if (docNoFieldController.text != "") {
      GetStorage().write('PortalMPContract_docNoFilter',
          " and contains(DocumentNo,'${docNoFieldController.text}')");
    } else {
      GetStorage().write('PortalMPContract_docNoFilter', "");
    }

    if (docTypeId != "0") {
      GetStorage().write(
          'PortalMPContract_docTypeFilter', " and C_DocType_ID eq $docTypeId");
    } else {
      GetStorage().write('PortalMPContract_docTypeFilter', "");
    }

    GetStorage().write('PortalMPContract_docNo', docNoFieldController.text);
    GetStorage().write('PortalMPContract_docTypeId', docTypeId);
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

  late TextEditingController docNoFieldController;
  String docTypeId = "0";

  @override
  void initState() {
    super.initState();
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
                  docNoFieldController.text = "";
                  docTypeId = "0";
                });
              },
              icon: const Icon(
                Symbols.filter_alt_off,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              tooltip: 'save filters',
              onPressed: saveFilters,
              icon: const Icon(
                Symbols.bookmark,
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

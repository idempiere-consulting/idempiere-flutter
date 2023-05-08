import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/views/screens/crm_contact_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class CRMFilterContact extends StatefulWidget {
  const CRMFilterContact({Key? key}) : super(key: key);

  @override
  State<CRMFilterContact> createState() => _CRMFilterContactState();
}

class _CRMFilterContactState extends State<CRMFilterContact> {
  applyFilters() {
    if (businessPartnerId > 0) {
      Get.find<CRMContactBPController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<CRMContactBPController>().businessPartnerFilter = "";
    }

    Get.find<CRMContactBPController>().businessPartnerId.value =
        businessPartnerId;

    if (businessPartnerId > 0) {
      Get.find<CRMContactBPController>().businessPartnerName =
          bpSearchFieldController.text;
    } else {
      Get.find<CRMContactBPController>().businessPartnerName = "";
    }
    if (nameFieldController.text != "") {
      Get.find<CRMContactBPController>().nameFilter =
          " and contains(tolower(Name),'${nameFieldController.text}')";
    } else {
      Get.find<CRMContactBPController>().nameFilter = "";
    }

    if (mailFieldController.text != "") {
      Get.find<CRMContactBPController>().mailFilter =
          " and contains(EMail,'${mailFieldController.text}')";
    } else {
      Get.find<CRMContactBPController>().mailFilter = "";
    }

    if (phoneFieldController.text != "") {
      Get.find<CRMContactBPController>().phoneFilter =
          " and contains(Phone,'${phoneFieldController.text}')";
    } else {
      Get.find<CRMContactBPController>().phoneFilter = "";
    }

    Get.find<CRMContactBPController>().nameValue.value =
        nameFieldController.text;
    Get.find<CRMContactBPController>().mailValue.value =
        mailFieldController.text;
    Get.find<CRMContactBPController>().phoneValue.value =
        phoneFieldController.text;

    Get.find<CRMContactBPController>().getContacts();
    Get.back();
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

  dynamic args = Get.arguments;

  int businessPartnerId = 0;
  late TextEditingController bpSearchFieldController;

  late TextEditingController nameFieldController;
  late TextEditingController mailFieldController;
  late TextEditingController phoneFieldController;

  @override
  void initState() {
    super.initState();
    bpSearchFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    businessPartnerId = args['businessPartnerId'] ?? 0;
    nameFieldController = TextEditingController(text: args['name']);
    mailFieldController = TextEditingController(text: args['mail']);
    phoneFieldController = TextEditingController(text: args['phone']);
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
                                    direction: AxisDirection.down,
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
                        controller: nameFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: mailFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Mail'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: phoneFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Phone'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
              children: const [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [],
            );
          },
        ),
      ),
    );
  }
}

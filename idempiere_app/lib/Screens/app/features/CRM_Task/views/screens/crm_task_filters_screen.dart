import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task/views/screens/crm_task_screen.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class CRMFilterTask extends StatefulWidget {
  const CRMFilterTask({Key? key}) : super(key: key);

  @override
  State<CRMFilterTask> createState() => _CRMFilterTaskState();
}

class _CRMFilterTaskState extends State<CRMFilterTask> {
  applyFilters() {
    if (selectedUserRadioTile > 0) {
      Get.find<CRMTaskController>().userFilter =
          " and AD_User_ID eq ${GetStorage().read('userId')}";
    } else {
      Get.find<CRMTaskController>().userFilter = "";
    }

    if (selectedStatusRadioTile > 0) {
      switch (selectedStatusRadioTile) {
        case 1:
          Get.find<CRMTaskController>().statusFilter =
              " and JP_ToDo_Status neq 'CO'";

          break;
        case 2:
          Get.find<CRMTaskController>().statusFilter =
              " and JP_ToDo_Status eq 'CO'";

          break;
        default:
      }
    } else {
      Get.find<CRMTaskController>().statusFilter = "";
    }

    if (businessPartnerId > 0) {
      Get.find<CRMTaskController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<CRMTaskController>().businessPartnerFilter = "";
    }

    Get.find<CRMTaskController>().selectedUserRadioTile.value =
        selectedUserRadioTile;

    Get.find<CRMTaskController>().selectedStatusRadioTile.value =
        selectedStatusRadioTile;
    Get.find<CRMTaskController>().businessPartnerId.value = businessPartnerId;

    if (businessPartnerId > 0) {
      Get.find<CRMTaskController>().businessPartnerName =
          bpSearchFieldController.text;
    } else {
      Get.find<CRMTaskController>().businessPartnerName = "";
    }

    Get.find<CRMTaskController>().getTasks();
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

  setSelectedUserRadioTile(int val) {
    setState(() {
      selectedUserRadioTile = val;
    });
  }

  setSelectedStatusRadioTile(int val) {
    setState(() {
      selectedStatusRadioTile = val;
    });
  }

  dynamic args = Get.arguments;
  int selectedUserRadioTile = 0;
  int selectedStatusRadioTile = 0;

  int businessPartnerId = 0;
  late TextEditingController bpSearchFieldController;

  @override
  void initState() {
    super.initState();
    bpSearchFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    selectedUserRadioTile = args['selectedUserRadioTile'] ?? 0;
    selectedStatusRadioTile = args['selectedStatusRadioTile'] ?? 0;
    businessPartnerId = args['businessPartnerId'] ?? 0;
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
                    'User Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  children: [
                    RadioListTile(
                      value: 0,
                      groupValue: selectedUserRadioTile,
                      title: Text("All".tr),
                      //subtitle: Text("Radio 1 Subtitle"),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      activeColor: Theme.of(context).primaryColor,

                      //selected: true,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedUserRadioTile,
                      title: Text("Mine Only".tr),
                      subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    )
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Status Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  children: [
                    RadioListTile(
                      value: 0,
                      groupValue: selectedStatusRadioTile,
                      title: Text("All".tr),
                      //subtitle: Text("Radio 1 Subtitle"),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedStatusRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      //selected: true,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedStatusRadioTile,
                      title: Text("Open Only".tr),
                      //subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedStatusRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,
                      selected: false,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedStatusRadioTile,
                      title: Text("Closed Only".tr),
                      //subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedStatusRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,
                      selected: false,
                    )
                  ],
                ),
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
                      margin: const EdgeInsets.only(left: 10, right: 10),
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
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                      decoration: InputDecoration(
                                        labelText: 'Business Partner'.tr,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
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
                  ],
                ),
                SizedBox(
                  height: 100,
                )
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            );
          },
        ),
      ),
    );
  }
}

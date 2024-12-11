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
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/city_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/coutry_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/region_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/sector_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpnomaly/views/screens/maintenance_mpanomaly_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';

class MaintenanceEditAnomaly extends StatefulWidget {
  const MaintenanceEditAnomaly({Key? key}) : super(key: key);

  @override
  State<MaintenanceEditAnomaly> createState() => _MaintenanceEditAnomalyState();
}

class _MaintenanceEditAnomalyState extends State<MaintenanceEditAnomaly> {
  editAnomaly() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    /* final msg = jsonEncode({
      "LIT_IsManagedByCustomer": manByCustomer,
      "IsClosed": isClosed,
    }); */
    var json = {
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "LIT_NCFaultType_ID": {"id": int.parse(anomalyType)},
      "LIT_IsManagedByCustomer": manByCustomer,
      "IsClosed": isClosed,
    };

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_nc/${args["id"]}');
    //print(msg);
    var response = await http.put(
      url,
      body: jsonEncode(json),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<MaintenanceMpanomalyController>().getAnomalies();
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

  deleteAnomaly() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_nc/${args["id"]}');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMLeadController>().getLeads();
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
  }

  Future<List<JRecords>> getAllSectors() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/LIT_NCFaultType');
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

  dynamic args = Get.arguments;

  late TextEditingController mpOtFieldController;
  late TextEditingController dateAnomalyFieldController;
  int userID = 0;
  late TextEditingController userFieldController;
  String anomalyType = "0";
  late TextEditingController nameFieldController;
  late TextEditingController descriptionFieldController;
  bool manByCustomer = false;
  bool isClosed = false;

  @override
  void initState() {
    super.initState();
    mpOtFieldController = TextEditingController(text: args["MPOTName"]);
    dateAnomalyFieldController =
        TextEditingController(text: args["DateAnomaly"]);
    userFieldController = TextEditingController(text: args["userName"]);
    anomalyType = args["anomalyType"].toString();
    nameFieldController = TextEditingController(text: args["name"]);
    descriptionFieldController =
        TextEditingController(text: args["description"]);
    manByCustomer = args["isManagedByCustomer"];
    isClosed = args["isClosed"];
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Anomaly'.tr),
        ),
        actions: [
          Padding(
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
                    deleteAnomaly();
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                editAnomaly();
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
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: mpOtFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Work Order'.tr,
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: dateAnomalyFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Date Anomaly'.tr,
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: userFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      labelText: 'Found By'.tr,
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Divider(),
                Container(
                  //padding: const EdgeInsets.all(10),
                  width: size.width,
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 10),
                  child: FutureBuilder(
                    future: getAllSectors(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<JRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Anomaly Type'.tr,
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
                                  underline: const SizedBox(),
                                  isDense: true,
                                  hint: Text("Select an Anomaly Type".tr),
                                  value:
                                      anomalyType == "0" ? null : anomalyType,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      anomalyType = newValue!;
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
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Managed by the Customer'.tr),
                  value: manByCustomer,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      manByCustomer = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Closed'.tr),
                  value: isClosed,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isClosed = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
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

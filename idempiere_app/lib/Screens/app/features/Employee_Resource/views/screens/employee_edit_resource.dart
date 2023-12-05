import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Vehicle/views/screens/vehicle_equipment_vehicle_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';

class EditEmployeeResource extends StatefulWidget {
  const EditEmployeeResource({Key? key}) : super(key: key);

  @override
  State<EditEmployeeResource> createState() => _EditEmployeeResourceState();
}

class _EditEmployeeResourceState extends State<EditEmployeeResource> {
  editLead() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var msg = {
      "Value": valueFieldController.text,
      "InventoryNo": invNoFieldController.text,
      "LIT_LicensePlate": licencePlateFieldController.text,
      "SerNo": serNoFieldController.text,
      "Target_Frame": targetFrameFieldController.text,
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "year": int.parse(yearFieldController.text),
      "IsInPosession": isOwned,
    };
    if (businessPartnerId != -1) {
      msg.addAll({
        "C_BPartner_ID": {"id": businessPartnerId},
      });
    }
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/A_Asset/${args["id"]}');
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
      Get.find<VehicleEquipmentVehicleController>().getVehicles();
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

  var args = Get.arguments;
  late TextEditingController valueFieldController;
  late TextEditingController invNoFieldController;
  late TextEditingController licencePlateFieldController;
  late TextEditingController serNoFieldController;
  late TextEditingController targetFrameFieldController;
  late TextEditingController nameFieldController;
  late TextEditingController descriptionFieldController;
  late TextEditingController yearFieldController;
  bool isOwned = false;
  late TextEditingController businessPartnerFieldController;
  int businessPartnerId = -1;

  @override
  void initState() {
    super.initState();
    valueFieldController = TextEditingController(text: args['value'] ?? '');
    invNoFieldController = TextEditingController(text: args['invNo'] ?? '');
    licencePlateFieldController =
        TextEditingController(text: args['licencePlate'] ?? '');
    serNoFieldController = TextEditingController(text: args['serNo'] ?? '');
    targetFrameFieldController =
        TextEditingController(text: args['targetFrame'] ?? '');
    nameFieldController = TextEditingController(text: args['name'] ?? '');
    descriptionFieldController =
        TextEditingController(text: args['description'] ?? '');
    yearFieldController = TextEditingController(text: args['year'] ?? '0');
    isOwned = args['isInPosession'] ?? false;
    businessPartnerFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? '');
    businessPartnerId = args['businessPartnerId'] ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Equipment'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                editLead();
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
                    controller: valueFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Number'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: invNoFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Inventory N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: licencePlateFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'License Plate'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: serNoFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'SerNo'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: targetFrameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Target Frame'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: yearFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'SerNo Year'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: Text('Is Owned'.tr),
                  value: isOwned,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isOwned = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
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
                                        businessPartnerId = -1;
                                      });
                                    }
                                  },
                                  controller: businessPartnerFieldController,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.handshake),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Business Partner'.tr,
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
                                  businessPartnerFieldController.text =
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
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
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
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/deliveryviarule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/movementtype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditShipment extends StatefulWidget {
  const EditShipment({Key? key}) : super(key: key);

  @override
  State<EditShipment> createState() => _EditShipmentState();
}

class _EditShipmentState extends State<EditShipment> {
  editShipment() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var msg = {
      "PrivateNote": noteFieldController.text,
      "Description": descriptionFieldController.text,
      "LIT_ExternalAspect": aspectFieldController.text,
      "Weight": double.tryParse(weightFieldController.text) ?? 0.0,
      "LIT_GrossWeight":
          double.tryParse(grossWeightFieldController.text) ?? 0.0,
      "NoPackages": int.tryParse(noPackagesFieldController.text) ?? 0,
      "ShipDate": shipmentDate,
      "MovementDate": movementDate,
    };
    if (movementTypeId != "0") {
      msg.addAll({
        'LIT_M_MovementType_ID': {"id": movementTypeId}
      });
    }
    if (deliveryViaRule != "0") {
      msg.addAll({
        "DeliveryViaRule": {"id": deliveryViaRule}
      });
    }
    if (shipperId != "0") {
      msg.addAll({
        "M_Shipper_ID": {"id": int.parse(shipperId)}
      });
    }
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/m_inout/${args["id"]}');
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
      //print(response.body);
      Get.find<CRMShipmentController>().getShipments();
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

  Future<List<MTRecords>> getAllMovementTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_M_MovementType?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = MovementTypeJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load movement types");
    }

    //print(response.body);
  }

  Future<List<DVRRecords>> getAllDeliveryViaRules() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 152');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = DeliveryViaRuleJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      print(response.body);
      throw Exception("Failed to load deliveryviarules");
    }

    //print(response.body);
  }

  Future<List<MTRecords>> getAllShippers() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Shipper?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = MovementTypeJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load shippers");
    }

    //print(response.body);
  }

  /*  deleteLead() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/m_inout/${args["id"]}');
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
  } */

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var noteFieldController;
  late TextEditingController documentNoFieldController;
  late TextEditingController descriptionFieldController;
  late TextEditingController docTypeFieldController;
  late TextEditingController aspectFieldController;
  late TextEditingController weightFieldController;
  late TextEditingController grossWeightFieldController;
  late TextEditingController noPackagesFieldController;
  String shipmentDate = "";
  String movementDate = "";
  String movementTypeId = "0";
  String deliveryViaRule = "0";
  String shipperId = "0";

  @override
  void initState() {
    super.initState();
    documentNoFieldController =
        TextEditingController(text: args['DocumentNo'] ?? "");
    noteFieldController = TextEditingController();
    descriptionFieldController =
        TextEditingController(text: args['description'] ?? "");
    noteFieldController.text = args["note"] ?? "";
    docTypeFieldController =
        TextEditingController(text: args['docTypeName'] ?? "");
    aspectFieldController = TextEditingController(text: args['externalAspect']);
    weightFieldController =
        TextEditingController(text: (args['weight'] ?? 0.0).toString());
    grossWeightFieldController =
        TextEditingController(text: (args['grossWeight'] ?? 0).toString());
    shipmentDate = args['shipDate'] ?? "";
    movementDate = args['movementDate'] ?? "";
    movementTypeId = (args['movementTypeID'] ?? 0).toString();
    deliveryViaRule = (args['deliveryViaRule'] ?? 0).toString();
    shipperId = (args['shipperId'] ?? 0).toString();
    noPackagesFieldController =
        TextEditingController(text: (args['noPackages'] ?? 0).toString());
    //getAllMovementTypes();
  }

  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Shipment'.tr),
        ),
        actions: [
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Eliminazione record",
                  middleText: "Sicuro di voler eliminare il record?",
                  backgroundColor: const Color.fromRGBO(38, 40, 55, 1),
                  //titleStyle: TextStyle(color: Colors.white),
                  //middleTextStyle: TextStyle(color: Colors.white),
                  textConfirm: "Elimina",
                  textCancel: "Annulla",
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
                editShipment();
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
                    maxLines: 5,
                    controller: documentNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: docTypeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Document Type'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllMovementTypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<MTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Movement Type'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: movementTypeId == "0"
                                      ? null
                                      : movementTypeId,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      movementTypeId = newValue!;
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
                    future: getAllDeliveryViaRules(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<DVRRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Delivery Via Rule'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: deliveryViaRule == "0"
                                      ? null
                                      : deliveryViaRule,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      deliveryViaRule = newValue!;
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
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllShippers(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<MTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Shipper'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: shipperId == "0" ? null : shipperId,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      shipperId = newValue!;
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
                    controller: aspectFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'External Aspect'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: noPackagesFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'NoPackages'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: weightFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Weight'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: grossWeightFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Gross Weight'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Movement Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: args['movementDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                    //dateLabelText: 'Shipment Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      var date = DateTime.parse(val);

                      movementDate = DateFormat('yyyy-MM-dd').format(date);
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Shipment Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.dateTime,
                    initialValue: args['shipDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                    //dateLabelText: 'Shipment Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      var date = DateTime.parse(val);

                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);
                      String formattedTime = DateFormat('kk:mm').format(date);
                      shipmentDate = '${formattedDate}T$formattedTime:00Z';
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
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
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: documentNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: docTypeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Document Type'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllMovementTypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<MTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Movement Type'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: movementTypeId == "0"
                                      ? null
                                      : movementTypeId,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      movementTypeId = newValue!;
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
                    future: getAllDeliveryViaRules(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<DVRRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Delivery Via Rule'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: deliveryViaRule == "0"
                                      ? null
                                      : deliveryViaRule,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      deliveryViaRule = newValue!;
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
                    controller: aspectFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'External Aspect'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: noPackagesFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'NoPackages'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: weightFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Weight'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: grossWeightFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Gross Weight'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Movement Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: args['movementDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                    //dateLabelText: 'Shipment Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      var date = DateTime.parse(val);

                      movementDate = DateFormat('yyyy-MM-dd').format(date);
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Shipment Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.dateTime,
                    initialValue: args['shipDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                    //dateLabelText: 'Shipment Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      var date = DateTime.parse(val);

                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);
                      String formattedTime = DateFormat('kk:mm').format(date);
                      shipmentDate = '${formattedDate}T$formattedTime:00Z';
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
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
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: documentNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: docTypeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.document_scanner),
                      border: const OutlineInputBorder(),
                      labelText: 'Document Type'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllMovementTypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<MTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Movement Type'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: movementTypeId == "0"
                                      ? null
                                      : movementTypeId,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      movementTypeId = newValue!;
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
                    future: getAllDeliveryViaRules(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<DVRRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Delivery Via Rule'.tr,
                                  //filled: true,
                                  border: const OutlineInputBorder(
                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                      ),
                                  prefixIcon: const Icon(EvaIcons.list),
                                  //hintText: "search..",

                                  //fillColor: Theme.of(context).cardColor,
                                ),
                                child: DropdownButton(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  value: deliveryViaRule == "0"
                                      ? null
                                      : deliveryViaRule,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      deliveryViaRule = newValue!;
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
                    controller: aspectFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'External Aspect'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: noPackagesFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'NoPackages'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: weightFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Weight'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: grossWeightFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Gross Weight'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Movement Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: args['movementDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                    //dateLabelText: 'Shipment Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      var date = DateTime.parse(val);

                      movementDate = DateFormat('yyyy-MM-dd').format(date);
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    locale: Locale('language'.tr, 'LANGUAGE'.tr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event),
                      border: const OutlineInputBorder(),
                      labelText: 'Shipment Date'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.dateTime,
                    initialValue: args['shipDate'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200),
                    //dateLabelText: 'Shipment Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      var date = DateTime.parse(val);

                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);
                      String formattedTime = DateFormat('kk:mm').format(date);
                      shipmentDate = '${formattedDate}T$formattedTime:00Z';
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
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

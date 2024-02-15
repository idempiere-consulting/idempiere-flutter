//import 'dart:developer';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/adreflist_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Maintenance_Mptask_taskline/models/workorder_local_json.dart';

class EditMaintenanceMptaskStandard extends StatefulWidget {
  const EditMaintenanceMptaskStandard({Key? key}) : super(key: key);

  @override
  State<EditMaintenanceMptaskStandard> createState() =>
      _EditMaintenanceMptaskStandardState();
}

class _EditMaintenanceMptaskStandardState
    extends State<EditMaintenanceMptaskStandard> {
  deleteWorkOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/mp_ot/${args["id"]}');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<MaintenanceMptaskController>().getWorkOrders();
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
      //print(response.body);
      Get.snackbar(
        "Errore!",
        "Il record non è stato cancellato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  editWorkOrderDate() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "JP_ToDo_ScheduledStartDate": dateFieldController.text,
      "JP_ToDo_ScheduledEndDate": dateFieldController.text,
    });
    final protocol = GetStorage().read('protocol');

    var url =
        Uri.parse('$protocol://$ip/api/v1/models/jp_todo/${args["jpId"]}');

    // ignore: unused_local_variable
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
  }

  editWorkOrder(bool isConnected) async {
    //print(now);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var msg = jsonEncode({
      "Description": noteWOFieldController.text,
      "IsPrinted": sendWorkOrder,
    });

    if (paidAmtFieldController.text != "0") {
      msg = jsonEncode({
        "Description": noteWOFieldController.text,
        "PaymentRule": {"id": dropdownValue},
        "PaidAmt": double.parse(paidAmtFieldController.text),
        "IsPrinted": sendWorkOrder,
      });
    }
    final protocol = GetStorage().read('protocol');

    const filename = "workorder";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    WorkOrderLocalJson trx =
        WorkOrderLocalJson.fromJson(jsonDecode(file.readAsStringSync()));

    if (Get.arguments["id"] != null) {
      trx.records![Get.arguments["index"]].description =
          noteWOFieldController.text;

      trx.records![Get.arguments["index"]].jpToDoStartDate =
          dateFieldController.text;
      trx.records![Get.arguments["index"]].jpToDoEndDate =
          dateFieldController.text;
      trx.records![Get.arguments["index"]].isPrinted = sendWorkOrder;

      if (paidAmtFieldController.text != "0") {
        trx.records![Get.arguments["index"]].paymentRule?.id = dropdownValue;
        trx.records![Get.arguments["index"]].paymentRule?.identifier =
            dropdownValue;
        trx.records![Get.arguments["index"]].paidAmt =
            double.parse(paidAmtFieldController.text);
      }

      var url = Uri.parse('$protocol://$ip/api/v1/models/mp_ot/${args["id"]}');
      if (isConnected) {
        emptyAPICallStak();
        var response = await http.put(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          var data = jsonEncode(trx.toJson());
          file.writeAsStringSync(data);
          Get.find<MaintenanceMptaskController>().getWorkOrders();
          //print("done!");
          //Get.back();
          Get.snackbar(
            "Fatto!",
            "Il record è stato modificato",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        } else {
          if (kDebugMode) {
            print(response.body);
          }
          //print(response.statusCode);
          Get.snackbar(
            "Errore!",
            "Il record non è stato modificato",
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      } else {
        var data = jsonEncode(trx.toJson());
        file.writeAsStringSync(data);
        Get.find<MaintenanceMptaskController>().getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['$protocol://$ip/api/v1/models/mp_ot/${args["id"]}'] = msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['$protocol://$ip/api/v1/models/mp_ot/${args["id"]}'] = msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.red,
          ),
        );
      }
    }
  }

  Future<List<Records>> getAllPaymentRule() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_ref_list?\$filter= AD_Reference_ID eq 195');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          ADRefListJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      return json.records!;
    } else {
      //print(response.body);
      throw Exception("Failed to load sales reps");
    }
  }

  var docNoFieldController;
  var bPartnerFieldController;
  var dateFieldController;
  var timeFieldController;
  var notePlantFieldController;
  var noteWOFieldController;
  var addressFieldController;
  var representativeFieldController;
  var teamFieldController;
  var paidAmtFieldController;
  var dropdownValue = "T";
  bool sendWorkOrder = false;

  dynamic args = Get.arguments;

  @override
  void initState() {
    super.initState();
    dropdownValue = Get.arguments["paymentRuleId"] ?? "T";
    docNoFieldController = TextEditingController(text: args["docNo"] ?? "");
    bPartnerFieldController =
        TextEditingController(text: args["businessPartner"] ?? "");
    dateFieldController = TextEditingController(text: args["date"] ?? "");
    timeFieldController = TextEditingController(
        text: "${args["timeStart"]} - ${args["timeEnd"]}");
    notePlantFieldController = TextEditingController(text: args["notePlant"]);
    noteWOFieldController = TextEditingController(text: args["noteWO"]);
    addressFieldController = TextEditingController(text: args["address"]);
    representativeFieldController =
        TextEditingController(text: args["representative"]);
    teamFieldController = TextEditingController(text: args["team"]);
    paidAmtFieldController =
        TextEditingController(text: args["paidAmt"].toString());
    sendWorkOrder = Get.arguments['isPrinted'] ?? false;
    //getDocType();
    //getResourceName();
    //getAllResources();
    getAllPaymentRule();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit WorkOrder'),
        ),
        actions: [
          Padding(
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
                    deleteWorkOrder();
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
              onPressed: () async {
                editWorkOrder(await checkConnection());

                if (await checkConnection()) {
                  editWorkOrderDate();
                }
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
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.content_paste),
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
                    controller: bPartnerFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.handshake),
                      border: const OutlineInputBorder(),
                      labelText: 'Business Partner'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  //width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: dateFieldController.text,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        dateFieldController.text = val.substring(0, 10);
                      });
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
                  child: TextField(
                    readOnly: true,
                    controller: timeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.timelapse),
                      border: const OutlineInputBorder(),
                      labelText: 'Time'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 3,
                    controller: notePlantFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note Plant'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    minLines: 1,
                    maxLines: 3,
                    controller: noteWOFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note Work Order'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    minLines: 1,
                    maxLines: 1,
                    controller: paidAmtFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Paid Amt'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Rule".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllPaymentRule(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.pin_drop),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: representativeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      labelText: 'Representative'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 3,
                    maxLines: 3,
                    controller: teamFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.build),
                      border: const OutlineInputBorder(),
                      labelText: 'Team'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Send Work Order'.tr),
                  value: sendWorkOrder,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      sendWorkOrder = value!;
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
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.content_paste),
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
                    controller: bPartnerFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.handshake),
                      border: const OutlineInputBorder(),
                      labelText: 'Business Partner'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  //width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: dateFieldController.text,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        dateFieldController.text = val.substring(0, 10);
                      });
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
                  child: TextField(
                    readOnly: true,
                    controller: timeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.timelapse),
                      border: const OutlineInputBorder(),
                      labelText: 'Time'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 3,
                    controller: notePlantFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note Plant'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    minLines: 1,
                    maxLines: 3,
                    controller: noteWOFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note Work Order'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    minLines: 1,
                    maxLines: 1,
                    controller: paidAmtFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Paid Amt'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Rule".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllPaymentRule(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.pin_drop),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: representativeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      labelText: 'Representative'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 3,
                    maxLines: 3,
                    controller: teamFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.build),
                      border: const OutlineInputBorder(),
                      labelText: 'Team'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Send Work Order'.tr),
                  value: sendWorkOrder,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      sendWorkOrder = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
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
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.content_paste),
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
                    controller: bPartnerFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.handshake),
                      border: const OutlineInputBorder(),
                      labelText: 'Business Partner'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  //width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: dateFieldController.text,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        dateFieldController.text = val.substring(0, 10);
                      });
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
                  child: TextField(
                    readOnly: true,
                    controller: timeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.timelapse),
                      border: const OutlineInputBorder(),
                      labelText: 'Time'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 3,
                    controller: notePlantFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note Plant'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    minLines: 1,
                    maxLines: 3,
                    controller: noteWOFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note Work Order'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    minLines: 1,
                    maxLines: 1,
                    controller: paidAmtFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Paid Amt'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Rule".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllPaymentRule(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.pin_drop),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: representativeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      labelText: 'Representative'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 3,
                    maxLines: 3,
                    controller: teamFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.build),
                      border: const OutlineInputBorder(),
                      labelText: 'Team'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Send Work Order'.tr),
                  value: sendWorkOrder,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      sendWorkOrder = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

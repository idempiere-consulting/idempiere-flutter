import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_tasks_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DashboardTasksEdit extends StatefulWidget {
  const DashboardTasksEdit({Key? key}) : super(key: key);

  @override
  State<DashboardTasksEdit> createState() => _DashboardTasksEditState();
}

class _DashboardTasksEditState extends State<DashboardTasksEdit> {
  Future<bool> editTask(String statusId) async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    var fakeDate1 = DateTime.parse('${args["startDate"]} $startTime');
    var fakeDate2 = DateTime.parse('$formattedDate $endTime');

    //var tot = fakeDate2.difference(fakeDate1).inHours;
    var totm = fakeDate2.difference(fakeDate1).inMinutes;

    double hours = totm / 60;
    //print(tot);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "JP_ToDo_Status": {"id": statusId},
      "Qty": hours,
      "JP_ToDo_ScheduledStartDate": '${args["startDate"]}T$startTime:00Z',
      "JP_ToDo_ScheduledEndDate": '${args["startDate"]}T$endTime:00Z',
      "JP_ToDo_ScheduledStartTime": startTime,
      "JP_ToDo_ScheduledEndTime": endTime,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo/${args['id']}');
    //print(msg);
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<DashboardTasksController>().getLeads();
      Get.find<DashboardController>().getAllEvents();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
      return true;
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
      return false;
    }
  }

  deleteLead() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user/${args["id"]}');
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

  Future<List<LSRecords>> getAllLeadStatuses() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 53416 ');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = LeadStatusJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead statuses");
    }

    //print(response.body);
  }

  Future<List<CRecords>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<PJRecords>> getAllProjects() async {
    final ip = GetStorage().read('ip');
    String authorization =
        'Bearer ${GetStorage().read('token')}'; //GetStorage().read("clientid")
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_project?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //var jsondecoded = jsonDecode(response.body);

      var jsonProjects =
          ProjectJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      return jsonProjects.records!;
    } else {
      throw Exception("Failed to load projects");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  void fillFields() {
    nameFieldController.text = args["name"] ?? "";
    userFieldController.text = args["user"] ?? "";

    switch (args["statusId"]) {
      case "NY":
        statusFieldController.text = "WP".tr;
        break;
      case "WP":
        statusFieldController.text = "CO".tr;
        break;
      default:
    }
    descriptionFieldController.text = args["description"] ?? "";
    double qty = (args["qty"]).toDouble() ?? 0.0;

    int minutes = (qty * 60.0).toInt();

    //print(qty);

    if (args["statusId"] == "NY") {
      DateTime now = DateTime.now();
      var n = now.minute; // Number to match
      var l = [0, 15, 30, 45]; // List of values

      var number = l.where((e) => e <= n).toList()..sort();

      //print(number[number.length - 1]);

      var addminutesDate = now.add(Duration(minutes: minutes));
      var n2 = addminutesDate.minute;

      var number2 = l.where((e) => e <= n2).toList()..sort();

      var hourTime = "00";

      var minuteTime = "00";

      var endminuteTime = "00";

      var endhourTime = "00";

      if (now.hour < 10) {
        hourTime = "0${now.hour}";
      } else {
        hourTime = "${now.hour}";
      }

      if (addminutesDate.hour < 10) {
        endhourTime = "0${addminutesDate.hour}";
      } else {
        endhourTime = "${addminutesDate.hour}";
      }

      if (number[number.length - 1] != 0) {
        minuteTime = number[number.length - 1].toString();
      }

      if (number2[number2.length - 1] != 0) {
        endminuteTime = number2[number2.length - 1].toString();
      }

      startTime = '$hourTime:$minuteTime:00Z';

      endTime = '$endhourTime:$endminuteTime:00Z';
    } else {
      startTime = args["startTime"];
    }

    if (args["statusId"] == "WP") {
      DateTime now = DateTime.now();
      var n = now.minute; // Number to match
      var l = [0, 15, 30, 45]; // List of values

      var number = l.where((e) => e <= n).toList()..sort();

      //print(number[number.length - 1]);

      var hourTime = "00";

      var minuteTime = "00";

      if (now.hour < 10) {
        hourTime = "0${now.hour}";
      } else {
        hourTime = "${now.hour}";
      }

      if (number[number.length - 1] != 0) {
        minuteTime = number[number.length - 1].toString();
      }
      if (number[number.length - 1] != 0) {
        minuteTime = number[number.length - 1].toString();
      }

      endTime = '$hourTime:$minuteTime:00Z';
    }
    //print(startTime);
    //print(endTime);
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var statusFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var userFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  String dropdownValue = "";
  String salesrepValue = "";
  String startTime = "";
  String endTime = "";

  @override
  void initState() {
    startTime = "";
    endTime = "";
    nameFieldController = TextEditingController();
    userFieldController = TextEditingController();
    statusFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    //dropdownValue = Get.arguments["leadStatus"];
    fillFields();
    super.initState();

    getAllLeadStatuses();
  }

  //static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Task'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Record deletion".tr,
                  middleText: "Are you sure to delete the record?".tr,
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
                    controller: userFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Assigned To'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.task_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'Task'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: statusFieldController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.settings_applications_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Status'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    readOnly: true,
                    locale: Locale('languageCalendar'.tr),
                    decoration: InputDecoration(
                      labelText: 'Date'.tr,
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
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    //dateLabelText: 'Ship Date'.tr,
                    //icon: const Icon(Icons.event),
                    onChanged: (val) {},
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    decoration: InputDecoration(
                      labelText: 'Start Time'.tr,
                      //filled: true,
                      border: const OutlineInputBorder(
                          /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                          ),
                      prefixIcon: const Icon(Icons.access_time),
                      //hintText: "search..",
                      isDense: true,
                      //fillColor: Theme.of(context).cardColor,
                    ),
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      /* setState(() {
                        //timeStart = val;
                      }); */
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    decoration: InputDecoration(
                      labelText: 'End Time'.tr,
                      //filled: true,
                      border: const OutlineInputBorder(
                          /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                          ),
                      prefixIcon: const Icon(Icons.access_time),
                      //hintText: "search..",
                      isDense: true,
                      //fillColor: Theme.of(context).cardColor,
                    ),
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: endTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      /* setState(() {
                        //timeStart = val;
                      }); */
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 5,
                  /* buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                  children: [
                    Visibility(
                      visible: args["statusId"] == "NY",
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: const Text("Start Task"),
                        onPressed: () async {
                          editTask("WP");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP",
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: Text("Complete".tr),
                        onPressed: () {
                          editTask("CO");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP" && 1 == 2,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("Exit without closing the task"),
                        onPressed: () {
                          editTask("NY");
                        },
                      ),
                    ),
                  ],
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
                    controller: userFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Assigned To'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.task_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'Task'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: statusFieldController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.settings_applications_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Status'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    maxLines: 4,
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      //prefixIcon: Icon(Icons.list),
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      /* setState(() {
                        //timeStart = val;
                      }); */
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: endTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      /* setState(() {
                        //timeStart = val;
                      }); */
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 5,
                  /* buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                  children: [
                    Visibility(
                      visible: args["statusId"] == "NY",
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: const Text("Start Task"),
                        onPressed: () async {
                          editTask("WP");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP",
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: Text("Complete".tr),
                        onPressed: () {
                          editTask("CO");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP" && 1 == 2,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("Exit without closing the task"),
                        onPressed: () {
                          editTask("NY");
                        },
                      ),
                    ),
                  ],
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
                    controller: userFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Assigned To'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.task_alt),
                      border: const OutlineInputBorder(),
                      labelText: 'Task'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: statusFieldController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.settings_applications_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Status'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    maxLines: 4,
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      //prefixIcon: Icon(Icons.list),
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      /* setState(() {
                        //timeStart = val;
                      }); */
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    //locale: Locale('languageCalendar'.tr),
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: endTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      /* setState(() {
                        //timeStart = val;
                      }); */
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 5,
                  /* buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                  children: [
                    Visibility(
                      visible: args["statusId"] == "NY",
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: const Text("Start Task"),
                        onPressed: () async {
                          editTask("WP");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP",
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: Text("Complete".tr),
                        onPressed: () {
                          editTask("CO");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP" && 1 == 2,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: const Text("Exit without closing the task"),
                        onPressed: () {
                          editTask("NY");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

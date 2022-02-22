import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
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
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "JP_ToDo_Status": {"id": statusId},
      "Qty": hours,
      "JP_ToDo_ScheduledStartTime": startTime,
      "JP_ToDo_ScheduledEndTime": endTime,
    });
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/jp_todo/${args['id']}');
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
        "Fatto!",
        "Il record è stato aggiornato",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
      return true;
    } else {
      Get.snackbar(
        "Errore!",
        "Record non aggiornato",
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
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/ad_user/${args["id"]}');
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
        "Fatto!",
        "Il record è stato cancellato",
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Errore!",
        "Record non aggiornato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  Future<List<LSRecords>> getAllLeadStatuses() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 53416 ');
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

  Future<List<Records>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/ad_user');
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
          child: Text('Edit Task'),
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Assigned To',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.task_alt),
                      border: OutlineInputBorder(),
                      labelText: 'Task',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: statusFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.settings_applications_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Status',
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
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time',
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
                    readOnly: true,
                    type: DateTimePickerType.time,
                    initialValue: endTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time',
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
                        child: const Text("Enter"),
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
                        child: const Text("Exit"),
                        onPressed: () {
                          editTask("CO");
                        },
                      ),
                    ),
                    Visibility(
                      visible: args["statusId"] == "WP",
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
            return const Text("desktop visual WIP");
          },
          desktopBuilder: (context, constraints) {
            return const Text("tablet visual WIP");
          },
        ),
      ),
    );
  }
}

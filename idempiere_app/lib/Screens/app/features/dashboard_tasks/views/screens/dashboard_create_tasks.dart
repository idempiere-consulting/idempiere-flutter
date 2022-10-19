import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_tasks_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';

class CreateDashboardTasks extends StatefulWidget {
  const CreateDashboardTasks({Key? key}) : super(key: key);

  @override
  State<CreateDashboardTasks> createState() => _CreateDashboardTasksState();
}

class _CreateDashboardTasksState extends State<CreateDashboardTasks> {
  createEvent() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"id": GetStorage().read('userId')},
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "Qty": 1.0,
      "C_BPartner_ID": {"id": businessPartnerId},
      "JP_ToDo_ScheduledStartDate": "${date}T$startTime",
      "JP_ToDo_ScheduledEndDate": "${date}T$startTime",
      "JP_ToDo_ScheduledStartTime": startTime,
      "JP_ToDo_ScheduledEndTime": startTime,
      "JP_ToDo_Status": {"id": dropdownValue},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "S"},
      "C_Project_ID": {"id": projectId}
    });

    if (projectId == 0) {
      msg = jsonEncode({
        "AD_Org_ID": {"id": GetStorage().read("organizationid")},
        "AD_Client_ID": {"id": GetStorage().read("clientid")},
        "AD_User_ID": {"id": GetStorage().read('userId')},
        "Name": nameFieldController.text,
        "Description": descriptionFieldController.text,
        "Qty": 1.0,
        //"C_BPartner_ID": {"id": businessPartnerId},
        "JP_ToDo_ScheduledStartDate": "${date}T$startTime",
        "JP_ToDo_ScheduledEndDate": "${date}T$startTime",
        "JP_ToDo_ScheduledStartTime": startTime,
        "JP_ToDo_ScheduledEndTime": startTime,
        "JP_ToDo_Status": {"id": dropdownValue},
        "IsOpenToDoJP": true,
        "JP_ToDo_Type": {"id": "S"},
        //"C_Project_ID": {"id": projectId}
      });
    }
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/jp_todo/');

    //print(msg);
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      try {
        Get.find<DashboardTasksController>().getLeads();
      } catch (e) {
        if (kDebugMode) {
          print('page not found');
        }
      }

      try {
        Get.find<DashboardController>().getAllEvents();
      } catch (e) {
        if (kDebugMode) {
          print('page not found');
        }
      }

      Get.back();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        isDismissible: true,
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
        "Record not created".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  final json = {
    "types": [
      {"id": "CO", "name": "Completed".tr},
      {"id": "NY", "name": "Not Yet Started".tr},
      {"id": "WP", "name": "Work In Progress".tr},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  Future<void> getProject() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/ad_user?\$filter= AD_User_ID eq ${GetStorage().read('userId')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      /* projectFieldController.text =
          json["records"][0]['C_Project_ID']['identifier'] ?? ""; */
      try {
        initialValue = TextEditingValue(
            text: json["records"][0]['C_Project_ID']['identifier'] ?? "");
      } catch (e) {
        initialValue = null;
      }

      try {
        nameFieldController.text =
            json["records"][0]['C_Project_ID']['identifier'] ?? "";
      } catch (e) {
        nameFieldController.text = "";
      }
      try {
        projectId = json["records"][0]['C_Project_ID']['id'] ?? 0;
      } catch (e) {
        projectId = 0;
      }
      getProjectBP();
      getAllProjects();
    }
  }

  Future<void> getProjectBP() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_project?\$filter= C_Project_ID eq $projectId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      try {
        businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"] ?? 0;
      } catch (e) {
        businessPartnerId = 0;
      }
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
    setState(() {
      flagProject = true;
    });
  }

  Future<List<Records>> getAllProjects() async {
    final ip = GetStorage().read('ip');
    String authorization =
        'Bearer ' + GetStorage().read('token'); //GetStorage().read("clientid")
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_project?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');
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

  fillFields() {
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

    var formatter = DateFormat('yyyy-MM-dd');
    date = formatter.format(now);
    startTime = '$hourTime:$minuteTime:00Z';
  }

  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var projectFieldController;
  String date = "";
  String timeStart = "";
  String timeEnd = "";
  String dropdownValue = "";
  String startTime = "";
  int projectId = 0;
  int businessPartnerId = 0;
  late List<Types> dropDownList;
  bool flagProject = false;
  late dynamic initialValue;
  //var adUserId;

  @override
  void initState() {
    flagProject = false;
    date = "";
    startTime = "";
    fillFields();
    super.initState();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    projectFieldController = TextEditingController();

    dropDownList = getTypes()!;
    dropdownValue = "WP";

    timeStart = "";
    timeEnd = "";
    getProject();
  }

  static String _displayStringForOption(Records option) => option.name!;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Create Task'.tr),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createEvent();
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
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
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
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: projectFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Progetto',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "Project".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProjects(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData && flagProject
                            ? Autocomplete<Records>(
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  projectId = selection.id!;
                                  nameFieldController.text =
                                      "${selection.value}_${selection.name}";
                                  setState(() {});
                                  getProjectBP();
                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                    type: DateTimePickerType.date,
                    initialValue: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date = val.substring(0, 10);
                      });
                      //print(date);
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
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      setState(() {
                        timeStart = val;
                      });
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
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      setState(() {
                        timeEnd = val;
                      });
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
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      //print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
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
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
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
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: projectFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Progetto',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "Project".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProjects(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData && flagProject
                            ? Autocomplete<Records>(
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  projectId = selection.id!;
                                  nameFieldController.text =
                                      "${selection.value}_${selection.name}";
                                  setState(() {});
                                  getProjectBP();
                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                    type: DateTimePickerType.date,
                    initialValue: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date = val.substring(0, 10);
                      });
                      //print(date);
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
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      setState(() {
                        timeStart = val;
                      });
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
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      setState(() {
                        timeEnd = val;
                      });
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
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      //print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
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
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
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
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: projectFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Progetto',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "Project".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProjects(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData && flagProject
                            ? Autocomplete<Records>(
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  projectId = selection.id!;
                                  nameFieldController.text =
                                      "${selection.value}_${selection.name}";
                                  setState(() {});
                                  getProjectBP();
                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                    type: DateTimePickerType.date,
                    initialValue: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date = val.substring(0, 10);
                      });
                      //print(date);
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
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Start Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      setState(() {
                        timeStart = val;
                      });
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
                    initialValue: startTime.substring(0, 5),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'End Time'.tr,
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) {
                      setState(() {
                        timeEnd = val;
                      });
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
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      //print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
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

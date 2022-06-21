import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

class CreateCalendarEvent extends StatefulWidget {
  const CreateCalendarEvent({Key? key}) : super(key: key);

  @override
  State<CreateCalendarEvent> createState() => _CreateCalendarEventState();
}

class _CreateCalendarEventState extends State<CreateCalendarEvent> {
  createEvent() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"identifier": GetStorage().read('user')},
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "JP_ToDo_ScheduledStartDate": date,
      "JP_ToDo_ScheduledEndDate": date,
      "JP_ToDo_ScheduledStartTime": '$timeStart:00Z',
      "JP_ToDo_ScheduledEndTime": '$timeEnd:00Z',
      "JP_ToDo_Status": {"id": dropdownValue},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "S"},
    });
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
      //print(response.statusCode);
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
      {"id": "CO", "name": "Completed"},
      {"id": "NY", "name": "Not Yet Started"},
      {"id": "WP", "name": "Work In Progress"},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  String date = "";
  String timeStart = "";
  String timeEnd = "";
  String dropdownValue = "";
  late List<Types> dropDownList;
  //var adUserId;

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    dropDownList = getTypes()!;
    dropdownValue = "NY";
    date = "";
    timeStart = "";
    timeEnd = "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Crea To Do'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.offNamed('/Calendar');
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Descrizione',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
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
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Inizio',
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
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Fine',
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Descrizione',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
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
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Inizio',
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
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Fine',
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Descrizione',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
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
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Inizio',
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
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Fine',
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

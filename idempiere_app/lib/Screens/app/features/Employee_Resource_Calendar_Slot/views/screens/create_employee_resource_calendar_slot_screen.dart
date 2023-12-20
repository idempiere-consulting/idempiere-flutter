import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Resource_Calendar_Slot/views/screens/employee_resource_calendar_slot_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class EmployeeResourceCreateCalendarSlot extends StatefulWidget {
  const EmployeeResourceCreateCalendarSlot({Key? key}) : super(key: key);

  @override
  State<EmployeeResourceCreateCalendarSlot> createState() =>
      _EmployeeResourceCreateCalendarSlotState();
}

class _EmployeeResourceCreateCalendarSlotState
    extends State<EmployeeResourceCreateCalendarSlot> {
  createEvent(String startTime, String endTime) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    DateTime date = DateTime.parse(Get.arguments['date'].toString());
    var formatter = DateFormat('yyyy-MM-dd');

    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"id": adUserId},
      "Name": 'Prenotazione',
      "Description": descriptionFieldController.text,
      "Qty": 1.0,
      //"C_BPartner_ID": {"id": businessPartnerId},
      "JP_ToDo_ScheduledStartDate":
          "${formatter.format(date)}T$startTime:00:00Z",
      "JP_ToDo_ScheduledEndDate": "${formatter.format(date)}T$endTime:00:00Z",
      "JP_ToDo_ScheduledStartTime": "$startTime:00:00Z",
      "JP_ToDo_ScheduledEndTime": "$endTime:00:00Z",
      "JP_ToDo_Status": {"id": dropdownValue},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "S"},
      //"C_Project_ID": {"id": projectId}
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo/');

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
      if (kDebugMode) {
        print(response.body);
      }
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

  getTodaySchedules() async {
    var now = DateTime.parse(Get.arguments['date'].toString());
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));
    var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    String formattedNow = formatter.format(now);
    String formattedTomorrow = formatter.format(tomorrow);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_jp_todo_v?\$filter=  JP_ToDo_Type eq \'S\' and AD_User_ID eq $adUserId and JP_ToDo_ScheduledStartDate ge \'$formattedNow\' and JP_ToDo_ScheduledStartDate lt \'$formattedTomorrow\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < json.records!.length; i++) {
        var dateStart = DateTime.parse(
            "${json.records![i].jPToDoScheduledStartDate} ${json.records![i].jPToDoScheduledStartTime}");
        var dateEnd = DateTime.parse(
            "${json.records![i].jPToDoScheduledEndDate} ${json.records![i].jPToDoScheduledEndTime}");

        var startTimeFound = false;
        var endTimeFound = false;
        for (var j = 0; j < availableHours.length; j++) {
          if (dateStart.hour == availableHours[j] && startTimeFound == false) {
            unavailableSlots[j] = true;
            startTimeFound = true;
          } else {
            if (dateEnd.hour != availableHours[j] &&
                endTimeFound == false &&
                startTimeFound) {
              unavailableSlots[j] = true;
            }

            if (dateEnd.hour == availableHours[j]) {
              break;
            }
          }
        }
      }
      setState(() {});

      //print(json.records);
    }
  }

  final json = {
    "types": [
      {"id": "CO", "name": "CO".tr},
      {"id": "NY", "name": "NY".tr},
      {"id": "WP", "name": "WP".tr},
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
  int adUserId = 0;
  String date = "";
  String dateEnd = "";
  String timeStart = "";
  String timeEnd = "";
  String dropdownValue = "";
  late List<Types> dropDownList;
  //var adUserId;
  bool flagProject = false;
  late dynamic initialValue;
  int projectId = 0;
  int businessPartnerId = 0;
  final List<dynamic> list = GetStorage().read('permission');

  static String _displayStringForOption(PJRecords option) => option.name!;

  late List<bool> availableSlots;

  late List<int> availableHours;

  late List<bool> unavailableSlots;

  bool allDayState = false;
  bool morningState = false;
  bool eveningState = false;

  @override
  void initState() {
    availableSlots = List.generate(11, (i) => false);
    availableHours = List.generate(11, (i) => i + 8);
    unavailableSlots = List.generate(11, (i) => false);
    //print(availableHours);
    adUserId = Get.arguments["resourceId"];
    flagProject = false;
    super.initState();
    getTodaySchedules();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    dropDownList = getTypes()!;
    dropdownValue = "NY";
    date = "";
    dateEnd = "";
    timeStart = "";
    timeEnd = "";
    allDayState = false;
    morningState = false;
    eveningState = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Create Slot'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                for (var i = 0; i < availableSlots.length; i++) {
                  if (unavailableSlots[i] == true) {
                    availableSlots[i] = false;
                  }
                }
                var taskFound = false;
                var startTime = "00";
                var endTime = "00";
                for (var i = 0; i < availableSlots.length; i++) {
                  if (availableSlots[i] && taskFound == false) {
                    print('Inizio Task');
                    taskFound = true;

                    if (availableHours[i] > 9) {
                      startTime = "${availableHours[i]}";
                    } else {
                      startTime = "0${availableHours[i]}";
                    }
                    print(startTime);
                  }
                  if ((availableSlots[i] == false && taskFound) ||
                      i == availableSlots.length - 1 && taskFound) {
                    taskFound = false;

                    if (availableHours[i] > 9) {
                      endTime = "${availableHours[i]}";
                    } else {
                      endTime = "0${availableHours[i]}";
                    }
                    print(endTime);
                    print('Fine Task');
                    createEvent(startTime, endTime);
                  }
                }
                Get.find<EmployeeResourceCalendarSlotController>()
                    .getAllEvents();
                Get.back();
                Get.back();
                Get.snackbar(
                  "Done!".tr,
                  "The record has been created".tr,
                  isDismissible: true,
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                );
                //createEvent();
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
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
              Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 5, left: 10, top: 10, bottom: 10),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        readOnly: true,
                        initialValue: Get.arguments['date'].toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Start Date'.tr,
                        //icon: const Icon(Icons.event),
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          labelText: 'Start Date'.tr,
                          prefixIcon: const Icon(Icons.event),
                          //hintText: "search..",
                          isDense: true,
                          fillColor: Theme.of(context).cardColor,
                        ),
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
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 10, left: 5, top: 10, bottom: 10),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: Get.arguments['date'].toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'End Date'.tr,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          labelText: 'End Date'.tr,
                          prefixIcon: const Icon(Icons.event),
                          //hintText: "search..",
                          isDense: true,
                          fillColor: Theme.of(context).cardColor,
                        ),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);
                          setState(() {
                            dateEnd = val.substring(0, 10);
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
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: InputDecorator(
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Symbols.list),
                    border: const OutlineInputBorder(),
                    labelText: 'Status'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  child: DropdownButton(
                    isDense: true,
                    underline: const SizedBox(),
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
                        value: list.id,
                        child: Text(
                          list.name.toString(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Flexible(
                    child: CheckboxListTile(
                      title: Text('All day'.tr),
                      value: allDayState,
                      activeColor: kPrimaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          morningState = false;
                          eveningState = false;
                          allDayState = value!;
                          if (value) {
                            for (var i = 0; i < availableSlots.length; i++) {
                              availableSlots[i] = true;
                            }
                          } else {
                            for (var i = 0; i < availableSlots.length; i++) {
                              availableSlots[i] = false;
                            }
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: CheckboxListTile(
                      title: Text('Morning'.tr),
                      value: morningState,
                      activeColor: kPrimaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          eveningState = false;
                          allDayState = false;
                          morningState = value!;
                          if (value) {
                            for (var i = 0; i < availableSlots.length; i++) {
                              availableSlots[i] = false;
                            }
                            availableSlots[0] = true;
                            availableSlots[1] = true;
                            availableSlots[2] = true;
                            availableSlots[3] = true;
                            availableSlots[4] = true;
                          } else {
                            for (var i = 0; i < availableSlots.length; i++) {
                              availableSlots[i] = false;
                            }
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Flexible(
                    child: CheckboxListTile(
                      title: Text('Evening'.tr),
                      value: eveningState,
                      activeColor: kPrimaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          morningState = false;
                          allDayState = false;
                          eveningState = value!;

                          if (value) {
                            for (var i = 0; i < availableSlots.length; i++) {
                              availableSlots[i] = false;
                            }
                            availableSlots[5] = true;
                            availableSlots[6] = true;
                            availableSlots[7] = true;
                            availableSlots[8] = true;
                            availableSlots[9] = true;
                            availableSlots[10] = true;
                          } else {
                            for (var i = 0; i < availableSlots.length; i++) {
                              availableSlots[i] = false;
                            }
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[0] = !availableSlots[0];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[0]
                                ? Colors.orangeAccent
                                : availableSlots[0]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "08:00 ${unavailableSlots[0] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[1] = !availableSlots[1];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[1]
                                ? Colors.orangeAccent
                                : availableSlots[1]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "09:00 ${unavailableSlots[1] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[2] = !availableSlots[2];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[2]
                                ? Colors.orangeAccent
                                : availableSlots[2]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "10:00 ${unavailableSlots[2] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[3] = !availableSlots[3];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[3]
                                ? Colors.orangeAccent
                                : availableSlots[3]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "11:00 ${unavailableSlots[3] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[4] = !availableSlots[4];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[4]
                                ? Colors.orangeAccent
                                : availableSlots[4]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "12:00 ${unavailableSlots[4] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[5] = !availableSlots[5];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[5]
                                ? Colors.orangeAccent
                                : availableSlots[5]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "13:00 ${unavailableSlots[5] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[6] = !availableSlots[6];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[6]
                                ? Colors.orangeAccent
                                : availableSlots[6]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "14:00 ${unavailableSlots[6] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[7] = !availableSlots[7];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[7]
                                ? Colors.orangeAccent
                                : availableSlots[7]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "15:00 ${unavailableSlots[7] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[8] = !availableSlots[8];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[8]
                                ? Colors.orangeAccent
                                : availableSlots[8]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "16:00 ${unavailableSlots[8] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[9] = !availableSlots[9];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[9]
                                ? Colors.orangeAccent
                                : availableSlots[9]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "17:00 ${unavailableSlots[9] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              availableSlots[10] = !availableSlots[10];
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 10,
                            color: unavailableSlots[10]
                                ? Colors.orangeAccent
                                : availableSlots[10]
                                    ? kNotifColor
                                    : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(Icons.access_time, size: 40),
                                  title: Text(
                                      "18:00 ${unavailableSlots[10] ? 'Unavailable'.tr : 'Available'.tr}"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}

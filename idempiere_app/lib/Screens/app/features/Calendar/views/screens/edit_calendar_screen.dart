import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/calendar_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

class EditCalendarEvent extends StatefulWidget {
  const EditCalendarEvent({Key? key}) : super(key: key);

  @override
  State<EditCalendarEvent> createState() => _EditCalendarEventState();
}

class _EditCalendarEventState extends State<EditCalendarEvent> {
  deleteEvent() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo/${args['id']}');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print("done!");
      Get.off(const CalendarScreen());
      Get.snackbar(
        "Done!".tr,
        "The record was deleted".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Record not deleted (is it yours?)".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  editEvent() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "JP_ToDo_ScheduledStartDate": '${date}T$timeStart:00Z',
      "JP_ToDo_ScheduledEndDate": '${date}T$timeEnd:00Z',
      "JP_ToDo_ScheduledStartTime": '$timeStart:00Z',
      "JP_ToDo_ScheduledEndTime": '$timeEnd:00Z',
      "JP_ToDo_Status": {"id": dropdownValue},
      "JP_ToDo_Type": {"id": "S"},
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
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Unmodified record (is it yours?)".tr,
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
      {"id": "CO", "name": "CO".tr},
      {"id": "NY", "name": "NY".tr},
      {"id": "WP", "name": "WP".tr},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  fillFields() {
    nameFieldController.text = args['name'] ?? "";
    descriptionFieldController.text = args['description'] ?? "";
    date = args['startDate'] ?? "";
    timeStart = args['startTime'] ?? "";
    timeEnd = args['endTime'] ?? "";
    dropdownValue = args['statusId'] ?? "NY";
  }

  dynamic args = Get.arguments;
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
    date = "";
    super.initState();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    dropDownList = getTypes()!;
    dropdownValue = "NY";
    timeStart = "";
    timeEnd = "";
    fillFields();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Edit To Do'.tr),
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
                  Get.defaultDialog(
                    title: "Record deletion".tr,
                    middleText:
                        "Are you sure you want to delete the record?".tr,
                    backgroundColor: const Color.fromRGBO(38, 40, 55, 1),
                    //titleStyle: TextStyle(color: Colors.white),
                    //middleTextStyle: TextStyle(color: Colors.white),
                    textConfirm: "Erase".tr,
                    textCancel: "Cancel".tr,
                    cancelTextColor: Colors.white,
                    confirmTextColor: Colors.white,
                    buttonColor: const Color.fromRGBO(31, 29, 44, 1),
                    barrierDismissible: false,
                    onConfirm: () {
                      deleteEvent();
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
                  editEvent();
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
                      //onSaved: (val) => print(val),
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
                      type: DateTimePickerType.time,
                      initialValue: timeStart,
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
                      //locale: Locale('languageCalendar'.tr),
                      type: DateTimePickerType.time,
                      initialValue: timeEnd,
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
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
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
                      //onSaved: (val) => print(val),
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
                      type: DateTimePickerType.time,
                      initialValue: timeStart,
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
                      //locale: Locale('languageCalendar'.tr),
                      type: DateTimePickerType.time,
                      initialValue: timeEnd,
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
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
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
                      //onSaved: (val) => print(val),
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
                      type: DateTimePickerType.time,
                      initialValue: timeStart,
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
                      //locale: Locale('languageCalendar'.tr),
                      type: DateTimePickerType.time,
                      initialValue: timeEnd,
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
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

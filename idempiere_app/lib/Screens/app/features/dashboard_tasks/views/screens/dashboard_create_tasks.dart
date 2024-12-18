import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_tasks_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class CreateDashboardTasks extends StatefulWidget {
  const CreateDashboardTasks({Key? key}) : super(key: key);

  @override
  State<CreateDashboardTasks> createState() => _CreateDashboardTasksState();
}

class _CreateDashboardTasksState extends State<CreateDashboardTasks> {
  createEvent() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    var inputFormat = DateFormat('dd/MM/yyyy');

    DateTime endTaskDate =
        (DateTime.parse("${date}T${timeFieldController.text}Z")).add(Duration(
            minutes: (60 * double.parse(qtyFieldController.text)).toInt()));

    String endTaskDateNoTime = DateFormat('yyyy-MM-dd').format(endTaskDate);

    String endTaskTime = DateFormat('HH:mm:ss').format(endTaskDate);

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"id": GetStorage().read('userId')},
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "Qty": double.parse(qtyFieldController.text),
      "C_BPartner_ID": {"id": businessPartnerId},
      "JP_ToDo_ScheduledStartDate": "${date}T${timeFieldController.text}Z",
      "JP_ToDo_ScheduledEndDate": "${endTaskDateNoTime}T${endTaskTime}Z",
      "JP_ToDo_ScheduledStartTime": "${timeFieldController.text}Z",
      "JP_ToDo_ScheduledEndTime": "${endTaskTime}Z",
      "JP_ToDo_Status": {"id": dropdownValue},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "S"},
    };
    if (projectId > 0) {
      msg.addAll({
        "C_Project_ID": {"id": projectId}
      });
    }
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo/');

    //print(msg);
    var response = await http.post(
      url,
      body: jsonEncode(msg),
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
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= AD_User_ID eq ${GetStorage().read('userId')}');

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
      //getAllProjects();
    }
  }

  Future<void> getProjectBP() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_project?\$filter= C_Project_ID eq $projectId');

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
        businessPartnerFieldController.text =
            json["records"][0]["C_BPartner_ID"]["identifier"];
      } catch (e) {
        businessPartnerId = 0;
        businessPartnerFieldController.text = "";
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

  Future<List<BPRecords>> getAllBusinessPartners() async {
    final ip = GetStorage().read('ip');
    String authorization =
        'Bearer ${GetStorage().read('token')}'; //GetStorage().read("clientid")
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //var jsondecoded = jsonDecode(response.body);

      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.pagecount! > 1) {
        int index = 1;
        var json2 = await getAllBusinessPartnersPages(json, index);
        return json2;
      } else {
        return json.records!;
      }
    } else {
      return BusinessPartnerJson(records: []).records!;
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBusinessPartnersPages(
      BusinessPartnerJson json, int index) async {
    final ip = GetStorage().read('ip');
    String authorization =
        'Bearer ${GetStorage().read('token')}'; //GetStorage().read("clientid")
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}&\$skip=${(index * 100)}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;

      var pageJson = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        var json2 = await getAllBusinessPartnersPages(json, index);
        return json2;
      } else {
        return json.records!;
      }
    } else {
      return BusinessPartnerJson(records: []).records!;
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

    timeFieldController =
        TextEditingController(text: "$hourTime:$minuteTime:00");
  }

  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  late TextEditingController projectFieldController;
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

  late TextEditingController timeFieldController;
  late TextEditingController dateFieldController;
  late TextEditingController qtyFieldController;
  late TextEditingController businessPartnerFieldController;
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
    qtyFieldController = TextEditingController(text: "1.0");
    businessPartnerFieldController = TextEditingController();

    dropDownList = getTypes()!;
    dropdownValue = "WP";

    timeStart = "";
    timeEnd = "";
    dateFieldController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));

    getProject();
  }

  static String _displayStringForOption(PJRecords option) => option.name!;

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
                    minLines: 1,
                    maxLines: 4,
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
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: TextField(
                    controller: descriptionFieldController,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
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
                /* Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Project".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                            AsyncSnapshot<List<PJRecords>> snapshot) =>
                        snapshot.hasData && flagProject
                            ? Autocomplete<PJRecords>(
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<PJRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((PJRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (PJRecords selection) {
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
                ), */
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllProjects(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<PJRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<PJRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: true,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        projectId = 0;
                                      });
                                    }
                                  },
                                  controller: projectFieldController,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'Project'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
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
                                  projectId = suggestion.id!;
                                  nameFieldController.text =
                                      "${suggestion.value}_${suggestion.name}";
                                  projectFieldController.text =
                                      "${suggestion.value}_${suggestion.name}";
                                  setState(() {});
                                  getProjectBP();
                                },
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
                    future: getAllBusinessPartners(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<BPRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: true,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        businessPartnerId = 0;
                                      });
                                    }
                                  },
                                  controller: businessPartnerFieldController,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'Business Partner'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
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
                                  businessPartnerId = suggestion.id!;
                                  businessPartnerFieldController.text =
                                      "${suggestion.value}_${suggestion.name}";
                                  setState(() {});
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                /* Container(
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
                ), */
                /* Container(
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
                ), */
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 5, bottom: 10),
                        child: TextField(
                          readOnly: true,
                          // maxLength: 10,
                          keyboardType: TextInputType.datetime,
                          controller: dateFieldController,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(EvaIcons.calendarOutline),
                            border: const OutlineInputBorder(),
                            labelText: 'Date'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'DD/MM/YYYY',
                            counterText: '',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                            LengthLimitingTextInputFormatter(10),
                            DateFormatterCustom(),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: TextField(
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: timeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'Time'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '00:00:00',
                            counterText: '',
                          ),
                          inputFormatters: [TimeTextInputFormatter()],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    controller: qtyFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity (Hour)'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
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
                ),*/
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Activity Status'.tr,
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Project".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                            AsyncSnapshot<List<PJRecords>> snapshot) =>
                        snapshot.hasData && flagProject
                            ? Autocomplete<PJRecords>(
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<PJRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((PJRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (PJRecords selection) {
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Project".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                            AsyncSnapshot<List<PJRecords>> snapshot) =>
                        snapshot.hasData && flagProject
                            ? Autocomplete<PJRecords>(
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<PJRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((PJRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (PJRecords selection) {
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
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = value.substring(6, 7) + ":" + value.substring(7);
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk = value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk = value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7, 8) +
              value.substring(8);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk = value.substring(0, 1) +
              ":" +
              value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}

class DateFormatterCustom extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = '${cText.substring(0, 2)}/';
      } else {
        // Insert / char
        cText =
            '${cText.substring(0, pLen)}/${cText.substring(pLen, pLen + 1)}';
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = '${cText.substring(0, 5)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, 5)}/${cText.substring(5, 6)}';
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

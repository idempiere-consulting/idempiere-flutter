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
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_create_tasks.dart';
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
    var msg = {
      "JP_ToDo_Status": {"id": statusId},
      "Qty": hours,
      "JP_ToDo_ScheduledStartDate":
          '${args["startDate"]}T${starttimeFieldController.text}Z',
      "JP_ToDo_ScheduledEndDate":
          '${args["startDate"]}T${endtimeFieldController.text}Z',
      "JP_ToDo_ScheduledStartTime": "${starttimeFieldController.text}Z",
      "JP_ToDo_ScheduledEndTime": "${endtimeFieldController.text}Z",
    };

    if (projectId > 0) {
      msg.addAll({
        "C_Project_ID": {"id": projectId}
      });
    }
    if (businessPartnerId > 0) {
      msg.addAll({
        "C_BPartner_ID": {"id": businessPartnerId}
      });
    }
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo/${args['id']}');
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
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo/${args["id"]}');
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

      starttimeFieldController =
          TextEditingController(text: '$hourTime:$minuteTime:00');

      endTime = '$endhourTime:$endminuteTime:00Z';
      endtimeFieldController =
          TextEditingController(text: "$hourTime:$minuteTime:00");
    } else {
      startTime = (args["startTime"] as String).substring(0, 5);
      starttimeFieldController = TextEditingController(
          text: (args["startTime"] as String).substring(0, 8));
      endtimeFieldController = TextEditingController(
          text: (args["endTime"] as String).substring(0, 8));
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

      endtimeFieldController =
          TextEditingController(text: "$hourTime:$minuteTime:00");
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

  late TextEditingController dateFieldController;
  late TextEditingController endtimeFieldController;
  late TextEditingController starttimeFieldController;
  late TextEditingController projectFieldController;
  late TextEditingController businessPartnerFieldController;
  int projectId = 0;
  bool flagProject = false;
  int businessPartnerId = 0;

  @override
  void initState() {
    flagProject = false;
    startTime = "";
    endTime = "";
    nameFieldController = TextEditingController();
    userFieldController = TextEditingController();
    statusFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    dateFieldController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
    starttimeFieldController = TextEditingController();
    endtimeFieldController = TextEditingController();
    projectFieldController = TextEditingController(text: args["projectName"]);
    businessPartnerFieldController =
        TextEditingController(text: args["businessPartnerName"]);
    projectId = args["projectID"];
    businessPartnerId = args["businessPartnerID"];
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
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: TextField(
                    readOnly: true,
                    controller: userFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Assigned To'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
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
                      isDense: true,
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
                ), */
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 5, bottom: 10),
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
                /* Container(
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
                ), */
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 5, bottom: 10),
                        child: TextField(
                          readOnly: args["statusId"] == "CO",
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: starttimeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'Start Time'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '00:00:00',
                            counterText: '',
                          ),
                          inputFormatters: [TimeTextInputFormatter()],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: TextField(
                          readOnly: args["statusId"] == "CO",
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: endtimeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'End Time'.tr,
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
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: TextField(
                    readOnly: true,
                    controller: userFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Assigned To'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
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
                      isDense: true,
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
                ), */
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 5, bottom: 10),
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
                /* Container(
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
                ), */
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 5, bottom: 10),
                        child: TextField(
                          readOnly: args["statusId"] == "CO",
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: starttimeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'Start Time'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '00:00:00',
                            counterText: '',
                          ),
                          inputFormatters: [TimeTextInputFormatter()],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: TextField(
                          readOnly: args["statusId"] == "CO",
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: endtimeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'End Time'.tr,
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
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: TextField(
                    readOnly: true,
                    controller: userFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Assigned To'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
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
                      isDense: true,
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
                ), */
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 5, bottom: 10),
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
                /* Container(
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
                ), */
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 5, bottom: 10),
                        child: TextField(
                          readOnly: args["statusId"] == "CO",
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: starttimeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'Start Time'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '00:00:00',
                            counterText: '',
                          ),
                          inputFormatters: [TimeTextInputFormatter()],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: TextField(
                          readOnly: args["statusId"] == "CO",
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: endtimeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.access_time),
                            border: const OutlineInputBorder(),
                            labelText: 'End Time'.tr,
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

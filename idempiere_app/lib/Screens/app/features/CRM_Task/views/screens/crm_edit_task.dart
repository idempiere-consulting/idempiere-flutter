import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task/views/screens/crm_task_screen.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:path_provider/path_provider.dart';

class EditCRMTask extends StatefulWidget {
  const EditCRMTask({Key? key}) : super(key: key);

  @override
  State<EditCRMTask> createState() => _EditCRMTaskState();
}

class _EditCRMTaskState extends State<EditCRMTask> {
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
      Get.find<CRMTaskController>().getTasks();
      //print("done!");
      Get.back();
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
    var msg = {
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "JP_ToDo_ScheduledStartDate": '${date}T$timeStart:00Z',
      "JP_ToDo_ScheduledEndDate": '${date}T$timeEnd:00Z',
      "JP_ToDo_ScheduledStartTime": '$timeStart:00Z',
      "JP_ToDo_ScheduledEndTime": '$timeEnd:00Z',
      "JP_ToDo_Status": {"id": dropdownValue},
      //"JP_ToDo_Type": {"id": "S"},
    };

    if (userValue != "") {
      msg.addAll({
        "AD_User_ID": {"identifier": userValue}
      });
    }

    if (businessPartnerId != 0) {
      msg.addAll({
        "C_BPartner_ID": {"id": businessPartnerId}
      });
    }

    if (projectId != 0) {
      msg.addAll({
        "C_Project_ID": {"id": projectId}
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
      Get.find<CRMTaskController>().getTasks();
      //print("done!");
      //Get.back();
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

  Future<List<BPRecords>> getAllBPs() async {
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(await file.readAsString());
    var jsonResources = BusinessPartnerJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

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

  Future<List<CRecords>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= DateLastLogin neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

  // ignore: prefer_typing_uninitialized_variables
  var userFieldController;
  String date = "";
  String timeStart = "";
  String timeEnd = "";
  String dropdownValue = "";
  late List<Types> dropDownList;
  String userValue = "";

  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerFieldController;
  int businessPartnerId = 0;

  // ignore: prefer_typing_uninitialized_variables
  var projectFieldController;
  int projectId = 0;
  //var adUserId;

  @override
  void initState() {
    date = "";
    super.initState();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    businessPartnerFieldController =
        TextEditingController(text: args['bpName'] ?? "");
    businessPartnerId = args['bpId'] ?? 0;
    projectFieldController =
        TextEditingController(text: args['projectName'] ?? "");
    projectId = args['projectId'] ?? 0;
    dropDownList = getTypes()!;
    dropdownValue = "NY";
    timeStart = "";
    timeEnd = "";
    userValue = args['user'] ?? "";
    userFieldController = TextEditingController(text: args['user'] ?? "");
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
              Get.back();
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
                    child: FutureBuilder(
                      future: getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<BPRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: businessPartnerFieldController,
                                    //autofocus: true,
                                    /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                    decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.handshake_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: 'Business Partner',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                        suggestion.name;
                                    //productName = selection.name;
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllProjects(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<PJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<PJRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: projectFieldController,
                                    //autofocus: true,
                                    /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.handshake_outlined),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Project'.tr,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    projectFieldController.text =
                                        suggestion.name;
                                    //productName = selection.name;
                                  },
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
                      maxLines: 4,
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
                      minLines: 1,
                      maxLines: 4,
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
                    child: FutureBuilder(
                      future: getAllSalesRep(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<CRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: userFieldController,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.person_outline),
                                      border: const OutlineInputBorder(),
                                      labelText: 'User'.tr,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    userValue = suggestion.name!;
                                    userFieldController.text = suggestion.name;
                                    //productName = selection.name;
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
                    child: FutureBuilder(
                      future: getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<BPRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: businessPartnerFieldController,
                                    //autofocus: true,
                                    /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                    decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.handshake_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: 'Business Partner',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                        suggestion.name;
                                    //productName = selection.name;
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllProjects(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<PJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<PJRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: projectFieldController,
                                    //autofocus: true,
                                    /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.handshake_outlined),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Project'.tr,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    projectFieldController.text =
                                        suggestion.name;
                                    //productName = selection.name;
                                  },
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
                      maxLines: 4,
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
                      minLines: 1,
                      maxLines: 4,
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
                    child: FutureBuilder(
                      future: getAllSalesRep(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<CRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: userFieldController,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.person_outline),
                                      border: const OutlineInputBorder(),
                                      labelText: 'User'.tr,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    userValue = suggestion.name!;
                                    userFieldController.text = suggestion.name;
                                    //productName = selection.name;
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
                    child: FutureBuilder(
                      future: getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<BPRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: businessPartnerFieldController,
                                    //autofocus: true,
                                    /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                    decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.handshake_outlined),
                                      border: OutlineInputBorder(),
                                      labelText: 'Business Partner',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                        suggestion.name;
                                    //productName = selection.name;
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllProjects(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<PJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<PJRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: projectFieldController,
                                    //autofocus: true,
                                    /* style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontStyle: FontStyle.italic), */
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.handshake_outlined),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Project'.tr,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    projectFieldController.text =
                                        suggestion.name;
                                    //productName = selection.name;
                                  },
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
                      maxLines: 4,
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
                      minLines: 1,
                      maxLines: 4,
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
                    child: FutureBuilder(
                      future: getAllSalesRep(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<CRecords>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: userFieldController,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.person_outline),
                                      border: const OutlineInputBorder(),
                                      labelText: 'User'.tr,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    userValue = suggestion.name!;
                                    userFieldController.text = suggestion.name;
                                    //productName = selection.name;
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

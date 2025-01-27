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
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_create_tasks.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';

import '../../../CRM_Contact_BP/models/contact.dart';

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
      "JP_ToDo_ScheduledStartDate":
          '${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateFieldController.text))}T$timeStart:00Z',
      "JP_ToDo_ScheduledEndDate": '${date}T$timeEnd:00Z',
      "JP_ToDo_ScheduledStartTime": '${starttimeFieldController.text}Z',
      "JP_ToDo_ScheduledEndTime": '${endtimeFieldController.text}Z',
      "JP_ToDo_Status": {"id": dropdownValue},
      "JP_ToDo_Type": {"id": "S"},
      "AD_User_ID": {"id": userId == 0 ? -1 : userId}
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
      print(response.body);
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

  Future<List<CRecords>> getAllUsers() async {
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

  late TextEditingController userFieldController;
  late TextEditingController dateFieldController;
  late TextEditingController starttimeFieldController;
  late TextEditingController endtimeFieldController;
  late TextEditingController projectFieldController;
  late TextEditingController businessPartnerFieldController;
  int userId = 0;
  int projectId = 0;
  bool flagProject = false;
  int businessPartnerId = 0;

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
    userFieldController = TextEditingController(text: args["userName"] ?? "");
    dateFieldController = TextEditingController(
        text:
            DateFormat('dd/MM/yyyy').format(DateTime.parse(args['startDate'])));
    userId = args["userId"] ?? 0;
    dropDownList = getTypes()!;
    dropdownValue = "NY";
    timeStart = "";
    timeEnd = "";
    starttimeFieldController =
        TextEditingController(text: "${args['startTime']}:00");
    endtimeFieldController =
        TextEditingController(text: "${args['endTime']}:00");
    projectFieldController = TextEditingController(text: args["projectName"]);
    businessPartnerFieldController =
        TextEditingController(text: args["businessPartnerName"]);
    projectId = args["projectID"] ?? 0;
    businessPartnerId = args["businessPartnerID"] ?? 0;
    print(args['startTime']);
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
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: TextField(
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: TextField(
                      controller: descriptionFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Description'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: FutureBuilder(
                      future: getAllUsers(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<CRecords>(
                                  direction: AxisDirection.up,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == "") {
                                        setState(() {
                                          userId = 0;
                                        });
                                      }
                                    },
                                    controller: userFieldController,
                                    //autofocus: true,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(EvaIcons.search),
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
                                    setState(() {
                                      userFieldController.text =
                                          suggestion.name!;
                                      userId = suggestion.id!;
                                    });
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
                      future: getAllProjects(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<PJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<PJRecords>(
                                  direction: AxisDirection.down,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
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
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 5, bottom: 10),
                          child: TextField(
                            // maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: starttimeFieldController,

                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.access_time),
                              border: const OutlineInputBorder(),
                              labelText: 'Start Time'.tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            // maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: endtimeFieldController,

                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.access_time),
                              border: const OutlineInputBorder(),
                              labelText: 'End Time'.tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Task Status'.tr,
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
                        isDense: true,
                        underline: SizedBox(),
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
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: TextField(
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: TextField(
                      controller: descriptionFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Description'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: FutureBuilder(
                      future: getAllUsers(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<CRecords>(
                                  direction: AxisDirection.up,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == "") {
                                        setState(() {
                                          userId = 0;
                                        });
                                      }
                                    },
                                    controller: userFieldController,
                                    //autofocus: true,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(EvaIcons.search),
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
                                    setState(() {
                                      userFieldController.text =
                                          suggestion.name!;
                                      userId = suggestion.id!;
                                    });
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
                      future: getAllProjects(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<PJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<PJRecords>(
                                  direction: AxisDirection.down,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
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
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 5, bottom: 10),
                          child: TextField(
                            // maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: starttimeFieldController,

                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.access_time),
                              border: const OutlineInputBorder(),
                              labelText: 'Start Time'.tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            // maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: endtimeFieldController,

                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.access_time),
                              border: const OutlineInputBorder(),
                              labelText: 'End Time'.tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Task Status'.tr,
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
                        isDense: true,
                        underline: SizedBox(),
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
            desktopBuilder: (context, constraints) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: TextField(
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: TextField(
                      controller: descriptionFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Description'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: FutureBuilder(
                      future: getAllUsers(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<CRecords>(
                                  direction: AxisDirection.up,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == "") {
                                        setState(() {
                                          userId = 0;
                                        });
                                      }
                                    },
                                    controller: userFieldController,
                                    //autofocus: true,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(EvaIcons.search),
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
                                    setState(() {
                                      userFieldController.text =
                                          suggestion.name!;
                                      userId = suggestion.id!;
                                    });
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
                      future: getAllProjects(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<PJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<PJRecords>(
                                  direction: AxisDirection.down,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
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
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
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
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 5, bottom: 10),
                          child: TextField(
                            // maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: starttimeFieldController,

                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.access_time),
                              border: const OutlineInputBorder(),
                              labelText: 'Start Time'.tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            // maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: endtimeFieldController,

                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.access_time),
                              border: const OutlineInputBorder(),
                              labelText: 'End Time'.tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Task Status'.tr,
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
                        isDense: true,
                        underline: SizedBox(),
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
          ),
        ),
      ),
    );
  }
}

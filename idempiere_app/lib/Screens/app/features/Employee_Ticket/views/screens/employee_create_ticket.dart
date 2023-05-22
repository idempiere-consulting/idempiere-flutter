import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Ticket/views/screens/employee_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/freeslotjson.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/tickettypejson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateEmployeeTicket extends StatefulWidget {
  const CreateEmployeeTicket({Key? key}) : super(key: key);

  @override
  State<CreateEmployeeTicket> createState() => _CreateEmployeeTicketState();
}

class _CreateEmployeeTicketState extends State<CreateEmployeeTicket> {
  attachImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    if (result != null) {
      //File file = File(result.files.first.bytes!);
      setState(() {
        image64 = base64.encode(result.files.first.bytes!);
        imageName = result.files.first.name;
      });
      //print(image64);
      //print(imageName);
    }
  }

  sendTicketAttachedImage(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final msg = jsonEncode({"name": "ticketimage.jpg", "data": image64});

    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/r_request/$id/attachments');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      //print(response.body);
    } else {
      //print(response.body);
    }
  }

  createTicket() async {
    var formatter = DateFormat('yyyy-MM-dd');
    var dateF = DateTime.parse(dateFrom);
    var dateT = DateTime.parse(dateTo);
    String formattedDateFrom = formatter.format(dateF);
    String formattedDateTo = formatter.format(dateT);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "R_RequestType_ID": Get.arguments["id"],
      "DueType": {"id": 5},
      "R_Status_ID": {"id": rStatusId},
      "PriorityUser": {"id": "5"},
      "Priority": {"id": "5"},
      "ConfidentialType": {"id": "C"},
      "SalesRep_ID": {"id": salesRepId},
      "Summary": " ",
      "ConfidentialTypeEntry": {"id": "C"},
      "C_BPartner_ID": {"id": businessPartnerId},
      "StartDate": "${formattedDateFrom}T00:00:00Z",
      "CloseDate": "${formattedDateTo}T00:00:00Z",
      "TaskStatus": '0',
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/R_Request');
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
      var json = jsonDecode(response.body);
      if (imageName != "" && image64 != "") {
        sendTicketAttachedImage(json["id"]);
        //print(response.body);
      }
      Get.find<EmployeeTicketController>().getTickets();
      Get.back();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.statusCode);
      if (kDebugMode) {
        print(response.body);
      }
      //print(response.statusCode);
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  createTicketPermission() async {
    var formatter = DateFormat('yyyy-MM-dd');
    var dateF = DateTime.parse(dateFrom);
    //var dateT = DateTime.parse(dateTo);
    String formattedDateFrom = formatter.format(dateF);
    //String formattedDateTo = formatter.format(dateT);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "R_RequestType_ID": Get.arguments["id"],
      "DueType": {"id": 5},
      "R_Status_ID": {"id": rStatusId},
      "PriorityUser": {"id": "5"},
      "Priority": {"id": "5"},
      "ConfidentialType": {"id": "C"},
      "SalesRep_ID": {"id": salesRepId},
      "Summary": " ",
      "ConfidentialTypeEntry": {"id": "C"},
      "C_BPartner_ID": {"id": businessPartnerId},
      "StartDate": "${formattedDateFrom}T$timeStart:00Z",
      "CloseDate": "${formattedDateFrom}T$timeEnd:00Z",
      "Result": noteFieldController.text,
      "TaskStatus": '0',
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/R_Request');
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
      var json = jsonDecode(response.body);
      if (imageName != "" && image64 != "") {
        sendTicketAttachedImage(json["id"]);
        //print(response.body);
      }
      Get.find<EmployeeTicketController>().getTickets();
      Get.back();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.statusCode);
      if (kDebugMode) {
        print(response.body);
      }
      //print(response.statusCode);
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  createTicketGeneric() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "R_RequestType_ID": Get.arguments["id"],
      "DueType": {"id": 5},
      "R_Status_ID": {"id": rStatusId},
      "PriorityUser": {"id": "5"},
      "Priority": {"id": "5"},
      "ConfidentialType": {"id": "C"},
      "SalesRep_ID": {"id": salesRepId},
      "Summary": nameFieldController.text,
      "ConfidentialTypeEntry": {"id": "C"},
      "C_BPartner_ID": {"id": businessPartnerId},
      "TaskStatus": '0',
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/R_Request');
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
      var json = jsonDecode(response.body);
      if (imageName != "" && image64 != "") {
        sendTicketAttachedImage(json["id"]);
        //print(response.body);
      }
      Get.find<EmployeeTicketController>().getTickets();
      Get.back();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.statusCode);
      if (kDebugMode) {
        print(response.body);
      }
      //print(response.statusCode);
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  final json = {
    "types": [
      {"id": "9", "name": "Minor"},
      {"id": "7", "name": "Low"},
      {"id": "5", "name": "Medium"},
      {"id": "3", "name": "High"},
      {"id": "1", "name": "Urgent"},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  Future<void> getBusinessPartner() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= Name eq \'$name\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(response.body);

      businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
      //getTickets();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<void> getRStatus() async {
    //var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/R_Status?\$filter= Value eq \'R00\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(response.body);

      rStatusId = json["records"][0]["id"];
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<void> getSalesRep() async {
    //var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_User?\$filter= Value eq \'tba\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(response.body);

      salesRepId = json["records"][0]["id"];
      //print(rStatusId);
      //getTickets();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  getTicketTypeInfo() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/R_RequestType?\$filter= R_RequestType_ID eq ${Get.arguments["id"]} and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = TicketTypeJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);
      setState(() {
        ticketTypeValue = json.records![0].lITRequestSubType!.id!;
      });
      //print(ticketTypeValue);
    } else {
      throw Exception("Failed to load ticket types");
    }
  }

  Future<List<Types>> getFreeSlots() async {
    List<Types> list = [];
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_resourcefreeslot_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var slots = FreeSlotJson.fromJson(jsonDecode(response.body));

      for (var i = 0; i < slots.rowcount!; i++) {
        // ignore: unused_local_variable
        var flag = true;

        DateTime slot = DateTime.parse(slots.records![i].dateSlot!);

        //print(slots.records![i].dateSlot);
        for (var j = 0; j < eventJson.rowcount!; j++) {
          DateTime dateTimeStart = DateTime.parse(
              '${eventJson.records![j].jPToDoScheduledStartDate}T${eventJson.records![j].jPToDoScheduledStartTime}');
          DateTime dateTimeEnd = DateTime.parse(
              '${eventJson.records![j].jPToDoScheduledEndDate}T${eventJson.records![j].jPToDoScheduledEndTime}');

          if ((slot.isAtSameMomentAs(dateTimeStart) ||
                  slot.isAfter(dateTimeStart)) &&
              (slot.isAtSameMomentAs(dateTimeEnd) ||
                  slot.isBefore(dateTimeEnd))) {
            flag = false;
            break;
          }
        }

        if (true) {
          //flag
          Types freeSlot = Types(
              id: slot.toString(),
              name:
                  "${slot.day}/${slot.month}/${slot.year}  Ore ${slot.hour}:00");
          //print(freeSlot.name);
          list.add(freeSlot);
        }
      }

      return list;
      //print(slots.rowcount);
      //print(ticketTypeValue);
    } else {
      throw Exception("Failed to load free slots");
    }
  }

  Future<List<Types>> getAllScheduledEvents() async {
    var now = DateTime.now();
    DateTime fourteenDayslater = now.add(const Duration(days: 14));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String formattedfourteenDayslater = formatter.format(fourteenDayslater);
    //print(formattedDate);
    //print(formattedFiftyDaysAgo);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/jp_todo?\$filter= JP_ToDo_Type eq \'S\' and JP_ToDo_ScheduledStartDate ge \'$formattedDate\' and JP_ToDo_ScheduledStartDate le \'$formattedfourteenDayslater 23:59:59\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      eventJson = EventJson.fromJson(jsonDecode(response.body));

      //print(eventJson.records![0].jPToDoScheduledStartDate);
      //print(eventJson.records![0].jPToDoScheduledStartTime);
      return getFreeSlots();
    } else {
      throw Exception("Failed to load scheduled events");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  /* void fillFields() {
    nameFieldController.text = args["name"];
    bPartnerFieldController.text = args["bpName"];
    phoneFieldController.text = args["Tel"];
    mailFieldController.text = args["eMail"];
    //dropdownValue = args["leadStatus"];
    salesrepValue = args["salesRep"];
    //salesRepFieldController.text = args["salesRep"];
  } */

  //dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var phoneFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var mailFieldController;

  late TextEditingController noteFieldController;

  String dropdownValue = "";
  String slotDropdownValue = "";
  String salesrepValue = "";
  String ticketTypeValue = "";
  String image64 = "";
  String imageName = "";
  String dateFrom = "";
  String dateTo = "";
  String timeStart = "";
  String timeEnd = "";
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;
  late EventJson eventJson;
  // ignore: prefer_typing_uninitialized_variables
  var rStatusId;
  // ignore: prefer_typing_uninitialized_variables
  var salesRepId;
  late List<Types> dropDownList;

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    mailFieldController = TextEditingController();
    noteFieldController = TextEditingController();
    dropdownValue = "9";
    dateFrom = "";
    dateTo = "";
    timeStart = "";
    timeEnd = "";
    slotDropdownValue = "";
    ticketTypeValue = "";
    image64 = "";
    imageName = "";
    dropDownList = getTypes()!;
    getBusinessPartner();
    getAllScheduledEvents();
    getTicketTypeInfo();
    getRStatus();
    getSalesRep();
    //fillFields();
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
          child: Text('Add Ticket'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                switch (ticketTypeValue) {
                  case "HRH":
                    createTicket();
                    break;
                  case "HRI":
                    createTicket();
                    break;
                  case "HRP":
                    createTicketPermission();
                    break;
                  case "HRG":
                    createTicketGeneric();
                    break;
                  default:
                }
                //createTicket();
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
                /* const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: const InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Summary of the issue',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: const InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Subject of the Scheduled Session',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Priority",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: const Align(
                      child: Text(
                        "Session slots currently free",
                        style: TextStyle(fontSize: 12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllScheduledEvents(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Types>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  value: snapshot.data![0].id,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      slotDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                      value: list.id.toString(),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ), */
                Visibility(
                  visible: ticketTypeValue == "HRG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Description'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "HRH" || ticketTypeValue == "HRI",
                  child: Container(
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'From'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateFrom = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    // padding: const EdgeInsets.all(10),
                    width: size.width,
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: const OutlineInputBorder(),
                        labelText: 'Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      //dateLabelText: 'Date'.tr,
                      //icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateFrom = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    //padding: const EdgeInsets.all(10),
                    width: size.width,

                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                        labelText: 'Start Time'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.time,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      timeLabelText: ''.tr,
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
                ),
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: size.width,
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                        labelText: 'End Time'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.time,
                      initialValue: '',
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
                ),
                Visibility(
                  visible: ticketTypeValue == "HRH" || ticketTypeValue == "HRI",
                  child: Container(
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'To',
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateTo = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP" || ticketTypeValue == "HRH",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: noteFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "HRI",
                  child: IconButton(
                      onPressed: () {
                        attachImage();
                      },
                      icon: const Icon(Icons.attach_file)),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                /* const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: const InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Summary of the issue',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: const InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Subject of the Scheduled Session',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Priority",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: const Align(
                      child: Text(
                        "Session slots currently free",
                        style: TextStyle(fontSize: 12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllScheduledEvents(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Types>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  value: snapshot.data![0].id,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      slotDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                      value: list.id.toString(),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ), */
                Visibility(
                  visible: ticketTypeValue == "HRG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Description'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "HRH" || ticketTypeValue == "HRI",
                  child: Container(
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'From'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateFrom = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    // padding: const EdgeInsets.all(10),
                    width: size.width,
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: const OutlineInputBorder(),
                        labelText: 'Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      //dateLabelText: 'Date'.tr,
                      //icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateFrom = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    //padding: const EdgeInsets.all(10),
                    width: size.width,

                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                        labelText: 'Start Time'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.time,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      timeLabelText: ''.tr,
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
                ),
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: size.width,
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                        labelText: 'End Time'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.time,
                      initialValue: '',
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
                ),
                Visibility(
                  visible: ticketTypeValue == "HRH" || ticketTypeValue == "HRI",
                  child: Container(
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'To',
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateTo = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP" || ticketTypeValue == "HRH",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: noteFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "HRI",
                  child: IconButton(
                      onPressed: () {
                        attachImage();
                      },
                      icon: const Icon(Icons.attach_file)),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                /* const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: const InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Summary of the issue',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: const InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Subject of the Scheduled Session',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Priority",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: const Align(
                      child: Text(
                        "Session slots currently free",
                        style: TextStyle(fontSize: 12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllScheduledEvents(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Types>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  value: snapshot.data![0].id,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      slotDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                      value: list.id.toString(),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ), */
                Visibility(
                  visible: ticketTypeValue == "HRG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Description'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "HRH" || ticketTypeValue == "HRI",
                  child: Container(
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'From'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateFrom = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    // padding: const EdgeInsets.all(10),
                    width: size.width,
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: const OutlineInputBorder(),
                        labelText: 'Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      //dateLabelText: 'Date'.tr,
                      //icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateFrom = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    //padding: const EdgeInsets.all(10),
                    width: size.width,

                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                        labelText: 'Start Time'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.time,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      timeLabelText: ''.tr,
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
                ),
                Visibility(
                  visible: ticketTypeValue == "HRP",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: size.width,
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.access_time),
                        border: const OutlineInputBorder(),
                        labelText: 'End Time'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      type: DateTimePickerType.time,
                      initialValue: '',
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
                ),
                Visibility(
                  visible: ticketTypeValue == "HRH" || ticketTypeValue == "HRI",
                  child: Container(
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'To',
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateTo = val.substring(0, 10);
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
                Visibility(
                  visible: ticketTypeValue == "HRP" || ticketTypeValue == "HRH",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: noteFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.badge),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "HRI",
                  child: IconButton(
                      onPressed: () {
                        attachImage();
                      },
                      icon: const Icon(Icons.attach_file)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

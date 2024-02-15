import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/freeslotjson.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/tickettypejson.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/views/screens/ticketclient_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../CRM_Contact_BP/models/contact.dart';

class CreateTicketClientTicket extends StatefulWidget {
  const CreateTicketClientTicket({Key? key}) : super(key: key);

  @override
  State<CreateTicketClientTicket> createState() =>
      _CreateTicketClientTicketState();
}

class _CreateTicketClientTicketState extends State<CreateTicketClientTicket> {
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
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/r_request/$id/attachments');

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
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": int.parse(GetStorage().read("organizationid"))},
      "AD_Client_ID": {"id": int.parse(GetStorage().read("clientid"))},
      "R_RequestType_ID": int.parse(Get.arguments["id"]),
      "DueType": {"id": 5},
      "R_Status_ID": {"id": rStatusId},
      "PriorityUser": {"id": dropdownValue},
      "Priority": {"id": dropdownValue},
      "ConfidentialType": {"id": "C"},
      "SalesRep_ID": {"id": salesRepId},
      "ConfidentialTypeEntry": {"id": "C"},
      "Name": titleFieldController.text,
      "Summary": nameFieldController.text,
      "AD_User_ID": userId,
      "C_BPartner_ID": {"id": businessPartnerId},
      "AD_Role_ID": {"id": -1}
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/windows/request');
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
      Get.find<TicketClientTicketController>().getTickets();
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

  createEvent() async {
    var formatter = DateFormat('yyyy-MM-dd');
    var date = DateTime.parse(slotDropdownValue);
    String formattedDate = formatter.format(date);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"id": salesRepId},
      "Name": titleFieldController.text,
      "Description": nameFieldController.text,
      "JP_ToDo_ScheduledStartDate": formattedDate,
      "JP_ToDo_ScheduledEndDate": formattedDate,
      "JP_ToDo_ScheduledStartTime": '${date.hour}:00:00Z',
      "JP_ToDo_ScheduledEndTime": '${date.hour + 1}:00:00Z',
      "JP_ToDo_Status": {"id": "NY"},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "S"},
      "C_BPartner_ID": {"id": businessPartnerId},
      "Qty": 1,
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
      //print(response.body);
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
    var userId = GetStorage().read("userId");
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/ad_user?\$filter= AD_User_ID eq $userId and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
      businessPartnerName = json["records"][0]["C_BPartner_ID"]["identifier"];

      //getTickets();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getRStatus() async {
    //var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/R_Status?\$filter= Value eq \'NEW\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_User?\$filter= Value eq \'tba\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/R_RequestType?\$filter= R_RequestType_ID eq ${Get.arguments["id"]} and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
      throw Exception("Failed to load ticket types".tr);
    }
  }

  Future<List<Types>> getFreeSlots() async {
    List<Types> list = [];
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/lit_resourcefreeslot_v');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      var slots = FreeSlotJson.fromJson(jsonDecode(response.body));

      for (var i = 0; i < slots.rowcount!; i++) {
        // ignore: unused_local_variable
        var flag = true;

        DateTime slot = DateTime.parse(slots.records![i].dateSlot!);

        //print(slots.records![i].dateSlot);
        /* for (var j = 0; j < eventJson.rowcount!; j++) {
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
        } */

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
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load free slots".tr);
    }
  }

  /* Future<List<Types>> getAllScheduledEvents() async {
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
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/jp_todo?\$filter= JP_ToDo_Type eq \'S\' and JP_ToDo_ScheduledStartDate ge \'$formattedDate\' and JP_ToDo_ScheduledStartDate le \'$formattedfourteenDayslater 23:59:59\'');
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
      throw Exception("Failed to load scheduled events".tr);
    }

    //print(list[0].eMail);

    //print(json.);
  } */

  Future<List<CRecords>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
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
      throw Exception("Failed to load sales reps".tr);
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
  final List<dynamic> list = GetStorage().read('permission');
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var titleFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var phoneFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var mailFieldController;
  String dropdownValue = "";
  String slotDropdownValue = "";
  String salesrepValue = "";
  String ticketTypeValue = "";
  String image64 = "";
  String imageName = "";
  String businessPartnerName = "";
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;
  var userName = "";
  // ignore: prefer_typing_uninitialized_variables
  var userId;
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
    titleFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    mailFieldController = TextEditingController();
    businessPartnerName = GetStorage().read('BusinessPartnerName');
    businessPartnerId = GetStorage().read('BusinessPartnerId');
    userName = GetStorage().read("user");
    userId = GetStorage().read("userId");
    dropdownValue = "9";
    slotDropdownValue = "";
    ticketTypeValue = "";
    image64 = "";
    imageName = "";
    dropDownList = getTypes()!;
    getTicketTypeInfo();
    getRStatus();
    getSalesRep();
    getAllBPs();
    //fillFields();
  }

  static String _displayStringForOption(BPRecords option) => option.name!;

  static String _displayStringForOptionUser(CRecords option) => option.name!;

  //static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Ticket'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                switch (ticketTypeValue) {
                  case "TKG":
                    createTicket();
                    break;
                  case "TKC":
                    createEvent();
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
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Business Partner".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? Autocomplete<BPRecords>(
                                  initialValue: TextEditingValue(
                                      text: businessPartnerName),
                                  displayStringForOption:
                                      _displayStringForOption,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<BPRecords>.empty();
                                    }
                                    return snapshot.data!
                                        .where((BPRecords option) {
                                      return option.name!
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (BPRecords selection) {
                                    //debugPrint(
                                    //'You just selected ${_displayStringForOption(selection)}');
                                    setState(() {
                                      businessPartnerName =
                                          _displayStringForOption(selection);
                                      businessPartnerId = selection.id;
                                    });

                                    //print(salesrepValue);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "User".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllSalesRep(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? Autocomplete<CRecords>(
                                  initialValue:
                                      TextEditingValue(text: userName),
                                  displayStringForOption:
                                      _displayStringForOptionUser,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<CRecords>.empty();
                                    }
                                    return snapshot.data!
                                        .where((CRecords option) {
                                      return option.name!
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (CRecords selection) {
                                    //debugPrint(
                                    //'You just selected ${_displayStringForOption(selection)}');
                                    setState(() {
                                      userName = _displayStringForOptionUser(
                                          selection);
                                    });

                                    userId = selection.id;

                                    //print(salesrepValue);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 1,
                      controller: titleFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Ticket Title'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Summary of the issue'.tr,
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
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Subject of the Scheduled Session'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Priority".tr,
                      style: const TextStyle(fontSize: 12),
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
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Session slots currently free".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
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
                      future: getFreeSlots(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Types>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  //value: null,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      slotDropdownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: IconButton(
                      onPressed: () {
                        attachImage();
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: image64 != "" ? Colors.green : Colors.white,
                      )),
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
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Business Partner".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? Autocomplete<BPRecords>(
                                  initialValue: TextEditingValue(
                                      text: businessPartnerName),
                                  displayStringForOption:
                                      _displayStringForOption,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<BPRecords>.empty();
                                    }
                                    return snapshot.data!
                                        .where((BPRecords option) {
                                      return option.name!
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (BPRecords selection) {
                                    //debugPrint(
                                    //'You just selected ${_displayStringForOption(selection)}');
                                    setState(() {
                                      businessPartnerName =
                                          _displayStringForOption(selection);
                                      businessPartnerId = selection.id;
                                    });

                                    //print(salesrepValue);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "User".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllSalesRep(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? Autocomplete<CRecords>(
                                  initialValue:
                                      TextEditingValue(text: userName),
                                  displayStringForOption:
                                      _displayStringForOptionUser,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<CRecords>.empty();
                                    }
                                    return snapshot.data!
                                        .where((CRecords option) {
                                      return option.name!
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (CRecords selection) {
                                    //debugPrint(
                                    //'You just selected ${_displayStringForOption(selection)}');
                                    setState(() {
                                      userName = _displayStringForOptionUser(
                                          selection);
                                    });

                                    userId = selection.id;

                                    //print(salesrepValue);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 1,
                      controller: titleFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Ticket Title'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Summary of the issue'.tr,
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
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Subject of the Scheduled Session'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Priority".tr,
                      style: const TextStyle(fontSize: 12),
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
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Session slots currently free".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
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
                      future: getFreeSlots(),
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
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: IconButton(
                      onPressed: () {
                        attachImage();
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: image64 != "" ? Colors.green : Colors.white,
                      )),
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
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Business Partner".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? Autocomplete<BPRecords>(
                                  initialValue: TextEditingValue(
                                      text: businessPartnerName),
                                  displayStringForOption:
                                      _displayStringForOption,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<BPRecords>.empty();
                                    }
                                    return snapshot.data!
                                        .where((BPRecords option) {
                                      return option.name!
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (BPRecords selection) {
                                    //debugPrint(
                                    //'You just selected ${_displayStringForOption(selection)}');
                                    setState(() {
                                      businessPartnerName =
                                          _displayStringForOption(selection);
                                      businessPartnerId = selection.id;
                                    });

                                    //print(salesrepValue);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "User".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: int.parse(list[37], radix: 16)
                              .toRadixString(2)
                              .padLeft(8, "0")
                              .toString()[6] ==
                          "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllSalesRep(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<CRecords>> snapshot) =>
                          snapshot.hasData
                              ? Autocomplete<CRecords>(
                                  initialValue:
                                      TextEditingValue(text: userName),
                                  displayStringForOption:
                                      _displayStringForOptionUser,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<CRecords>.empty();
                                    }
                                    return snapshot.data!
                                        .where((CRecords option) {
                                      return option.name!
                                          .toString()
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (CRecords selection) {
                                    //debugPrint(
                                    //'You just selected ${_displayStringForOption(selection)}');
                                    setState(() {
                                      userName = _displayStringForOptionUser(
                                          selection);
                                    });

                                    userId = selection.id;

                                    //print(salesrepValue);
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 1,
                      controller: titleFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Ticket Title'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 5,
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Summary of the issue'.tr,
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
                      decoration: InputDecoration(
                        //prefixIcon: Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Subject of the Scheduled Session'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Priority".tr,
                      style: const TextStyle(fontSize: 12),
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
                Visibility(
                  visible: ticketTypeValue == "TKC",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Session slots currently free".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
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
                      future: getFreeSlots(),
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
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: ticketTypeValue == "TKG",
                  child: IconButton(
                      onPressed: () {
                        attachImage();
                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: image64 != "" ? Colors.green : Colors.white,
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/create_calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/edit_calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Calendar/views/screens/edit_calendar_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/list_profil_image.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_report_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/project_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/shared_components/search_field.dart';
import 'package:idempiere_app/Screens/app/shared_components/selection_button.dart';
import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/today_text.dart';
import 'package:idempiere_app/Screens/app/utils/helpers/app_helpers.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/maintenance_calendar_binding.dart';

// controller
part '../../controllers/maintenance_calendar_controller.dart';

// models
part '../../models/profile.dart';

// component
//part '../components/active_project_card.dart';
part '../components/header.dart';
//part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class MaintenanceCalendarScreen extends StatefulWidget {
  const MaintenanceCalendarScreen({Key? key}) : super(key: key);

  @override
  State<MaintenanceCalendarScreen> createState() =>
      _MaintenanceCalendarScreenState();
}

class _MaintenanceCalendarScreenState extends State<MaintenanceCalendarScreen> {
  Future<void> getAllEventsOffline() async {
    var json = EventJson.fromJson(jsonDecode(GetStorage().read('')));
    List<EventRecords>? list = json.records;

    for (var i = 0; i < json.records!.length; i++) {
      //print(list![i].jPToDoScheduledStartTime);
      //print(list![i].mpotid?.id);
      var formatter = DateFormat('yyyy-MM-dd');
      var date = DateTime.parse(list![i].jPToDoScheduledStartDate!);
      if (selectedEvents[
              DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] !=
          null) {
        selectedEvents[
                DateTime.parse('${formatter.format(date)} 00:00:00.000Z')]!
            .add(
          Event(
              id: list[i].id!,
              workOrderId: list[i].mpotid?.id ?? 0,
              workOrderName: list[i].mpotid?.identifier ?? "",
              type: list[i].jPToDoType!.identifier ?? "???",
              typeId: list[i].jPToDoType!.id!,
              status: list[i].jPToDoStatus!.identifier ?? "???",
              statusId: list[i].jPToDoStatus!.id!,
              title: list[i].name ?? "???",
              description: list[i].description ?? "",
              scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "",
              startDate: formatter.format(date),
              scheduledStartTime:
                  list[i].jPToDoScheduledStartTime!.substring(0, 5),
              scheduledEndTime: list[i].jPToDoScheduledEndTime!.substring(0, 5),
              phone: list[i].phone ?? "N/A",
              phone2: list[i].phone2 ?? "N/A",
              refname: list[i].refname ?? "N/A",
              ref2name: list[i].ref2name ?? "N/A",
              cBPartner: list[i].cBPartnerID?.identifier ?? ""),
        );
      } else {
        selectedEvents[
            DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] = [
          Event(
              id: list[i].id!,
              workOrderId: list[i].mpotid?.id ?? 0,
              workOrderName: list[i].mpotid?.identifier ?? "",
              type: list[i].jPToDoType!.identifier ?? "???",
              typeId: list[i].jPToDoType!.id!,
              status: list[i].jPToDoStatus!.identifier ?? "???",
              statusId: list[i].jPToDoStatus!.id!,
              title: list[i].name ?? "???",
              description: list[i].description ?? "",
              scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "???",
              startDate: formatter.format(date),
              scheduledStartTime:
                  list[i].jPToDoScheduledStartTime!.substring(0, 5),
              scheduledEndTime: list[i].jPToDoScheduledEndTime!.substring(0, 5),
              phone: list[i].phone ?? "N/A",
              phone2: list[i].phone2 ?? "N/A",
              refname: list[i].refname ?? "N/A",
              ref2name: list[i].ref2name ?? "N/A",
              cBPartner: list[i].cBPartnerID?.identifier ?? "")
        ];
      }
    }
    setState(() {});
  }

  Future<void> getAllEvents() async {
    var now = DateTime.now();
    DateTime fiftyDaysAgo = now.subtract(const Duration(days: 30));
    DateTime sixtyDaysLater = now.add(const Duration(days: 30));
    var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);
    String formattedSixtyDaysLater = formatter.format(sixtyDaysLater);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_jp_todo_v?\$filter=  JP_ToDo_Type eq \'S\' and AD_User_ID eq $adUserId and JP_ToDo_ScheduledStartDate ge \'$formattedFiftyDaysAgo 00:00:00\' and JP_ToDo_ScheduledStartDate le \'$formattedSixtyDaysLater 23:59:59\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      List<EventRecords>? list = json.records;

      if (json.pagecount! > 1) {
        int index = 1;
        getAllEventsPages(json, index);
      } else {
        for (var i = 0; i < json.records!.length; i++) {
          //print('hallo');
          //print(list![i].mpotid?.id);
          var formatter = DateFormat('yyyy-MM-dd');
          var date = DateTime.parse(list![i].jPToDoScheduledStartDate!);

          if (selectedEvents[
                  DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] !=
              null) {
            selectedEvents[
                    DateTime.parse('${formatter.format(date)} 00:00:00.000Z')]!
                .add(
              Event(
                  id: list[i].id!,
                  workOrderId: list[i].mpotid?.id ?? 0,
                  workOrderName: list[i].mpotid?.identifier ?? "",
                  type: list[i].jPToDoType!.identifier ?? "???",
                  typeId: list[i].jPToDoType!.id!,
                  status: list[i].jPToDoStatus!.identifier ?? "???",
                  statusId: list[i].jPToDoStatus!.id!,
                  title: list[i].name ?? "???",
                  description: list[i].description ?? "",
                  scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "",
                  startDate: formatter.format(date),
                  scheduledStartTime:
                      list[i].jPToDoScheduledStartTime!.substring(0, 5),
                  scheduledEndTime:
                      list[i].jPToDoScheduledEndTime!.substring(0, 5),
                  phone: list[i].phone ?? "N/A",
                  phone2: list[i].phone2 ?? "N/A",
                  refname: list[i].refname ?? "N/A",
                  ref2name: list[i].ref2name ?? "N/A",
                  cBPartner: list[i].cBPartnerID?.identifier ?? ""),
            );
          } else {
            selectedEvents[
                DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] = [
              Event(
                  id: list[i].id!,
                  workOrderId: list[i].mpotid?.id ?? 0,
                  workOrderName: list[i].mpotid?.identifier ?? "",
                  type: list[i].jPToDoType!.identifier ?? "???",
                  typeId: list[i].jPToDoType!.id!,
                  status: list[i].jPToDoStatus!.identifier ?? "???",
                  statusId: list[i].jPToDoStatus!.id!,
                  title: list[i].name ?? "???",
                  description: list[i].description ?? "",
                  scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "???",
                  startDate: formatter.format(date),
                  scheduledStartTime:
                      list[i].jPToDoScheduledStartTime!.substring(0, 5),
                  scheduledEndTime:
                      list[i].jPToDoScheduledEndTime!.substring(0, 5),
                  phone: list[i].phone ?? "N/A",
                  phone2: list[i].phone2 ?? "N/A",
                  refname: list[i].refname ?? "N/A",
                  ref2name: list[i].ref2name ?? "N/A",
                  cBPartner: list[i].cBPartnerID?.identifier ?? "")
            ];
          }
        }
        flag = true;
        setState(() {});
      }
      //print(json.rowcount);
    } else {
      //throw Exception("Failed to load events");
      if (kDebugMode) {
        print(response.body);
      }
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getAllEventsPages(EventJson json, int index) async {
    var now = DateTime.now();
    DateTime fiftyDaysAgo = now.subtract(const Duration(days: 50));
    DateTime sixtyDaysLater = now.add(const Duration(days: 60));
    var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);
    String formattedSixtyDaysLater = formatter.format(sixtyDaysLater);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_jp_todo_v?\$filter=  JP_ToDo_Type eq \'S\' and AD_User_ID eq $adUserId and JP_ToDo_ScheduledStartDate ge \'$formattedFiftyDaysAgo 00:00:00\' and JP_ToDo_ScheduledStartDate le \'$formattedSixtyDaysLater 23:59:59\'&\$skip=${(index * 100)}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      //print(response.body);
      var pageJson =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      List<EventRecords>? list = json.records;

      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        getAllEventsPages(json, index);
      } else {
        for (var i = 0; i < json.records!.length; i++) {
          //print('hallo');
          //print(list![i].mpotid?.id);
          var formatter = DateFormat('yyyy-MM-dd');
          var date = DateTime.parse(list![i].jPToDoScheduledStartDate!);

          if (selectedEvents[
                  DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] !=
              null) {
            selectedEvents[
                    DateTime.parse('${formatter.format(date)} 00:00:00.000Z')]!
                .add(
              Event(
                  id: list[i].id!,
                  workOrderId: list[i].mpotid?.id ?? 0,
                  workOrderName: list[i].mpotid?.identifier ?? "",
                  type: list[i].jPToDoType!.identifier ?? "???",
                  typeId: list[i].jPToDoType!.id!,
                  status: list[i].jPToDoStatus!.identifier ?? "???",
                  statusId: list[i].jPToDoStatus!.id!,
                  title: list[i].name ?? "???",
                  description: list[i].description ?? "",
                  scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "",
                  startDate: formatter.format(date),
                  scheduledStartTime:
                      list[i].jPToDoScheduledStartTime!.substring(0, 5),
                  scheduledEndTime:
                      list[i].jPToDoScheduledEndTime!.substring(0, 5),
                  phone: list[i].phone ?? "N/A",
                  phone2: list[i].phone2 ?? "N/A",
                  refname: list[i].refname ?? "N/A",
                  ref2name: list[i].ref2name ?? "N/A",
                  cBPartner: list[i].cBPartnerID?.identifier ?? ""),
            );
          } else {
            selectedEvents[
                DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] = [
              Event(
                  id: list[i].id!,
                  workOrderId: list[i].mpotid?.id ?? 0,
                  workOrderName: list[i].mpotid?.identifier ?? "",
                  type: list[i].jPToDoType!.identifier ?? "???",
                  typeId: list[i].jPToDoType!.id!,
                  status: list[i].jPToDoStatus!.identifier ?? "???",
                  statusId: list[i].jPToDoStatus!.id!,
                  title: list[i].name ?? "???",
                  description: list[i].description ?? "",
                  scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "???",
                  startDate: formatter.format(date),
                  scheduledStartTime:
                      list[i].jPToDoScheduledStartTime!.substring(0, 5),
                  scheduledEndTime:
                      list[i].jPToDoScheduledEndTime!.substring(0, 5),
                  phone: list[i].phone ?? "N/A",
                  phone2: list[i].phone2 ?? "N/A",
                  refname: list[i].refname ?? "N/A",
                  ref2name: list[i].ref2name ?? "N/A",
                  cBPartner: list[i].cBPartnerID?.identifier ?? "")
            ];
          }
        }
        flag = true;
        setState(() {});
      }
      //print(json.rowcount);
    } else {
      //throw Exception("Failed to load events");
      if (kDebugMode) {
        print(response.body);
      }
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Map<DateTime, List<Event>> selectedEvents = {};

  final json = {
    "types": [
      {"id": "1", "name": "Task To Do"},
      {"id": "2", "name": "Intervento Tecnico"},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  Future<List<Records>> getAllSalesRep() async {
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

  Future<void> makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    if (_hasCallSupport) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  static String _displayStringForOption(Records option) => option.name!;

  CalendarFormat format = CalendarFormat.month;
  // ignore: prefer_typing_uninitialized_variables
  var selectedDay;
  // ignore: prefer_typing_uninitialized_variables
  var focusedDay;
  bool _hasCallSupport = false;
  // ignore: prefer_final_fields, prefer_typing_uninitialized_variables
  var checkbox;
  String dropdownValue = "";
  late List<Types> dropDownList;
  int adUserId = 0;
  bool flag = true;

  final List<dynamic> list = GetStorage().read('permission');

  @override
  void initState() {
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });
    flag = true;
    adUserId = GetStorage().read('userId');
    super.initState();
    selectedEvents = {};
    getAllEvents();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    dropdownValue = "1";
    dropDownList = getTypes()!;
    checkbox = false;
  }

  List<Event> _getEventsfromDay(DateTime date) {
    //print(selectedEvents.length);
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: /* (ResponsiveBuilder.isDesktop(context))
          ? null
          : */
          Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: kSpacing),
          child: _Sidebar(data: getSelectedProject()),
        ),
      ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: getProfil()),
            const SizedBox(height: kSpacing),
            Visibility(
              visible: int.parse(list[0], radix: 16)
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
                          AsyncSnapshot<List<Records>> snapshot) =>
                      snapshot.hasData
                          ? Visibility(
                              visible: int.parse(list[0], radix: 16)
                                          .toRadixString(2)
                                          .padLeft(8, "0")
                                          .toString()[7] ==
                                      "1"
                                  ? true
                                  : false,
                              child: Autocomplete<Records>(
                                initialValue: TextEditingValue(
                                    text: GetStorage().read('user') ?? ""),
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
                                  setState(() {
                                    flag = false;
                                    adUserId = selection.id!;
                                    //flag = true;
                                  });
                                  getAllEvents();

                                  //print(salesrepValue);
                                },
                              ),
                            )
                          : Visibility(
                              visible: int.parse(list[0], radix: 16)
                                          .toRadixString(2)
                                          .padLeft(8, "0")
                                          .toString()[7] ==
                                      "1"
                                  ? true
                                  : false,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                ),
              ),
            ),
            flag
                ? TableCalendar(
                    locale: 'languageCalendar'.tr,
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    calendarFormat: format,
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(
                          color: Colors.yellow, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      //formatButtonVisible: false,
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    onFormatChanged: (CalendarFormat format) {
                      setState(() {
                        format = format;
                      });
                    },
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                      //print(focusedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    onHeaderLongPressed: (date) {
                      /* showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Add Event".tr,
                          ),
                          content: DropdownButton(
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
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel".tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                setState(() {});
                                switch (dropdownValue) {
                                  case "1":
                                    Get.off(const CreateCalendarEvent());
                                    break;
                                  default:
                                }
                              },
                              child: Text("Accept".tr),
                            ),
                          ],
                        ),
                      ); */
                      Get.off(const CreateCalendarEvent(),
                          arguments: {"adUserId": adUserId});
                    },
                    eventLoader: _getEventsfromDay,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => /* ListTile(
                title: Text(
                  event.title,
                ),
              ), */
                  Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(64, 75, 96, .9)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                        tooltip: 'Edit Event'.tr,
                        onPressed: () {
                          Get.off(const EditWorkOrderCalendarEvent(),
                              arguments: {
                                "id": event.id,
                                "name": event.title,
                                "description": event.description,
                                "typeId": event.typeId,
                                "startDate": event.scheduledStartDate,
                                "startTime": event.scheduledStartTime,
                                "endTime": event.scheduledEndTime,
                                "statusId": event.statusId,
                              });
                        },
                      ),
                    ),
                    title: Text(
                      event.cBPartner,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.timelapse,
                        color: event.statusId == "DR"
                            ? Colors.yellow
                            : event.statusId == "CO"
                                ? Colors.green
                                : event.statusId == "IN"
                                    ? Colors.grey
                                    : event.statusId == "PR"
                                        ? Colors.orange
                                        : event.statusId == "IP"
                                            ? Colors.white
                                            : event.statusId == "CF"
                                                ? Colors.lightGreen
                                                : event.statusId == "NY"
                                                    ? Colors.red
                                                    : event.statusId == "WP"
                                                        ? Colors.yellow
                                                        : Colors.red,
                      ),
                      onPressed: () {},
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              event.title,
                              style: const TextStyle(color: Colors.white),
                            )),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.event,
                              color: Colors.white,
                            ),
                            Text(
                              '${event.startDate}   ${event.scheduledStartTime} - ${event.scheduledEndTime}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: event.workOrderId != 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      //print(event.workOrderId);

                                      Get.offNamed('/MaintenanceMptask',
                                          arguments: {
                                            'notificationId': event.workOrderId
                                          });
                                    },
                                    child: Text(
                                      event.workOrderName,
                                      style:
                                          const TextStyle(color: kNotifColor),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    children: [
                      Visibility(
                        visible: event.refname != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "User : ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(event.refname),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.phone != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "Phone: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              tooltip: 'Call',
                              onPressed: () {
                                //log("info button pressed");
                                if (event.phone != 'N/A') {
                                  makePhoneCall(event.phone.toString());
                                }
                              },
                            ),
                            Text(event.phone),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.ref2name != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "User 2: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(event.ref2name),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.phone2 != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "Phone 2: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              tooltip: 'Call',
                              onPressed: () {
                                //log("info button pressed");
                                if (event.phone != 'N/A') {
                                  makePhoneCall(event.phone.toString());
                                }
                              },
                            ),
                            Text(event.phone2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: getProfil()),
            const SizedBox(height: kSpacing),
            Visibility(
              visible: int.parse(list[0], radix: 16)
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
                          AsyncSnapshot<List<Records>> snapshot) =>
                      snapshot.hasData
                          ? Autocomplete<Records>(
                              initialValue: TextEditingValue(
                                  text: GetStorage().read('user') ?? ""),
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (Records selection) {
                                //debugPrint(
                                //'You just selected ${_displayStringForOption(selection)}');
                                setState(() {
                                  flag = false;
                                  adUserId = selection.id!;
                                  //flag = true;
                                });
                                getAllEvents();

                                //print(salesrepValue);
                              },
                            )
                          : Visibility(
                              visible: int.parse(list[0], radix: 16)
                                          .toRadixString(2)
                                          .padLeft(8, "0")
                                          .toString()[7] ==
                                      "1"
                                  ? true
                                  : false,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                ),
              ),
            ),
            flag
                ? TableCalendar(
                    locale: 'languageCalendar'.tr,
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    calendarFormat: format,
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(
                          color: Colors.yellow, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      //formatButtonVisible: false,
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    onFormatChanged: (CalendarFormat format) {
                      setState(() {
                        format = format;
                      });
                    },
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                      //print(focusedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    onHeaderLongPressed: (date) {
                      /* showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Add Event".tr,
                          ),
                          content: DropdownButton(
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
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel".tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                setState(() {});
                                switch (dropdownValue) {
                                  case "1":
                                    Get.off(const CreateCalendarEvent());
                                    break;
                                  default:
                                }
                              },
                              child: Text("Accept".tr),
                            ),
                          ],
                        ),
                      ); */
                      Get.off(const CreateCalendarEvent(),
                          arguments: {"adUserId": adUserId});
                    },
                    eventLoader: _getEventsfromDay,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => /* ListTile(
                title: Text(
                  event.title,
                ),
              ), */
                  Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(64, 75, 96, .9)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                        tooltip: 'Edit Event'.tr,
                        onPressed: () {
                          Get.off(const EditCalendarEvent(), arguments: {
                            "id": event.id,
                            "name": event.title,
                            "description": event.description,
                            "typeId": event.typeId,
                            "startDate": event.scheduledStartDate,
                            "startTime": event.scheduledStartTime,
                            "endTime": event.scheduledEndTime,
                            "statusId": event.statusId,
                          });
                        },
                      ),
                    ),
                    title: Text(
                      event.cBPartner,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.timelapse,
                        color: event.statusId == "DR"
                            ? Colors.yellow
                            : event.statusId == "CO"
                                ? Colors.green
                                : event.statusId == "IN"
                                    ? Colors.grey
                                    : event.statusId == "PR"
                                        ? Colors.orange
                                        : event.statusId == "IP"
                                            ? Colors.white
                                            : event.statusId == "CF"
                                                ? Colors.lightGreen
                                                : event.statusId == "NY"
                                                    ? Colors.red
                                                    : event.statusId == "WP"
                                                        ? Colors.yellow
                                                        : Colors.red,
                      ),
                      onPressed: () {},
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              event.title,
                              style: const TextStyle(color: Colors.white),
                            )),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.event,
                              color: Colors.white,
                            ),
                            Text(
                              '${event.startDate}   ${event.scheduledStartTime} - ${event.scheduledEndTime}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    children: [
                      Visibility(
                        visible: event.refname != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "User : ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(event.refname),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.phone != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "Phone: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              tooltip: 'Call',
                              onPressed: () {
                                //log("info button pressed");
                                if (event.phone != 'N/A') {
                                  makePhoneCall(event.phone.toString());
                                }
                              },
                            ),
                            Text(event.phone),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.ref2name != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "User 2: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(event.ref2name),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.phone2 != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "Phone 2: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              tooltip: 'Call',
                              onPressed: () {
                                //log("info button pressed");
                                if (event.phone != 'N/A') {
                                  makePhoneCall(event.phone.toString());
                                }
                              },
                            ),
                            Text(event.phone2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        },
        desktopBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: getProfil()),
            const SizedBox(height: kSpacing),
            Visibility(
              visible: int.parse(list[0], radix: 16)
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
                          AsyncSnapshot<List<Records>> snapshot) =>
                      snapshot.hasData
                          ? Autocomplete<Records>(
                              initialValue: TextEditingValue(
                                  text: GetStorage().read('user') ?? ""),
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (Records selection) {
                                //debugPrint(
                                //'You just selected ${_displayStringForOption(selection)}');
                                setState(() {
                                  flag = false;
                                  adUserId = selection.id!;
                                  //flag = true;
                                });
                                getAllEvents();

                                //print(salesrepValue);
                              },
                            )
                          : Visibility(
                              visible: int.parse(list[0], radix: 16)
                                          .toRadixString(2)
                                          .padLeft(8, "0")
                                          .toString()[7] ==
                                      "1"
                                  ? true
                                  : false,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                ),
              ),
            ),
            flag
                ? TableCalendar(
                    locale: 'languageCalendar'.tr,
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    calendarFormat: format,
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(
                          color: Colors.yellow, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      //formatButtonVisible: false,
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    onFormatChanged: (CalendarFormat format) {
                      setState(() {
                        format = format;
                      });
                    },
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                      //print(focusedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    onHeaderLongPressed: (date) {
                      /* showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Add Event".tr,
                          ),
                          content: DropdownButton(
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
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Cancel".tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                setState(() {});
                                switch (dropdownValue) {
                                  case "1":
                                    Get.off(const CreateCalendarEvent());
                                    break;
                                  default:
                                }
                              },
                              child: Text("Accept".tr),
                            ),
                          ],
                        ),
                      ); */
                      Get.off(const CreateCalendarEvent(),
                          arguments: {"adUserId": adUserId});
                    },
                    eventLoader: _getEventsfromDay,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => /* ListTile(
                title: Text(
                  event.title,
                ),
              ), */
                  Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(64, 75, 96, .9)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                        tooltip: 'Edit Event'.tr,
                        onPressed: () {
                          Get.off(const EditCalendarEvent(), arguments: {
                            "id": event.id,
                            "name": event.title,
                            "description": event.description,
                            "typeId": event.typeId,
                            "startDate": event.scheduledStartDate,
                            "startTime": event.scheduledStartTime,
                            "endTime": event.scheduledEndTime,
                            "statusId": event.statusId,
                          });
                        },
                      ),
                    ),
                    title: Text(
                      event.cBPartner,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.timelapse,
                        color: event.statusId == "DR"
                            ? Colors.yellow
                            : event.statusId == "CO"
                                ? Colors.green
                                : event.statusId == "IN"
                                    ? Colors.grey
                                    : event.statusId == "PR"
                                        ? Colors.orange
                                        : event.statusId == "IP"
                                            ? Colors.white
                                            : event.statusId == "CF"
                                                ? Colors.lightGreen
                                                : event.statusId == "NY"
                                                    ? Colors.red
                                                    : event.statusId == "WP"
                                                        ? Colors.yellow
                                                        : Colors.red,
                      ),
                      onPressed: () {},
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              event.title,
                              style: const TextStyle(color: Colors.white),
                            )),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.event,
                              color: Colors.white,
                            ),
                            Text(
                              '${event.startDate}   ${event.scheduledStartTime} - ${event.scheduledEndTime}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    children: [
                      Visibility(
                        visible: event.refname != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "User : ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(event.refname),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.phone != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "Phone: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              tooltip: 'Call',
                              onPressed: () {
                                //log("info button pressed");
                                if (event.phone != 'N/A') {
                                  makePhoneCall(event.phone.toString());
                                }
                              },
                            ),
                            Text(event.phone),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.ref2name != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "User 2: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(event.ref2name),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: event.phone2 != 'N/A' ? true : false,
                        child: Row(
                          children: [
                            Text(
                              "Phone 2: ".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              tooltip: 'Call',
                              onPressed: () {
                                //log("info button pressed");
                                if (event.phone != 'N/A') {
                                  makePhoneCall(event.phone.toString());
                                }
                              },
                            ),
                            Text(event.phone2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        },
      )),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const Expanded(child: _Header()),
        ],
      ),
    );
  }

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalUndone: 10,
                      totalTaskInProress: 2,
                    ),
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "1st Sprint",
                      doneTask: 5,
                      percent: .3,
                      task: 3,
                      undoneTask: 2,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalUndone: 10,
                    totalTaskInProress: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "1st Sprint",
                    doneTask: 5,
                    percent: .3,
                    task: 3,
                    undoneTask: 2,
                  ),
                ),
              ],
            ),
    );
  }

  /* Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: _OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget _buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  } */

  Widget _buildProfile({required _Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ProfilTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }

  Widget _buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }

  _Profile getProfil() {
    String userName = GetStorage().read('user') as String;
    String roleName = GetStorage().read('rolename') as String;
    return _Profile(
      photo: const AssetImage(ImageRasterPath.avatar1),
      name: userName,
      email: roleName,
    );
  }

  List<TaskCardData> getAllTask() {
    //List<TaskCardData> list;

    return [
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Lead');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Lead",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar1),
          const AssetImage(ImageRasterPath.avatar2),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Opportunity');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Opportunità",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Contatti');
        },
        addFunction: () {},
        title: "Contatti Business Partner",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
          const AssetImage(ImageRasterPath.avatar2),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Clienti');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Clienti BP",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Task&Appuntamenti');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Task e Appuntamenti",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Offerte');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Offerte",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Fattura');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Fatture di Vendita",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Incassi');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Incassi",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Provvigioni');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Provvigioni",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "Calendario",
      releaseTime: DateTime.now(),
    );
  }

  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo2),
        projectName: "Taxi Online",
        releaseTime: DateTime.now().add(const Duration(days: 130)),
      ),
      ProjectCardData(
        percent: .5,
        projectImage: const AssetImage(ImageRasterPath.logo3),
        projectName: "E-Movies Mobile",
        releaseTime: DateTime.now().add(const Duration(days: 140)),
      ),
      ProjectCardData(
        percent: .8,
        projectImage: const AssetImage(ImageRasterPath.logo4),
        projectName: "Video Converter App",
        releaseTime: DateTime.now().add(const Duration(days: 100)),
      ),
    ];
  }

  List<ImageProvider> getMember() {
    return const [
      AssetImage(ImageRasterPath.avatar1),
      AssetImage(ImageRasterPath.avatar2),
      AssetImage(ImageRasterPath.avatar3),
      AssetImage(ImageRasterPath.avatar4),
      AssetImage(ImageRasterPath.avatar5),
      AssetImage(ImageRasterPath.avatar6),
    ];
  }

  List<ChattingCardData> getChatting() {
    return const [
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar6),
        isOnline: true,
        name: "Samantha",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar3),
        isOnline: false,
        name: "John",
        lastMessage: "well done john",
        isRead: true,
        totalUnread: 0,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar4),
        isOnline: true,
        name: "Alexander Purwoto",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];
  }
}

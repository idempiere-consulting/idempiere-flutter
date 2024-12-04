import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/models/project_json.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_tasks_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';

class DashboardFinishedTasks extends StatefulWidget {
  const DashboardFinishedTasks({Key? key}) : super(key: key);

  @override
  State<DashboardFinishedTasks> createState() => _DashboardFinishedTasksState();
}

class _DashboardFinishedTasksState extends State<DashboardFinishedTasks> {
  Future<void> getLeads() async {
    setState(() {
      dataAvailable = false;
    });
    var now = DateTime.now();
    //DateTime fiftyDaysAgo = now.subtract(const Duration(days: 60));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/jp_todo?\$filter= JP_ToDo_Status eq \'CO\' and JP_ToDo_Type eq \'S\' and AD_User_ID eq ${GetStorage().read('userId')} and JP_ToDo_ScheduledStartDate ge \'$formattedDate 00:00:00\' and JP_ToDo_ScheduledStartDate le \'$formattedDate 23:59:59\'&\$orderby=JP_ToDo_Status desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      _trx = EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      setState(() {
        dataAvailable = true;
      });
    }
  }

  EventJson _trx = EventJson(records: []);
  bool dataAvailable = false;

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getLeads();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Done Today'.tr),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
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
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.task,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Task'.tr,
                                    onPressed: () {},
                                  ),
                                ),
                                title: Text(
                                  _trx.records![index].name ?? "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " ${_trx.records![index].jPToDoScheduledStartTime!.substring(0, 5)} - ${_trx.records![index].jPToDoScheduledEndTime!.substring(0, 5)}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.timelapse,
                                    color:
                                        _trx.records![index].jPToDoStatus!.id ==
                                                "WP"
                                            ? Colors.yellow
                                            : _trx.records![index].jPToDoStatus!
                                                        .id ==
                                                    "CO"
                                                ? Colors.green
                                                : Colors.red,
                                  ),
                                  onPressed: () {},
                                ),
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Business Partner: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(_trx.records![index]
                                                    .cBPartnerID?.identifier ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          Text(
                                            "Description: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(_trx.records![index]
                                                    .description ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
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
      ),
    );
  }
}

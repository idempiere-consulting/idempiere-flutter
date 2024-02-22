import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TicketClientTicketCalendar extends StatefulWidget {
  const TicketClientTicketCalendar({Key? key}) : super(key: key);

  @override
  State<TicketClientTicketCalendar> createState() =>
      _TicketClientTicketCalendarState();
}

class _TicketClientTicketCalendarState
    extends State<TicketClientTicketCalendar> {
  Future<void> getJpToDO() async {
    setState(() {
      dataAvailable = false;
    });

    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/jp_todo?\$filter= R_Request_ID eq ${args['requestId']} and AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= JP_ToDo_ScheduledStartDate desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      _trx = EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      setState(() {
        dataAvailable = true;
      });
    } else {
      //print(response.body);
    }
  }

  EventJson get trx => _trx;

  var args = Get.arguments;
  EventJson _trx = EventJson(records: []);

  bool dataAvailable = false;

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getJpToDO();
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Work Done'.tr),
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
                        itemCount: _trx.records!.length,
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
                                      color: Colors.white,
                                    ),
                                    //tooltip: 'Edit Task'.tr,
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

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            _trx.records![index].description ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${DateTime.tryParse(_trx.records![index].jPToDoScheduledStartDate ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].jPToDoScheduledStartDate!)) : ""}  ${_trx.records![index].qty != 1 ? '${_trx.records![index].qty} ${'Hours'.tr}' : '${_trx.records![index].qty} ${'Hour'.tr}'}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.handshake,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _trx.records![index].cBPartnerID
                                                    ?.identifier ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                        visible:
                                            _trx.records![index].cProjectID !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${'Project'.tr}: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Text(_trx.records![index]
                                                      .cProjectID?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            _trx.records![index].aDUserID !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${'User'.tr}: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Text(_trx.records![index]
                                                      .aDUserID?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
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
                        itemCount: _trx.records!.length,
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
                                      color: Colors.white,
                                    ),
                                    //tooltip: 'Edit Task'.tr,
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

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            _trx.records![index].description ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${DateTime.tryParse(_trx.records![index].jPToDoScheduledStartDate ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].jPToDoScheduledStartDate!)) : ""}  ${_trx.records![index].qty != 1 ? '${_trx.records![index].qty} ${'Hours'.tr}' : '${_trx.records![index].qty} ${'Hour'.tr}'}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.handshake,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _trx.records![index].cBPartnerID
                                                    ?.identifier ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                        visible:
                                            _trx.records![index].cProjectID !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${'Project'.tr}: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Text(_trx.records![index]
                                                      .cProjectID?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            _trx.records![index].aDUserID !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${'User'.tr}: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Text(_trx.records![index]
                                                      .aDUserID?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
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
                        itemCount: _trx.records!.length,
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
                                      color: Colors.white,
                                    ),
                                    //tooltip: 'Edit Task'.tr,
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

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            _trx.records![index].description ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${DateTime.tryParse(_trx.records![index].jPToDoScheduledStartDate ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].jPToDoScheduledStartDate!)) : ""}  ${_trx.records![index].qty != 1 ? '${_trx.records![index].qty} ${'Hours'.tr}' : '${_trx.records![index].qty} ${'Hour'.tr}'}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.handshake,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _trx.records![index].cBPartnerID
                                                    ?.identifier ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                        visible:
                                            _trx.records![index].cProjectID !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${'Project'.tr}: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Text(_trx.records![index]
                                                      .cProjectID?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            _trx.records![index].aDUserID !=
                                                null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${'User'.tr}: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Text(_trx.records![index]
                                                      .aDUserID?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
//import 'dart:developer';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/infocount_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class MaintenanceMptaskInfo extends StatefulWidget {
  const MaintenanceMptaskInfo({Key? key}) : super(key: key);

  @override
  State<MaintenanceMptaskInfo> createState() => _MaintenanceMptaskInfoState();
}

class _MaintenanceMptaskInfoState extends State<MaintenanceMptaskInfo> {
  getWorkOrderInfo() async {
    //print('hello');
    setState(() {
      dataAvailable = false;
    });
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '${'$protocol://' + ip}/api/v1/models/lit_mp_main_res_totct_v?\$filter=  MP_OT_ID eq ${Get.arguments["id"]}');

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
      trx = InfoCountJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < trx.records!.length; i++) {
        if ((tableRows
            .where((element) =>
                element.categoryName == trx.records![i].categoryName)
            .isEmpty)) {
          tableRows.add(Records(
            categoryName: trx.records![i].categoryName,
            pcCount: trx.records![i].pcCount ?? "0",
            prCount: trx.records![i].prCount ?? "0",
            ptCount: trx.records![i].ptCount ?? "0",
            pxCount: trx.records![i].pxCount ?? "0",
          ));
        } else {
          for (var j = 0; j < tableRows.length; j++) {
            if (tableRows[j].categoryName == trx.records![i].categoryName) {
              tableRows[j].pcCount = (int.parse(tableRows[j].pcCount ?? "0") +
                      int.parse(trx.records![i].pcCount ?? "0"))
                  .toString();
              tableRows[j].prCount = (int.parse(tableRows[j].prCount ?? "0") +
                      int.parse(trx.records![i].prCount ?? "0"))
                  .toString();
              tableRows[j].ptCount = (int.parse(tableRows[j].ptCount ?? "0") +
                      int.parse(trx.records![i].ptCount ?? "0"))
                  .toString();
              tableRows[j].pxCount = (int.parse(tableRows[j].pxCount ?? "0") +
                      int.parse(trx.records![i].pxCount ?? "0"))
                  .toString();
            }
          }
        }
      }

      //InfoCountJSON list = InfoCountJSON(records: []);

      /* trx.records!.retainWhere((element) =>
          element.revisionCount == "0" && element.testingCount == "0"); */

      setState(() {
        dataAvailable = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  bool dataAvailable = false;
  late InfoCountJSON trx;

  List<Records> tableRows = [];

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getWorkOrderInfo();
    //getWorkOrderInfo();
    //print('hello');
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(Get.arguments["docN"]),
              Text('Summary Info'.tr),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: dataAvailable
                      ? DataTable2(
                          columns: [
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Category'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot C'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot R'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot CL'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot X'.tr),
                              ],
                            )),
                          ],
                          rows: tableRows
                              .map((e) => DataRow(cells: [
                                    DataCell(Tooltip(
                                        message: e.categoryName ?? "N/A",
                                        child: Text(e.categoryName ?? "N/A"))),
                                    DataCell(Text(
                                      e.pcCount ?? "N/A",
                                      textAlign: TextAlign.end,
                                    )),
                                    DataCell(Text(e.prCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                    DataCell(Text(e.ptCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                    DataCell(Text(e.pxCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                  ]))
                              .toList(),
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: dataAvailable
                      ? DataTable2(
                          columns: [
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Category'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot C'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot R'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot CL'.tr),
                              ],
                            )),
                          ],
                          rows: tableRows
                              .map((e) => DataRow(cells: [
                                    DataCell(Tooltip(
                                        message: e.categoryName ?? "N/A",
                                        child: Text(e.categoryName ?? "N/A"))),
                                    DataCell(Text(
                                      e.pcCount ?? "N/A",
                                      textAlign: TextAlign.end,
                                    )),
                                    DataCell(Text(e.prCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                    DataCell(Text(e.ptCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                  ]))
                              .toList(),
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: dataAvailable
                      ? DataTable2(
                          columns: [
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Category'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot C'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot R'.tr),
                              ],
                            )),
                            DataColumn(
                                label: Row(
                              children: [
                                Text('Tot CL'.tr),
                              ],
                            )),
                          ],
                          rows: tableRows
                              .map((e) => DataRow(cells: [
                                    DataCell(Tooltip(
                                        message: e.categoryName ?? "N/A",
                                        child: Text(e.categoryName ?? "N/A"))),
                                    DataCell(Text(
                                      e.pcCount ?? "N/A",
                                      textAlign: TextAlign.end,
                                    )),
                                    DataCell(Text(e.prCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                    DataCell(Text(e.ptCount ?? "N/A",
                                        textAlign: TextAlign.end)),
                                  ]))
                              .toList(),
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/business_partner_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/infocount_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/resource_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_mp_resource_testcount_v?\$filter= lit_mp_resource_testcount_v_ID eq ${Get.arguments["id"]}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      trx = InfoCountJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      List<PlutoRow> newRows = [];
      for (var element in trx.records!) {
        PlutoRow row = PlutoRow(cells: {
          'Product'.tr: PlutoCell(value: element.mProductID?.identifier),
          'Revision'.tr: PlutoCell(value: element.revisionCount),
          'Testing'.tr: PlutoCell(value: element.testingCount),
        });
        newRows.add(row);
      }
      stateManager.appendRows(newRows);

      setState(() {
        dataAvailable = true;
      });
    } else {
      print(response.body);
    }
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      //readOnly: true,
      title: 'Product'.tr,
      field: 'Product'.tr,
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Revision'.tr,
      field: 'Revisione'.tr,
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Testing'.tr,
      field: 'Testing'.tr,
      type: PlutoColumnType.number(),
    ),
  ];
  List<PlutoRow> rows = [];
  late final PlutoGridStateManager stateManager;
  bool dataAvailable = false;
  late InfoCountJSON trx;

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getWorkOrderInfo();
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
                  height: size.height,
                  width: size.width,
                  //padding: const EdgeInsets.all(15),
                  child: PlutoGrid(
                    columns: columns,
                    rows: rows,
                    //columnGroups: controllecolumnGroups,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;
                      getWorkOrderInfo();
                    },
                    onChanged: (PlutoGridOnChangedEvent event) {},
                    configuration: const PlutoGridConfiguration(
                      enableColumnBorder: true,
                    ),
                  ),
                )
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

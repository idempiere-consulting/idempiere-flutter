library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/reflist_resource_type_json.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_resource_anomaly.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
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
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

// binding
part '../../bindings/maintenance_mptask_resource_binding.dart';

// controller
part '../../controllers/maintenance_mptask_resource_controller.dart';

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

class MaintenanceMpResourceScreen
    extends GetView<MaintenanceMpResourceController> {
  const MaintenanceMpResourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                controller.handleAddRows();
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ], */
        centerTitle: true,
        title: Column(
          children: [
            Text("${GetStorage().read('selectedTaskDocNo')}"),
            Text("${GetStorage().read('selectedTaskBP')}"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.offNamed('/MaintenanceMptaskLine');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing),
              Row(
                children: [
                  Container(
                    child: Obx(() => controller.dataAvailable
                        ? Text("RESOURCES: ${controller.trx.rowcount}")
                        : const Text("RESOURCES: ")),
                    margin: const EdgeInsets.only(left: 15),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        //Get.to(const CreateMaintenanceMpResource());
                        controller.openResourceType();
                      },
                      icon: const Icon(
                        Icons.note_add_outlined,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        //controller.syncWorkOrder();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ), */
                ],
              ),
              //const SizedBox(height: 5),
              Row(
                //mainAxisAlignment: MainAxisAlignment.,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => DropdownButton(
                        value: controller.dropDownValue2.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue2.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt2.records!.map((list) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              list.name.toString(),
                            ),
                            value: list.value,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kSpacing),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: GetStorage().read('selectedTaskDocNo') ==
                                controller.trx.records![index].mpOtDocumentno,
                            child: Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.timer_outlined,
                                      color: (controller.trx.records![index]
                                                      .lITControl2DateNext)
                                                  ?.substring(0, 4) ==
                                              controller.now.year.toString()
                                          ? Colors.yellow
                                          : (controller.trx.records![index]
                                                          .lITControl3DateNext)
                                                      ?.substring(0, 4) ==
                                                  controller.now.year.toString()
                                              ? Colors.orange
                                              : Colors.green,
                                    ),
                                  ),
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
                                      icon: Icon(
                                        controller.trx.records![index].eDIType
                                                    ?.id ==
                                                'A2'
                                            ? Icons.grid_4x4_outlined
                                            : Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Resource',
                                      onPressed: () {
                                        switch (controller
                                            .trx.records![index].eDIType?.id) {
                                          case "A1":
                                            if (controller.trx.records![index]
                                                    .offlineId ==
                                                null) {
                                              Get.toNamed(
                                                  '/MaintenanceMpResourceSheet',
                                                  arguments: {
                                                    "surveyId": controller
                                                        .trx
                                                        .records![index]
                                                        .lITSurveySheetsID
                                                        ?.id,
                                                    "id": controller
                                                        .trx.records![index].id,
                                                    "serNo": controller
                                                            .trx
                                                            .records![index]
                                                            .serNo ??
                                                        "",
                                                    "prodId": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.id,
                                                    "prodName": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier,
                                                    "lot": controller.trx
                                                        .records![index].lot,
                                                    "location": controller
                                                        .trx
                                                        .records![index]
                                                        .locationComment,
                                                    "locationCode": controller
                                                        .trx
                                                        .records![index]
                                                        .value,
                                                    "manYear": controller
                                                        .trx
                                                        .records![index]
                                                        .manufacturedYear,
                                                    "userName": controller
                                                        .trx
                                                        .records![index]
                                                        .userName,
                                                    "serviceDate": controller
                                                        .trx
                                                        .records![index]
                                                        .serviceDate,
                                                    "endDate": controller
                                                        .trx
                                                        .records![index]
                                                        .endDate,
                                                    "manufacturer": controller
                                                        .trx
                                                        .records![index]
                                                        .manufacturer,
                                                    "model": controller
                                                        .trx
                                                        .records![index]
                                                        .lITProductModel,
                                                    "manufacturedYear":
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .manufacturedYear,
                                                    "purchaseDate": controller
                                                        .trx
                                                        .records![index]
                                                        .dateOrdered,
                                                    "note": controller.trx
                                                        .records![index].name,
                                                    "resTypeId": controller
                                                        .trx
                                                        .records![index]
                                                        .lITResourceType
                                                        ?.id,
                                                    "valid": controller
                                                        .trx
                                                        .records![index]
                                                        .isValid,
                                                    "offlineid": controller
                                                        .trx
                                                        .records![index]
                                                        .offlineId,
                                                    "index": index,
                                                  });
                                            }

                                            break;
                                          case 'A2':
                                            Get.toNamed(
                                                '/MaintenanceMpResourceFireExtinguisherGrid');
                                            break;
                                          default:
                                        }
                                        /* Get.to(
                                            const EditMaintenanceMpResource(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "productName": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "SerNo": controller
                                                  .trx.records![index].serNo,
                                              "Description": controller.trx
                                                  .records![index].description,
                                              "date3": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl3DateFrom,
                                              "date2": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl2DateFrom,
                                              "date1": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": controller.trx
                                                  .records![index].offlineId,
                                              "index": index,
                                            }); */
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.records![index].mProductID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(
                                          Icons.settings_input_component),
                                      Expanded(
                                        child: Text(
                                          controller.trx.records![index]
                                                  .resourceType?.identifier ??
                                              "??",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
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
                                        Row(children: [
                                          const Text('Quantity: '),
                                          Text(
                                              "${controller.trx.records![index].resourceQty}"),
                                        ]),
                                        Row(children: [
                                          const Text('Note: '),
                                          Text(controller
                                                  .trx.records![index].name ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Descrizione: '),
                                          Text(controller.trx.records![index]
                                                  .description ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateNext ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateNext ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateNext ??
                                              "??"),
                                        ]),
                                        controller.trx.records![index].eDIType
                                                    ?.id ==
                                                "A2"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                    IconButton(
                                                      tooltip: 'Check',
                                                      onPressed: () async {
                                                        var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                          Icons.content_paste),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Revision',
                                                      onPressed: () async {
                                                        var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                          Icons.search),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Testing',
                                                      onPressed: () async {
                                                        var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                          Icons.gavel_sharp),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Anomaly',
                                                      onPressed: () async {
                                                        var isConnected =
                                                            await checkConnection();
                                                        if (isConnected) {
                                                          await emptyPostCallStack();
                                                          await emptyEditAPICallStack();
                                                          await emptyDeleteCallStack();

                                                          Get.to(
                                                              const CreateResAnomaly(),
                                                              arguments: {
                                                                "id": controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .id,
                                                                "docNo": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .mpOtDocumentno ??
                                                                    "",
                                                                "productId": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .mProductID
                                                                        ?.id ??
                                                                    0,
                                                                "productName": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .mProductID
                                                                        ?.identifier ??
                                                                    "",
                                                              });
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ])
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Anomaly',
                                                    onPressed: () async {
                                                      var isConnected =
                                                          await checkConnection();
                                                      if (isConnected) {
                                                        await emptyPostCallStack();
                                                        await emptyEditAPICallStack();
                                                        await emptyDeleteCallStack();

                                                        Get.to(
                                                            const CreateResAnomaly(),
                                                            arguments: {
                                                              "docNo": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .mpOtDocumentno ??
                                                                  "",
                                                              "productId": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID
                                                                      ?.id ??
                                                                  0,
                                                              "productName": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID
                                                                      ?.identifier ??
                                                                  "",
                                                            });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.warning,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]);
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing),
              Row(
                children: [
                  Container(
                    child: Obx(() => controller.dataAvailable
                        ? Text("RESOURCES: ${controller.trx.rowcount}")
                        : const Text("RESOURCES: ")),
                    margin: const EdgeInsets.only(left: 15),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        //Get.to(const CreateMaintenanceMpResource());
                        controller.openResourceType();
                      },
                      icon: const Icon(
                        Icons.note_add_outlined,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        //controller.syncWorkOrder();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ), */
                ],
              ),
              //const SizedBox(height: 5),
              Row(
                //mainAxisAlignment: MainAxisAlignment.,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => DropdownButton(
                        value: controller.dropDownValue2.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue2.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt2.records!.map((list) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              list.name.toString(),
                            ),
                            value: list.value,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kSpacing),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: GetStorage().read('selectedTaskDocNo') ==
                                controller.trx.records![index].mpOtDocumentno,
                            child: Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.timer_outlined,
                                      color: (controller.trx.records![index]
                                                      .lITControl2DateNext)
                                                  ?.substring(0, 4) ==
                                              controller.now.year.toString()
                                          ? Colors.yellow
                                          : (controller.trx.records![index]
                                                          .lITControl3DateNext)
                                                      ?.substring(0, 4) ==
                                                  controller.now.year.toString()
                                              ? Colors.orange
                                              : Colors.green,
                                    ),
                                  ),
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
                                      icon: Icon(
                                        controller.trx.records![index].eDIType
                                                    ?.id ==
                                                'A2'
                                            ? Icons.grid_4x4_outlined
                                            : Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Resource',
                                      onPressed: () {
                                        switch (controller
                                            .trx.records![index].eDIType?.id) {
                                          case "A1":
                                            if (controller.trx.records![index]
                                                    .offlineId ==
                                                null) {
                                              Get.toNamed(
                                                  '/MaintenanceMpResourceSheet',
                                                  arguments: {
                                                    "surveyId": controller
                                                        .trx
                                                        .records![index]
                                                        .lITSurveySheetsID
                                                        ?.id,
                                                    "id": controller
                                                        .trx.records![index].id,
                                                    "serNo": controller
                                                            .trx
                                                            .records![index]
                                                            .serNo ??
                                                        "",
                                                    "prodId": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.id,
                                                    "prodName": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier,
                                                    "lot": controller.trx
                                                        .records![index].lot,
                                                    "location": controller
                                                        .trx
                                                        .records![index]
                                                        .locationComment,
                                                    "locationCode": controller
                                                        .trx
                                                        .records![index]
                                                        .value,
                                                    "manYear": controller
                                                        .trx
                                                        .records![index]
                                                        .manufacturedYear,
                                                    "userName": controller
                                                        .trx
                                                        .records![index]
                                                        .userName,
                                                    "serviceDate": controller
                                                        .trx
                                                        .records![index]
                                                        .serviceDate,
                                                    "endDate": controller
                                                        .trx
                                                        .records![index]
                                                        .endDate,
                                                    "manufacturer": controller
                                                        .trx
                                                        .records![index]
                                                        .manufacturer,
                                                    "model": controller
                                                        .trx
                                                        .records![index]
                                                        .lITProductModel,
                                                    "manufacturedYear":
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .manufacturedYear,
                                                    "purchaseDate": controller
                                                        .trx
                                                        .records![index]
                                                        .dateOrdered,
                                                    "note": controller.trx
                                                        .records![index].name,
                                                    "resTypeId": controller
                                                        .trx
                                                        .records![index]
                                                        .lITResourceType
                                                        ?.id,
                                                    "valid": controller
                                                        .trx
                                                        .records![index]
                                                        .isValid,
                                                    "offlineid": controller
                                                        .trx
                                                        .records![index]
                                                        .offlineId,
                                                    "index": index,
                                                  });
                                            }

                                            break;
                                          case 'A2':
                                            Get.toNamed(
                                                '/MaintenanceMpResourceFireExtinguisherGrid');
                                            break;
                                          default:
                                        }
                                        /* Get.to(
                                            const EditMaintenanceMpResource(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "productName": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "SerNo": controller
                                                  .trx.records![index].serNo,
                                              "Description": controller.trx
                                                  .records![index].description,
                                              "date3": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl3DateFrom,
                                              "date2": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl2DateFrom,
                                              "date1": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": controller.trx
                                                  .records![index].offlineId,
                                              "index": index,
                                            }); */
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.records![index].mProductID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(
                                          Icons.settings_input_component),
                                      Text(
                                        controller.trx.records![index]
                                                .resourceType?.identifier ??
                                            "??",
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                        Row(children: [
                                          const Text('Quantity: '),
                                          Text(
                                              "${controller.trx.records![index].resourceQty}"),
                                        ]),
                                        Row(children: [
                                          const Text('Note: '),
                                          Text(controller
                                                  .trx.records![index].name ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Descrizione: '),
                                          Text(controller.trx.records![index]
                                                  .description ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateNext ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateNext ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateNext ??
                                              "??"),
                                        ]),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .eDIType
                                                  ?.id ==
                                              "A2",
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.content_paste),
                                                ),
                                                IconButton(
                                                  tooltip: 'Revision',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateRevision(
                                                            isConnected, index);
                                                  },
                                                  icon:
                                                      const Icon(Icons.search),
                                                ),
                                                IconButton(
                                                  tooltip: 'Testing',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateTesting(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.gavel_sharp),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]);
          },
          desktopBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing),
              Row(
                children: [
                  Container(
                    child: Obx(() => controller.dataAvailable
                        ? Text("RESOURCES: ${controller.trx.rowcount}")
                        : const Text("RESOURCES: ")),
                    margin: const EdgeInsets.only(left: 15),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        //Get.to(const CreateMaintenanceMpResource());
                        controller.openResourceType();
                      },
                      icon: const Icon(
                        Icons.note_add_outlined,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        //controller.syncWorkOrder();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ), */
                ],
              ),
              //const SizedBox(height: 5),
              Row(
                //mainAxisAlignment: MainAxisAlignment.,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => DropdownButton(
                        value: controller.dropDownValue2.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue2.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt2.records!.map((list) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              list.name.toString(),
                            ),
                            value: list.value,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kSpacing),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: GetStorage().read('selectedTaskDocNo') ==
                                controller.trx.records![index].mpOtDocumentno,
                            child: Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.timer_outlined,
                                      color: (controller.trx.records![index]
                                                      .lITControl2DateNext)
                                                  ?.substring(0, 4) ==
                                              controller.now.year.toString()
                                          ? Colors.yellow
                                          : (controller.trx.records![index]
                                                          .lITControl3DateNext)
                                                      ?.substring(0, 4) ==
                                                  controller.now.year.toString()
                                              ? Colors.orange
                                              : Colors.green,
                                    ),
                                  ),
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
                                      icon: Icon(
                                        controller.trx.records![index].eDIType
                                                    ?.id ==
                                                'A2'
                                            ? Icons.grid_4x4_outlined
                                            : Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Resource',
                                      onPressed: () {
                                        switch (controller
                                            .trx.records![index].eDIType?.id) {
                                          case "A1":
                                            if (controller.trx.records![index]
                                                    .offlineId ==
                                                null) {
                                              Get.toNamed(
                                                  '/MaintenanceMpResourceSheet',
                                                  arguments: {
                                                    "surveyId": controller
                                                        .trx
                                                        .records![index]
                                                        .lITSurveySheetsID
                                                        ?.id,
                                                    "id": controller
                                                        .trx.records![index].id,
                                                    "serNo": controller
                                                            .trx
                                                            .records![index]
                                                            .serNo ??
                                                        "",
                                                    "prodId": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.id,
                                                    "prodName": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier,
                                                    "lot": controller.trx
                                                        .records![index].lot,
                                                    "location": controller
                                                        .trx
                                                        .records![index]
                                                        .locationComment,
                                                    "locationCode": controller
                                                        .trx
                                                        .records![index]
                                                        .value,
                                                    "manYear": controller
                                                        .trx
                                                        .records![index]
                                                        .manufacturedYear,
                                                    "userName": controller
                                                        .trx
                                                        .records![index]
                                                        .userName,
                                                    "serviceDate": controller
                                                        .trx
                                                        .records![index]
                                                        .serviceDate,
                                                    "endDate": controller
                                                        .trx
                                                        .records![index]
                                                        .endDate,
                                                    "manufacturer": controller
                                                        .trx
                                                        .records![index]
                                                        .manufacturer,
                                                    "model": controller
                                                        .trx
                                                        .records![index]
                                                        .lITProductModel,
                                                    "manufacturedYear":
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .manufacturedYear,
                                                    "purchaseDate": controller
                                                        .trx
                                                        .records![index]
                                                        .dateOrdered,
                                                    "note": controller.trx
                                                        .records![index].name,
                                                    "resTypeId": controller
                                                        .trx
                                                        .records![index]
                                                        .lITResourceType
                                                        ?.id,
                                                    "valid": controller
                                                        .trx
                                                        .records![index]
                                                        .isValid,
                                                    "offlineid": controller
                                                        .trx
                                                        .records![index]
                                                        .offlineId,
                                                    "index": index,
                                                  });
                                            }

                                            break;
                                          case 'A2':
                                            Get.toNamed(
                                                '/MaintenanceMpResourceFireExtinguisherGrid');
                                            break;
                                          default:
                                        }
                                        /* Get.to(
                                            const EditMaintenanceMpResource(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "productName": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "SerNo": controller
                                                  .trx.records![index].serNo,
                                              "Description": controller.trx
                                                  .records![index].description,
                                              "date3": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl3DateFrom,
                                              "date2": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl2DateFrom,
                                              "date1": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": controller.trx
                                                  .records![index].offlineId,
                                              "index": index,
                                            }); */
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.records![index].mProductID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(
                                          Icons.settings_input_component),
                                      Text(
                                        controller.trx.records![index]
                                                .resourceType?.identifier ??
                                            "??",
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                        Row(children: [
                                          const Text('Quantity: '),
                                          Text(
                                              "${controller.trx.records![index].resourceQty}"),
                                        ]),
                                        Row(children: [
                                          const Text('Note: '),
                                          Text(controller
                                                  .trx.records![index].name ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Descrizione: '),
                                          Text(controller.trx.records![index]
                                                  .description ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateNext ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateNext ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]),
                                        Row(children: [
                                          const Text('Next Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateNext ??
                                              "??"),
                                        ]),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .eDIType
                                                  ?.id ==
                                              "A2",
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.content_paste),
                                                ),
                                                IconButton(
                                                  tooltip: 'Revision',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateRevision(
                                                            isConnected, index);
                                                  },
                                                  icon:
                                                      const Icon(Icons.search),
                                                ),
                                                IconButton(
                                                  tooltip: 'Testing',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateTesting(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.gavel_sharp),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

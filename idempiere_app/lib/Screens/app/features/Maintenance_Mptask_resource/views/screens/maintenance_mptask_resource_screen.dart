library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_edit_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_A2_Fire_Extinguisher_Grid/views/screens/maintenance_mptask_resource_fire_extinguisher_screen.dart';
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
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// binding
part '../../bindings/maintenance_mptask_resource_binding.dart';

// controller
part '../../controllers/maintenance_mptask_resource_controller.dart';

// models
part '../../models/profile.dart';

// component
part '../components/active_project_card.dart';
part '../components/header.dart';
part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class MaintenanceMpResourceScreen
    extends GetView<MaintenanceMpResourceController> {
  const MaintenanceMpResourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateMaintenanceMpResource());
                      },
                      icon: const Icon(
                        Icons.note_add_outlined,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
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
                                                  "lot": controller
                                                      .trx.records![index].lot,
                                                  "location": controller
                                                      .trx
                                                      .records![index]
                                                      .locationComment,
                                                  "locationCode": controller.trx
                                                      .records![index].value,
                                                  "manYear": controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturedYear,
                                                  "userName": controller.trx
                                                      .records![index].userName,
                                                  "serviceDate": controller
                                                      .trx
                                                      .records![index]
                                                      .serviceDate,
                                                  "endDate": controller.trx
                                                      .records![index].endDate,
                                                  "manufacturer": controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturer,
                                                  "model": controller
                                                      .trx
                                                      .records![index]
                                                      .lITProductModel,
                                                  "manufacturedYear": controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturedYear,
                                                  "purchaseDate": controller
                                                      .trx
                                                      .records![index]
                                                      .dateOrdered,
                                                  "note": controller
                                                      .trx.records![index].name,
                                                  "resTypeId": controller
                                                      .trx
                                                      .records![index]
                                                      .lITResourceType
                                                      ?.id,
                                                  "valid": controller.trx
                                                      .records![index].isValid,
                                                  "offlineid": controller
                                                      .trx
                                                      .records![index]
                                                      .offlineId,
                                                  "index": index,
                                                });

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
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateMaintenanceMpResource());
                      },
                      icon: const Icon(
                        Icons.note_add_outlined,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
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
                                                  "lot": controller
                                                      .trx.records![index].lot,
                                                  "location": controller
                                                      .trx
                                                      .records![index]
                                                      .locationComment,
                                                  "locationCode": controller.trx
                                                      .records![index].value,
                                                  "manYear": controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturedYear,
                                                  "userName": controller.trx
                                                      .records![index].userName,
                                                  "serviceDate": controller
                                                      .trx
                                                      .records![index]
                                                      .serviceDate,
                                                  "endDate": controller.trx
                                                      .records![index].endDate,
                                                  "manufacturer": controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturer,
                                                  "model": controller
                                                      .trx
                                                      .records![index]
                                                      .lITProductModel,
                                                  "manufacturedYear": controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturedYear,
                                                  "purchaseDate": controller
                                                      .trx
                                                      .records![index]
                                                      .dateOrdered,
                                                  "note": controller
                                                      .trx.records![index].name,
                                                  "resTypeId": controller
                                                      .trx
                                                      .records![index]
                                                      .lITResourceType
                                                      ?.id,
                                                  "valid": controller.trx
                                                      .records![index].isValid,
                                                  "offlineid": controller
                                                      .trx
                                                      .records![index]
                                                      .offlineId,
                                                  "index": index,
                                                });

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
            return Container(
              height: size.height,
              width: size.width,
              //padding: const EdgeInsets.all(15),
              child: PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                columnGroups: controller.columnGroups,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  controller.stateManager = event.stateManager;
                },
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                configuration: const PlutoGridConfiguration(
                  enableColumnBorder: true,
                ),
              ),
            );
          },
        ),
      ),
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

  Widget _buildTaskOverview({
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
  }

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
}

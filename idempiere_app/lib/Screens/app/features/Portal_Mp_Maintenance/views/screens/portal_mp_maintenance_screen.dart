// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Maintenance/models/lit_maintain_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Maintenance/models/mp_maintain_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Maintenance/models/mp_maintain_resource_resource_detail_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Maintenance/models/mp_maintain_resources_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Maintenance/models/mp_maintain_task_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/get_premium_card.dart';
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
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/portal_mp_maintenance_binding.dart';

// controller
part '../../controllers/portal_mp_maintenance_controller.dart';

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

class PortalMpMaintenanceMpScreen extends GetView<PortalMpMaintenanceMpController> {
  const PortalMpMaintenanceMpScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    controller.getMPMaintain();
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('Dashboard');
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        drawer: (ResponsiveBuilder.isDesktop(context))
            ? null
            :
            Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: kSpacing),
            child: _Sidebar(data: controller.getSelectedProject()),
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
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      child: Obx(() => controller.dataAvailable
                          ? Text("MAINTENANCES: ${controller.trxMaintain.rowcount}")
                          : const Text("MAINTENANCES: ")),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateMaintenanceMptask());
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
                          controller.getMPMaintain();
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
                          itemCount: controller.trxMaintain.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      /* GetStorage().write(
                                          'selectedWorkOrderId',
                                          controller
                                              .trx.records![index].id);
                                      Get.toNamed('/MaintenanceMptaskLine'); */
                                    },
                                    icon: const Icon(
                                      Icons.view_list,
                                      color: Colors.green,
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
                                      icon: const Icon(
                                        Icons.work,
                                      ),
                                      tooltip: 'Edit MAINTENANCES',
                                      onPressed: () {
                                        //log("info button pressed");
                                        /* Get.to(const EditMaintenanceMptask(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier ??
                                                  "",
                                              "bPartnerLocationId": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerLocationID
                                                      ?.id ??
                                                  "",
                                              "resource":
                                                  controller //serve id risorsa
                                                          .trx
                                                          .records![index]
                                                          .mpOtAdUserName ??
                                                      "",
                                              "dateStart": controller
                                                      .trx
                                                      .records![index]
                                                      .dateWorkStart ??
                                                  ""
                                            }); */
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trxMaintain.records![index].documentNo ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                          
                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(Icons.event),
                                      Text(
                                        controller.trxMaintain.records![index]
                                                .documentNo ??
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
                                        Row(
                                          children: [
                                            const Text(
                                              "Doc Number: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxMaintain.records![index]
                                                    .documentNo ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trxMaintain.records![index].documentNo}"
                                                    .tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */
                                            Icon(Icons.location_pin,
                                                color: Colors.red.shade700),
                                            const Expanded(
                                              child: Text(
                                                  ""),//"${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity}"),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              child:
                                                  Text("Create Sales Order".tr),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                /* Get.defaultDialog(
                                                        title: 'Complete Action',
                                                        content: const Text(
                                                            "Are you sure you want to complete the record?"),
                                                        onCancel: () {},
                                                        onConfirm: () async {
                                                          final ip = GetStorage()
                                                              .read('ip');
                                                          String authorization =
                                                              'Bearer ' +
                                                                  GetStorage().read(
                                                                      'token');
                                                          final msg = jsonEncode({
                                                            "DocAction": "CO",
                                                          });
                                                          final protocol =
                                                              GetStorage()
                                                                  .read('protocol');
                                                          var url = Uri.parse(
                                                              '$protocol://' +
                                                                  ip +
                                                                  '/api/v1/models/c_order/${controller.trx.records![index].id}');
                            
                                                          var response =
                                                              await http.put(
                                                            url,
                                                            body: msg,
                                                            headers: <String,
                                                                String>{
                                                              'Content-Type':
                                                                  'application/json',
                                                              'Authorization':
                                                                  authorization,
                                                            },
                                                          );
                                                          if (response.statusCode ==
                                                              200) {
                                                            //print("done!");
                                                            completeOrder(index);
                                                          } else {
                                                            //print(response.body);
                                                            Get.snackbar(
                                                              "Error!".tr,
                                                              "Record not completed".tr,
                                                              icon: const Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ); */
                                              },
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
                      : const Center(child: CircularProgressIndicator()),
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
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      child: Obx(() => controller.dataAvailable
                          ? Text("MAINTENANCES: ${controller.trxMaintain.rowcount}")
                          : const Text("MAINTENANCES: ")),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateMaintenanceMptask());
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
                          controller.getMPMaintain();
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
                          itemCount: controller.trxMaintain.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      /* GetStorage().write(
                                          'selectedWorkOrderId',
                                          controller
                                              .trx.records![index].id);
                                      Get.toNamed('/MaintenanceMptaskLine'); */
                                    },
                                    icon: const Icon(
                                      Icons.view_list,
                                      color: Colors.green,
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
                                      icon: const Icon(
                                        Icons.work,
                                      ),
                                      tooltip: 'Edit MAINTENANCES',
                                      onPressed: () {
                                        //log("info button pressed");
                                        /* Get.to(const EditMaintenanceMptask(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier ??
                                                  "",
                                              "bPartnerLocationId": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerLocationID
                                                      ?.id ??
                                                  "",
                                              "resource":
                                                  controller //serve id risorsa
                                                          .trx
                                                          .records![index]
                                                          .mpOtAdUserName ??
                                                      "",
                                              "dateStart": controller
                                                      .trx
                                                      .records![index]
                                                      .dateWorkStart ??
                                                  ""
                                            }); */
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trxMaintain.records![index].documentNo ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                          
                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(Icons.event),
                                      Text(
                                        controller.trxMaintain.records![index]
                                                .documentNo ??
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
                                        Row(
                                          children: [
                                            const Text(
                                              "Doc Number: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxMaintain.records![index]
                                                    .documentNo ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trxMaintain.records![index].documentNo}"
                                                    .tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */
                                            Icon(Icons.location_pin,
                                                color: Colors.red.shade700),
                                            const Expanded(
                                              child: Text(
                                                  ""),//"${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity}"),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              child:
                                                  Text("Create Sales Order".tr),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                /* Get.defaultDialog(
                                                        title: 'Complete Action',
                                                        content: const Text(
                                                            "Are you sure you want to complete the record?"),
                                                        onCancel: () {},
                                                        onConfirm: () async {
                                                          final ip = GetStorage()
                                                              .read('ip');
                                                          String authorization =
                                                              'Bearer ' +
                                                                  GetStorage().read(
                                                                      'token');
                                                          final msg = jsonEncode({
                                                            "DocAction": "CO",
                                                          });
                                                          final protocol =
                                                              GetStorage()
                                                                  .read('protocol');
                                                          var url = Uri.parse(
                                                              '$protocol://' +
                                                                  ip +
                                                                  '/api/v1/models/c_order/${controller.trx.records![index].id}');
                            
                                                          var response =
                                                              await http.put(
                                                            url,
                                                            body: msg,
                                                            headers: <String,
                                                                String>{
                                                              'Content-Type':
                                                                  'application/json',
                                                              'Authorization':
                                                                  authorization,
                                                            },
                                                          );
                                                          if (response.statusCode ==
                                                              200) {
                                                            //print("done!");
                                                            completeOrder(index);
                                                          } else {
                                                            //print(response.body);
                                                            Get.snackbar(
                                                              "Error!".tr,
                                                              "Record not completed".tr,
                                                              icon: const Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ); */
                                              },
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
                      : const Center(child: CircularProgressIndicator()),
                ),
              ]);
            },
            desktopBuilder: (context, constraints) {
              return  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3/* (constraints.maxWidth < 1360) ? 4 : 3 */,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(kBorderRadius),
                      bottomRight: Radius.circular(kBorderRadius),
                    ),
                    child: _Sidebar(data: controller.getSelectedProject())),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    _buildProfile(data: controller.getProfil()),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    Row(
                      children: [
                        Container(
                          child: Obx(() => controller.dataAvailable
                            ? Text("MAINTENANCES".tr + ": ${controller.trxMaintain.rowcount}")
                            : Text("MAINTENANCES".tr + ": ")),
                          margin: const EdgeInsets.only(left: 15),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: IconButton(
                            onPressed: () {
                              controller.getMPMaintain();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.yellow,
                            ),
                          ),
                        ),    
                    ]),
                    Obx( () => controller.dataAvailable ? 
                      Scrollbar( 
                        child: ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trxMaintain.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                              child: Obx( () => controller.selectedMaintenanceCard == index ? 
                                _buildMaintainCard(Theme.of(context).cardColor, context, index) : 
                                _buildMaintainCard(const Color.fromRGBO(64, 75, 96, .9), context, index),
                              ),
                            );
                          },
                        ),
                      ):
                      const Center(child: CircularProgressIndicator()),
                    ),
                    ]),
                  ),
            Flexible(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(height: kSpacing),
                  _buildHeader(),
                  const SizedBox(height: kSpacing * 2),
                  Row(
                    children: [
                      Container(
                        child: Obx(() => controller.dataAvailable1
                          ? Text("RESOURCES".tr + ": ${controller.trxResources.rowcount}")
                          : Text("RESOURCES".tr + ": ")),
                        margin: const EdgeInsets.only(left: 15),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: IconButton(
                          onPressed: () {
                            controller.getResources();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                      ],
                  ),
                  Obx( () => controller.dataAvailable1 ? 
                    ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: controller.trxResources.rowcount,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                          child: Obx( () => controller.selectedResourceCard == index ? 
                            _buildResourceCard(Theme.of(context).cardColor, context, index) : 
                            _buildResourceCard(const Color.fromRGBO(64, 75, 96, .9), context, index),
                          ),
                        );
                      },
                    ): Center(child: Text('No Maintenance Selected'.tr)),
                  ),],
                ),),
                Flexible(
                  flex: 4,
                      child: Column(
                        children: [
                          const SizedBox(height: kSpacing * 7.7),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                //width: 100,
                                height: MediaQuery.of(context).size.height / 1.2,
                                child: 
                                Obx( () => controller.showResourceDetails ? 
                                  SingleChildScrollView(
                                    child: Container(
                                      //margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      margin: const EdgeInsets.only(right: 10.0, left: 10.0, /* top: kSpacing * 7.7 */ bottom: 6.0),
                                      color: const Color.fromRGBO(64, 75, 96, .9),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Product'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trxResources.records![0].mProductID?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Maintenance Task'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trxResources.records![0].mPMaintainTaskID?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Location'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trxResources.records![0].locationComment ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Code/Position'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trxResources.records![0].value ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'SerNo'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trxResources.records![0].serNo ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      labelText: 'Check Date'.tr,
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintText: controller.trxResources.records![0].litControl1DateFrom ?? '',
                                                      enabled: false
                                                    ),
                                                  ),
                                                ),
                                              ), 
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      labelText: 'Next Check Date'.tr,
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintText: controller.trxResources.records![0].litControl1DateNext ?? '',
                                                      enabled: false
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      labelText: 'Revision Date'.tr,
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintText: controller.trxResources.records![0].litControl2DateFrom ?? '',
                                                      enabled: false
                                                    ),
                                                  ),
                                                ),
                                              ), 
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      labelText: 'Next Revision Date'.tr,
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintText: controller.trxResources.records![0].litControl2DateNext ?? '',
                                                      enabled: false
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ), 
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      labelText: 'Testing Date'.tr,
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintText: controller.trxResources.records![0].litControl3DateFrom ?? '',
                                                      enabled: false
                                                    ),
                                                  ),
                                                ),
                                              ), 
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 300,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintStyle: const TextStyle(
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                      labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      border: const OutlineInputBorder(),
                                                      labelText: 'Next Testing Date'.tr,
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintText: controller.trxResources.records![0].litControl3DateNext ?? '',
                                                      enabled: false
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ), 
                                  
                                  
                                        ])),
                                  ) : Center(child: Text('No Resource Selected'.tr)) /* Container(
                                        margin: const EdgeInsets.only(right: 10.0, left: 10.0, top: kSpacing * 7.7, bottom: 6.0),
                                        color: const Color.fromRGBO(64, 75, 96, .9),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('No Resource Selected'),
                                        )) */
                                  )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
            ],);
                    /* SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height,
                      child: 
                      Obx( () => controller.dataAvailable1 ? 
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          color: const Color.fromRGBO(64, 75, 96, .9),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255)
                                    ),
                                    labelStyle: const TextStyle(
                                      //color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Line'.tr,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText: ''/* controller.trx1.records![0].id != null 
                                      ? controller.trx1.records![0].id.toString() : '' */,
                                    enabled: false
                                  ),
                                ),
                              ),
                              /* Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255)
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Quantity'.tr,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText: controller.trx1.records![0].id != null 
                                      ? controller.trx1.records![0].id.toString() : '',
                                    enabled: false
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255)
                                    ),
                                    labelStyle: const TextStyle(
                                      //color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: const OutlineInputBorder(),
                                    labelText: 'UdM'.tr,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText: controller.trx1.records![0].aDOrgID?.identifier ?? '',
                                    enabled: false
                                  ),
                                ),
                              ),  */  
                                          ])) /* _buildDetails() */ :  Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              color: const Color.fromRGBO(64, 75, 96, .9),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No Maintenance Selected'),
                              ))
                              ))],
                ),
              ),
            ],
          ); *//* Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      child: Obx(() => controller.dataAvailable
                          ? Text("MAINTENANCES: ${controller.trx.rowcount}")
                          : const Text("MAINTENANCES: ")),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateMaintenanceMptask());
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
                          controller.getMPMaintain();
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
                /* Row(
                  children: [
                  StaggeredGrid.count(
                    crossAxisCount: 4, 
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child:Text('0'),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 1,
      child: Text('index: 1'),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: Text('index: 2'),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: Text('index: 3'),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 2,
      child: Text('index: 4'),
    ),
                    ],)
              ]), */
                Row(
                  children: [
                    SizedBox(
                      //height: kSpacing,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 2,
                      child: 
                        Obx( () => controller.dataAvailable ? 
                          Scrollbar( 
                            child: ListView.builder(
                              primary: false,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: controller.trx.rowcount,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                    child: ExpansionTile(
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.article,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          GetStorage().write('selectedMaintainID', 
                                            controller.trx.records![index].id.toString());
                                          controller.getTasks();
                                        }),
                                      title: Text(
                                        "DocumentNo".tr + " " +
                                        controller.trx.records![index].documentNo!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: 
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text("Business Partner".tr + ": ",),
                                                Text(controller.trx.records![index].cBPartnerID?.identifier ?? "???",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold
                                                )),
                                              ],
                                            ),
                                            const SizedBox(width: 50 /* MediaQuery.of(context).size.width / 10, */),
                                            Row(
                                              children: [
                                                Text('Business Partner Location'.tr + ': '),
                                                Text(controller.trx.records![index].cBPartnerLocationID?.identifier ?? '???',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  )
                                                ),
                                              ],
                                            ),
                                        ],
                                        
                                                                          ),
                                      ),
                                    childrenPadding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Organization'.tr + ': '),
                                                Text(controller.trx.records![index].aDOrgID?.identifier ?? '???')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Bill Business Partner'.tr + ': '),
                                                Text(controller.trx.records![index].cBPartnerLocationID?.identifier ?? '???')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Date Next Run'.tr + ': '),
                                                Text(controller.trx.records![index].dateNextRun ?? '')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Date Last Run'.tr + ': '),
                                                Text(controller.trx.records![index].dateLastRun ?? '',)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('ContractNo'.tr + ': '),
                                                /* Text(controller.trx.records![index].cContractID?.identifier ?? '??') */
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ):
                          const Center(child: CircularProgressIndicator()),
                        ),
                    ), 
                    SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height,
                    child: 
                    Obx( () => controller.dataAvailable1 ? 
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        color: const Color.fromRGBO(64, 75, 96, .9),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Column(
                                children: [ 
                                  Text('DocumentNo'.tr),
                                  const SizedBox(height: 10,),
                                  Text('Line'.tr),
                                ]),
                            ),
                              
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                                  decoration: const ShapeDecoration(
                                    shape: StadiumBorder(
                                      side: BorderSide(width: 0.5, color: Colors.white),
                                    ),
                                  ),
                                  child: Text(
                                    controller.trx1.records![0].mPMaintainID?.identifier ?? '',
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                                  decoration: const ShapeDecoration(
                                    shape: StadiumBorder(
                                      side: BorderSide(width: 0.5, color: Colors.white),
                                    ),
                                  ),
                                  child: Text(
                                    controller.trx1.records![0].line.toString(),
                                  ),
                                ),
                              ],
                        )],
                        ),
                      ):  Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            color: const Color.fromRGBO(64, 75, 96, .9),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No Maintenance Selected'),
                            ))
                      
                      /* Column(
                        
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Row(
                              children: [
                                Text(
                                  'DocumentNo'.tr + ': ',
                                  style: const TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                Text(
                                  controller.trx1.records![0].mPMaintainID?.identifier ?? '',
                                  style: const TextStyle( fontSize: 20),
                                ),
                                Text(
                                  'Line'.tr + ': ${controller.trx1.records![0].line ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ) */
                          /* Row(
                            children: [
                              Text('DocumentNo'.tr),
                                 Container(
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                                  decoration: const ShapeDecoration(
                                    shape: StadiumBorder(
                                      side: BorderSide(width: 0.5, color: Colors.white),
                                    ),
                                  ),
                                  child: Text(
                                    controller.trx1.records![0].mPMaintainID?.identifier ?? '',
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Line'.tr),
                                 Container(
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                                  decoration: const ShapeDecoration(
                                    shape: StadiumBorder(
                                      side: BorderSide(width: 0.5, color: Colors.white),
                                    ),
                                  ),
                                  child: Text(
                                    controller.trx1.records![0].line.toString() ?? '',
                                  ),
                                ),
                            ],
                          ) */ 
                      //Text(controller.trx1.records![0].mPMaintainID?.identifier ?? '') : Text('No Maintenance Selected')
                    ) 
                      )
                  ],
                )
                /* Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      /* GetStorage().write(
                                          'selectedWorkOrderId',
                                          controller
                                              .trx.records![index].id);
                                      Get.toNamed('/MaintenanceMptaskLine'); */
                                    },
                                    icon: const Icon(
                                      Icons.view_list,
                                      color: Colors.green,
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
                                      icon: const Icon(
                                        Icons.work,
                                      ),
                                      tooltip: 'Edit MAINTENANCES',
                                      onPressed: () {
                                        //log("info button pressed");
                                        /* Get.to(const EditMaintenanceMptask(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier ??
                                                  "",
                                              "bPartnerLocationId": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerLocationID
                                                      ?.id ??
                                                  "",
                                              "resource":
                                                  controller //serve id risorsa
                                                          .trx
                                                          .records![index]
                                                          .mpOtAdUserName ??
                                                      "",
                                              "dateStart": controller
                                                      .trx
                                                      .records![index]
                                                      .dateWorkStart ??
                                                  ""
                                            }); */
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.records![index].documentNo ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                          
                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(Icons.event),
                                      Text(
                                        controller.trx.records![index]
                                                .documentNo ??
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
                                        Row(
                                          children: [
                                            const Text(
                                              "Doc Number: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .documentNo ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].documentNo}"
                                                    .tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */
                                            Icon(Icons.location_pin,
                                                color: Colors.red.shade700),
                                            Expanded(
                                              child: Text(
                                                  ""),//"${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity}"),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              child:
                                                  Text("Create Sales Order".tr),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                /* Get.defaultDialog(
                                                        title: 'Complete Action',
                                                        content: const Text(
                                                            "Are you sure you want to complete the record?"),
                                                        onCancel: () {},
                                                        onConfirm: () async {
                                                          final ip = GetStorage()
                                                              .read('ip');
                                                          String authorization =
                                                              'Bearer ' +
                                                                  GetStorage().read(
                                                                      'token');
                                                          final msg = jsonEncode({
                                                            "DocAction": "CO",
                                                          });
                                                          final protocol =
                                                              GetStorage()
                                                                  .read('protocol');
                                                          var url = Uri.parse(
                                                              '$protocol://' +
                                                                  ip +
                                                                  '/api/v1/models/c_order/${controller.trx.records![index].id}');
                            
                                                          var response =
                                                              await http.put(
                                                            url,
                                                            body: msg,
                                                            headers: <String,
                                                                String>{
                                                              'Content-Type':
                                                                  'application/json',
                                                              'Authorization':
                                                                  authorization,
                                                            },
                                                          );
                                                          if (response.statusCode ==
                                                              200) {
                                                            //print("done!");
                                                            completeOrder(index);
                                                          } else {
                                                            //print(response.body);
                                                            Get.snackbar(
                                                              "Error!".tr,
                                                              "Record not completed".tr,
                                                              icon: const Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ); */
                                              },
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
                      : const Center(child: CircularProgressIndicator()),
                ), */
              ]); */
            }
          ),
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

  Widget _buildMaintainCard(Color selectionColor, context, index){
    return Container(
      decoration: BoxDecoration(
        color: selectionColor
      ),
      child: ExpansionTile(
        trailing: IconButton(
          icon: const Icon(
            Icons.article,
            color: Colors.green,
          ),
          onPressed: () {
            controller.selectedMaintenanceCard = index;
            controller.selectedMaintainID = controller.
              trxMaintain.records![index].id;
            /* GetStorage().write('selectedMaintainID', 
              controller.trxMaintain.records![index].id.toString()); */
            controller.getResources();
            print(controller.dataAvailable1);
          }),
        title: Text(
          "DocumentNo".tr + " " +
          controller.trxMaintain.records![index].documentNo!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold),
        ),
        subtitle: 
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text("Business Partner".tr + ": ",),
                  Text(controller.trxMaintain.records![index].cBPartnerID?.identifier ?? "???",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
              const SizedBox(width: 50 /* MediaQuery.of(context).size.width / 10, */),
              Row(
                children: [
                  //Text('Business Partner Location'.tr + ': '),
                  Text(controller.trxMaintain.records![index].cBPartnerLocationID?.identifier ?? '???',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              ),
          ],

                                            ),
        ),
      childrenPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text('Organization'.tr + ': '),
                  Text(controller.trxMaintain.records![index].aDOrgID?.identifier ?? '???')
                ],
              ),
              Row(
                children: [
                  Text('Bill Business Partner'.tr + ': '),
                  Text(controller.trxMaintain.records![index].cBPartnerLocationID?.identifier ?? '???')
                ],
              ),
              Row(
                children: [
                  Text('Date Next Run'.tr + ': '),
                  Text(controller.trxMaintain.records![index].dateNextRun ?? '')
                ],
              ),
              Row(
                children: [
                  Text('Date Last Run'.tr + ': '),
                  Text(controller.trxMaintain.records![index].dateLastRun ?? '',)
                ],
              ),
              Row(
                children: [
                  Text('ContractNo'.tr + ': '),
                  /* Text(controller.trx.records![index].cContractID?.identifier ?? '??') */
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildResourceCard(Color selectionColor, context, index){
    return Container(
      decoration: BoxDecoration(
        color: selectionColor
      ),
      child: ExpansionTile(
        trailing: IconButton(
          icon: const Icon(
            Icons.article,
            color: Colors.green,
          ),
          onPressed: () {
            print(controller.trxResources.records![index].id.toString());
            controller.selectedResourceCard = index;
            /* GetStorage().write('selectedResourceID', 
              controller.trxResources.records![index].id.toString()); */
            controller.showResourceDetails = true;
          }),
        title: Text(
          "Product".tr + ": " +
         ( controller.trxResources.records!.isNotEmpty ? 
          controller.trxResources.records![index].mProductID?.identifier ?? '' : ''),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold),
        ),
        subtitle: 
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text("Location".tr + ": ",),
                  Text(controller.trxResources.records![index].locationComment ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
          ],

        ),
        ),
      /* childrenPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text('Organization'.tr + ': '),
                  Text(controller.trx.records![index].aDOrgID?.identifier ?? '???')
                ],
              ),
              Row(
                children: [
                  Text('Bill Business Partner'.tr + ': '),
                  Text(controller.trx.records![index].cBPartnerLocationID?.identifier ?? '???')
                ],
              ),
              Row(
                children: [
                  Text('Date Next Run'.tr + ': '),
                  Text(controller.trx.records![index].dateNextRun ?? '')
                ],
              ),
              Row(
                children: [
                  Text('Date Last Run'.tr + ': '),
                  Text(controller.trx.records![index].dateLastRun ?? '',)
                ],
              ),
              Row(
                children: [
                  Text('ContractNo'.tr + ': '),
                  /* Text(controller.trx.records![index].cContractID?.identifier ?? '??') */
                ],
              ),
            ],
          )
        ], */
      ),
    );
  }
}
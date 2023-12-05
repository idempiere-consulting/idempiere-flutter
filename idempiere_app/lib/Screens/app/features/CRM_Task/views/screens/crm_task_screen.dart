// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task/views/screens/crm_edit_task.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task/views/screens/crm_task_filters_screen.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
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
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/crm_task_binding.dart';

// controller
part '../../controllers/crm_task_controller.dart';

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

class CRMTaskScreen extends GetView<CRMTaskController> {
  const CRMTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder()),
        //shape: AutomaticNotchedShape(RoundedRectangleBorder(), StadiumBorder()),
        color: Theme.of(context).cardColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.getTasks();
                        },
                        child: Row(
                          children: [
                            //Icon(Icons.filter_alt),
                            Obx(() => controller.dataAvailable
                                ? Text("TASK: ".tr +
                                    controller.trx.rowcount.toString())
                                : Text("TASK: ".tr)),
                          ],
                        ),
                      ),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getTasks();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ), */
                  ],
                )
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (controller.pagesCount > 1) {
                            controller.pagesCount.value -= 1;
                            controller.getTasks();
                          }
                        },
                        icon: const Icon(Icons.skip_previous),
                      ),
                      Obx(() => Text(
                          "${controller.pagesCount.value}/${controller.pagesTot.value}")),
                      IconButton(
                        onPressed: () {
                          if (controller.pagesCount <
                              controller.pagesTot.value) {
                            controller.pagesCount.value += 1;
                            controller.getTasks();
                          }
                        },
                        icon: const Icon(Icons.skip_next),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.home_menu,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        /*  buttonSize: const Size(, 45),
        childrenButtonSize: const Size(45, 45), */
        children: [
          SpeedDialChild(
              label: 'Filter'.tr,
              child: Obx(() => Icon(
                    Symbols.filter_alt,
                    color: controller.businessPartnerId.value == 0 &&
                            controller.selectedUserRadioTile.value == 0 &&
                            controller.selectedStatusRadioTile.value == 0 &&
                            controller.dateStartValue == "" &&
                            controller.dateEndValue == ""
                        ? Colors.white
                        : kNotifColor,
                  )),
              onTap: () {
                Get.to(const CRMFilterTask(), arguments: {
                  'selectedUserRadioTile':
                      controller.selectedUserRadioTile.value,
                  'selectedStatusRadioTile':
                      controller.selectedStatusRadioTile.value,
                  'userId': controller.userId,
                  'userName': controller.userName,
                  'businessPartnerId': controller.businessPartnerId.value,
                  'businessPartnerName': controller.businessPartnerName,
                  'dateStart': controller.dateStartValue,
                  'dateEnd': controller.dateEndValue,
                });
              }),
          SpeedDialChild(
            label: 'New'.tr,
            child: const Icon(Symbols.calendar_add_on),
          )
        ],
      ),
      //key: controller.scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
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
              _buildHeader2(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              //_buildProfile(data: controller.getProfil()),
              //const SizedBox(height: kSpacing),
              /* Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Obx(() => controller.dataAvailable
                        ? Text("TASK: ".tr + controller.trx.rowcount.toString())
                        : Text("TASK: ".tr)),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateLead());
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        controller.getTasks();
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
              ), */

              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.pagesCount > 1) {
                        controller.pagesCount.value -= 1;
                        controller.getTasks();
                      }
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),
                  Obx(() => Text(
                      "${controller.pagesCount.value}/${controller.pagesTot.value}")),
                  IconButton(
                    onPressed: () {
                      if (controller.pagesCount < controller.pagesTot.value) {
                        controller.pagesCount.value += 1;
                        controller.getTasks();
                      }
                    },
                    icon: const Icon(Icons.skip_next),
                  )
                ],
              ), */
              //const SizedBox(height: kSpacing),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller._trx.records!.length,
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
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Edit Task'.tr,
                                    onPressed: () {
                                      Get.to(const EditCRMTask(), arguments: {
                                        "id":
                                            controller._trx.records![index].id,
                                        "name": controller
                                                ._trx.records![index].name ??
                                            "",
                                        "description": controller
                                            ._trx.records![index].description,
                                        "typeId": controller
                                                ._trx
                                                .records![index]
                                                .jPToDoType
                                                ?.id ??
                                            'S',
                                        "startDate": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledStartDate,
                                        "startTime": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledStartTime!
                                            .substring(0, 5),
                                        "endTime": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledEndTime!
                                            .substring(0, 5),
                                        "statusId": controller
                                                ._trx
                                                .records![index]
                                                .jPToDoStatus
                                                ?.id ??
                                            'NY',
                                        "user": controller._trx.records![index]
                                            .aDUserID?.identifier,
                                        "bpId": controller._trx.records![index]
                                            .cBPartnerID?.id,
                                        "bpName": controller
                                            ._trx
                                            .records![index]
                                            .cBPartnerID
                                            ?.identifier,
                                        "projectId": controller._trx
                                            .records![index].cProjectID?.id,
                                        "projectName": controller
                                            ._trx
                                            .records![index]
                                            .cProjectID
                                            ?.identifier,
                                      });
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].name ?? "???",
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
                                            controller.trx.records![index]
                                                    .description ??
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
                                            "${DateTime.tryParse(controller.trx.records![index].jPToDoScheduledStartDate ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].jPToDoScheduledStartDate!)) : ""}  ${controller.trx.records![index].jPToDoScheduledStartTime == null ? "" : controller.trx.records![index].jPToDoScheduledStartTime!.substring(0, 5)} - ${controller.trx.records![index].jPToDoScheduledEndTime == null ? "" : controller.trx.records![index].jPToDoScheduledEndTime!.substring(0, 5)}",
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
                                            controller.trx.records![index]
                                                    .cBPartnerID?.identifier ??
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
                                        visible: controller.trx.records![index]
                                                .cProjectID !=
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
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .cProjectID
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller
                                                .trx.records![index].aDUserID !=
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
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .aDUserID
                                                      ?.identifier ??
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
              ),
            ]);
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader2(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              //_buildProfile(data: controller.getProfil()),
              //const SizedBox(height: kSpacing),
              /* Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Obx(() => controller.dataAvailable
                        ? Text("TASK: ".tr + controller.trx.rowcount.toString())
                        : Text("TASK: ".tr)),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateLead());
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        controller.getTasks();
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
              ), */

              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.pagesCount > 1) {
                        controller.pagesCount.value -= 1;
                        controller.getTasks();
                      }
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),
                  Obx(() => Text(
                      "${controller.pagesCount.value}/${controller.pagesTot.value}")),
                  IconButton(
                    onPressed: () {
                      if (controller.pagesCount < controller.pagesTot.value) {
                        controller.pagesCount.value += 1;
                        controller.getTasks();
                      }
                    },
                    icon: const Icon(Icons.skip_next),
                  )
                ],
              ), */
              //const SizedBox(height: kSpacing),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller._trx.records!.length,
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
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Edit Task'.tr,
                                    onPressed: () {
                                      Get.to(const EditCRMTask(), arguments: {
                                        "id":
                                            controller._trx.records![index].id,
                                        "name": controller
                                                ._trx.records![index].name ??
                                            "",
                                        "description": controller
                                            ._trx.records![index].description,
                                        "typeId": controller
                                                ._trx
                                                .records![index]
                                                .jPToDoType
                                                ?.id ??
                                            'S',
                                        "startDate": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledStartDate,
                                        "startTime": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledStartTime!
                                            .substring(0, 5),
                                        "endTime": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledEndTime!
                                            .substring(0, 5),
                                        "statusId": controller
                                                ._trx
                                                .records![index]
                                                .jPToDoStatus
                                                ?.id ??
                                            'NY',
                                        "user": controller._trx.records![index]
                                            .aDUserID?.identifier,
                                        "bpId": controller._trx.records![index]
                                            .cBPartnerID?.id,
                                        "bpName": controller
                                            ._trx
                                            .records![index]
                                            .cBPartnerID
                                            ?.identifier,
                                        "projectId": controller._trx
                                            .records![index].cProjectID?.id,
                                        "projectName": controller
                                            ._trx
                                            .records![index]
                                            .cProjectID
                                            ?.identifier,
                                      });
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].name ?? "???",
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
                                            controller.trx.records![index]
                                                    .description ??
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
                                            "${DateTime.tryParse(controller.trx.records![index].jPToDoScheduledStartDate ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].jPToDoScheduledStartDate!)) : ""}  ${controller.trx.records![index].jPToDoScheduledStartTime == null ? "" : controller.trx.records![index].jPToDoScheduledStartTime!.substring(0, 5)} - ${controller.trx.records![index].jPToDoScheduledEndTime == null ? "" : controller.trx.records![index].jPToDoScheduledEndTime!.substring(0, 5)}",
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
                                            controller.trx.records![index]
                                                    .cBPartnerID?.identifier ??
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
                                        visible: controller.trx.records![index]
                                                .cProjectID !=
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
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .cProjectID
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller
                                                .trx.records![index].aDUserID !=
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
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .aDUserID
                                                      ?.identifier ??
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
              ),
            ]);
          },
          desktopBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader2(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              //_buildProfile(data: controller.getProfil()),
              //const SizedBox(height: kSpacing),
              /* Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Obx(() => controller.dataAvailable
                        ? Text("TASK: ".tr + controller.trx.rowcount.toString())
                        : Text("TASK: ".tr)),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateLead());
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        controller.getTasks();
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
              ), */

              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.pagesCount > 1) {
                        controller.pagesCount.value -= 1;
                        controller.getTasks();
                      }
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),
                  Obx(() => Text(
                      "${controller.pagesCount.value}/${controller.pagesTot.value}")),
                  IconButton(
                    onPressed: () {
                      if (controller.pagesCount < controller.pagesTot.value) {
                        controller.pagesCount.value += 1;
                        controller.getTasks();
                      }
                    },
                    icon: const Icon(Icons.skip_next),
                  )
                ],
              ), */
              //const SizedBox(height: kSpacing),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller._trx.records!.length,
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
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Edit Task'.tr,
                                    onPressed: () {
                                      Get.to(const EditCRMTask(), arguments: {
                                        "id":
                                            controller._trx.records![index].id,
                                        "name": controller
                                                ._trx.records![index].name ??
                                            "",
                                        "description": controller
                                            ._trx.records![index].description,
                                        "typeId": controller
                                                ._trx
                                                .records![index]
                                                .jPToDoType
                                                ?.id ??
                                            'S',
                                        "startDate": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledStartDate,
                                        "startTime": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledStartTime!
                                            .substring(0, 5),
                                        "endTime": controller
                                            ._trx
                                            .records![index]
                                            .jPToDoScheduledEndTime!
                                            .substring(0, 5),
                                        "statusId": controller
                                                ._trx
                                                .records![index]
                                                .jPToDoStatus
                                                ?.id ??
                                            'NY',
                                        "user": controller._trx.records![index]
                                            .aDUserID?.identifier,
                                        "bpId": controller._trx.records![index]
                                            .cBPartnerID?.id,
                                        "bpName": controller
                                            ._trx
                                            .records![index]
                                            .cBPartnerID
                                            ?.identifier,
                                        "projectId": controller._trx
                                            .records![index].cProjectID?.id,
                                        "projectName": controller
                                            ._trx
                                            .records![index]
                                            .cProjectID
                                            ?.identifier,
                                      });
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].name ?? "???",
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
                                            controller.trx.records![index]
                                                    .description ??
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
                                            "${DateTime.tryParse(controller.trx.records![index].jPToDoScheduledStartDate ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].jPToDoScheduledStartDate!)) : ""}  ${controller.trx.records![index].jPToDoScheduledStartTime == null ? "" : controller.trx.records![index].jPToDoScheduledStartTime!.substring(0, 5)} - ${controller.trx.records![index].jPToDoScheduledEndTime == null ? "" : controller.trx.records![index].jPToDoScheduledEndTime!.substring(0, 5)}",
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
                                            controller.trx.records![index]
                                                    .cBPartnerID?.identifier ??
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
                                        visible: controller.trx.records![index]
                                                .cProjectID !=
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
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .cProjectID
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller
                                                .trx.records![index].aDUserID !=
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
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .aDUserID
                                                      ?.identifier ??
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
              ),
            ]);
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

  Widget _buildHeader2({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          Row(
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
              Expanded(
                child: _ProfilTile(
                  data: controller.getProfil(),
                  onPressedNotification: () {},
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Expanded(child: _Header()),
            ],
          ),
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
}

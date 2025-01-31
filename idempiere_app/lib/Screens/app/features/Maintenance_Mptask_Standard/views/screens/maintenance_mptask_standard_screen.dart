// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_edit_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_info_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_product_unloaded_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/models/attachment_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/views/screens/maintenance_edit_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/views/screens/maintenance_mptask_image_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Signature_WorkOrder/signature_page.dart';
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
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

// binding
part '../../bindings/maintenance_mptask_standard_binding.dart';

// controller
part '../../controllers/maintenance_mptask_standard_controller.dart';

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

class MaintenanceMptaskStandardScreen
    extends GetView<MaintenanceMptaskStandardController> {
  const MaintenanceMptaskStandardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('Dashboard');
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        drawer: /* (ResponsiveBuilder.isDesktop(context))
            ? null
            : */
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
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text(
                              "${"WORK ORDER".tr}: ${controller.trx.records!.length}")
                          : Text("${"WORK ORDER".tr}: ")),
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
                          controller.syncWorkOrder();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    /* Tooltip(
                      message: 'All Devices'.tr,
                      child: Obx(
                        () => Checkbox(
                            activeColor: kPrimaryColor,
                            value: controller.allDevices.value,
                            onChanged: (value) {
                              controller.allDevices.value = value ?? true;
                            }),
                      ),
                    ), */
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
                          key: const PageStorageKey('workorder'),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  key: PageStorageKey('workorderrow$index'),
                                  trailing: IconButton(
                                    onPressed: () {
                                      GetStorage().write(
                                          'selectedWorkOrderId',
                                          controller
                                              .trx.records![index].mPOTID!.id);

                                      GetStorage().write(
                                          'selectedTaskDocNo',
                                          controller.trx.records![index]
                                              .mPMaintainID?.id);
                                      GetStorage().write(
                                          'selectedTaskBP',
                                          controller.trx.records![index]
                                                  .cBPartnerID?.identifier ??
                                              "");

                                      /* GetStorage().write(
                                          'selectedTaskId',
                                          controller.trx.records![index]
                                              .mPMaintainTaskID!.id); */

                                      Get.toNamed(
                                          '/MaintenanceStandardMptaskLine',
                                          arguments: {
                                            "isSpecialOrder": true,
                                            "paymentRuleId": controller
                                                .trx
                                                .records![index]
                                                .paymentRule
                                                ?.id,
                                            "bPartner": controller
                                                .trx
                                                .records![index]
                                                .cBPartnerID
                                                ?.identifier,
                                            "docN": controller
                                                .trx.records![index].documentNo,
                                            "docType": controller
                                                .trx
                                                .records![index]
                                                .cDocTypeID
                                                ?.identifier,
                                            "id": controller
                                                .trx.records![index].mPOTID!.id,
                                            "note": controller
                                                .trx.records![index].note,
                                            "manualNote": controller
                                                .trx.records![index].manualNote,
                                            "request": controller.trx
                                                .records![index].description,
                                            "index": index,
                                            "date": controller.trx
                                                .records![index].dateWorkStart,
                                            "org": controller
                                                .trx
                                                .records![index]
                                                .aDOrgID
                                                ?.identifier,
                                            "hasAttachment": controller
                                                    .trx
                                                    .records![index]
                                                    .attachment ??
                                                "false",
                                            "maintenanceId": controller
                                                .trx
                                                .records![index]
                                                .mPMaintainID
                                                ?.id,
                                            "paidAmt": controller
                                                            .trx
                                                            .records![index]
                                                            .paidAmt !=
                                                        0 &&
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .paidAmt !=
                                                        null
                                                ? controller
                                                    .trx.records![index].paidAmt
                                                : 0,
                                          });
                                    },
                                    icon: Icon(
                                      controller.trx.records![index].docStatus
                                                  ?.id !=
                                              "CO"
                                          ? Icons.view_list
                                          : controller.trx.records![index]
                                                          .docStatus?.id ==
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .cOrderID ==
                                                      null
                                              ? Icons.view_list
                                              : Icons.check_box,
                                      color: controller.trx.records![index]
                                                      .docStatus?.id ==
                                                  "CO" &&
                                              /* controller.trx.records![index]
                                                      .cOrderID !=
                                                  null && */
                                              controller.trx.records![index]
                                                      .cInvoiceID ==
                                                  null
                                          ? Colors.green
                                          : controller.trx.records![index]
                                                          .docStatus?.id ==
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .cInvoiceID !=
                                                      null
                                              ? Colors.blue
                                              : Colors.yellow,
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
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Work Order',
                                      onPressed: () {
                                        var index2 = 0;
                                        /* var count = 0;
                                        for (var element
                                            in controller._trx2.records!) {
                                          count++;
                                          if (element.id ==
                                              controller
                                                  .trx.records![index].id) {
                                            index2 = count;
                                          }
                                        } */

                                        for (var i = 0;
                                            i <
                                                controller
                                                    ._trx2.records!.length;
                                            i++) {
                                          if (controller._trx2.records![i].id ==
                                              controller
                                                  .trx.records![index].id) {
                                            index2 = i;
                                          }
                                        }
                                        //log("info button pressed");
                                        /* print(controller.trx.records![index]
                                            .jpToDoStartDate); */
                                        Get.to(
                                            const EditMaintenanceMptaskStandard(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "index": index2,
                                              "docNo": controller.trx
                                                  .records![index].documentNo,
                                              "businessPartner": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.identifier,
                                              "date": controller
                                                  .trx
                                                  .records![index]
                                                  .jpToDoStartDate,
                                              "timeStart": controller
                                                  .trx
                                                  .records![index]
                                                  .jpToDoStartTime
                                                  ?.substring(0, 5),
                                              "timeEnd": controller.trx
                                                  .records![index].jpToDoEndTime
                                                  ?.substring(0, 5),
                                              "notePlant": controller
                                                  .trx
                                                  .records![index]
                                                  .litMpMaintainHelp,
                                              "maintainId": controller
                                                  .trx
                                                  .records![index]
                                                  .mPMaintainID
                                                  ?.id,
                                              "noteWO": controller.trx
                                                  .records![index].description,
                                              "address":
                                                  "${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal ?? ""} ${controller.trx.records![index].cLocationCity}",
                                              "representative": controller
                                                      .trx
                                                      .records![index]
                                                      .refname ??
                                                  controller.trx.records![index]
                                                      .ref2name,
                                              "team": controller
                                                  .trx.records![index].team,
                                              "jpId": controller.trx
                                                  .records![index].jPToDoID?.id,
                                              "paidAmt": controller
                                                              .trx
                                                              .records![index]
                                                              .paidAmt !=
                                                          0 &&
                                                      controller
                                                              .trx
                                                              .records![index]
                                                              .paidAmt !=
                                                          null
                                                  ? controller.trx
                                                      .records![index].paidAmt
                                                  : 0,
                                              "paymentRuleId": controller
                                                  .trx
                                                  .records![index]
                                                  .paymentRule
                                                  ?.id,
                                              "IsPrinted": controller
                                                  .trx.records![index].isPrinted
                                            });
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .cDocTypeID?.identifier ??
                                                  "N/A",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.event,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(controller
                                                    .trx
                                                    .records![index]
                                                    .jpToDoStartDate!)),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.handshake,
                                            color: controller
                                                            ._trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order'.tr ||
                                                    controller
                                                            ._trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order with Material'
                                                            .tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Shipment Order'.tr
                                                ? Colors.orange
                                                : Colors.yellow,
                                          ),
                                          Expanded(
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/CustomerBP',
                                                      arguments: {
                                                        'notificationId':
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .cBPartnerID
                                                                ?.id,
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .cBPartnerID
                                                                ?.identifier ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: kNotifColor),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */

                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.location_pin,
                                                color: Colors.red.shade700),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity} ${controller.trx.records![index].regionName}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Expanded(
                                          child: Text(
                                            "P.IVA: ${controller.trx.records![index].lITTaxID ?? "-"}, Codice SDI: ${controller.trx.records![index].lITFEPAIPA ?? "-"}, Codice Fiscale: ${controller.trx.records![index].lITNationalIdNumberID ?? ""}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      ]),
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
                                            Text(
                                              'N° Work Order: '.tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .documentNo ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Document Type: ".tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .cDocTypeID?.identifier ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Time'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].jpToDoStartTime != null ? controller.trx.records![index].jpToDoStartTime!.substring(0, 5) : "N/A"} - ${controller.trx.records![index].jpToDoEndTime != null ? controller.trx.records![index].jpToDoEndTime!.substring(0, 5) : "N/A"}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Contract Type'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .contracttypename ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .records![index]
                                                  .mPMaintainID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"N° Maintenance".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  /* Get.offNamed(
                                                      '/MaintenanceMpContracts',
                                                      arguments: {
                                                        'notificationId':
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .mPMaintainID
                                                                ?.id,
                                                      }); */
                                                },
                                                child: Text(
                                                  '${controller._trx.records![index].documentNo2}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              ),
                                              IconButton(
                                                  tooltip:
                                                      'Show All Work Orders linked to this Maintenance'
                                                          .tr,
                                                  onPressed: () {
                                                    controller
                                                        .syncWorkOrderByMaintainID(
                                                            controller
                                                                    ._trx
                                                                    .records![
                                                                        index]
                                                                    .mPMaintainID
                                                                    ?.id ??
                                                                0);
                                                  },
                                                  icon: const Icon(
                                                      Symbols.search_check)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Note Plant'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .litMpMaintainHelp ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Note Work Order'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .description ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        /* Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].mpOtTaskStatus}"
                                                    .tr),
                                          ],
                                        ), */

                                        Visibility(
                                          visible: controller
                                                  .trx.records![index].name !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Desc. Impianto'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    "${controller.trx.records![index].name}"
                                                        .tr),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].refname !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Representative'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "${controller.trx.records![index].refname}"
                                                      .tr),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                      .records![index].mail !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .mail !=
                                                  "",
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.mail,
                                                  color: Colors.white,
                                                ),
                                                tooltip: 'Mail',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone !=
                                                      null) {
                                                    controller.writeMailTo(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .mail!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].mail ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].refname !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .phone!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].phone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .cBpartnerLocationPhone !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .cBpartnerLocationPhone !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .cBpartnerLocationPhone!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .cBpartnerLocationPhone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].ref2name !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Representative'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "${controller.trx.records![index].ref2name}"
                                                      .tr),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].ref2name !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone2 !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .phone2!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].phone2 ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Team".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller.trx
                                                      .records![index].team ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Payment Rule".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .paymentRule
                                                      ?.identifier ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Paid Amt".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                  .trx.records![index].paidAmt
                                                  .toString()),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.trx.records![index]
                                                                .isPaid !=
                                                            true ||
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .isPaid ==
                                                            null
                                                    ? 'Not Paid'.tr
                                                    : 'Paid'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .isPaid !=
                                                                true ||
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .isPaid ==
                                                                null
                                                        ? Colors.yellow
                                                        : kNotifColor),
                                              ),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller._trx
                                                  .records![index].cOrderID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"Sales Order".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/SalesOrder',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cOrderID
                                                                ?.id
                                                      });
                                                },
                                                child: Text(
                                                  '${controller.trx.records![index].cOrderID?.identifier}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller._trx
                                                  .records![index].cInvoiceID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"Invoice".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/Invoice',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cInvoiceID
                                                                ?.id
                                                      });
                                                },
                                                child: Text(
                                                  '${controller._trx.records![index].cInvoiceID?.identifier}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              /* IconButton(
                                                  onPressed: () {
                                                    Get.to(
                                                        const MaintenanceMptaskProductUnloaded(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPMaintainID
                                                              ?.id,
                                                          "docN": controller
                                                              .trx
                                                              .records![index]
                                                              .documentNo,
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .screen_search_desktop)), */
                                              IconButton(
                                                tooltip: "Attachment".tr,
                                                onPressed: () {
                                                  controller
                                                      .getDocumentAttachments(
                                                          index);
                                                },
                                                icon:
                                                    const Icon(EvaIcons.attach),
                                              ),
                                              IconButton(
                                                tooltip: "Sign".tr,
                                                onPressed: () {
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .litSignImageID ==
                                                      null) {
                                                    Get.to(
                                                        const SignatureWorkOrderScreen(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.id,
                                                        });
                                                  } else {
                                                    Get.defaultDialog(
                                                      title:
                                                          'Record already Signed'
                                                              .tr,
                                                      content: Text(
                                                          "Are you sure you want Sign again?"
                                                              .tr),
                                                      onCancel: () {},
                                                      onConfirm: () async {
                                                        Get.to(
                                                            const SignatureWorkOrderScreen(),
                                                            arguments: {
                                                              "id": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mPOTID
                                                                  ?.id,
                                                            });
                                                      },
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  EvaIcons.edit2Outline,
                                                  color: controller
                                                              .trx
                                                              .records![index]
                                                              .litSignImageID !=
                                                          null
                                                      ? kNotifColor
                                                      : Colors.yellow,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: "Print".tr,
                                                onPressed: () {
                                                  controller.getDocument(index);
                                                },
                                                icon: const Icon(
                                                    EvaIcons.printer),
                                              ),
                                              /* Visibility(
                                                visible: controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier !=
                                                        'Special Order'.tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order with Material'
                                                            .tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Shipment Order'.tr,
                                                child: IconButton(
                                                  tooltip: "Tasks".tr,
                                                  onPressed: () {
                                                    Get.toNamed(
                                                        '/MaintenanceMptaskLine',
                                                        arguments: {
                                                          "isSpecialOrder":
                                                              false,
                                                          "bPartner": controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerID
                                                              ?.identifier,
                                                          "docN": controller
                                                              .trx
                                                              .records![index]
                                                              .documentNo,
                                                          "docType": controller
                                                              .trx
                                                              .records![index]
                                                              .cDocTypeID
                                                              ?.identifier,
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID!
                                                              .id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "manualNote":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manualNote,
                                                          "request": controller
                                                              .trx
                                                              .records![index]
                                                              .description,
                                                          "index": index,
                                                          "date": controller
                                                              .trx
                                                              .records![index]
                                                              .dateWorkStart,
                                                          "org": controller
                                                              .trx
                                                              .records![index]
                                                              .aDOrgID
                                                              ?.identifier,
                                                          "hasAttachment":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .attachment ??
                                                                  "false"
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .document_scanner_outlined),
                                                ),
                                              ), */
                                            ]),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          overflowDirection:
                                              VerticalDirection.down,
                                          overflowButtonSpacing: 5,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .jpToDoStatus
                                                      ?.id !=
                                                  'CO',
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();

                                                  if (isConnected) {
                                                    //print('si.');
                                                    controller
                                                        .completeToDo(index);
                                                  }
                                                },
                                                child: Text("Complete".tr),
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                          ._trx
                                                          .records![index]
                                                          .jpToDoStatus
                                                          ?.id ==
                                                      'CO' &&
                                                  controller
                                                          ._trx
                                                          .records![index]
                                                          .docStatus
                                                          ?.id ==
                                                      'CO',
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();

                                                  if (isConnected) {
                                                    //print('si.');
                                                    controller
                                                        .reOpenToDo(index);
                                                  }
                                                },
                                                child: Text("Reopen".tr),
                                              ),
                                            ),
                                            /* ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                Get.toNamed(
                                                    '/MaintenanceMptaskAnomalyReview',
                                                    arguments: {
                                                      "id": controller
                                                          .trx
                                                          .records![index]
                                                          .mPOTID
                                                          ?.id,
                                                      "record-id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.id ??
                                                          0,
                                                      "model-name": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.modelname ??
                                                          "",
                                                    });
                                              },
                                              child:
                                                  Text("Anomalies Review".tr),
                                            ), */
                                            /* ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                controller
                                                    .createSalesOrderFromWorkOrder(
                                                        index);
                                              },
                                              child: Text(
                                                  "Create Sales Order from Work Order"
                                                      .tr
                                                      .tr),
                                            ), */
                                            /* Visibility(
                                              visible: controller
                                                      .trx
                                                      .records![index]
                                                      .cOrderID !=
                                                  null,
                                              child: ElevatedButton(
                                                child:
                                                    Text("Sales Order Zoom".tr),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  Get.offNamed('/SalesOrder',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cOrderID
                                                                ?.id
                                                      });
                                                },
                                              ),
                                            ), */
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
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text(
                              "${"WORK ORDER".tr}: ${controller.trx.records!.length}")
                          : Text("${"WORK ORDER".tr}: ")),
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
                          controller.syncWorkOrder();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    /* Tooltip(
                      message: 'All Devices'.tr,
                      child: Obx(
                        () => Checkbox(
                            activeColor: kPrimaryColor,
                            value: controller.allDevices.value,
                            onChanged: (value) {
                              controller.allDevices.value = value ?? true;
                            }),
                      ),
                    ), */
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
                          key: const PageStorageKey('workorder'),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  key: PageStorageKey('workorderrow$index'),
                                  trailing: IconButton(
                                    onPressed: () {
                                      GetStorage().write(
                                          'selectedWorkOrderId',
                                          controller
                                              .trx.records![index].mPOTID!.id);

                                      GetStorage().write(
                                          'selectedTaskDocNo',
                                          controller.trx.records![index]
                                              .mPMaintainID?.id);
                                      GetStorage().write(
                                          'selectedTaskBP',
                                          controller.trx.records![index]
                                                  .cBPartnerID?.identifier ??
                                              "");

                                      /* GetStorage().write(
                                          'selectedTaskId',
                                          controller.trx.records![index]
                                              .mPMaintainTaskID!.id); */

                                      Get.toNamed(
                                          '/MaintenanceStandardMptaskLine',
                                          arguments: {
                                            "isSpecialOrder": true,
                                            "paymentRuleId": controller
                                                .trx
                                                .records![index]
                                                .paymentRule
                                                ?.id,
                                            "bPartner": controller
                                                .trx
                                                .records![index]
                                                .cBPartnerID
                                                ?.identifier,
                                            "docN": controller
                                                .trx.records![index].documentNo,
                                            "docType": controller
                                                .trx
                                                .records![index]
                                                .cDocTypeID
                                                ?.identifier,
                                            "id": controller
                                                .trx.records![index].mPOTID!.id,
                                            "note": controller
                                                .trx.records![index].note,
                                            "manualNote": controller
                                                .trx.records![index].manualNote,
                                            "request": controller.trx
                                                .records![index].description,
                                            "index": index,
                                            "date": controller.trx
                                                .records![index].dateWorkStart,
                                            "org": controller
                                                .trx
                                                .records![index]
                                                .aDOrgID
                                                ?.identifier,
                                            "hasAttachment": controller
                                                    .trx
                                                    .records![index]
                                                    .attachment ??
                                                "false",
                                            "maintenanceId": controller
                                                .trx
                                                .records![index]
                                                .mPMaintainID
                                                ?.id,
                                            "paidAmt": controller
                                                            .trx
                                                            .records![index]
                                                            .paidAmt !=
                                                        0 &&
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .paidAmt !=
                                                        null
                                                ? controller
                                                    .trx.records![index].paidAmt
                                                : 0,
                                          });
                                    },
                                    icon: Icon(
                                      controller.trx.records![index].docStatus
                                                  ?.id !=
                                              "CO"
                                          ? Icons.view_list
                                          : controller.trx.records![index]
                                                          .docStatus?.id ==
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .cOrderID ==
                                                      null
                                              ? Icons.view_list
                                              : Icons.check_box,
                                      color: controller.trx.records![index]
                                                      .docStatus?.id ==
                                                  "CO" &&
                                              /* controller.trx.records![index]
                                                      .cOrderID !=
                                                  null && */
                                              controller.trx.records![index]
                                                      .cInvoiceID ==
                                                  null
                                          ? Colors.green
                                          : controller.trx.records![index]
                                                          .docStatus?.id ==
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .cInvoiceID !=
                                                      null
                                              ? Colors.blue
                                              : Colors.yellow,
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
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Work Order',
                                      onPressed: () {
                                        var index2 = 0;
                                        /* var count = 0;
                                        for (var element
                                            in controller._trx2.records!) {
                                          count++;
                                          if (element.id ==
                                              controller
                                                  .trx.records![index].id) {
                                            index2 = count;
                                          }
                                        } */

                                        for (var i = 0;
                                            i <
                                                controller
                                                    ._trx2.records!.length;
                                            i++) {
                                          if (controller._trx2.records![i].id ==
                                              controller
                                                  .trx.records![index].id) {
                                            index2 = i;
                                          }
                                        }
                                        //log("info button pressed");
                                        /* print(controller.trx.records![index]
                                            .jpToDoStartDate); */
                                        Get.to(
                                            const EditMaintenanceMptaskStandard(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "index": index2,
                                              "docNo": controller.trx
                                                  .records![index].documentNo,
                                              "businessPartner": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.identifier,
                                              "date": controller
                                                  .trx
                                                  .records![index]
                                                  .jpToDoStartDate,
                                              "timeStart": controller
                                                  .trx
                                                  .records![index]
                                                  .jpToDoStartTime
                                                  ?.substring(0, 5),
                                              "timeEnd": controller.trx
                                                  .records![index].jpToDoEndTime
                                                  ?.substring(0, 5),
                                              "notePlant": controller
                                                  .trx
                                                  .records![index]
                                                  .litMpMaintainHelp,
                                              "maintainId": controller
                                                  .trx
                                                  .records![index]
                                                  .mPMaintainID
                                                  ?.id,
                                              "noteWO": controller.trx
                                                  .records![index].description,
                                              "address":
                                                  "${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal ?? ""} ${controller.trx.records![index].cLocationCity}",
                                              "representative": controller
                                                      .trx
                                                      .records![index]
                                                      .refname ??
                                                  controller.trx.records![index]
                                                      .ref2name,
                                              "team": controller
                                                  .trx.records![index].team,
                                              "jpId": controller.trx
                                                  .records![index].jPToDoID?.id,
                                              "paidAmt": controller
                                                              .trx
                                                              .records![index]
                                                              .paidAmt !=
                                                          0 &&
                                                      controller
                                                              .trx
                                                              .records![index]
                                                              .paidAmt !=
                                                          null
                                                  ? controller.trx
                                                      .records![index].paidAmt
                                                  : 0,
                                              "paymentRuleId": controller
                                                  .trx
                                                  .records![index]
                                                  .paymentRule
                                                  ?.id,
                                              "IsPrinted": controller
                                                  .trx.records![index].isPrinted
                                            });
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .cDocTypeID?.identifier ??
                                                  "N/A",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.event,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(controller
                                                    .trx
                                                    .records![index]
                                                    .jpToDoStartDate!)),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.handshake,
                                            color: controller
                                                            ._trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order'.tr ||
                                                    controller
                                                            ._trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order with Material'
                                                            .tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Shipment Order'.tr
                                                ? Colors.orange
                                                : Colors.yellow,
                                          ),
                                          Expanded(
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/CustomerBP',
                                                      arguments: {
                                                        'notificationId':
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .cBPartnerID
                                                                ?.id,
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .cBPartnerID
                                                                ?.identifier ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: kNotifColor),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
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
                                              "${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity} ${controller.trx.records![index].regionName}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Expanded(
                                          child: Text(
                                            "P.IVA: ${controller.trx.records![index].lITTaxID ?? "-"}, Codice SDI: ${controller.trx.records![index].lITFEPAIPA ?? "-"}, Codice Fiscale: ${controller.trx.records![index].lITNationalIdNumberID ?? ""}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      ]),
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
                                            Text(
                                              'N° Work Order: '.tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .documentNo ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Document Type: ".tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .cDocTypeID?.identifier ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Time'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].jpToDoStartTime != null ? controller.trx.records![index].jpToDoStartTime!.substring(0, 5) : "N/A"} - ${controller.trx.records![index].jpToDoEndTime != null ? controller.trx.records![index].jpToDoEndTime!.substring(0, 5) : "N/A"}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Contract Type'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .contracttypename ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .records![index]
                                                  .mPMaintainID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"N° Maintenance".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  /* Get.offNamed(
                                                      '/MaintenanceMpContracts',
                                                      arguments: {
                                                        'notificationId':
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .mPMaintainID
                                                                ?.id,
                                                      }); */
                                                },
                                                child: Text(
                                                  '${controller._trx.records![index].documentNo2}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              ),
                                              IconButton(
                                                  tooltip:
                                                      'Show All Work Orders linked to this Maintenance'
                                                          .tr,
                                                  onPressed: () {
                                                    controller
                                                        .syncWorkOrderByMaintainID(
                                                            controller
                                                                    ._trx
                                                                    .records![
                                                                        index]
                                                                    .mPMaintainID
                                                                    ?.id ??
                                                                0);
                                                  },
                                                  icon: const Icon(
                                                      Symbols.search_check)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Note Plant'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .litMpMaintainHelp ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Note Work Order'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .description ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        /* Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].mpOtTaskStatus}"
                                                    .tr),
                                          ],
                                        ), */

                                        Visibility(
                                          visible: controller
                                                  .trx.records![index].name !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Desc. Impianto'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    "${controller.trx.records![index].name}"
                                                        .tr),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].refname !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Representative'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "${controller.trx.records![index].refname}"
                                                      .tr),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                      .records![index].mail !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .mail !=
                                                  "",
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.mail,
                                                  color: Colors.white,
                                                ),
                                                tooltip: 'Mail',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone !=
                                                      null) {
                                                    controller.writeMailTo(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .mail!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].mail ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].refname !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .phone!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].phone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .cBpartnerLocationPhone !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .cBpartnerLocationPhone !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .cBpartnerLocationPhone!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .cBpartnerLocationPhone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].ref2name !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Representative'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "${controller.trx.records![index].ref2name}"
                                                      .tr),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].ref2name !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone2 !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .phone2!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].phone2 ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Team".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller.trx
                                                      .records![index].team ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Payment Rule".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .paymentRule
                                                      ?.identifier ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Paid Amt".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                  .trx.records![index].paidAmt
                                                  .toString()),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.trx.records![index]
                                                                .isPaid !=
                                                            true ||
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .isPaid ==
                                                            null
                                                    ? 'Not Paid'.tr
                                                    : 'Paid'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .isPaid !=
                                                                true ||
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .isPaid ==
                                                                null
                                                        ? Colors.yellow
                                                        : kNotifColor),
                                              ),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller._trx
                                                  .records![index].cOrderID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"Sales Order".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/SalesOrder',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cOrderID
                                                                ?.id
                                                      });
                                                },
                                                child: Text(
                                                  '${controller.trx.records![index].cOrderID?.identifier}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller._trx
                                                  .records![index].cInvoiceID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"Invoice".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/Invoice',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cInvoiceID
                                                                ?.id
                                                      });
                                                },
                                                child: Text(
                                                  '${controller._trx.records![index].cInvoiceID?.identifier}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              /* IconButton(
                                                  onPressed: () {
                                                    Get.to(
                                                        const MaintenanceMptaskProductUnloaded(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPMaintainID
                                                              ?.id,
                                                          "docN": controller
                                                              .trx
                                                              .records![index]
                                                              .documentNo,
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .screen_search_desktop)), */
                                              IconButton(
                                                tooltip: "Attachment".tr,
                                                onPressed: () {
                                                  controller
                                                      .getDocumentAttachments(
                                                          index);
                                                },
                                                icon:
                                                    const Icon(EvaIcons.attach),
                                              ),
                                              IconButton(
                                                tooltip: "Sign".tr,
                                                onPressed: () {
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .litSignImageID ==
                                                      null) {
                                                    Get.to(
                                                        const SignatureWorkOrderScreen(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.id,
                                                        });
                                                  } else {
                                                    Get.defaultDialog(
                                                      title:
                                                          'Record already Signed'
                                                              .tr,
                                                      content: Text(
                                                          "Are you sure you want Sign again?"
                                                              .tr),
                                                      onCancel: () {},
                                                      onConfirm: () async {
                                                        Get.to(
                                                            const SignatureWorkOrderScreen(),
                                                            arguments: {
                                                              "id": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mPOTID
                                                                  ?.id,
                                                            });
                                                      },
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  EvaIcons.edit2Outline,
                                                  color: controller
                                                              .trx
                                                              .records![index]
                                                              .litSignImageID !=
                                                          null
                                                      ? kNotifColor
                                                      : Colors.yellow,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: "Print".tr,
                                                onPressed: () {
                                                  controller.getDocument(index);
                                                },
                                                icon: const Icon(
                                                    EvaIcons.printer),
                                              ),
                                              /* Visibility(
                                                visible: controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier !=
                                                        'Special Order'.tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order with Material'
                                                            .tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Shipment Order'.tr,
                                                child: IconButton(
                                                  tooltip: "Tasks".tr,
                                                  onPressed: () {
                                                    Get.toNamed(
                                                        '/MaintenanceMptaskLine',
                                                        arguments: {
                                                          "isSpecialOrder":
                                                              false,
                                                          "bPartner": controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerID
                                                              ?.identifier,
                                                          "docN": controller
                                                              .trx
                                                              .records![index]
                                                              .documentNo,
                                                          "docType": controller
                                                              .trx
                                                              .records![index]
                                                              .cDocTypeID
                                                              ?.identifier,
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID!
                                                              .id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "manualNote":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manualNote,
                                                          "request": controller
                                                              .trx
                                                              .records![index]
                                                              .description,
                                                          "index": index,
                                                          "date": controller
                                                              .trx
                                                              .records![index]
                                                              .dateWorkStart,
                                                          "org": controller
                                                              .trx
                                                              .records![index]
                                                              .aDOrgID
                                                              ?.identifier,
                                                          "hasAttachment":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .attachment ??
                                                                  "false"
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .document_scanner_outlined),
                                                ),
                                              ), */
                                            ]),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          overflowDirection:
                                              VerticalDirection.down,
                                          overflowButtonSpacing: 5,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .jpToDoStatus
                                                      ?.id !=
                                                  'CO',
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();

                                                  if (isConnected) {
                                                    //print('si.');
                                                    controller
                                                        .completeToDo(index);
                                                  }
                                                },
                                                child: Text("Complete".tr),
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                          ._trx
                                                          .records![index]
                                                          .jpToDoStatus
                                                          ?.id ==
                                                      'CO' &&
                                                  controller
                                                          ._trx
                                                          .records![index]
                                                          .docStatus
                                                          ?.id ==
                                                      'CO',
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();

                                                  if (isConnected) {
                                                    //print('si.');
                                                    controller
                                                        .reOpenToDo(index);
                                                  }
                                                },
                                                child: Text("Reopen".tr),
                                              ),
                                            ),
                                            /* ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                Get.toNamed(
                                                    '/MaintenanceMptaskAnomalyReview',
                                                    arguments: {
                                                      "id": controller
                                                          .trx
                                                          .records![index]
                                                          .mPOTID
                                                          ?.id,
                                                      "record-id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.id ??
                                                          0,
                                                      "model-name": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.modelname ??
                                                          "",
                                                    });
                                              },
                                              child:
                                                  Text("Anomalies Review".tr),
                                            ), */
                                            /* ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                controller
                                                    .createSalesOrderFromWorkOrder(
                                                        index);
                                              },
                                              child: Text(
                                                  "Create Sales Order from Work Order"
                                                      .tr
                                                      .tr),
                                            ), */
                                            /* Visibility(
                                              visible: controller
                                                      .trx
                                                      .records![index]
                                                      .cOrderID !=
                                                  null,
                                              child: ElevatedButton(
                                                child:
                                                    Text("Sales Order Zoom".tr),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  Get.offNamed('/SalesOrder',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cOrderID
                                                                ?.id
                                                      });
                                                },
                                              ),
                                            ), */
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
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text(
                              "${"WORK ORDER".tr}: ${controller.trx.records!.length}")
                          : Text("${"WORK ORDER".tr}: ")),
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
                          controller.syncWorkOrder();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    /* Tooltip(
                      message: 'All Devices'.tr,
                      child: Obx(
                        () => Checkbox(
                            activeColor: kPrimaryColor,
                            value: controller.allDevices.value,
                            onChanged: (value) {
                              controller.allDevices.value = value ?? true;
                            }),
                      ),
                    ), */
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
                          key: const PageStorageKey('workorder'),
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  key: PageStorageKey('workorderrow$index'),
                                  trailing: IconButton(
                                    onPressed: () {
                                      GetStorage().write(
                                          'selectedWorkOrderId',
                                          controller
                                              .trx.records![index].mPOTID!.id);

                                      GetStorage().write(
                                          'selectedTaskDocNo',
                                          controller.trx.records![index]
                                              .mPMaintainID?.id);
                                      GetStorage().write(
                                          'selectedTaskBP',
                                          controller.trx.records![index]
                                                  .cBPartnerID?.identifier ??
                                              "");

                                      /* GetStorage().write(
                                          'selectedTaskId',
                                          controller.trx.records![index]
                                              .mPMaintainTaskID!.id); */

                                      Get.toNamed(
                                          '/MaintenanceStandardMptaskLine',
                                          arguments: {
                                            "isSpecialOrder": true,
                                            "paymentRuleId": controller
                                                .trx
                                                .records![index]
                                                .paymentRule
                                                ?.id,
                                            "bPartner": controller
                                                .trx
                                                .records![index]
                                                .cBPartnerID
                                                ?.identifier,
                                            "docN": controller
                                                .trx.records![index].documentNo,
                                            "docType": controller
                                                .trx
                                                .records![index]
                                                .cDocTypeID
                                                ?.identifier,
                                            "id": controller
                                                .trx.records![index].mPOTID!.id,
                                            "note": controller
                                                .trx.records![index].note,
                                            "manualNote": controller
                                                .trx.records![index].manualNote,
                                            "request": controller.trx
                                                .records![index].description,
                                            "index": index,
                                            "date": controller.trx
                                                .records![index].dateWorkStart,
                                            "org": controller
                                                .trx
                                                .records![index]
                                                .aDOrgID
                                                ?.identifier,
                                            "hasAttachment": controller
                                                    .trx
                                                    .records![index]
                                                    .attachment ??
                                                "false",
                                            "maintenanceId": controller
                                                .trx
                                                .records![index]
                                                .mPMaintainID
                                                ?.id,
                                            "paidAmt": controller
                                                            .trx
                                                            .records![index]
                                                            .paidAmt !=
                                                        0 &&
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .paidAmt !=
                                                        null
                                                ? controller
                                                    .trx.records![index].paidAmt
                                                : 0,
                                          });
                                    },
                                    icon: Icon(
                                      controller.trx.records![index].docStatus
                                                  ?.id !=
                                              "CO"
                                          ? Icons.view_list
                                          : controller.trx.records![index]
                                                          .docStatus?.id ==
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .cOrderID ==
                                                      null
                                              ? Icons.view_list
                                              : Icons.check_box,
                                      color: controller.trx.records![index]
                                                      .docStatus?.id ==
                                                  "CO" &&
                                              /* controller.trx.records![index]
                                                      .cOrderID !=
                                                  null && */
                                              controller.trx.records![index]
                                                      .cInvoiceID ==
                                                  null
                                          ? Colors.green
                                          : controller.trx.records![index]
                                                          .docStatus?.id ==
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .cInvoiceID !=
                                                      null
                                              ? Colors.blue
                                              : Colors.yellow,
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
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Work Order',
                                      onPressed: () {
                                        var index2 = 0;
                                        /* var count = 0;
                                        for (var element
                                            in controller._trx2.records!) {
                                          count++;
                                          if (element.id ==
                                              controller
                                                  .trx.records![index].id) {
                                            index2 = count;
                                          }
                                        } */

                                        for (var i = 0;
                                            i <
                                                controller
                                                    ._trx2.records!.length;
                                            i++) {
                                          if (controller._trx2.records![i].id ==
                                              controller
                                                  .trx.records![index].id) {
                                            index2 = i;
                                          }
                                        }
                                        //log("info button pressed");
                                        /* print(controller.trx.records![index]
                                            .jpToDoStartDate); */
                                        Get.to(
                                            const EditMaintenanceMptaskStandard(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "index": index2,
                                              "docNo": controller.trx
                                                  .records![index].documentNo,
                                              "businessPartner": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.identifier,
                                              "date": controller
                                                  .trx
                                                  .records![index]
                                                  .jpToDoStartDate,
                                              "timeStart": controller
                                                  .trx
                                                  .records![index]
                                                  .jpToDoStartTime
                                                  ?.substring(0, 5),
                                              "timeEnd": controller.trx
                                                  .records![index].jpToDoEndTime
                                                  ?.substring(0, 5),
                                              "notePlant": controller
                                                  .trx
                                                  .records![index]
                                                  .litMpMaintainHelp,
                                              "maintainId": controller
                                                  .trx
                                                  .records![index]
                                                  .mPMaintainID
                                                  ?.id,
                                              "noteWO": controller.trx
                                                  .records![index].description,
                                              "address":
                                                  "${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal ?? ""} ${controller.trx.records![index].cLocationCity}",
                                              "representative": controller
                                                      .trx
                                                      .records![index]
                                                      .refname ??
                                                  controller.trx.records![index]
                                                      .ref2name,
                                              "team": controller
                                                  .trx.records![index].team,
                                              "jpId": controller.trx
                                                  .records![index].jPToDoID?.id,
                                              "paidAmt": controller
                                                              .trx
                                                              .records![index]
                                                              .paidAmt !=
                                                          0 &&
                                                      controller
                                                              .trx
                                                              .records![index]
                                                              .paidAmt !=
                                                          null
                                                  ? controller.trx
                                                      .records![index].paidAmt
                                                  : 0,
                                              "paymentRuleId": controller
                                                  .trx
                                                  .records![index]
                                                  .paymentRule
                                                  ?.id,
                                              "IsPrinted": controller
                                                  .trx.records![index].isPrinted
                                            });
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .cDocTypeID?.identifier ??
                                                  "N/A",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.event,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(controller
                                                    .trx
                                                    .records![index]
                                                    .jpToDoStartDate!)),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.handshake,
                                            color: controller
                                                            ._trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order'.tr ||
                                                    controller
                                                            ._trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order with Material'
                                                            .tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Shipment Order'.tr
                                                ? Colors.orange
                                                : Colors.yellow,
                                          ),
                                          Expanded(
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/CustomerBP',
                                                      arguments: {
                                                        'notificationId':
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .cBPartnerID
                                                                ?.id,
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .cBPartnerID
                                                                ?.identifier ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: kNotifColor),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
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
                                              "${controller.trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity} ${controller.trx.records![index].regionName}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Expanded(
                                          child: Text(
                                            "P.IVA: ${controller.trx.records![index].lITTaxID ?? "-"}, Codice SDI: ${controller.trx.records![index].lITFEPAIPA ?? "-"}, Codice Fiscale: ${controller.trx.records![index].lITNationalIdNumberID ?? ""}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      ]),
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
                                            Text(
                                              'N° Work Order: '.tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .documentNo ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Document Type: ".tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .cDocTypeID?.identifier ??
                                                "")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Time'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].jpToDoStartTime != null ? controller.trx.records![index].jpToDoStartTime!.substring(0, 5) : "N/A"} - ${controller.trx.records![index].jpToDoEndTime != null ? controller.trx.records![index].jpToDoEndTime!.substring(0, 5) : "N/A"}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Contract Type'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .contracttypename ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .records![index]
                                                  .mPMaintainID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"N° Maintenance".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  /* Get.offNamed(
                                                      '/MaintenanceMpContracts',
                                                      arguments: {
                                                        'notificationId':
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .mPMaintainID
                                                                ?.id,
                                                      }); */
                                                },
                                                child: Text(
                                                  '${controller._trx.records![index].documentNo2}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              ),
                                              IconButton(
                                                  tooltip:
                                                      'Show All Work Orders linked to this Maintenance'
                                                          .tr,
                                                  onPressed: () {
                                                    controller
                                                        .syncWorkOrderByMaintainID(
                                                            controller
                                                                    ._trx
                                                                    .records![
                                                                        index]
                                                                    .mPMaintainID
                                                                    ?.id ??
                                                                0);
                                                  },
                                                  icon: const Icon(
                                                      Symbols.search_check)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Note Plant'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .litMpMaintainHelp ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Note Work Order'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .description ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        /* Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${controller.trx.records![index].mpOtTaskStatus}"
                                                    .tr),
                                          ],
                                        ), */

                                        Visibility(
                                          visible: controller
                                                  .trx.records![index].name !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Desc. Impianto'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    "${controller.trx.records![index].name}"
                                                        .tr),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].refname !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Representative'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "${controller.trx.records![index].refname}"
                                                      .tr),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                      .records![index].mail !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .mail !=
                                                  "",
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.mail,
                                                  color: Colors.white,
                                                ),
                                                tooltip: 'Mail',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone !=
                                                      null) {
                                                    controller.writeMailTo(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .mail!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].mail ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].refname !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .phone!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].phone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .cBpartnerLocationPhone !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .cBpartnerLocationPhone !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .cBpartnerLocationPhone!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .cBpartnerLocationPhone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].ref2name !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Representative'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "${controller.trx.records![index].ref2name}"
                                                      .tr),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].ref2name !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                                tooltip: 'Call',
                                                onPressed: () {
                                                  //log("info button pressed");
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .phone2 !=
                                                      null) {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .records![index]
                                                            .phone2!);
                                                  }
                                                },
                                              ),
                                              Text(controller.trx
                                                      .records![index].phone2 ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Team".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller.trx
                                                      .records![index].team ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Payment Rule".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .paymentRule
                                                      ?.identifier ??
                                                  ""),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Paid Amt".tr}:  ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                  .trx.records![index].paidAmt
                                                  .toString()),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.trx.records![index]
                                                                .isPaid !=
                                                            true ||
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .isPaid ==
                                                            null
                                                    ? 'Not Paid'.tr
                                                    : 'Paid'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .isPaid !=
                                                                true ||
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .isPaid ==
                                                                null
                                                        ? Colors.yellow
                                                        : kNotifColor),
                                              ),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller._trx
                                                  .records![index].cOrderID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"Sales Order".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/SalesOrder',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cOrderID
                                                                ?.id
                                                      });
                                                },
                                                child: Text(
                                                  '${controller.trx.records![index].cOrderID?.identifier}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller._trx
                                                  .records![index].cInvoiceID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"Invoice".tr}:  ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.offNamed('/Invoice',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cInvoiceID
                                                                ?.id
                                                      });
                                                },
                                                child: Text(
                                                  '${controller._trx.records![index].cInvoiceID?.identifier}',
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              /* IconButton(
                                                  onPressed: () {
                                                    Get.to(
                                                        const MaintenanceMptaskProductUnloaded(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPMaintainID
                                                              ?.id,
                                                          "docN": controller
                                                              .trx
                                                              .records![index]
                                                              .documentNo,
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .screen_search_desktop)), */
                                              IconButton(
                                                tooltip: "Attachment".tr,
                                                onPressed: () {
                                                  controller
                                                      .getDocumentAttachments(
                                                          index);
                                                },
                                                icon:
                                                    const Icon(EvaIcons.attach),
                                              ),
                                              IconButton(
                                                tooltip: "Sign".tr,
                                                onPressed: () {
                                                  if (controller
                                                          .trx
                                                          .records![index]
                                                          .litSignImageID ==
                                                      null) {
                                                    Get.to(
                                                        const SignatureWorkOrderScreen(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.id,
                                                        });
                                                  } else {
                                                    Get.defaultDialog(
                                                      title:
                                                          'Record already Signed'
                                                              .tr,
                                                      content: Text(
                                                          "Are you sure you want Sign again?"
                                                              .tr),
                                                      onCancel: () {},
                                                      onConfirm: () async {
                                                        Get.to(
                                                            const SignatureWorkOrderScreen(),
                                                            arguments: {
                                                              "id": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mPOTID
                                                                  ?.id,
                                                            });
                                                      },
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  EvaIcons.edit2Outline,
                                                  color: controller
                                                              .trx
                                                              .records![index]
                                                              .litSignImageID !=
                                                          null
                                                      ? kNotifColor
                                                      : Colors.yellow,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: "Print".tr,
                                                onPressed: () {
                                                  controller.getDocument(index);
                                                },
                                                icon: const Icon(
                                                    EvaIcons.printer),
                                              ),
                                              /* Visibility(
                                                visible: controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier !=
                                                        'Special Order'.tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Special Order with Material'
                                                            .tr ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeID
                                                            ?.identifier ==
                                                        'Shipment Order'.tr,
                                                child: IconButton(
                                                  tooltip: "Tasks".tr,
                                                  onPressed: () {
                                                    Get.toNamed(
                                                        '/MaintenanceMptaskLine',
                                                        arguments: {
                                                          "isSpecialOrder":
                                                              false,
                                                          "bPartner": controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerID
                                                              ?.identifier,
                                                          "docN": controller
                                                              .trx
                                                              .records![index]
                                                              .documentNo,
                                                          "docType": controller
                                                              .trx
                                                              .records![index]
                                                              .cDocTypeID
                                                              ?.identifier,
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID!
                                                              .id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "manualNote":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manualNote,
                                                          "request": controller
                                                              .trx
                                                              .records![index]
                                                              .description,
                                                          "index": index,
                                                          "date": controller
                                                              .trx
                                                              .records![index]
                                                              .dateWorkStart,
                                                          "org": controller
                                                              .trx
                                                              .records![index]
                                                              .aDOrgID
                                                              ?.identifier,
                                                          "hasAttachment":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .attachment ??
                                                                  "false"
                                                        });
                                                  },
                                                  icon: const Icon(Icons
                                                      .document_scanner_outlined),
                                                ),
                                              ), */
                                            ]),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          overflowDirection:
                                              VerticalDirection.down,
                                          overflowButtonSpacing: 5,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .jpToDoStatus
                                                      ?.id !=
                                                  'CO',
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();

                                                  if (isConnected) {
                                                    //print('si.');
                                                    controller
                                                        .completeToDo(index);
                                                  }
                                                },
                                                child: Text("Complete".tr),
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                          ._trx
                                                          .records![index]
                                                          .jpToDoStatus
                                                          ?.id ==
                                                      'CO' &&
                                                  controller
                                                          ._trx
                                                          .records![index]
                                                          .docStatus
                                                          ?.id ==
                                                      'CO',
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();

                                                  if (isConnected) {
                                                    //print('si.');
                                                    controller
                                                        .reOpenToDo(index);
                                                  }
                                                },
                                                child: Text("Reopen".tr),
                                              ),
                                            ),
                                            /* ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                Get.toNamed(
                                                    '/MaintenanceMptaskAnomalyReview',
                                                    arguments: {
                                                      "id": controller
                                                          .trx
                                                          .records![index]
                                                          .mPOTID
                                                          ?.id,
                                                      "record-id": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.id ??
                                                          0,
                                                      "model-name": controller
                                                              .trx
                                                              .records![index]
                                                              .mPOTID
                                                              ?.modelname ??
                                                          "",
                                                    });
                                              },
                                              child:
                                                  Text("Anomalies Review".tr),
                                            ), */
                                            /* ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                              onPressed: () async {
                                                controller
                                                    .createSalesOrderFromWorkOrder(
                                                        index);
                                              },
                                              child: Text(
                                                  "Create Sales Order from Work Order"
                                                      .tr
                                                      .tr),
                                            ), */
                                            /* Visibility(
                                              visible: controller
                                                      .trx
                                                      .records![index]
                                                      .cOrderID !=
                                                  null,
                                              child: ElevatedButton(
                                                child:
                                                    Text("Sales Order Zoom".tr),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  Get.offNamed('/SalesOrder',
                                                      arguments: {
                                                        "notificationId":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .cOrderID
                                                                ?.id
                                                      });
                                                },
                                              ),
                                            ), */
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
}

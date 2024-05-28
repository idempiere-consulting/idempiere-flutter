// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/models/orginfo_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/views/screens/maintenance_mptask_standard_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_create_mptask_standard_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_edit_mptask_standard_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_mptask_standard_maintcard.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_task_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_create_mptask_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_edit_mptask_taskline_screen.dart';
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
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
// binding
part '../../bindings/maintenance_mptask_standard_taskline_binding.dart';

// controller
part '../../controllers/maintenance_mptask_standard_taskline_controller.dart';

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

class MaintenanceStandardMptaskLineScreen
    extends GetView<MaintenanceStandardMptaskLineController> {
  const MaintenanceStandardMptaskLineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: controller.syncWorkOrderTask,
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("${controller.args["docN"]}"),
            Text("${controller.args["bPartner"]}"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.offNamed('/MaintenanceMptaskStandard');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing),
              Container(
                color: Colors.grey[600],
                width: screenSize.width,
                height: 0.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: "Save".tr,
                    onPressed: () {
                      controller.editManualNote();
                      controller.editPaidAmt();
                    },
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    tooltip: "Add Task".tr,
                    onPressed: () {
                      Get.to(const CreateMaintenanceStandardMptask(),
                          arguments: {
                            "id": controller.args["id"],
                          });
                    },
                    icon: const Icon(EvaIcons.fileAddOutline),
                  ),
                  IconButton(
                    tooltip: "Print".tr,
                    onPressed: () {
                      controller.getDocument();
                    },
                    icon: const Icon(EvaIcons.printerOutline),
                  ),
                  IconButton(
                    tooltip: "Report".tr,
                    onPressed: () {
                      controller.printWorkOrderTasksTicket();
                    },
                    icon: const Icon(Icons.receipt),
                  ),
                  IconButton(
                    tooltip: "Maintenance Card".tr,
                    onPressed: () {
                      Get.to(
                          () =>
                              const MaintenanceStandardMptaskMaintenanceCard(),
                          arguments: {
                            "MpOTID": controller.args["id"],
                            "maintainId": controller.args["maintenanceId"],
                            "paidAmt": controller.paidAmtFieldController.text,
                            "request": controller.requestFieldController.text,
                            "note": controller.noteFieldController.text,
                            "manualNote":
                                controller.manualNoteFieldController.text,
                          });
                    },
                    icon: const Icon(Symbols.info),
                  ),
                ],
              ),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.prodCountList.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.setFilter(controller.prodCountList
                                          .records![index].mProductID?.id ??
                                      0);
                                },
                                child: Text(
                                    "${controller.prodCountList.records![index].mProductID?.identifier} : ${controller.prodCountList.records![index].qty}")),
                          );
                        })
                    : const SizedBox(),
              ),
              Container(
                color: Colors.grey[600],
                width: screenSize.width,
                height: 0.25,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  //readOnly: true,
                  minLines: 1,
                  maxLines: 1,
                  controller: controller.paidAmtFieldController,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.text_fields),
                    border: const OutlineInputBorder(),
                    labelText: 'Paid Amt'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.requestFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Request Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity To Do'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.manualNoteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity Done'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
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
                                trailing: IconButton(
                                  onPressed: () {
                                    int taskindex = 0;
                                    for (var i = 0;
                                        i < controller._trx2.records!.length;
                                        i++) {
                                      if (controller._trx2.records![i].id ==
                                          controller._trx.records![index].id) {
                                        taskindex = i;
                                      }
                                    }
                                    //print(taskindex);
                                    Get.to(
                                        const EditMaintenanceStandardMptaskLine(),
                                        arguments: {
                                          "index": taskindex,
                                          "id": controller
                                              ._trx.records![index].id,
                                          "qtyEntered": (controller
                                                      ._trx
                                                      .records![index]
                                                      .qtyEntered ??
                                                  0)
                                              .toString(),
                                          "resourceQty": controller
                                              ._trx.records![index].resourceQty
                                              .toString(),
                                          "description": controller
                                              ._trx.records![index].description,
                                          "qty": controller
                                              ._trx.records![index].qty
                                              .toString(),
                                          "offlineid": controller
                                              ._trx.records![index].offlineId,
                                          "prod": controller
                                              ._trx
                                              .records![index]
                                              .mProductID
                                              ?.identifier,
                                          "prodId": controller._trx
                                              .records![index].mProductID?.id,
                                          "priceList": (controller
                                                      ._trx
                                                      .records![index]
                                                      .priceList ??
                                                  0.0)
                                              .toString(),
                                          "priceEntered": (controller
                                                      ._trx
                                                      .records![index]
                                                      .priceEntered ??
                                                  0.0)
                                              .toString(),
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
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
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Delete Task',
                                    onPressed: () {
                                      controller.deleteTask(
                                          controller._trx.records![index].id!,
                                          index);
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].mProductID
                                          ?.identifier ??
                                      "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ${controller.trx.records![index].qty}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "${"Description".tr}: ${controller.trx.records![index].description ?? ""}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Price".tr}: ${controller.trx.records![index].priceEntered ?? 0.00}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Prezzo Listino".tr}: ${controller.trx.records![index].priceList ?? 0.00}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: const [],
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
              Container(
                color: Colors.grey[600],
                width: screenSize.width,
                height: 0.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: "Save".tr,
                    onPressed: () {
                      controller.editManualNote();
                      controller.editPaidAmt();
                    },
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    tooltip: "Add Task".tr,
                    onPressed: () {
                      Get.to(const CreateMaintenanceStandardMptask(),
                          arguments: {
                            "id": controller.args["id"],
                          });
                    },
                    icon: const Icon(EvaIcons.fileAddOutline),
                  ),
                  IconButton(
                    tooltip: "Print".tr,
                    onPressed: () {
                      controller.getDocument();
                    },
                    icon: const Icon(EvaIcons.printerOutline),
                  ),
                  IconButton(
                    tooltip: "Report".tr,
                    onPressed: () {
                      controller.printWorkOrderTasksTicket();
                    },
                    icon: const Icon(Icons.receipt),
                  ),
                  IconButton(
                    tooltip: "Maintenance Card".tr,
                    onPressed: () {
                      Get.to(
                          () =>
                              const MaintenanceStandardMptaskMaintenanceCard(),
                          arguments: {
                            "MpOTID": controller.args["id"],
                            "maintainId": controller.args["maintenanceId"],
                            "paidAmt": controller.paidAmtFieldController.text,
                            "request": controller.requestFieldController.text,
                            "note": controller.noteFieldController.text,
                            "manualNote":
                                controller.manualNoteFieldController.text,
                          });
                    },
                    icon: const Icon(Symbols.info),
                  ),
                ],
              ),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.prodCountList.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.setFilter(controller.prodCountList
                                          .records![index].mProductID?.id ??
                                      0);
                                },
                                child: Text(
                                    "${controller.prodCountList.records![index].mProductID?.identifier} : ${controller.prodCountList.records![index].qty}")),
                          );
                        })
                    : const SizedBox(),
              ),
              Container(
                color: Colors.grey[600],
                width: screenSize.width,
                height: 0.25,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  //readOnly: true,
                  minLines: 1,
                  maxLines: 1,
                  controller: controller.paidAmtFieldController,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.text_fields),
                    border: const OutlineInputBorder(),
                    labelText: 'Paid Amt'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.requestFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Request Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity To Do'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.manualNoteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity Done'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
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
                                trailing: IconButton(
                                  onPressed: () {
                                    int taskindex = 0;
                                    for (var i = 0;
                                        i < controller._trx2.records!.length;
                                        i++) {
                                      if (controller._trx2.records![i].id ==
                                          controller._trx.records![index].id) {
                                        taskindex = i;
                                      }
                                    }
                                    //print(taskindex);
                                    Get.to(
                                        const EditMaintenanceStandardMptaskLine(),
                                        arguments: {
                                          "index": taskindex,
                                          "id": controller
                                              ._trx.records![index].id,
                                          "qtyEntered": (controller
                                                      ._trx
                                                      .records![index]
                                                      .qtyEntered ??
                                                  0)
                                              .toString(),
                                          "resourceQty": controller
                                              ._trx.records![index].resourceQty
                                              .toString(),
                                          "description": controller
                                              ._trx.records![index].description,
                                          "qty": controller
                                              ._trx.records![index].qty
                                              .toString(),
                                          "offlineid": controller
                                              ._trx.records![index].offlineId,
                                          "prod": controller
                                              ._trx
                                              .records![index]
                                              .mProductID
                                              ?.identifier,
                                          "prodId": controller._trx
                                              .records![index].mProductID?.id,
                                          "priceList": (controller
                                                      ._trx
                                                      .records![index]
                                                      .priceList ??
                                                  0.0)
                                              .toString(),
                                          "priceEntered": (controller
                                                      ._trx
                                                      .records![index]
                                                      .priceEntered ??
                                                  0.0)
                                              .toString(),
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
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
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Delete Task',
                                    onPressed: () {
                                      controller.deleteTask(
                                          controller._trx.records![index].id!,
                                          index);
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].mProductID
                                          ?.identifier ??
                                      "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ${controller.trx.records![index].qty}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "${"Description".tr}: ${controller.trx.records![index].description ?? ""}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Price".tr}: ${controller.trx.records![index].priceEntered ?? 0.00}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Prezzo Listino".tr}: ${controller.trx.records![index].priceList ?? 0.00}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: const [],
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
              Container(
                color: Colors.grey[600],
                width: screenSize.width,
                height: 0.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: "Save".tr,
                    onPressed: () {
                      controller.editManualNote();
                      controller.editPaidAmt();
                    },
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    tooltip: "Add Task".tr,
                    onPressed: () {
                      Get.to(const CreateMaintenanceStandardMptask(),
                          arguments: {
                            "id": controller.args["id"],
                          });
                    },
                    icon: const Icon(EvaIcons.fileAddOutline),
                  ),
                  IconButton(
                    tooltip: "Print".tr,
                    onPressed: () {
                      controller.getDocument();
                    },
                    icon: const Icon(EvaIcons.printerOutline),
                  ),
                  IconButton(
                    tooltip: "Report".tr,
                    onPressed: () {
                      controller.printWorkOrderTasksTicket();
                    },
                    icon: const Icon(Icons.receipt),
                  ),
                  IconButton(
                    tooltip: "Maintenance Card".tr,
                    onPressed: () {
                      Get.to(
                          () =>
                              const MaintenanceStandardMptaskMaintenanceCard(),
                          arguments: {
                            "MpOTID": controller.args["id"],
                            "maintainId": controller.args["maintenanceId"],
                            "paidAmt": controller.paidAmtFieldController.text,
                            "request": controller.requestFieldController.text,
                            "note": controller.noteFieldController.text,
                            "manualNote":
                                controller.manualNoteFieldController.text,
                          });
                    },
                    icon: const Icon(Symbols.info),
                  ),
                ],
              ),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.prodCountList.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.setFilter(controller.prodCountList
                                          .records![index].mProductID?.id ??
                                      0);
                                },
                                child: Text(
                                    "${controller.prodCountList.records![index].mProductID?.identifier} : ${controller.prodCountList.records![index].qty}")),
                          );
                        })
                    : const SizedBox(),
              ),
              Container(
                color: Colors.grey[600],
                width: screenSize.width,
                height: 0.25,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  //readOnly: true,
                  minLines: 1,
                  maxLines: 1,
                  controller: controller.paidAmtFieldController,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.text_fields),
                    border: const OutlineInputBorder(),
                    labelText: 'Paid Amt'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.requestFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Request Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity To Do'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.args["isSpecialOrder"],
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: controller.manualNoteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity Done'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
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
                                trailing: IconButton(
                                  onPressed: () {
                                    int taskindex = 0;
                                    for (var i = 0;
                                        i < controller._trx2.records!.length;
                                        i++) {
                                      if (controller._trx2.records![i].id ==
                                          controller._trx.records![index].id) {
                                        taskindex = i;
                                      }
                                    }
                                    //print(taskindex);
                                    Get.to(
                                        const EditMaintenanceStandardMptaskLine(),
                                        arguments: {
                                          "index": taskindex,
                                          "id": controller
                                              ._trx.records![index].id,
                                          "qtyEntered": (controller
                                                      ._trx
                                                      .records![index]
                                                      .qtyEntered ??
                                                  0)
                                              .toString(),
                                          "resourceQty": controller
                                              ._trx.records![index].resourceQty
                                              .toString(),
                                          "description": controller
                                              ._trx.records![index].description,
                                          "qty": controller
                                              ._trx.records![index].qty
                                              .toString(),
                                          "offlineid": controller
                                              ._trx.records![index].offlineId,
                                          "prod": controller
                                              ._trx
                                              .records![index]
                                              .mProductID
                                              ?.identifier,
                                          "prodId": controller._trx
                                              .records![index].mProductID?.id,
                                          "priceList": (controller
                                                      ._trx
                                                      .records![index]
                                                      .priceList ??
                                                  0.0)
                                              .toString(),
                                          "priceEntered": (controller
                                                      ._trx
                                                      .records![index]
                                                      .priceEntered ??
                                                  0.0)
                                              .toString(),
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
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
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Delete Task',
                                    onPressed: () {
                                      controller.deleteTask(
                                          controller._trx.records![index].id!,
                                          index);
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].mProductID
                                          ?.identifier ??
                                      "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ${controller.trx.records![index].qty}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "${"Description".tr}: ${controller.trx.records![index].description ?? ""}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Price".tr}: ${controller.trx.records![index].priceEntered ?? 0.00}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Prezzo Listino".tr}: ${controller.trx.records![index].priceList ?? 0.00}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: const [],
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

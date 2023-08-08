library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/reflist_resource_type_json.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_resource_anomaly.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_edit_mptask_resource_screen.dart';
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
import 'package:idempiere_app/components/rounded_code_field.dart';
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
part '../components/sidebar.dart';
part '../components/team_member.dart';

class MaintenanceMpResourceScreen
    extends GetView<MaintenanceMpResourceController> {
  const MaintenanceMpResourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.arrow_upward),
          onPressed: () {
            //print('hello');
            controller.listscrollController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          }),
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
            Text("${controller.args["docN"]}"),
            Text("${GetStorage().read('selectedTaskBP')}"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            //Get.offNamed('/MaintenanceMptask');
            Get.back();
          },
        ),
      ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Obx(() => controller.dataAvailable
                      ? Text(
                          "${"RESOURCES".tr}: ${controller._trx.records!.length}")
                      : Text("${"RESOURCES".tr}: ")),
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
                      controller.syncThisWorkOrderResource(
                          GetStorage().read('selectedTaskDocNo'));
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    tooltip: 'Send locally saved records',
                    onPressed: () async {
                      if (await checkConnection()) {
                        emptyAPICallStak();
                      } else {
                        Get.snackbar(
                          "Error!".tr,
                          "No Internet connection".tr,
                          icon: const Icon(
                            Icons.signal_wifi_connected_no_internet_4_outlined,
                            color: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      color: kNotifColor,
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
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter3Available.value,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: controller.dropDownValue3.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue3.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt3.records!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list.id.toString(),
                            child: Text(
                              list.name.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter1Available.value,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: controller.dropDownValue2.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue2.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt2.records!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list.value,
                            child: Text(
                              list.name.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter2Available.value,
                      child: TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter3Available.value,
                      child: DropdownButton(
                        value: controller.dropDownValue3.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue3.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt3.records!.map((list) {
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
                ), */
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  //padding: const EdgeInsets.all(10),
                  //width: 20,
                  /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                  child: Obx(
                    () => DropdownButton(
                      underline: const SizedBox(),
                      icon: const Icon(Icons.filter_alt_sharp),
                      value: controller.dropdownValue.value,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        controller.dropdownValue.value = newValue!;

                        //print(dropdownValue);
                      },
                      items: controller.dropDownList.map((list) {
                        return DropdownMenuItem<String>(
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      autofocus: true,
                      onTap: () {
                        controller.searchFieldController.text = "";
                      },
                      controller: controller.searchFieldController,
                      onSubmitted: (String? value) {
                        controller.searchFilterValue.value =
                            controller.searchFieldController.text;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(EvaIcons.search),
                        hintText: "search..".tr,
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing),
            Obx(
              () => controller.dataAvailable
                  ? Expanded(
                      child: ListView.builder(
                        key: const PageStorageKey<String>('workorderresource'),
                        controller: controller.listscrollController,
                        //primary: true,
                        //reverse: true,
                        // scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(() => Visibility(
                                visible: GetStorage().read('selectedTaskDocNo') ==
                                            controller.trx.records![index]
                                                .mpMaintainID?.id &&
                                        controller.trx.records![index].resourceStatus?.id ==
                                            "INS" &&
                                        controller.searchFilterValue.value == ""
                                    ? true
                                    : controller.dropdownValue.value == "1"
                                        ? controller.trx.records![index].prodCode
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller.searchFilterValue.value
                                                .toLowerCase())
                                        : controller.dropdownValue.value == "2"
                                            ? controller.trx.records![index].serNo
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller.searchFilterValue.value
                                                    .toLowerCase())
                                            : controller.dropdownValue.value ==
                                                    "3"
                                                ? controller.trx.records![index].locationComment
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(controller.searchFilterValue.value.toLowerCase())
                                                : controller.dropdownValue.value == "4"
                                                    ? controller.trx.records![index].number.toString().toLowerCase() == controller.searchFilterValue.value.toLowerCase()
                                                    : true,
                                child: Card(
                                  elevation: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(64, 75, 96, .9)),
                                    child: ExpansionTile(
                                      key: PageStorageKey(
                                          'workorderresource$index'),
                                      initiallyExpanded: true,
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
                                                      controller.now.year
                                                          .toString()
                                                  ? Colors.orange
                                                  : Colors.green,
                                        ),
                                      ),
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      leading: Container(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white24))),
                                        child: IconButton(
                                          icon: Icon(
                                            controller.trx.records![index]
                                                            .eDIType?.id ==
                                                        'A02' ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .eDIType
                                                            ?.id ==
                                                        "A08"
                                                ? Icons.grid_4x4_outlined
                                                : Icons.auto_stories,
                                            color: Colors.green,
                                          ),
                                          //tooltip: '',
                                          onPressed: () async {
                                            switch (controller.trx
                                                .records![index].eDIType?.id) {
                                              case "A01":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "orderedDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

                                                break;
                                              case 'A02':
                                                Get.toNamed(
                                                    '/MaintenanceMpResourceFireExtinguisherGrid',
                                                    arguments: {
                                                      "products": File(
                                                          '${(await getApplicationDocumentsDirectory()).path}/products.json')
                                                    });
                                                break;
                                              case "A03":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

                                                break;
                                              case "A04":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

                                                break;
                                              case "A05":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                      });
                                                }

                                                break;
                                              case "A06":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

                                                break;
                                              case "A09":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

                                                break;
                                              case "A10":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

                                                break;
                                              case "A12":
                                                if (controller
                                                        .trx
                                                        .records![index]
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
                                                        "id": controller.trx
                                                            .records![index].id,
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
                                                            .trx
                                                            .records![index]
                                                            .lot,
                                                        "location": controller
                                                            .trx
                                                            .records![index]
                                                            .locationComment,
                                                        "locationCode":
                                                            controller
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
                                                        "serviceDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .serviceDate,
                                                        "orderedDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "endDate": controller
                                                            .trx
                                                            .records![index]
                                                            .endDate,
                                                        "manufacturer":
                                                            controller
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
                                                        "purchaseDate":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .dateOrdered,
                                                        "note": controller
                                                            .trx
                                                            .records![index]
                                                            .note,
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
                                                        "resourceStatus":
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                        "resourceGroup": controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id,
                                                        "dateWorkStart":
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .mpDateworkstart,
                                                        "middlePeriod":
                                                            int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .periodAction ??
                                                                "1"),
                                                      });
                                                }

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
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "NR. ${controller.trx.records![index].number} L. ${controller.trx.records![index].lineNo} b. ${controller.trx.records![index].prodCode} M. ${controller.trx.records![index].serNo}",
                                                  style: const TextStyle(
                                                    color:
                                                        kNotifColor, /* fontWeight: FontWeight.bold */
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  controller
                                                          .trx
                                                          .records![index]
                                                          .mProductID
                                                          ?.identifier ??
                                                      "???",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                            children: <Widget>[
                                              const Icon(
                                                Icons.location_city,
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.trx.records![index]
                                                          .locationComment ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(children: [
                                            Text(
                                              'Quantity: '.tr,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${controller.trx.records![index].resourceQty}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ]),
                                          Row(children: [
                                            Text(
                                              'Manufactured Year: '.tr,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              controller.trx.records![index]
                                                  .manufacturedYear
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ]),
                                          Visibility(
                                            visible: controller.trx
                                                    .records![index].isOwned ??
                                                false,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                                  child: Text(
                                                    "Is Property".tr,
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: controller
                                                    .trx
                                                    .records![index]
                                                    .anomaliesCount !=
                                                "0",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                                  child: Text(
                                                    "Has Anomaly".tr,
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: controller
                                                    .trx
                                                    .records![index]
                                                    .doneAction !=
                                                "Nothing",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: kNotifColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                                  child: Text(
                                                    controller
                                                        .trx
                                                        .records![index]
                                                        .doneAction!
                                                        .tr
                                                        .tr,
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: controller
                                                        .trx
                                                        .records![index]
                                                        .toDoAction! !=
                                                    "OK" &&
                                                controller.trx.records![index]
                                                        .doneAction ==
                                                    "Nothing",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: controller.trx.records![index].toDoAction! == "OK" ||
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction! ==
                                                                "NEW"
                                                        ? kNotifColor
                                                        : controller.trx.records![index].toDoAction! == "PR" ||
                                                                controller.trx.records![index].toDoAction! ==
                                                                    "PC" ||
                                                                controller.trx.records![index].toDoAction! ==
                                                                    "PRnow" ||
                                                                controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .toDoAction! ==
                                                                    "PCnow"
                                                            ? const Color.fromARGB(
                                                                255, 209, 189, 4)
                                                            : controller.trx.records![index].toDoAction! ==
                                                                        "PT" ||
                                                                    controller.trx.records![index].toDoAction! ==
                                                                        "PTnow"
                                                                ? Colors.orange
                                                                : controller
                                                                            .trx
                                                                            .records![index]
                                                                            .toDoAction! ==
                                                                        "PSG"
                                                                    ? Colors.red
                                                                    : controller.trx.records![index].toDoAction! == "PX"
                                                                        ? Colors.black
                                                                        : kNotifColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                                  child: Text(
                                                    controller
                                                        .trx
                                                        .records![index]
                                                        .toDoAction!
                                                        .tr,
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */

                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            Row(children: [
                                              Text('Note: '.tr),
                                              Expanded(
                                                child: Text(controller.trx
                                                        .records![index].note ??
                                                    ""),
                                              ),
                                            ]),
                                            Row(children: [
                                              Text('Status: '.tr),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .resourceStatus
                                                      ?.identifier ??
                                                  ""),
                                            ]),
                                            /* Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]), */
                                            Row(children: [
                                              Text('Description: '.tr),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .description ??
                                                  ""),
                                            ]),
                                            /* Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]), */
                                            /* Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]), */
                                            Row(children: [
                                              Text('Check Date: '.tr),
                                              Text(
                                                  "${DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl1DateNext!))}"),
                                            ]),
                                            /* Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]), */
                                            Row(children: [
                                              Text('Revision Date: '.tr),
                                              Text(
                                                  "${DateTime.tryParse(controller.trx.records![index].lITControl2DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl2DateFrom!)) : ""} - ${controller.trx.records![index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl2DateNext!)) : ""}"),
                                            ]),
                                            /*  Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]), */ //DateFormat('dd-MM-yyyy').format(
                                            //DateTime.parse(controller.trx
                                            //   .records![index].jpToDoStartDate!))
                                            Row(children: [
                                              Text('Testing Date: '.tr),
                                              Text(
                                                  "${DateTime.tryParse(controller.trx.records![index].lITControl3DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl3DateFrom!)) : ""} - ${controller.trx.records![index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl3DateNext!)) : ""}"),
                                            ]),

                                            Row(children: [
                                              Text('Manufacturer: '.tr),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .manufacturer ??
                                                  ""),
                                            ]),
                                            Visibility(
                                              visible: controller
                                                          .trx
                                                          .records![index]
                                                          .eDIType
                                                          ?.id ==
                                                      "A01" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A03" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A04" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A05" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A06" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A09" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A10" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A11" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A12" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A13",
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Edit',
                                                    onPressed: () async {
                                                      var index2 = 0;
                                                      for (var i = 0;
                                                          i <
                                                              controller
                                                                  ._trx2
                                                                  .records!
                                                                  .length;
                                                          i++) {
                                                        if (controller
                                                                ._trx2
                                                                .records![i]
                                                                .id ==
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .id) {
                                                          index2 = i;
                                                        }
                                                      }
                                                      Get.to(
                                                          const EditMaintenanceMpResource(),
                                                          arguments: {
                                                            "perm": controller
                                                                .getPerm(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .eDIType!
                                                                    .id!),
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                            "number": controller
                                                                .trx
                                                                .records![index]
                                                                .number,
                                                            "lineNo": controller
                                                                .trx
                                                                .records![index]
                                                                .lineNo
                                                                .toString(),
                                                            "cartel": controller
                                                                .trx
                                                                .records![index]
                                                                .textDetails,
                                                            "model": controller
                                                                .trx
                                                                .records![index]
                                                                .lITProductModel,
                                                            "dateOrder":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .dateOrdered,
                                                            "years": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .useLifeYears !=
                                                                    null
                                                                ? controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .useLifeYears
                                                                    .toString()
                                                                : "0",
                                                            "user": controller
                                                                .trx
                                                                .records![index]
                                                                .userName,
                                                            "serviceDate":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .serviceDate,
                                                            "productName":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .identifier,
                                                            "productId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .id,
                                                            "cartelFormatId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litCartelFormID
                                                                    ?.id,
                                                            "subCategoryId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litmProductSubCategoryID
                                                                    ?.id,
                                                            "cartelFormatName":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litCartelFormID
                                                                    ?.identifier,
                                                            "location": controller
                                                                .trx
                                                                .records![index]
                                                                .locationComment,
                                                            "observation":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .name,
                                                            "SerNo": controller
                                                                .trx
                                                                .records![index]
                                                                .serNo,
                                                            "barcode":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .prodCode,
                                                            "manufacturer":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .manufacturer,
                                                            "year": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .manufacturedYear !=
                                                                    null
                                                                ? controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .manufacturedYear
                                                                    .toString()
                                                                : "0",
                                                            "Description":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .description,
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
                                                            "offlineid":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .offlineId,
                                                            "index": index2,
                                                            "length": controller
                                                                .trx
                                                                .records![index]
                                                                .length,
                                                            "width": controller
                                                                .trx
                                                                .records![index]
                                                                .width,
                                                            "weightAmt":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .weightAmt,
                                                            "height": controller
                                                                .trx
                                                                .records![index]
                                                                .height,
                                                            "color": controller
                                                                .trx
                                                                .records![index]
                                                                .color,
                                                            "resourceStatus": controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                            "resourceGroup":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litResourceGroupID
                                                                    ?.id,
                                                            "note": controller
                                                                .trx
                                                                .records![index]
                                                                .note,
                                                            "name": controller
                                                                .trx
                                                                .records![index]
                                                                .name,
                                                            "lot": controller
                                                                .trx
                                                                .records![index]
                                                                .lot,
                                                          });
                                                      /* controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
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
                                                    icon: const Text('C'),
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
                                                      }
                                                      Get.to(
                                                          const CreateResAnomaly(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
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
                                                            "isConnected":
                                                                isConnected,
                                                          });
                                                    },
                                                    icon: Stack(
                                                      children: <Widget>[
                                                        const Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .anomaliesCount !=
                                                              "0",
                                                          child: Positioned(
                                                            right: 1,
                                                            top: 1,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              constraints:
                                                                  const BoxConstraints(
                                                                minWidth: 12,
                                                                minHeight: 12,
                                                              ),
                                                              child: Text(
                                                                '${controller.trx.records![index].anomaliesCount}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Undo',
                                                    onPressed: () async {
                                                      if (await checkConnection()) {
                                                        controller.undoLastChanges(
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .id!,
                                                            "mp-maintain-resource");
                                                      }
                                                    },
                                                    icon:
                                                        const Icon(Icons.undo),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                          .trx
                                                          .records![index]
                                                          .eDIType
                                                          ?.id ==
                                                      "A02" ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A08",
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      tooltip: 'Edit',
                                                      onPressed: () async {
                                                        var index2 = 0;
                                                        for (var i = 0;
                                                            i <
                                                                controller
                                                                    ._trx2
                                                                    .records!
                                                                    .length;
                                                            i++) {
                                                          if (controller
                                                                  ._trx2
                                                                  .records![i]
                                                                  .id ==
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .id) {
                                                            index2 = i;
                                                          }
                                                        }
                                                        /* print(controller
                                                            .trx
                                                            .records![index]
                                                            .litResourceGroupID
                                                            ?.id); */
                                                        Get.to(
                                                            const EditMaintenanceMpResource(),
                                                            arguments: {
                                                              "perm": controller
                                                                  .getPerm(
                                                                      "A02"),
                                                              "id": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .id,
                                                              "number":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .number,
                                                              "lineNo": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .lineNo
                                                                  .toString(),
                                                              "cartel": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .textDetails,
                                                              "model": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .lITProductModel,
                                                              "dateOrder":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .dateOrdered,
                                                              "years": controller
                                                                          .trx
                                                                          .records![
                                                                              index]
                                                                          .useLifeYears !=
                                                                      null
                                                                  ? controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .useLifeYears
                                                                      .toString()
                                                                  : "0",
                                                              "user": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .userName,
                                                              "serviceDate":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .serviceDate,
                                                              "productName":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID!
                                                                      .identifier,
                                                              "productId":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID!
                                                                      .id,
                                                              "cartelFormatId":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .litCartelFormID
                                                                      ?.id,
                                                              "subCategoryId":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .litmProductSubCategoryID
                                                                      ?.id,
                                                              "cartelFormatName":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .litCartelFormID
                                                                      ?.identifier,
                                                              "location": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .locationComment,
                                                              "observation":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .name,
                                                              "SerNo":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .serNo,
                                                              "barcode":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .prodCode,
                                                              "manufacturer":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .manufacturer,
                                                              "year": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturedYear
                                                                  .toString(),
                                                              "Description":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .description,
                                                              "date3": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .lITControl3DateFrom,
                                                              "date2": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .lITControl2DateFrom,
                                                              "date1": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .lITControl1DateFrom,
                                                              "offlineid":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .offlineId,
                                                              "index": index2,
                                                              "resourceStatus": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .resourceStatus
                                                                      ?.id ??
                                                                  "OUT",
                                                              "resourceGroup":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .litResourceGroupID
                                                                      ?.id,
                                                              "length":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .length,
                                                              "width":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .width,
                                                              "weightAmt":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .weightAmt,
                                                              "height":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .height,
                                                              "color":
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .color,
                                                              "note": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .note,
                                                              "name": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .name,
                                                              "lot": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .lot,
                                                            });
                                                        /* controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index); */
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Check',
                                                      onPressed: () async {
                                                        if (controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction !=
                                                                "PC" &&
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction !=
                                                                "Nothing") {
                                                          Get.defaultDialog(
                                                            title: 'Warning'.tr,
                                                            content: Text(
                                                                "The resource shouldn't be checked"
                                                                    .tr
                                                                    .tr),
                                                            onCancel: () {},
                                                            onConfirm:
                                                                () async {
                                                              Get.back();
                                                              var isConnected =
                                                                  await checkConnection();
                                                              controller
                                                                  .editWorkOrderResourceDateCheck(
                                                                      isConnected,
                                                                      index);
                                                            },
                                                          );
                                                        } else {
                                                          var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index);
                                                        }
                                                      },
                                                      icon: const Text('C'),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Revision',
                                                      onPressed: () async {
                                                        if (controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction !=
                                                                "PR" &&
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction !=
                                                                "Nothing") {
                                                          Get.defaultDialog(
                                                            title: 'Warning'.tr,
                                                            content: Text(
                                                                "The resource shouldn't be reviewed"
                                                                    .tr
                                                                    .tr),
                                                            onCancel: () {},
                                                            onConfirm:
                                                                () async {
                                                              Get.back();
                                                              /* var isConnected =
                                                                  await checkConnection(); */
                                                              controller
                                                                  .reviewResourceButton(
                                                                      index);
                                                            },
                                                          );
                                                        } else {
                                                          /* var isConnected =
                                                              await checkConnection(); */
                                                          controller
                                                              .reviewResourceButton(
                                                                  index);
                                                        }
                                                        /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                      },
                                                      icon: const Text('R'),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Testing',
                                                      onPressed: () async {
                                                        if (controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction !=
                                                                "PT" &&
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .toDoAction !=
                                                                "Nothing") {
                                                          Get.defaultDialog(
                                                            title: 'Warning'.tr,
                                                            content: Text(
                                                                "The resource shouldn't be tested"
                                                                    .tr
                                                                    .tr),
                                                            onCancel: () {},
                                                            onConfirm:
                                                                () async {
                                                              Get.back();
                                                              /* var isConnected =
                                                                  await checkConnection(); */
                                                              controller
                                                                  .testingResourceButton(
                                                                      index);
                                                            },
                                                          );
                                                        } else {
                                                          /* var isConnected =
                                                              await checkConnection(); */
                                                          controller
                                                              .testingResourceButton(
                                                                  index);
                                                        }
                                                      },
                                                      icon: const Text('CL'),
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
                                                        }
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
                                                              "isConnected":
                                                                  isConnected,
                                                            });
                                                      },
                                                      icon: Stack(
                                                        children: <Widget>[
                                                          const Icon(
                                                            Icons.warning,
                                                            color: Colors.red,
                                                          ),
                                                          Visibility(
                                                            visible: controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .anomaliesCount !=
                                                                "0",
                                                            child: Positioned(
                                                              right: 1,
                                                              top: 1,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(1),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                ),
                                                                constraints:
                                                                    const BoxConstraints(
                                                                  minWidth: 12,
                                                                  minHeight: 12,
                                                                ),
                                                                child: Text(
                                                                  '${controller.trx.records![index].anomaliesCount}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 8,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Replace',
                                                      onPressed: () async {
                                                        controller
                                                            .replaceResourceButton(
                                                                index);
                                                        /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                      },
                                                      icon: const Icon(
                                                          Icons.find_replace),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Undo',
                                                      onPressed: () async {
                                                        if (await checkConnection()) {
                                                          controller
                                                              .undoLastChanges(
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .id!,
                                                                  "mp-maintain-resource");
                                                        }

                                                        /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                      },
                                                      icon: const Icon(
                                                          Icons.undo),
                                                    ),
                                                  ]),
                                            ),
                                            Visibility(
                                              //
                                              visible: controller
                                                      .trx
                                                      .records![index]
                                                      .eDIType
                                                      ?.id ==
                                                  "A07",
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Edit A07',
                                                    onPressed: () async {
                                                      var index2 = 0;
                                                      for (var i = 0;
                                                          i <
                                                              controller
                                                                  ._trx2
                                                                  .records!
                                                                  .length;
                                                          i++) {
                                                        if (controller
                                                                ._trx2
                                                                .records![i]
                                                                .id ==
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .id) {
                                                          index2 = i;
                                                        }
                                                      }
                                                      Get.to(
                                                          const EditMaintenanceMpResource(),
                                                          arguments: {
                                                            "perm": controller
                                                                .getPerm("A07"),
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                            "number": controller
                                                                .trx
                                                                .records![index]
                                                                .number,
                                                            "lineNo": controller
                                                                .trx
                                                                .records![index]
                                                                .lineNo
                                                                .toString(),
                                                            "cartel": controller
                                                                .trx
                                                                .records![index]
                                                                .textDetails,
                                                            "model": controller
                                                                .trx
                                                                .records![index]
                                                                .lITProductModel,
                                                            "dateOrder":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .dateOrdered,
                                                            "years": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .useLifeYears !=
                                                                    null
                                                                ? controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .useLifeYears
                                                                    .toString()
                                                                : "0",
                                                            "user": controller
                                                                .trx
                                                                .records![index]
                                                                .userName,
                                                            "serviceDate":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .serviceDate,
                                                            "productName":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .identifier,
                                                            "productId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .id,
                                                            "cartelFormatId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litCartelFormID
                                                                    ?.id,
                                                            "cartelFormatName":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litCartelFormID
                                                                    ?.identifier,
                                                            "subCategoryId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litmProductSubCategoryID
                                                                    ?.id,
                                                            "location": controller
                                                                .trx
                                                                .records![index]
                                                                .locationComment,
                                                            "observation":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .name,
                                                            "SerNo": controller
                                                                .trx
                                                                .records![index]
                                                                .serNo,
                                                            "barcode":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .prodCode,
                                                            "manufacturer":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .manufacturer,
                                                            "year": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .manufacturedYear !=
                                                                    null
                                                                ? controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .manufacturedYear
                                                                    .toString()
                                                                : "0",
                                                            "Description":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .description,
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
                                                            "offlineid":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .offlineId,
                                                            "index": index2,
                                                            "length": controller
                                                                .trx
                                                                .records![index]
                                                                .length,
                                                            "width": controller
                                                                .trx
                                                                .records![index]
                                                                .width,
                                                            "weightAmt":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .weightAmt,
                                                            "height": controller
                                                                .trx
                                                                .records![index]
                                                                .height,
                                                            "color": controller
                                                                .trx
                                                                .records![index]
                                                                .color,
                                                            "resourceStatus": controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                            "resourceGroup":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litResourceGroupID
                                                                    ?.id,
                                                            "note": controller
                                                                .trx
                                                                .records![index]
                                                                .note,
                                                            "name": controller
                                                                .trx
                                                                .records![index]
                                                                .name,
                                                            "lot": controller
                                                                .trx
                                                                .records![index]
                                                                .lot,
                                                          });
                                                      /* controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
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
                                                    icon: const Text('C'),
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
                                                      }
                                                      Get.to(
                                                          const CreateResAnomaly(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
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
                                                            "isConnected":
                                                                isConnected,
                                                          });
                                                    },
                                                    icon: Stack(
                                                      children: <Widget>[
                                                        const Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .anomaliesCount !=
                                                              "0",
                                                          child: Positioned(
                                                            right: 1,
                                                            top: 1,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              constraints:
                                                                  const BoxConstraints(
                                                                minWidth: 12,
                                                                minHeight: 12,
                                                              ),
                                                              child: Text(
                                                                '${controller.trx.records![index].anomaliesCount}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Undo',
                                                    onPressed: () async {
                                                      if (await checkConnection()) {
                                                        controller.undoLastChanges(
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .id!,
                                                            "mp-maintain-resource");
                                                      }
                                                    },
                                                    icon:
                                                        const Icon(Icons.undo),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Consume Item',
                                                  onPressed: () async {
                                                    if (await checkConnection()) {
                                                      controller
                                                          .openConsumeItem(
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .id!);
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      MaterialSymbols
                                                          .place_item),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
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
                  margin: const EdgeInsets.only(left: 15),
                  child: Obx(() => controller.dataAvailable
                      ? Text(
                          "${"RESOURCES".tr}: ${controller._trx.records!.length}")
                      : Text("${"RESOURCES".tr}: ")),
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
                      controller.syncThisWorkOrderResource(
                          GetStorage().read('selectedTaskDocNo'));
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    tooltip: 'Send locally saved records',
                    onPressed: () async {
                      if (await checkConnection()) {
                        emptyAPICallStak();
                      } else {
                        Get.snackbar(
                          "Error!".tr,
                          "No Internet connection".tr,
                          icon: const Icon(
                            Icons.signal_wifi_connected_no_internet_4_outlined,
                            color: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      color: kNotifColor,
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
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter3Available.value,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: controller.dropDownValue3.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue3.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt3.records!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list.id.toString(),
                            child: Text(
                              list.name.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter1Available.value,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: controller.dropDownValue2.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue2.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt2.records!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list.value,
                            child: Text(
                              list.name.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter2Available.value,
                      child: TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter3Available.value,
                      child: DropdownButton(
                        value: controller.dropDownValue3.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue3.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt3.records!.map((list) {
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
                ), */
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  //padding: const EdgeInsets.all(10),
                  //width: 20,
                  /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                  child: Obx(
                    () => DropdownButton(
                      underline: const SizedBox(),
                      icon: const Icon(Icons.filter_alt_sharp),
                      value: controller.dropdownValue.value,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        controller.dropdownValue.value = newValue!;

                        //print(dropdownValue);
                      },
                      items: controller.dropDownList.map((list) {
                        return DropdownMenuItem<String>(
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      autofocus: true,
                      onTap: () {
                        controller.searchFieldController.text = "";
                      },
                      controller: controller.searchFieldController,
                      onSubmitted: (String? value) {
                        controller.searchFilterValue.value =
                            controller.searchFieldController.text;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(EvaIcons.search),
                        hintText: "search..".tr,
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing),
            Obx(
              () => controller.dataAvailable
                  ? ListView.builder(
                      key: const PageStorageKey<String>('workorderresource'),
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: controller.trx.records!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => Visibility(
                              visible: GetStorage().read('selectedTaskDocNo') ==
                                          controller.trx.records![index]
                                              .mpMaintainID?.id &&
                                      controller.trx.records![index].resourceStatus?.id ==
                                          "INS" &&
                                      controller.searchFilterValue.value == ""
                                  ? true
                                  : controller.dropdownValue.value == "1"
                                      ? controller.trx.records![index].prodCode
                                          .toString()
                                          .toLowerCase()
                                          .contains(controller.searchFilterValue.value
                                              .toLowerCase())
                                      : controller.dropdownValue.value == "2"
                                          ? controller.trx.records![index].serNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
                                                  "3"
                                              ? controller.trx.records![index]
                                                  .locationComment
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller.searchFilterValue.value.toLowerCase())
                                              : controller.dropdownValue.value == "4"
                                                  ? controller.trx.records![index].number.toString().toLowerCase() == controller.searchFilterValue.value.toLowerCase()
                                                  : true,
                              child: Card(
                                elevation: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ExpansionTile(
                                    key: PageStorageKey(
                                        'workorderresource$index'),
                                    initiallyExpanded: true,
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
                                                    controller.now.year
                                                        .toString()
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    leading: Container(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.white24))),
                                      child: IconButton(
                                        icon: Icon(
                                          controller.trx.records![index].eDIType
                                                          ?.id ==
                                                      'A02' ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A08"
                                              ? Icons.grid_4x4_outlined
                                              : Icons.edit,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Resource',
                                        onPressed: () async {
                                          switch (controller.trx.records![index]
                                              .eDIType?.id) {
                                            case "A01":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                      "orderedDate": controller
                                                          .trx
                                                          .records![index]
                                                          .dateOrdered,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

                                              break;
                                            case 'A02':
                                              Get.toNamed(
                                                  '/MaintenanceMpResourceFireExtinguisherGrid',
                                                  arguments: {
                                                    "products": File(
                                                        '${(await getApplicationDocumentsDirectory()).path}/products.json')
                                                  });
                                              break;
                                            case "A03":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

                                              break;
                                            case "A04":
                                              if (controller.trx.records![index]
                                                      .offlineId ==
                                                  null) {
                                                print(controller
                                                    .trx
                                                    .records![index]
                                                    .mpDateworkstart);
                                                Get.toNamed(
                                                    '/MaintenanceMpResourceSheet',
                                                    arguments: {
                                                      "surveyId": controller
                                                          .trx
                                                          .records![index]
                                                          .lITSurveySheetsID
                                                          ?.id,
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

                                              break;
                                            case "A05":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

                                              break;
                                            case "A06":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

                                              break;
                                            case "A09":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

                                              break;
                                            case "A10":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                      "dateWorkStart":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .mpDateworkstart,
                                                      "middlePeriod": int.parse(
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .periodAction ??
                                                              "1"),
                                                    });
                                              }

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
                                    title: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "NR. ${controller.trx.records![index].number} L. ${controller.trx.records![index].lineNo} b. ${controller.trx.records![index].prodCode} M. ${controller.trx.records![index].serNo}",
                                                style: const TextStyle(
                                                  color:
                                                      kNotifColor, /* fontWeight: FontWeight.bold */
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier ??
                                                    "???",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          children: <Widget>[
                                            const Icon(
                                              Icons.location_city,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.trx.records![index]
                                                        .locationComment ??
                                                    "",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          Text(
                                            'Quantity: '.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "${controller.trx.records![index].resourceQty}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ]),
                                        Row(children: [
                                          Text(
                                            'Manufactured Year: '.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            controller.trx.records![index]
                                                .manufacturedYear
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ]),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .anomaliesCount !=
                                              "0",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2.5),
                                                child: Text(
                                                  "Has Anomaly".tr,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].doneAction !=
                                              "Nothing",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: kNotifColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2.5),
                                                child: Text(
                                                  controller.trx.records![index]
                                                      .doneAction!.tr.tr,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .toDoAction! !=
                                                  "OK" &&
                                              controller.trx.records![index]
                                                      .doneAction ==
                                                  "Nothing",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: controller.trx.records![index].toDoAction! ==
                                                              "OK" ||
                                                          controller.trx.records![index].toDoAction! ==
                                                              "NEW"
                                                      ? kNotifColor
                                                      : controller.trx.records![index].toDoAction! ==
                                                                  "PR" ||
                                                              controller.trx.records![index].toDoAction! ==
                                                                  "PC" ||
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .toDoAction! ==
                                                                  "PRnow" ||
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .toDoAction! ==
                                                                  "PCnow"
                                                          ? const Color.fromARGB(
                                                              255, 209, 189, 4)
                                                          : controller.trx.records![index].toDoAction! == "PT" ||
                                                                  controller
                                                                          .trx
                                                                          .records![index]
                                                                          .toDoAction! ==
                                                                      "PTnow"
                                                              ? Colors.orange
                                                              : controller.trx.records![index].toDoAction! == "PSG"
                                                                  ? Colors.red
                                                                  : controller.trx.records![index].toDoAction! == "PX"
                                                                      ? Colors.black
                                                                      : kNotifColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2.5),
                                                child: Text(
                                                  controller.trx.records![index]
                                                      .toDoAction!.tr,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
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
                                            Text('Note: '.tr),
                                            Expanded(
                                              child: Text(controller.trx
                                                      .records![index].note ??
                                                  ""),
                                            ),
                                          ]),
                                          Row(children: [
                                            Text('Status: '.tr),
                                            Text(controller
                                                    .trx
                                                    .records![index]
                                                    .resourceStatus
                                                    ?.identifier ??
                                                ""),
                                          ]),
                                          /* Row(children: [
                                        const Text('SerNo: '),
                                        Text(controller
                                                .trx.records![index].serNo ??
                                            "??"),
                                      ]), */
                                          Row(children: [
                                            Text('Description: '.tr),
                                            Text(controller.trx.records![index]
                                                    .description ??
                                                ""),
                                          ]),
                                          /* Row(children: [
                                        const Text('Location Code: '),
                                        Text(controller
                                                .trx.records![index].value ??
                                            "??"),
                                      ]), */
                                          /* Row(children: [
                                        const Text('Check Date: '),
                                        Text(controller.trx.records![index]
                                                .lITControl1DateFrom ??
                                            "??"),
                                      ]), */
                                          Row(children: [
                                            Text('Check Date: '.tr),
                                            Text(
                                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl1DateNext!))}"),
                                          ]),
                                          /* Row(children: [
                                        const Text('Revision Date: '),
                                        Text(controller.trx.records![index]
                                                .lITControl2DateFrom ??
                                            "??"),
                                      ]), */
                                          Row(children: [
                                            Text('Revision Date: '.tr),
                                            Text(
                                                "${DateTime.tryParse(controller.trx.records![index].lITControl2DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl2DateFrom!)) : ""} - ${controller.trx.records![index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl2DateNext!)) : ""}"),
                                          ]),
                                          /*  Row(children: [
                                        const Text('Testing Date: '),
                                        Text(controller.trx.records![index]
                                                .lITControl3DateFrom ??
                                            "??"),
                                      ]), */ //DateFormat('dd-MM-yyyy').format(
                                          //DateTime.parse(controller.trx
                                          //   .records![index].jpToDoStartDate!))
                                          Row(children: [
                                            Text('Testing Date: '.tr),
                                            Text(
                                                "${DateTime.tryParse(controller.trx.records![index].lITControl3DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl3DateFrom!)) : ""} - ${controller.trx.records![index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl3DateNext!)) : ""}"),
                                          ]),

                                          Row(children: [
                                            Text('Manufacturer: '.tr),
                                            Text(controller.trx.records![index]
                                                    .manufacturer ??
                                                ""),
                                          ]),
                                          Visibility(
                                            visible: controller
                                                        .trx
                                                        .records![index]
                                                        .eDIType
                                                        ?.id ==
                                                    "A01" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A03" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A04" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A05" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A06" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A09" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A10" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A11" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A12" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A13",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Edit',
                                                  onPressed: () async {
                                                    var index2 = 0;
                                                    for (var i = 0;
                                                        i <
                                                            controller
                                                                ._trx2
                                                                .records!
                                                                .length;
                                                        i++) {
                                                      if (controller._trx2
                                                              .records![i].id ==
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .id) {
                                                        index2 = i;
                                                      }
                                                    }
                                                    Get.to(
                                                        const EditMaintenanceMpResource(),
                                                        arguments: {
                                                          "perm": controller
                                                              .getPerm(
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .eDIType!
                                                                      .id!),
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "number": controller
                                                              .trx
                                                              .records![index]
                                                              .number,
                                                          "lineNo": controller
                                                              .trx
                                                              .records![index]
                                                              .lineNo
                                                              .toString(),
                                                          "cartel": controller
                                                              .trx
                                                              .records![index]
                                                              .textDetails,
                                                          "model": controller
                                                              .trx
                                                              .records![index]
                                                              .lITProductModel,
                                                          "dateOrder":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .dateOrdered,
                                                          "years": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .useLifeYears !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .useLifeYears
                                                                  .toString()
                                                              : "0",
                                                          "user": controller
                                                              .trx
                                                              .records![index]
                                                              .userName,
                                                          "serviceDate":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .serviceDate,
                                                          "productName":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .identifier,
                                                          "productId":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .id,
                                                          "cartelFormatId":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .litCartelFormID
                                                                  ?.id,
                                                          "cartelFormatName":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .litCartelFormID
                                                                  ?.identifier,
                                                          "location": controller
                                                              .trx
                                                              .records![index]
                                                              .locationComment,
                                                          "observation":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .name,
                                                          "SerNo": controller
                                                              .trx
                                                              .records![index]
                                                              .serNo,
                                                          "barcode": controller
                                                              .trx
                                                              .records![index]
                                                              .prodCode,
                                                          "manufacturer":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturer,
                                                          "year": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .manufacturedYear !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturedYear
                                                                  .toString()
                                                              : "0",
                                                          "Description":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .description,
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
                                                          "offlineid":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .offlineId,
                                                          "index": index2,
                                                          "length": controller
                                                              .trx
                                                              .records![index]
                                                              .length,
                                                          "width": controller
                                                              .trx
                                                              .records![index]
                                                              .width,
                                                          "weightAmt":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .weightAmt,
                                                          "height": controller
                                                              .trx
                                                              .records![index]
                                                              .height,
                                                          "color": controller
                                                              .trx
                                                              .records![index]
                                                              .color,
                                                          "resourceStatus":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .resourceStatus
                                                                      ?.id ??
                                                                  "OUT",
                                                          "resourceGroup":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .litResourceGroupID
                                                                  ?.id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "name": controller
                                                              .trx
                                                              .records![index]
                                                              .name,
                                                        });
                                                    /* controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index); */
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
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
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
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
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: controller
                                                                .trx
                                                                .records![index]
                                                                .anomaliesCount !=
                                                            "0",
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Undo',
                                                  onPressed: () async {
                                                    if (await checkConnection()) {
                                                      controller.undoLastChanges(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .id!,
                                                          "mp-maintain-resource");
                                                    }
                                                  },
                                                  icon: const Icon(Icons.undo),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: controller
                                                        .trx
                                                        .records![index]
                                                        .eDIType
                                                        ?.id ==
                                                    "A02" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A08",
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Edit',
                                                    onPressed: () async {
                                                      var index2 = 0;
                                                      for (var i = 0;
                                                          i <
                                                              controller
                                                                  ._trx2
                                                                  .records!
                                                                  .length;
                                                          i++) {
                                                        if (controller
                                                                ._trx2
                                                                .records![i]
                                                                .id ==
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .id) {
                                                          index2 = i;
                                                        }
                                                      }
                                                      /* print(controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id); */
                                                      Get.to(
                                                          const EditMaintenanceMpResource(),
                                                          arguments: {
                                                            "perm": controller
                                                                .getPerm("A02"),
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                            "number": controller
                                                                .trx
                                                                .records![index]
                                                                .number,
                                                            "lineNo": controller
                                                                .trx
                                                                .records![index]
                                                                .lineNo
                                                                .toString(),
                                                            "cartel": controller
                                                                .trx
                                                                .records![index]
                                                                .textDetails,
                                                            "model": controller
                                                                .trx
                                                                .records![index]
                                                                .lITProductModel,
                                                            "dateOrder":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .dateOrdered,
                                                            "years": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .useLifeYears !=
                                                                    null
                                                                ? controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .useLifeYears
                                                                    .toString()
                                                                : "0",
                                                            "user": controller
                                                                .trx
                                                                .records![index]
                                                                .userName,
                                                            "serviceDate":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .serviceDate,
                                                            "productName":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .identifier,
                                                            "productId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .id,
                                                            "location": controller
                                                                .trx
                                                                .records![index]
                                                                .locationComment,
                                                            "observation":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .name,
                                                            "SerNo": controller
                                                                .trx
                                                                .records![index]
                                                                .serNo,
                                                            "barcode":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .prodCode,
                                                            "manufacturer":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .manufacturer,
                                                            "year": controller
                                                                .trx
                                                                .records![index]
                                                                .manufacturedYear
                                                                .toString(),
                                                            "Description":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .description,
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
                                                            "offlineid":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .offlineId,
                                                            "index": index2,
                                                            "resourceStatus": controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                            "resourceGroup":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litResourceGroupID
                                                                    ?.id,
                                                            "length": controller
                                                                .trx
                                                                .records![index]
                                                                .length,
                                                            "width": controller
                                                                .trx
                                                                .records![index]
                                                                .width,
                                                            "weightAmt":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .weightAmt,
                                                            "height": controller
                                                                .trx
                                                                .records![index]
                                                                .height,
                                                            "color": controller
                                                                .trx
                                                                .records![index]
                                                                .color,
                                                            "note": controller
                                                                .trx
                                                                .records![index]
                                                                .note,
                                                            "name": controller
                                                                .trx
                                                                .records![index]
                                                                .name,
                                                          });
                                                      /* controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Check',
                                                    onPressed: () async {
                                                      if (controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "PC" &&
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "Nothing") {
                                                        Get.defaultDialog(
                                                          title: 'Warning'.tr,
                                                          content: Text(
                                                              "The resource shouldn't be checked"
                                                                  .tr
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            Get.back();
                                                            var isConnected =
                                                                await checkConnection();
                                                            controller
                                                                .editWorkOrderResourceDateCheck(
                                                                    isConnected,
                                                                    index);
                                                          },
                                                        );
                                                      } else {
                                                        var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index);
                                                      }
                                                    },
                                                    icon: const Icon(Icons
                                                        .check_circle_outline),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Revision',
                                                    onPressed: () async {
                                                      if (controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "PR" &&
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "Nothing") {
                                                        Get.defaultDialog(
                                                          title: 'Warning'.tr,
                                                          content: Text(
                                                              "The resource shouldn't be reviewed"
                                                                  .tr
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            Get.back();
                                                            /* var isConnected =
                                                                await checkConnection(); */
                                                            controller
                                                                .reviewResourceButton(
                                                                    index);
                                                          },
                                                        );
                                                      } else {
                                                        /* var isConnected =
                                                            await checkConnection(); */
                                                        controller
                                                            .reviewResourceButton(
                                                                index);
                                                      }
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon: const Icon(Icons
                                                        .handyman_outlined),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Testing',
                                                    onPressed: () async {
                                                      if (controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "PT" &&
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "Nothing") {
                                                        Get.defaultDialog(
                                                          title: 'Warning'.tr,
                                                          content: Text(
                                                              "The resource shouldn't be tested"
                                                                  .tr
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            Get.back();
                                                            /* var isConnected =
                                                                await checkConnection(); */
                                                            controller
                                                                .testingResourceButton(
                                                                    index);
                                                          },
                                                        );
                                                      } else {
                                                        /* var isConnected =
                                                            await checkConnection(); */
                                                        controller
                                                            .testingResourceButton(
                                                                index);
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.gavel_outlined),
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
                                                      }
                                                      Get.to(
                                                          const CreateResAnomaly(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
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
                                                            "isConnected":
                                                                isConnected,
                                                          });
                                                    },
                                                    icon: Stack(
                                                      children: <Widget>[
                                                        const Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .anomaliesCount !=
                                                              "0",
                                                          child: Positioned(
                                                            right: 1,
                                                            top: 1,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              constraints:
                                                                  const BoxConstraints(
                                                                minWidth: 12,
                                                                minHeight: 12,
                                                              ),
                                                              child: Text(
                                                                '${controller.trx.records![index].anomaliesCount}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Replace',
                                                    onPressed: () async {
                                                      controller
                                                          .replaceResourceButton(
                                                              index);
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon: const Icon(
                                                        Icons.find_replace),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Undo',
                                                    onPressed: () async {
                                                      if (await checkConnection()) {
                                                        controller.undoLastChanges(
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .id!,
                                                            "mp-maintain-resource");
                                                      }

                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.undo),
                                                  ),
                                                ]),
                                          ),
                                          Visibility(
                                            //
                                            visible: controller
                                                    .trx
                                                    .records![index]
                                                    .eDIType
                                                    ?.id ==
                                                "A07",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Edit A07',
                                                  onPressed: () async {
                                                    var index2 = 0;
                                                    for (var i = 0;
                                                        i <
                                                            controller
                                                                ._trx2
                                                                .records!
                                                                .length;
                                                        i++) {
                                                      if (controller._trx2
                                                              .records![i].id ==
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .id) {
                                                        index2 = i;
                                                      }
                                                    }
                                                    Get.to(
                                                        const EditMaintenanceMpResource(),
                                                        arguments: {
                                                          "perm": controller
                                                              .getPerm("A07"),
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "number": controller
                                                              .trx
                                                              .records![index]
                                                              .number,
                                                          "lineNo": controller
                                                              .trx
                                                              .records![index]
                                                              .lineNo
                                                              .toString(),
                                                          "cartel": controller
                                                              .trx
                                                              .records![index]
                                                              .textDetails,
                                                          "model": controller
                                                              .trx
                                                              .records![index]
                                                              .lITProductModel,
                                                          "dateOrder":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .dateOrdered,
                                                          "years": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .useLifeYears !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .useLifeYears
                                                                  .toString()
                                                              : "0",
                                                          "user": controller
                                                              .trx
                                                              .records![index]
                                                              .userName,
                                                          "serviceDate":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .serviceDate,
                                                          "productName":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .identifier,
                                                          "productId":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .id,
                                                          "location": controller
                                                              .trx
                                                              .records![index]
                                                              .locationComment,
                                                          "observation":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .name,
                                                          "SerNo": controller
                                                              .trx
                                                              .records![index]
                                                              .serNo,
                                                          "barcode": controller
                                                              .trx
                                                              .records![index]
                                                              .prodCode,
                                                          "manufacturer":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturer,
                                                          "year": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .manufacturedYear !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturedYear
                                                                  .toString()
                                                              : "0",
                                                          "Description":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .description,
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
                                                          "offlineid":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .offlineId,
                                                          "index": index2,
                                                          "length": controller
                                                              .trx
                                                              .records![index]
                                                              .length,
                                                          "width": controller
                                                              .trx
                                                              .records![index]
                                                              .width,
                                                          "weightAmt":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .weightAmt,
                                                          "height": controller
                                                              .trx
                                                              .records![index]
                                                              .height,
                                                          "color": controller
                                                              .trx
                                                              .records![index]
                                                              .color,
                                                          "resourceStatus":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .resourceStatus
                                                                      ?.id ??
                                                                  "OUT",
                                                          "resourceGroup":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .litResourceGroupID
                                                                  ?.id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "name": controller
                                                              .trx
                                                              .records![index]
                                                              .name,
                                                        });
                                                    /* controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index); */
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
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
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
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
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: controller
                                                                .trx
                                                                .records![index]
                                                                .anomaliesCount !=
                                                            "0",
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Undo',
                                                  onPressed: () async {
                                                    if (await checkConnection()) {
                                                      controller.undoLastChanges(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .id!,
                                                          "mp-maintain-resource");
                                                    }
                                                  },
                                                  icon: const Icon(Icons.undo),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
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
                  margin: const EdgeInsets.only(left: 15),
                  child: Obx(() => controller.dataAvailable
                      ? Text(
                          "${"RESOURCES".tr}: ${controller._trx.records!.length}")
                      : Text("${"RESOURCES".tr}: ")),
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
                      controller.syncThisWorkOrderResource(
                          GetStorage().read('selectedTaskDocNo'));
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    tooltip: 'Send locally saved records',
                    onPressed: () async {
                      if (await checkConnection()) {
                        emptyAPICallStak();
                      } else {
                        Get.snackbar(
                          "Error!".tr,
                          "No Internet connection".tr,
                          icon: const Icon(
                            Icons.signal_wifi_connected_no_internet_4_outlined,
                            color: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      color: kNotifColor,
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
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter3Available.value,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: controller.dropDownValue3.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue3.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt3.records!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list.id.toString(),
                            child: Text(
                              list.name.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter1Available.value,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        value: controller.dropDownValue2.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue2.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt2.records!.map((list) {
                          return DropdownMenuItem<String>(
                            value: list.value,
                            child: Text(
                              list.name.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter2Available.value,
                      child: TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Obx(
                    () => Visibility(
                      visible: controller.filter3Available.value,
                      child: DropdownButton(
                        value: controller.dropDownValue3.value,
                        style: const TextStyle(fontSize: 12.0),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          controller.dropDownValue3.value = newValue!;
                          controller.getWorkOrders();
                        },
                        items: controller._tt3.records!.map((list) {
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
                ), */
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  //padding: const EdgeInsets.all(10),
                  //width: 20,
                  /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                  child: Obx(
                    () => DropdownButton(
                      underline: const SizedBox(),
                      icon: const Icon(Icons.filter_alt_sharp),
                      value: controller.dropdownValue.value,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        controller.dropdownValue.value = newValue!;

                        //print(dropdownValue);
                      },
                      items: controller.dropDownList.map((list) {
                        return DropdownMenuItem<String>(
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      autofocus: true,
                      onTap: () {
                        controller.searchFieldController.text = "";
                      },
                      controller: controller.searchFieldController,
                      onSubmitted: (String? value) {
                        controller.searchFilterValue.value =
                            controller.searchFieldController.text;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(EvaIcons.search),
                        hintText: "search..".tr,
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing),
            Obx(
              () => controller.dataAvailable
                  ? ListView.builder(
                      key: const PageStorageKey<String>('workorderresource'),
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: controller.trx.records!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => Visibility(
                              visible: GetStorage().read('selectedTaskDocNo') ==
                                          controller.trx.records![index]
                                              .mpMaintainID?.id &&
                                      controller.trx.records![index].resourceStatus?.id ==
                                          "INS" &&
                                      controller.searchFilterValue.value == ""
                                  ? true
                                  : controller.dropdownValue.value == "1"
                                      ? controller.trx.records![index].prodCode
                                          .toString()
                                          .toLowerCase()
                                          .contains(controller.searchFilterValue.value
                                              .toLowerCase())
                                      : controller.dropdownValue.value == "2"
                                          ? controller.trx.records![index].serNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
                                                  "3"
                                              ? controller.trx.records![index]
                                                  .locationComment
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller.searchFilterValue.value.toLowerCase())
                                              : controller.dropdownValue.value == "4"
                                                  ? controller.trx.records![index].number.toString().toLowerCase() == controller.searchFilterValue.value.toLowerCase()
                                                  : true,
                              child: Card(
                                elevation: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ExpansionTile(
                                    key: PageStorageKey(
                                        'workorderresource$index'),
                                    initiallyExpanded: true,
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
                                                    controller.now.year
                                                        .toString()
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    leading: Container(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.white24))),
                                      child: IconButton(
                                        icon: Icon(
                                          controller.trx.records![index].eDIType
                                                          ?.id ==
                                                      'A02' ||
                                                  controller.trx.records![index]
                                                          .eDIType?.id ==
                                                      "A08"
                                              ? Icons.grid_4x4_outlined
                                              : Icons.edit,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Resource',
                                        onPressed: () async {
                                          switch (controller.trx.records![index]
                                              .eDIType?.id) {
                                            case "A01":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                      "orderedDate": controller
                                                          .trx
                                                          .records![index]
                                                          .dateOrdered,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

                                              break;
                                            case 'A02':
                                              Get.toNamed(
                                                  '/MaintenanceMpResourceFireExtinguisherGrid',
                                                  arguments: {
                                                    "products": File(
                                                        '${(await getApplicationDocumentsDirectory()).path}/products.json')
                                                  });
                                              break;
                                            case "A03":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

                                              break;
                                            case "A04":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

                                              break;
                                            case "A05":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

                                              break;
                                            case "A06":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

                                              break;
                                            case "A09":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

                                              break;
                                            case "A10":
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
                                                      "id": controller.trx
                                                          .records![index].id,
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
                                                          .records![index].note,
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
                                                      "resourceStatus":
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .resourceStatus
                                                                  ?.id ??
                                                              "OUT",
                                                      "resourceGroup": controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id,
                                                    });
                                              }

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
                                    title: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "NR. ${controller.trx.records![index].number} L. ${controller.trx.records![index].lineNo} b. ${controller.trx.records![index].prodCode} M. ${controller.trx.records![index].serNo}",
                                                style: const TextStyle(
                                                  color:
                                                      kNotifColor, /* fontWeight: FontWeight.bold */
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier ??
                                                    "???",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          children: <Widget>[
                                            const Icon(
                                              Icons.location_city,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.trx.records![index]
                                                        .locationComment ??
                                                    "",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          Text(
                                            'Quantity: '.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "${controller.trx.records![index].resourceQty}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ]),
                                        Row(children: [
                                          Text(
                                            'Manufactured Year: '.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            controller.trx.records![index]
                                                .manufacturedYear
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ]),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .anomaliesCount !=
                                              "0",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2.5),
                                                child: Text(
                                                  "Has Anomaly".tr,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].doneAction !=
                                              "Nothing",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: kNotifColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2.5),
                                                child: Text(
                                                  controller.trx.records![index]
                                                      .doneAction!.tr.tr,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .toDoAction! !=
                                                  "OK" &&
                                              controller.trx.records![index]
                                                      .doneAction ==
                                                  "Nothing",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: controller.trx.records![index].toDoAction! ==
                                                              "OK" ||
                                                          controller.trx.records![index].toDoAction! ==
                                                              "NEW"
                                                      ? kNotifColor
                                                      : controller.trx.records![index].toDoAction! ==
                                                                  "PR" ||
                                                              controller.trx.records![index].toDoAction! ==
                                                                  "PC" ||
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .toDoAction! ==
                                                                  "PRnow" ||
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .toDoAction! ==
                                                                  "PCnow"
                                                          ? const Color.fromARGB(
                                                              255, 209, 189, 4)
                                                          : controller.trx.records![index].toDoAction! == "PT" ||
                                                                  controller
                                                                          .trx
                                                                          .records![index]
                                                                          .toDoAction! ==
                                                                      "PTnow"
                                                              ? Colors.orange
                                                              : controller.trx.records![index].toDoAction! == "PSG"
                                                                  ? Colors.red
                                                                  : controller.trx.records![index].toDoAction! == "PX"
                                                                      ? Colors.black
                                                                      : kNotifColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2.5),
                                                child: Text(
                                                  controller.trx.records![index]
                                                      .toDoAction!.tr,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
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
                                            Text('Note: '.tr),
                                            Expanded(
                                              child: Text(controller.trx
                                                      .records![index].note ??
                                                  ""),
                                            ),
                                          ]),
                                          Row(children: [
                                            Text('Status: '.tr),
                                            Text(controller
                                                    .trx
                                                    .records![index]
                                                    .resourceStatus
                                                    ?.identifier ??
                                                ""),
                                          ]),
                                          /* Row(children: [
                                        const Text('SerNo: '),
                                        Text(controller
                                                .trx.records![index].serNo ??
                                            "??"),
                                      ]), */
                                          Row(children: [
                                            Text('Description: '.tr),
                                            Text(controller.trx.records![index]
                                                    .description ??
                                                ""),
                                          ]),
                                          /* Row(children: [
                                        const Text('Location Code: '),
                                        Text(controller
                                                .trx.records![index].value ??
                                            "??"),
                                      ]), */
                                          /* Row(children: [
                                        const Text('Check Date: '),
                                        Text(controller.trx.records![index]
                                                .lITControl1DateFrom ??
                                            "??"),
                                      ]), */
                                          Row(children: [
                                            Text('Check Date: '.tr),
                                            Text(
                                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl1DateNext!))}"),
                                          ]),
                                          /* Row(children: [
                                        const Text('Revision Date: '),
                                        Text(controller.trx.records![index]
                                                .lITControl2DateFrom ??
                                            "??"),
                                      ]), */
                                          Row(children: [
                                            Text('Revision Date: '.tr),
                                            Text(
                                                "${DateTime.tryParse(controller.trx.records![index].lITControl2DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl2DateFrom!)) : ""} - ${controller.trx.records![index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl2DateNext!)) : ""}"),
                                          ]),
                                          /*  Row(children: [
                                        const Text('Testing Date: '),
                                        Text(controller.trx.records![index]
                                                .lITControl3DateFrom ??
                                            "??"),
                                      ]), */ //DateFormat('dd-MM-yyyy').format(
                                          //DateTime.parse(controller.trx
                                          //   .records![index].jpToDoStartDate!))
                                          Row(children: [
                                            Text('Testing Date: '.tr),
                                            Text(
                                                "${DateTime.tryParse(controller.trx.records![index].lITControl3DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl3DateFrom!)) : ""} - ${controller.trx.records![index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.trx.records![index].lITControl3DateNext!)) : ""}"),
                                          ]),

                                          Row(children: [
                                            Text('Manufacturer: '.tr),
                                            Text(controller.trx.records![index]
                                                    .manufacturer ??
                                                ""),
                                          ]),
                                          Visibility(
                                            visible: controller
                                                        .trx
                                                        .records![index]
                                                        .eDIType
                                                        ?.id ==
                                                    "A01" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A03" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A04" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A05" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A06" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A09" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A10" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A11" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A12" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A13",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Edit',
                                                  onPressed: () async {
                                                    var index2 = 0;
                                                    for (var i = 0;
                                                        i <
                                                            controller
                                                                ._trx2
                                                                .records!
                                                                .length;
                                                        i++) {
                                                      if (controller._trx2
                                                              .records![i].id ==
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .id) {
                                                        index2 = i;
                                                      }
                                                    }
                                                    Get.to(
                                                        const EditMaintenanceMpResource(),
                                                        arguments: {
                                                          "perm": controller
                                                              .getPerm(
                                                                  controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .eDIType!
                                                                      .id!),
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "number": controller
                                                              .trx
                                                              .records![index]
                                                              .number,
                                                          "lineNo": controller
                                                              .trx
                                                              .records![index]
                                                              .lineNo
                                                              .toString(),
                                                          "cartel": controller
                                                              .trx
                                                              .records![index]
                                                              .textDetails,
                                                          "model": controller
                                                              .trx
                                                              .records![index]
                                                              .lITProductModel,
                                                          "dateOrder":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .dateOrdered,
                                                          "years": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .useLifeYears !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .useLifeYears
                                                                  .toString()
                                                              : "0",
                                                          "user": controller
                                                              .trx
                                                              .records![index]
                                                              .userName,
                                                          "serviceDate":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .serviceDate,
                                                          "productName":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .identifier,
                                                          "productId":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .id,
                                                          "location": controller
                                                              .trx
                                                              .records![index]
                                                              .locationComment,
                                                          "observation":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .name,
                                                          "SerNo": controller
                                                              .trx
                                                              .records![index]
                                                              .serNo,
                                                          "barcode": controller
                                                              .trx
                                                              .records![index]
                                                              .prodCode,
                                                          "manufacturer":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturer,
                                                          "year": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .manufacturedYear !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturedYear
                                                                  .toString()
                                                              : "0",
                                                          "Description":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .description,
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
                                                          "offlineid":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .offlineId,
                                                          "index": index2,
                                                          "length": controller
                                                              .trx
                                                              .records![index]
                                                              .length,
                                                          "width": controller
                                                              .trx
                                                              .records![index]
                                                              .width,
                                                          "weightAmt":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .weightAmt,
                                                          "height": controller
                                                              .trx
                                                              .records![index]
                                                              .height,
                                                          "color": controller
                                                              .trx
                                                              .records![index]
                                                              .color,
                                                          "resourceStatus":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .resourceStatus
                                                                      ?.id ??
                                                                  "OUT",
                                                          "resourceGroup":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .litResourceGroupID
                                                                  ?.id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "name": controller
                                                              .trx
                                                              .records![index]
                                                              .name,
                                                        });
                                                    /* controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index); */
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
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
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
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
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: controller
                                                                .trx
                                                                .records![index]
                                                                .anomaliesCount !=
                                                            "0",
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Undo',
                                                  onPressed: () async {
                                                    if (await checkConnection()) {
                                                      controller.undoLastChanges(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .id!,
                                                          "mp-maintain-resource");
                                                    }
                                                  },
                                                  icon: const Icon(Icons.undo),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: controller
                                                        .trx
                                                        .records![index]
                                                        .eDIType
                                                        ?.id ==
                                                    "A02" ||
                                                controller.trx.records![index]
                                                        .eDIType?.id ==
                                                    "A08",
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Edit',
                                                    onPressed: () async {
                                                      var index2 = 0;
                                                      for (var i = 0;
                                                          i <
                                                              controller
                                                                  ._trx2
                                                                  .records!
                                                                  .length;
                                                          i++) {
                                                        if (controller
                                                                ._trx2
                                                                .records![i]
                                                                .id ==
                                                            controller
                                                                ._trx
                                                                .records![index]
                                                                .id) {
                                                          index2 = i;
                                                        }
                                                      }
                                                      /* print(controller
                                                          .trx
                                                          .records![index]
                                                          .litResourceGroupID
                                                          ?.id); */
                                                      Get.to(
                                                          const EditMaintenanceMpResource(),
                                                          arguments: {
                                                            "perm": controller
                                                                .getPerm("A02"),
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                            "number": controller
                                                                .trx
                                                                .records![index]
                                                                .number,
                                                            "lineNo": controller
                                                                .trx
                                                                .records![index]
                                                                .lineNo
                                                                .toString(),
                                                            "cartel": controller
                                                                .trx
                                                                .records![index]
                                                                .textDetails,
                                                            "model": controller
                                                                .trx
                                                                .records![index]
                                                                .lITProductModel,
                                                            "dateOrder":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .dateOrdered,
                                                            "years": controller
                                                                        .trx
                                                                        .records![
                                                                            index]
                                                                        .useLifeYears !=
                                                                    null
                                                                ? controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .useLifeYears
                                                                    .toString()
                                                                : "0",
                                                            "user": controller
                                                                .trx
                                                                .records![index]
                                                                .userName,
                                                            "serviceDate":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .serviceDate,
                                                            "productName":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .identifier,
                                                            "productId":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mProductID!
                                                                    .id,
                                                            "location": controller
                                                                .trx
                                                                .records![index]
                                                                .locationComment,
                                                            "observation":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .name,
                                                            "SerNo": controller
                                                                .trx
                                                                .records![index]
                                                                .serNo,
                                                            "barcode":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .prodCode,
                                                            "manufacturer":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .manufacturer,
                                                            "year": controller
                                                                .trx
                                                                .records![index]
                                                                .manufacturedYear
                                                                .toString(),
                                                            "Description":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .description,
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
                                                            "offlineid":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .offlineId,
                                                            "index": index2,
                                                            "resourceStatus": controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .resourceStatus
                                                                    ?.id ??
                                                                "OUT",
                                                            "resourceGroup":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .litResourceGroupID
                                                                    ?.id,
                                                            "length": controller
                                                                .trx
                                                                .records![index]
                                                                .length,
                                                            "width": controller
                                                                .trx
                                                                .records![index]
                                                                .width,
                                                            "weightAmt":
                                                                controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .weightAmt,
                                                            "height": controller
                                                                .trx
                                                                .records![index]
                                                                .height,
                                                            "color": controller
                                                                .trx
                                                                .records![index]
                                                                .color,
                                                            "note": controller
                                                                .trx
                                                                .records![index]
                                                                .note,
                                                            "name": controller
                                                                .trx
                                                                .records![index]
                                                                .name,
                                                          });
                                                      /* controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Check',
                                                    onPressed: () async {
                                                      if (controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "PC" &&
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "Nothing") {
                                                        Get.defaultDialog(
                                                          title: 'Warning'.tr,
                                                          content: Text(
                                                              "The resource shouldn't be checked"
                                                                  .tr
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            Get.back();
                                                            var isConnected =
                                                                await checkConnection();
                                                            controller
                                                                .editWorkOrderResourceDateCheck(
                                                                    isConnected,
                                                                    index);
                                                          },
                                                        );
                                                      } else {
                                                        var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index);
                                                      }
                                                    },
                                                    icon: const Icon(Icons
                                                        .check_circle_outline),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Revision',
                                                    onPressed: () async {
                                                      if (controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "PR" &&
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "Nothing") {
                                                        Get.defaultDialog(
                                                          title: 'Warning'.tr,
                                                          content: Text(
                                                              "The resource shouldn't be reviewed"
                                                                  .tr
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            Get.back();
                                                            /* var isConnected =
                                                                await checkConnection(); */
                                                            controller
                                                                .reviewResourceButton(
                                                                    index);
                                                          },
                                                        );
                                                      } else {
                                                        /* var isConnected =
                                                            await checkConnection(); */
                                                        controller
                                                            .reviewResourceButton(
                                                                index);
                                                      }
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon: const Icon(Icons
                                                        .handyman_outlined),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Testing',
                                                    onPressed: () async {
                                                      if (controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "PT" &&
                                                          controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .toDoAction !=
                                                              "Nothing") {
                                                        Get.defaultDialog(
                                                          title: 'Warning'.tr,
                                                          content: Text(
                                                              "The resource shouldn't be tested"
                                                                  .tr
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            Get.back();
                                                            /* var isConnected =
                                                                await checkConnection(); */
                                                            controller
                                                                .testingResourceButton(
                                                                    index);
                                                          },
                                                        );
                                                      } else {
                                                        /* var isConnected =
                                                            await checkConnection(); */
                                                        controller
                                                            .testingResourceButton(
                                                                index);
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.gavel_outlined),
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
                                                      }
                                                      Get.to(
                                                          const CreateResAnomaly(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
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
                                                            "isConnected":
                                                                isConnected,
                                                          });
                                                    },
                                                    icon: Stack(
                                                      children: <Widget>[
                                                        const Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .anomaliesCount !=
                                                              "0",
                                                          child: Positioned(
                                                            right: 1,
                                                            top: 1,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              constraints:
                                                                  const BoxConstraints(
                                                                minWidth: 12,
                                                                minHeight: 12,
                                                              ),
                                                              child: Text(
                                                                '${controller.trx.records![index].anomaliesCount}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Replace',
                                                    onPressed: () async {
                                                      controller
                                                          .replaceResourceButton(
                                                              index);
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon: const Icon(
                                                        Icons.find_replace),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Undo',
                                                    onPressed: () async {
                                                      if (await checkConnection()) {
                                                        controller.undoLastChanges(
                                                            controller
                                                                .trx
                                                                .records![index]
                                                                .id!,
                                                            "mp-maintain-resource");
                                                      }

                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateRevision(
                                                                isConnected,
                                                                index); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.undo),
                                                  ),
                                                ]),
                                          ),
                                          Visibility(
                                            //
                                            visible: controller
                                                    .trx
                                                    .records![index]
                                                    .eDIType
                                                    ?.id ==
                                                "A07",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Edit A07',
                                                  onPressed: () async {
                                                    var index2 = 0;
                                                    for (var i = 0;
                                                        i <
                                                            controller
                                                                ._trx2
                                                                .records!
                                                                .length;
                                                        i++) {
                                                      if (controller._trx2
                                                              .records![i].id ==
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .id) {
                                                        index2 = i;
                                                      }
                                                    }
                                                    Get.to(
                                                        const EditMaintenanceMpResource(),
                                                        arguments: {
                                                          "perm": controller
                                                              .getPerm("A07"),
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "number": controller
                                                              .trx
                                                              .records![index]
                                                              .number,
                                                          "lineNo": controller
                                                              .trx
                                                              .records![index]
                                                              .lineNo
                                                              .toString(),
                                                          "cartel": controller
                                                              .trx
                                                              .records![index]
                                                              .textDetails,
                                                          "model": controller
                                                              .trx
                                                              .records![index]
                                                              .lITProductModel,
                                                          "dateOrder":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .dateOrdered,
                                                          "years": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .useLifeYears !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .useLifeYears
                                                                  .toString()
                                                              : "0",
                                                          "user": controller
                                                              .trx
                                                              .records![index]
                                                              .userName,
                                                          "serviceDate":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .serviceDate,
                                                          "productName":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .identifier,
                                                          "productId":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID!
                                                                  .id,
                                                          "location": controller
                                                              .trx
                                                              .records![index]
                                                              .locationComment,
                                                          "observation":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .name,
                                                          "SerNo": controller
                                                              .trx
                                                              .records![index]
                                                              .serNo,
                                                          "barcode": controller
                                                              .trx
                                                              .records![index]
                                                              .prodCode,
                                                          "manufacturer":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturer,
                                                          "year": controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .manufacturedYear !=
                                                                  null
                                                              ? controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .manufacturedYear
                                                                  .toString()
                                                              : "0",
                                                          "Description":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .description,
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
                                                          "offlineid":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .offlineId,
                                                          "index": index2,
                                                          "length": controller
                                                              .trx
                                                              .records![index]
                                                              .length,
                                                          "width": controller
                                                              .trx
                                                              .records![index]
                                                              .width,
                                                          "weightAmt":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .weightAmt,
                                                          "height": controller
                                                              .trx
                                                              .records![index]
                                                              .height,
                                                          "color": controller
                                                              .trx
                                                              .records![index]
                                                              .color,
                                                          "resourceStatus":
                                                              controller
                                                                      .trx
                                                                      .records![
                                                                          index]
                                                                      .resourceStatus
                                                                      ?.id ??
                                                                  "OUT",
                                                          "resourceGroup":
                                                              controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .litResourceGroupID
                                                                  ?.id,
                                                          "note": controller
                                                              .trx
                                                              .records![index]
                                                              .note,
                                                          "name": controller
                                                              .trx
                                                              .records![index]
                                                              .name,
                                                        });
                                                    /* controller
                                                            .editWorkOrderResourceDateCheck(
                                                                isConnected,
                                                                index); */
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
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
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
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
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: controller
                                                                .trx
                                                                .records![index]
                                                                .anomaliesCount !=
                                                            "0",
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Undo',
                                                  onPressed: () async {
                                                    if (await checkConnection()) {
                                                      controller.undoLastChanges(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .id!,
                                                          "mp-maintain-resource");
                                                    }
                                                  },
                                                  icon: const Icon(Icons.undo),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ]);
        },
      ),
    );
  }
}

// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Contract/models/portal_mp_contract_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Contract/models/portal_mp_contractline_json.dart';
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

//model for sales_order_controller

// binding
part '../../bindings/portal_mp_contract_binding.dart';

// controller
part '../../controllers/portal_mp_contract_controller.dart';

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

class PortalMpContractScreen extends GetView<PortalMpContractController> {
  const PortalMpContractScreen({Key? key}) : super(key: key);

  completeOrder(int index) async {
    Get.back();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "record-id": controller.trx.records![index].id,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/processes/c-order-process');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      controller.getContracts();
      //print("done!");

      Get.snackbar(
        "Done!".tr,
        "Record has been completed".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
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
                          ? Text("CONTRACTS: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("CONTRACTS: ".tr)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getContracts();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
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
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.contractDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.contractDropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.contractDropDownList.map((list) {
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
                          controller: controller.contractSearchFieldController,
                          onSubmitted: (String? value) {
                            controller.contractSearchFilterValue.value =
                                controller.contractSearchFieldController.text;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller.contractSearchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.contractDropdownValue.value ==
                                              "1"
                                          ? controller.trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .contractSearchFilterValue
                                                  .value
                                                  .toLowerCase())
                                          : controller.contractDropdownValue.value ==
                                                  "2"
                                              ? (controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier ??
                                                      "")
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller
                                                      .contractSearchFilterValue
                                                      .value
                                                      .toLowerCase())
                                              : true,
                                  child: Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(64, 75, 96, .9)),
                                      child: ExpansionTile(
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.article,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            /* Get.toNamed('/SalesOrderLine',
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "bPartner": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.identifier,
                                              "docNo": controller
                                                  .trx.records![index].documentNo,
                                              "priceListId": controller
                                                  .trx
                                                  .records![index]
                                                  .mPriceListID
                                                  ?.id,
                                              "dateOrdered": controller.trx
                                                  .records![index].dateOrdered,
                                            }); */
                                          },
                                        ),
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        leading: Container(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.white24))),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                            ),
                                            tooltip: 'Edit Contract'.tr,
                                            onPressed: () {
                                              //log("info button pressed");
                                              /* Get.to(const CRMEditSalesOrder(), arguments: {
                                            "id": controller
                                                .trx.records![index].id,
                                            "docNo": controller
                                                  .trx.records![index].documentNo,
                                            "docTypeTargetId": controller.trx.records![index].cDocTypeTargetID!.id,
                                            "BPartnerLocationId": controller.trx.records![index].cBPartnerLocationID!.id,
                                            "bPartnerId": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.id,
                                          }); */
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Row(
                                          children: <Widget>[
                                            const Icon(Icons.handshake,
                                                color: Colors.yellowAccent),
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .trx
                                                        .records![index]
                                                        .cBPartnerID!
                                                        .identifier ??
                                                    "??",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),

                                        childrenPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Business Partner: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "${controller.trx.records![index].cBPartnerID!.identifier}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Visibility(
                                                    visible: controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeTargetID!
                                                            .identifier !=
                                                        '',
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .green),
                                                      ),
                                                      onPressed: () async {
                                                        Get.defaultDialog(
                                                          title:
                                                              'Complete Action',
                                                          content: const Text(
                                                              "Are you sure you want to complete the record?"),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            final ip =
                                                                GetStorage()
                                                                    .read('ip');
                                                            String
                                                                authorization =
                                                                'Bearer ${GetStorage().read('token')}';
                                                            final msg =
                                                                jsonEncode({
                                                              "DocAction": "CO",
                                                            });
                                                            final protocol =
                                                                GetStorage().read(
                                                                    'protocol');
                                                            var url = Uri.parse(
                                                                '$protocol://$ip/api/v1/models/c_order/${controller.trx.records![index].id}');

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
                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              //print("done!");
                                                              completeOrder(
                                                                  index);
                                                            } else {
                                                              //print(response.body);
                                                              Get.snackbar(
                                                                "Error!".tr,
                                                                "Record not completed"
                                                                    .tr,
                                                                icon:
                                                                    const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        );
                                                      },
                                                      child:
                                                          Text("Complete".tr),
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
                                ));
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
                          ? Text("CONTRACTS: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("CONTRACTS: ".tr)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getContracts();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
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
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.contractDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.contractDropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.contractDropDownList.map((list) {
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
                          controller: controller.contractSearchFieldController,
                          onSubmitted: (String? value) {
                            controller.contractSearchFilterValue.value =
                                controller.contractSearchFieldController.text;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller.contractSearchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.contractDropdownValue.value ==
                                              "1"
                                          ? controller.trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .contractSearchFilterValue
                                                  .value
                                                  .toLowerCase())
                                          : controller.contractDropdownValue.value ==
                                                  "2"
                                              ? (controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier ??
                                                      "")
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller
                                                      .contractSearchFilterValue
                                                      .value
                                                      .toLowerCase())
                                              : true,
                                  child: Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(64, 75, 96, .9)),
                                      child: ExpansionTile(
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.article,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            /* Get.toNamed('/SalesOrderLine',
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "bPartner": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.identifier,
                                              "docNo": controller
                                                  .trx.records![index].documentNo,
                                              "priceListId": controller
                                                  .trx
                                                  .records![index]
                                                  .mPriceListID
                                                  ?.id,
                                              "dateOrdered": controller.trx
                                                  .records![index].dateOrdered,
                                            }); */
                                          },
                                        ),
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        leading: Container(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.white24))),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                            ),
                                            tooltip: 'Edit Contract'.tr,
                                            onPressed: () {
                                              //log("info button pressed");
                                              /* Get.to(const CRMEditSalesOrder(), arguments: {
                                            "id": controller
                                                .trx.records![index].id,
                                            "docNo": controller
                                                  .trx.records![index].documentNo,
                                            "docTypeTargetId": controller.trx.records![index].cDocTypeTargetID!.id,
                                            "BPartnerLocationId": controller.trx.records![index].cBPartnerLocationID!.id,
                                            "bPartnerId": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID
                                                  ?.id,
                                          }); */
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Row(
                                          children: <Widget>[
                                            const Icon(Icons.handshake,
                                                color: Colors.yellowAccent),
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .trx
                                                        .records![index]
                                                        .cBPartnerID!
                                                        .identifier ??
                                                    "??",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),

                                        childrenPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Business Partner: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "${controller.trx.records![index].cBPartnerID!.identifier}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Visibility(
                                                    visible: controller
                                                            .trx
                                                            .records![index]
                                                            .cDocTypeTargetID!
                                                            .identifier !=
                                                        '',
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .green),
                                                      ),
                                                      onPressed: () async {
                                                        Get.defaultDialog(
                                                          title:
                                                              'Complete Action',
                                                          content: const Text(
                                                              "Are you sure you want to complete the record?"),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            final ip =
                                                                GetStorage()
                                                                    .read('ip');
                                                            String
                                                                authorization =
                                                                'Bearer ${GetStorage().read('token')}';
                                                            final msg =
                                                                jsonEncode({
                                                              "DocAction": "CO",
                                                            });
                                                            final protocol =
                                                                GetStorage().read(
                                                                    'protocol');
                                                            var url = Uri.parse(
                                                                '$protocol://$ip/api/v1/models/c_order/${controller.trx.records![index].id}');

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
                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              //print("done!");
                                                              completeOrder(
                                                                  index);
                                                            } else {
                                                              //print(response.body);
                                                              Get.snackbar(
                                                                "Error!".tr,
                                                                "Record not completed"
                                                                    .tr,
                                                                icon:
                                                                    const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        );
                                                      },
                                                      child:
                                                          Text("Complete".tr),
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
                                ));
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ]);
            },
            desktopBuilder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: (constraints.maxWidth < 1360) ? 4 : 3,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(kBorderRadius),
                          bottomRight: Radius.circular(kBorderRadius),
                        ),
                        child: _Sidebar(data: controller.getSelectedProject())),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: _buildProfile(
                                    data: controller.getProfil())),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Obx(() => controller.dataAvailable
                                  ? Text("CONTRACTS: ".tr +
                                      controller.trx.rowcount.toString())
                                  : Text("CONTRACTS: ".tr)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getContracts();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                            /* Container(
                              margin: const EdgeInsets.only(left: 10),
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
                        _buildContractsFilter(),
                        const SizedBox(height: kSpacing),
                        Obx(
                          () => controller.dataAvailable
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: controller.trx.rowcount,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Obx(() => Visibility(
                                        visible: controller
                                                    .contractSearchFilterValue
                                                    .value ==
                                                ""
                                            ? true
                                            : controller.contractDropdownValue.value ==
                                                    "1"
                                                ? controller.trx.records![index]
                                                    .documentNo
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(controller
                                                        .contractSearchFilterValue
                                                        .value
                                                        .toLowerCase())
                                                : controller.contractDropdownValue
                                                            .value ==
                                                        "2"
                                                    ? (controller
                                                                .trx
                                                                .records![index]
                                                                .cDocTypeTargetID
                                                                ?.identifier ??
                                                            "")
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(controller.contractSearchFilterValue.value.toLowerCase())
                                                    : controller.contractDropdownValue.value == "3"
                                                        ? (controller.trx.records![index].contractsigndate ?? "").toString().toLowerCase().contains(controller.contractSearchFilterValue.value.toLowerCase())
                                                        : true,
                                        child: Card(
                                          elevation: 8.0,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 6.0),
                                          child: Obx(
                                            () => controller.selectedCard ==
                                                    index
                                                ? _buildCard(
                                                    Theme.of(context).cardColor,
                                                    context,
                                                    index)
                                                : _buildCard(
                                                    const Color.fromRGBO(
                                                        64, 75, 96, .9),
                                                    context,
                                                    index),
                                          ),
                                        )));
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 4,
                      child: Column(children: [
                        const SizedBox(height: kSpacing),
                        _buildHeader(),
                        const SizedBox(height: kSpacing * 6.5),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                  //width: 100,
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: Obx(() => controller.dataAvailable
                                      ? SingleChildScrollView(
                                          child: Container(
                                              //margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                              margin: const EdgeInsets.only(
                                                  right: 10.0,
                                                  left: 10.0,
                                                  /* top: kSpacing * 7.7 */ bottom:
                                                      6.0),
                                              color: const Color.fromRGBO(
                                                  64, 75, 96, .9),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'DocumentNo'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .documentNo ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'Business Partner'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .cBPartnerID
                                                                      ?.identifier ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'Document Type'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .cDocTypeTargetID
                                                                      ?.identifier ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'Contract Date'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .contractsigndate ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'Client'.tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .aDClientID
                                                                      ?.identifier ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'Name'.tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .name ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintStyle: const TextStyle(
                                                                  color:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              labelText:
                                                                  'Description'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trx
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .description ??
                                                                  '',
                                                              enabled: false),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                                    hintStyle: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'Valid from Date'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: controller
                                                                            .trx
                                                                            .records![controller
                                                                                .selectedCard]
                                                                            .validfromdate
                                                                            ?.replaceAll('T',
                                                                                ' ')
                                                                            .replaceAll('Z',
                                                                                '') ??
                                                                        '',
                                                                    enabled:
                                                                        false),
                                                          ),
                                                        ),
                                                      ),
                                                      //const SizedBox(width: kSpacing * 2,),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                                    hintStyle: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'Valid to Date'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: controller
                                                                            .trx
                                                                            .records![controller
                                                                                .selectedCard]
                                                                            .validtodate
                                                                            ?.replaceAll('T',
                                                                                ' ')
                                                                            .replaceAll('Z',
                                                                                '') ??
                                                                        '',
                                                                    enabled:
                                                                        false),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                                    hintStyle: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'Frequency Next Date'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: controller
                                                                            .trx
                                                                            .records![controller
                                                                                .selectedCard]
                                                                            .frequencyNextDate ??
                                                                        '',
                                                                    enabled:
                                                                        false),
                                                          ),
                                                        ),
                                                      ),
                                                      //const SizedBox(width: kSpacing * 2,),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                                    hintStyle: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'Frequency Type'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: controller
                                                                            .trx
                                                                            .records![controller
                                                                                .selectedCard]
                                                                            .frequencyType
                                                                            ?.identifier ??
                                                                        '',
                                                                    enabled:
                                                                        false),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                                    hintStyle: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'Payment Rule'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: controller
                                                                            .trx
                                                                            .records![controller
                                                                                .selectedCard]
                                                                            .paymentRule
                                                                            ?.identifier ??
                                                                        '',
                                                                    enabled:
                                                                        false),
                                                          ),
                                                        ),
                                                      ),
                                                      //const SizedBox(width: kSpacing * 2,),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                                    hintStyle: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'Payment Term'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: controller
                                                                            .trx
                                                                            .records![controller
                                                                                .selectedCard]
                                                                            .cPaymentTermID
                                                                            ?.identifier ??
                                                                        '',
                                                                    enabled:
                                                                        false),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              )),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator()))),
                            ),
                          ],
                        ),
                      ])),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing * 3.3),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Obx(() => controller.showData
                                  ? Text("LINES: ".tr +
                                      controller.trx1.rowcount.toString())
                                  : Text("LINES: ".tr)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getContractLines();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildLinesFilter(),
                        const SizedBox(height: kSpacing * 1.2),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                  //width: 100,
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: Obx(() => controller.showData
                                      ? SingleChildScrollView(
                                          child: ListView.builder(
                                              primary: false,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount:
                                                  controller.trx1.rowcount,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Obx(() => Visibility(
                                                    visible: controller
                                                                .linesSearchFilterValue
                                                                .value ==
                                                            ""
                                                        ? true
                                                        : controller.linesDropdownValue
                                                                    .value ==
                                                                "1"
                                                            ? (controller.trx1.records![index].mProductID?.identifier ?? "")
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(controller
                                                                    .linesSearchFilterValue
                                                                    .value
                                                                    .toLowerCase())
                                                            : controller.linesDropdownValue
                                                                        .value ==
                                                                    "2"
                                                                ? (controller
                                                                            .trx1
                                                                            .records![index]
                                                                            .name ??
                                                                        "")
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(controller.linesSearchFilterValue.value.toLowerCase())
                                                                : controller.linesDropdownValue.value == "3"
                                                                    ? (controller.trx1.records![index].amount ?? "").toString().toLowerCase().contains(controller.linesSearchFilterValue.value.toLowerCase())
                                                                    : true,
                                                    child: SizedBox(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          margin: const EdgeInsets
                                                                  .only(
                                                              right: 10.0,
                                                              left: 10.0,
                                                              /* top: kSpacing * 7.7 */ bottom:
                                                                  6.0),
                                                          color: const Color
                                                                  .fromRGBO(
                                                              64, 75, 96, .9),
                                                          child: Row(
                                                            children: [
                                                              Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                450,
                                                                            child:
                                                                                TextField(
                                                                              decoration: InputDecoration(
                                                                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                                                                  labelStyle: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 20,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  labelText: 'Product'.tr,
                                                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                  hintText: controller.trx1.records![index].mProductID?.identifier ?? '',
                                                                                  enabled: false),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                450,
                                                                            child:
                                                                                TextField(
                                                                              decoration: InputDecoration(
                                                                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                                                                  labelStyle: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 20,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  labelText: 'Amount'.tr,
                                                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                  hintText: (controller.trx1.records![index].amount != null ? controller.trx1.records![index].amount.toString() : ''),
                                                                                  enabled: false),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.all(10),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                450,
                                                                            child:
                                                                                TextField(
                                                                              decoration: InputDecoration(
                                                                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                                                                  labelStyle: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 20,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                  border: const OutlineInputBorder(),
                                                                                  labelText: 'Name'.tr,
                                                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                  hintText: controller.trx1.records![index].name ?? '',
                                                                                  enabled: false),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )));
                                              }),
                                        )
                                      : Center(
                                          child: Text(
                                              'No Contract Selected'.tr)))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Color selectionColor, context, index) {
    return Container(
      decoration: BoxDecoration(color: selectionColor),
      child: ExpansionTile(
        trailing: IconButton(
          icon: const Icon(
            Icons.article,
            color: Colors.green,
          ),
          onPressed: () {
            controller.selectedCard = index;
            controller.contractId = controller.trx.records?[index].id;
            controller.getContractLines();
          },
        ),
        title: Text(
          '${'DocumentNo'.tr} ${controller.trx.records![index].documentNo!}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            const Icon(Icons.payments, color: Colors.green),
            Expanded(
              child: Text(
                controller.trx.records![index].cBPartnerID?.identifier ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text('${'Document Type'.tr}: '),
                  Text(
                    controller
                            .trx.records![index].cDocTypeTargetID?.identifier ??
                        "",
                  )
                ],
              ),
              Row(
                children: [
                  Text('${'Contract Date'.tr}: '),
                  Text(
                    controller.trx.records![index].contractsigndate ?? "",
                  )
                ],
              ),
            ],
          ),
        ],
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

  Widget _buildLinesFilter() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Obx(
            () => DropdownButton(
              icon: const Icon(Icons.filter_alt_sharp),
              value: controller.linesDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.linesDropdownValue.value = newValue!;
              },
              items: controller.linesDropDownList.map((list) {
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
              controller: controller.linesSearchFieldController,
              onSubmitted: (String? value) {
                controller.linesSearchFilterValue.value =
                    controller.linesSearchFieldController.text;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                border: const OutlineInputBorder(),
                hintText: 'Search'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildContractsFilter() {
    return Row(
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
              icon: const Icon(Icons.filter_alt_sharp),
              value: controller.contractDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.contractDropdownValue.value = newValue!;
              },
              items: controller.contractDropDownList.map((list) {
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
              controller: controller.contractSearchFieldController,
              onSubmitted: (String? value) {
                controller.contractSearchFilterValue.value =
                    controller.contractSearchFieldController.text;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                border: const OutlineInputBorder(),
                //labelText: 'Product Value',
                hintText: 'Search'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order/models/portal_mp_sales_order_line_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order/models/sales_order_json.dart';
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
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_edit_sales_order.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';

//model for sales_order_controller
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';

// binding
part '../../bindings/portal_mp_sales_order_binding.dart';

// controller
part '../../controllers/portal_mp_sales_order_controller.dart';

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

class PortalMpSalesOrderScreen extends GetView<PortalMpSalesOrderController> {
  const PortalMpSalesOrderScreen({Key? key}) : super(key: key);

  approveSalesOrder(index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "isApproved": true,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_order/${controller.trxSalesOrder.records![index].id}');
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      controller.getSalesOrders();
      Get.snackbar(
        "Done!".tr,
        "Sales Order approved".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Sales Order not approved".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  postImage(id, String date, int index) async {
    var data = await controller.signatureController.toPngBytes();
    // ignore: unused_local_variable
    var image64 = base64.encode(data!);
    //print(image64);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    final msg =
        jsonEncode({"name": "customersignature.jpg", "BinaryData": image64});
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/ad_image');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      //print(response.body);
      var json = jsonDecode(response.body);
      signOrder(id, index, json["id"]);
    } else {
      //print(response.body);
    }
  }

  signOrder(id, int index, int imageId) async {
    var data = await controller.signatureController.toPngBytes();
    // ignore: unused_local_variable
    var image64 = base64.encode(data!);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "LIT_Sign_Image_ID": imageId,
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/C_Order/$id');
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      //print(response.body);
      Get.back();
      Get.snackbar(
        "Signed!".tr,
        "Sales Order has been signed".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
      controller.signatureController.value = [];
      controller.signatureNameController.text = '';
      controller.canSign = false;
      controller.canApprove = [index, true];
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Sales Order not signed".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  completeOrder(int index) async {
    Get.back();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "record-id": controller.trxSalesOrder.records![index].id,
    });
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/processes/c-order-process');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      controller.getSalesOrders();
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
                          ? Text("SALES ORDERS: ".tr +
                              controller.trxSalesOrder.rowcount.toString())
                          : Text("SALES ORDERS: ".tr)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getSalesOrders();
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
                          value: controller.salesOrderDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.salesOrderDropdownValue.value =
                                newValue!;

                            //print(salesOrderDropdownValue);
                          },
                          items: controller.salesOrderDropDownList.map((list) {
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
                          controller:
                              controller.salesOrderSearchFieldController,
                          onSubmitted: (String? value) {
                            controller.salesOrderSearchFilterValue.value =
                                controller.salesOrderSearchFieldController.text;
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
                          itemCount: controller.trxSalesOrder.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller
                                              .salesOrderSearchFilterValue
                                              .value ==
                                          ""
                                      ? true
                                      : controller.salesOrderDropdownValue.value ==
                                              "1"
                                          ? controller.trxSalesOrder
                                              .records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .salesOrderSearchFilterValue
                                                  .value
                                                  .toLowerCase())
                                          : controller.salesOrderDropdownValue
                                                      .value ==
                                                  "2"
                                              ? (controller
                                                          .trxSalesOrder
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier ??
                                                      "")
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller.salesOrderSearchFilterValue.value.toLowerCase())
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
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .docStatus
                                                        ?.id ==
                                                    "CO"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.toNamed(
                                                '/PortalMpSalesOrderLine',
                                                arguments: {
                                                  "id": controller.trxSalesOrder
                                                      .records![index].id,
                                                  "bPartner": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "docNo": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .documentNo,
                                                  "priceListId": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .mPriceListID
                                                      ?.id,
                                                  "dateOrdered": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .dateOrdered,
                                                });
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
                                            tooltip: 'Edit Sales Order'.tr,
                                            onPressed: () {
                                              //log("info button pressed");
                                              Get.to(const CRMEditSalesOrder(),
                                                  arguments: {
                                                    "id": controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .id,
                                                    "docNo": controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .documentNo,
                                                    "docTypeTargetId":
                                                        controller
                                                            .trxSalesOrder
                                                            .records![index]
                                                            .cDocTypeTargetID!
                                                            .id,
                                                    "BPartnerLocationId":
                                                        controller
                                                            .trxSalesOrder
                                                            .records![index]
                                                            .cBPartnerLocationID!
                                                            .id,
                                                    "bPartnerId": controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .cBPartnerID
                                                        ?.id,
                                                  });
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trxSalesOrder.records![index].documentNo} Dt ${controller.trxSalesOrder.records![index].dateOrdered}",
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
                                                        .trxSalesOrder
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
                                                    "Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trxSalesOrder.records![index].grandTotal}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Visibility(
                                                    visible: controller
                                                            .trxSalesOrder
                                                            .records![index]
                                                            .docStatus
                                                            ?.id !=
                                                        'CO',
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
                                                                'Bearer ' +
                                                                    GetStorage()
                                                                        .read(
                                                                            'token');
                                                            final msg =
                                                                jsonEncode({
                                                              "DocAction": "CO",
                                                            });
                                                            final protocol =
                                                                GetStorage().read(
                                                                    'protocol');
                                                            var url = Uri.parse(
                                                                '$protocol://' +
                                                                    ip +
                                                                    '/api/v1/models/c_order/${controller.trxSalesOrder.records![index].id}');

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
                          ? Text("SALES ORDERS: ".tr +
                              controller.trxSalesOrder.rowcount.toString())
                          : Text("SALES ORDERS: ".tr)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getSalesOrders();
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
                          value: controller.salesOrderDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.salesOrderDropdownValue.value =
                                newValue!;

                            //print(salesOrderDropdownValue);
                          },
                          items: controller.salesOrderDropDownList.map((list) {
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
                          controller:
                              controller.salesOrderSearchFieldController,
                          onSubmitted: (String? value) {
                            controller.salesOrderSearchFilterValue.value =
                                controller.salesOrderSearchFieldController.text;
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
                          itemCount: controller.trxSalesOrder.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller
                                              .salesOrderSearchFilterValue
                                              .value ==
                                          ""
                                      ? true
                                      : controller.salesOrderDropdownValue.value ==
                                              "1"
                                          ? controller.trxSalesOrder
                                              .records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .salesOrderSearchFilterValue
                                                  .value
                                                  .toLowerCase())
                                          : controller.salesOrderDropdownValue
                                                      .value ==
                                                  "2"
                                              ? (controller
                                                          .trxSalesOrder
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier ??
                                                      "")
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller.salesOrderSearchFilterValue.value.toLowerCase())
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
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .docStatus
                                                        ?.id ==
                                                    "CO"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.toNamed(
                                                '/PortalMpSalesOrderLine',
                                                arguments: {
                                                  "id": controller.trxSalesOrder
                                                      .records![index].id,
                                                  "bPartner": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "docNo": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .documentNo,
                                                  "priceListId": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .mPriceListID
                                                      ?.id,
                                                  "dateOrdered": controller
                                                      .trxSalesOrder
                                                      .records![index]
                                                      .dateOrdered,
                                                });
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
                                            tooltip: 'Edit Sales Order'.tr,
                                            onPressed: () {
                                              //log("info button pressed");
                                              Get.to(const CRMEditSalesOrder(),
                                                  arguments: {
                                                    "id": controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .id,
                                                    "docNo": controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .documentNo,
                                                    "docTypeTargetId":
                                                        controller
                                                            .trxSalesOrder
                                                            .records![index]
                                                            .cDocTypeTargetID!
                                                            .id,
                                                    "BPartnerLocationId":
                                                        controller
                                                            .trxSalesOrder
                                                            .records![index]
                                                            .cBPartnerLocationID!
                                                            .id,
                                                    "bPartnerId": controller
                                                        .trxSalesOrder
                                                        .records![index]
                                                        .cBPartnerID
                                                        ?.id,
                                                  });
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trxSalesOrder.records![index].documentNo} Dt ${controller.trxSalesOrder.records![index].dateOrdered}",
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
                                                        .trxSalesOrder
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
                                                    "Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trxSalesOrder.records![index].grandTotal}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Visibility(
                                                    visible: controller
                                                            .trxSalesOrder
                                                            .records![index]
                                                            .docStatus
                                                            ?.id !=
                                                        'CO',
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
                                                                'Bearer ' +
                                                                    GetStorage()
                                                                        .read(
                                                                            'token');
                                                            final msg =
                                                                jsonEncode({
                                                              "DocAction": "CO",
                                                            });
                                                            final protocol =
                                                                GetStorage().read(
                                                                    'protocol');
                                                            var url = Uri.parse(
                                                                '$protocol://' +
                                                                    ip +
                                                                    '/api/v1/models/c_order/${controller.trxSalesOrder.records![index].id}');

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
                                  ? Text("SALES ORDERS: ".tr +
                                      controller.trxSalesOrder.rowcount
                                          .toString())
                                  : Text("SALES ORDERS: ".tr)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getSalesOrders();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildSalesOrdersFilter(),
                        const SizedBox(height: kSpacing),
                        Obx(
                          () => controller.dataAvailable
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: controller.trxSalesOrder.rowcount,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Obx(() => Visibility(
                                        visible: controller
                                                    .salesOrderSearchFilterValue
                                                    .value ==
                                                ""
                                            ? true
                                            : controller.salesOrderDropdownValue.value ==
                                                    "1"
                                                ? controller.trxSalesOrder
                                                    .records![index].documentNo
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(controller
                                                        .salesOrderSearchFilterValue
                                                        .value
                                                        .toLowerCase())
                                                : controller.salesOrderDropdownValue
                                                            .value ==
                                                        "2"
                                                    ? (controller
                                                                .trxSalesOrder
                                                                .records![index]
                                                                .cDocTypeTargetID
                                                                ?.identifier ??
                                                            "")
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(controller.salesOrderSearchFilterValue.value.toLowerCase())
                                                    : controller.salesOrderDropdownValue.value == "3"
                                                        ? (controller.trxSalesOrder.records![index].dateOrdered ?? "").toString().toLowerCase().contains(controller.salesOrderSearchFilterValue.value.toLowerCase())
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
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
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
                                                                      .trxSalesOrder
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
                                                                      .trxSalesOrder
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
                                                                      .trxSalesOrder
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
                                                                  'Date Ordered'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trxSalesOrder
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .dateOrdered ??
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
                                                                  'Payment Rule'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trxSalesOrder
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .paymentRule
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
                                                                  'Payment Term'
                                                                      .tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trxSalesOrder
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .cPaymentTermID
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
                                                                  'SalesRep'.tr,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText: controller
                                                                      .trxSalesOrder
                                                                      .records![
                                                                          controller
                                                                              .selectedCard]
                                                                      .salesRepID
                                                                      ?.identifier ??
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
                                                                        'Lines Amount'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: (controller.trxSalesOrder.records![controller.selectedCard].totalLines ??
                                                                            "")
                                                                        .toString(),
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
                                                                        'Charge Amount'
                                                                            .tr,
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    hintText: (controller.trxSalesOrder.records![controller.selectedCard].chargeAmt ??
                                                                            "")
                                                                        .toString(),
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
                                      controller.trxLine.rowcount.toString())
                                  : Text("LINES: ".tr)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getSalesOrderLines();
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
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: SingleChildScrollView(
                                            child: ListView.builder(
                                                primary: false,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount:
                                                    controller.trxLine.rowcount,
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
                                                              ? (controller.trxLine.records![index].mProductID?.identifier ?? "")
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(controller
                                                                      .linesSearchFilterValue
                                                                      .value
                                                                      .toLowerCase())
                                                              : controller.linesDropdownValue
                                                                          .value ==
                                                                      "2"
                                                                  ? (controller.trxLine.records![index].line ?? "")
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          controller.linesSearchFilterValue.value.toLowerCase())
                                                                  : controller.linesDropdownValue.value == "3"
                                                                      ? (controller.trxLine.records![index].name ?? "").toString().toLowerCase().contains(controller.linesSearchFilterValue.value.toLowerCase())
                                                                      : controller.linesDropdownValue.value == "4"
                                                                          ? (controller.trxLine.records![index].lineNetAmt ?? "").toString().toLowerCase().contains(controller.linesSearchFilterValue.value.toLowerCase())
                                                                          : true,
                                                      child: _buildLineCard(context, index)));
                                                }),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                              'No Sales Order selected'.tr)))),
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

  Widget _buildCard(Color selectionColor, context, index) {
    return Container(
      decoration: BoxDecoration(color: selectionColor),
      child: ExpansionTile(
        leading: Icon(
          Icons.handshake,
          color: controller.trxSalesOrder.records![index].docStatus?.id == 'CO'
              ? Colors.green
              : Colors.yellow,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.article,
            color: controller.trxSalesOrder.records![index].isApproved == false
                ? Colors.green
                : Colors.blue,
          ),
          onPressed: () {
            controller.selectedCard = index;
            controller.salesOrderId =
                controller.trxSalesOrder.records?[index].id;
            controller.getSalesOrderLines();
          },
        ),
        title: Text(
          'DocumentNo'.tr +
              ' ' +
              controller.trxSalesOrder.records![index].documentNo!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        controller.trxSalesOrder.records![index].cBPartnerID
                                ?.identifier ??
                            "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(children: [
                    Text(
                      controller.trxSalesOrder.records![index]
                              .cBPartnerLocationID?.identifier ??
                          "",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ])
                ],
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
                  Text('Date Ordered'.tr + ': '),
                  Text(
                    controller.trxSalesOrder.records![index].dateOrdered ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Document Type'.tr + ': '),
                  Text(
                    controller.trxSalesOrder.records![index].cDocTypeTargetID
                            ?.identifier ??
                        "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Line Amount'.tr + ': '),
                  Text(
                    (controller.trxSalesOrder.records![index].totalLines ?? "")
                        .toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  controller.trxSalesOrder.records![index].isApproved == false
                      ? IconButton(
                          tooltip: 'Sign'.tr,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      title: Text('DocumentNo'.tr +
                                          ' ' +
                                          (controller.trxSalesOrder
                                                  .records?[index].documentNo ??
                                              "")),
                                      content: Builder(builder: (context) {
                                        var height =
                                            MediaQuery.of(context).size.height;
                                        var width =
                                            MediaQuery.of(context).size.width;
                                        String dateNow =
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now())
                                                .toString();
                                        return SizedBox(
                                          height: height - 400,
                                          width: width - 800,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Date'.tr + ': $dateNow'),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              'Name'.tr + ': '),
                                                          SizedBox(
                                                            width: 300,
                                                            child:
                                                                TextFormField(
                                                              controller: controller
                                                                  .signatureNameController,
                                                              onChanged:
                                                                  (text) {
                                                                controller
                                                                        .canSign =
                                                                    text.isNotEmpty;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        postImage(
                                                            controller
                                                                .trxSalesOrder
                                                                .records![index]
                                                                .id,
                                                            dateNow,
                                                            index);
                                                      },
                                                      icon: const Icon(
                                                          Icons.save))
                                                ],
                                              ),
                                              Obx(
                                                () => controller.canSign
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                child: Signature(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    width:
                                                                        width -
                                                                            1000,
                                                                    height:
                                                                        height -
                                                                            500,
                                                                    controller:
                                                                        controller
                                                                            .signatureController),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 100),
                                                            child: Column(
                                                              children: [
                                                                Center(
                                                                  child: IconButton(
                                                                      onPressed: () => controller.signatureController.value = [],
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .cleaning_services,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            30,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
                                                        child: Text(
                                                            'Please, fill the Name field to sign'
                                                                .tr,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red))),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    )); //.then((exit) => controller.signatureController.value = []);
                          },
                          icon: const Icon(EvaIcons.edit2Outline),
                        )
                      : Text('Approved'.tr),
                  Obx(() => controller.canApprove[index]
                      ? Visibility(
                          visible: controller
                                  .trxSalesOrder.records![index].isApproved ==
                              false,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              onPressed: () async {
                                Get.defaultDialog(
                                    title: 'Approve Sales Order',
                                    content: const Text(
                                        "Are you sure you want to approve this Sales Order?"),
                                    onCancel: () {},
                                    onConfirm: () async {
                                      approveSalesOrder(index);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    });
                              },
                              child: Text("Approve".tr)),
                        )
                      : Visibility(
                          visible: controller
                                  .trxSalesOrder.records![index].isApproved ==
                              false,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                              ),
                              onPressed: () async {
                                Get.snackbar(
                                  "Sign missing".tr,
                                  "Please, sign this Sales Order to approve it"
                                      .tr,
                                  icon: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                );
                              },
                              child: Text("Approve".tr)),
                        ))
                ],
              ),
              /* Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Signature(
                          controller: controller.signatureController,
                          height: 100,
                          width: 200,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ) */
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineCard(context, index) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: ExpansionTile(
        title: Text(
          controller.trxLine.records![index].mProductID?.identifier ?? "???",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Expanded(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'LineNo'.tr + ': ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    (controller.trxLine.records![index].line ?? "").toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Name'.tr + ': ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(controller.trxLine.records![index].name ?? "",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                children: [
                  Text(
                    'Line Amount'.tr + ': ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    (controller.trxLine.records![index].lineNetAmt ?? "")
                        .toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text('Description'.tr + ': '),
                  Text(
                    controller.trxLine.records![index].description ?? "",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Date Promised'.tr + ': '),
                  Text(
                    controller.trxLine.records![index].datePromised ?? "",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Date Ordered'.tr + ': '),
                  Text(
                    controller.trxLine.records![index].dateOrdered ?? "",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Price'.tr + ': '),
                  Text(
                    (controller.trxLine.records![index].priceEntered ?? "")
                        .toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Text('List Price'.tr + ': '),
                  Text(
                    (controller.trxLine.records![index].priceList ?? "")
                        .toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Tax'.tr + ': '),
                  Text(
                    controller.trxLine.records![index].cTaxID?.identifier ?? "",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildSalesOrdersFilter() {
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
              value: controller.salesOrderDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.salesOrderDropdownValue.value = newValue!;
              },
              items: controller.salesOrderDropDownList.map((list) {
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
              controller: controller.salesOrderSearchFieldController,
              onSubmitted: (String? value) {
                controller.salesOrderSearchFilterValue.value =
                    controller.salesOrderSearchFieldController.text;
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
}

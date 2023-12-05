// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/models/orginfo_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/contractarticle_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/sales_order_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_edithtml_sales_order.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_filter_screen.dart';
//import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/print_pos_page.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/signature_page.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Line/models/salesorderline_json.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Vehicle/models/asset_json.dart';
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
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

//model for sales_order_controller
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';

// binding
part '../../bindings/crm_sales_order_binding.dart';

// controller
part '../../controllers/crm_sales_order_controller.dart';

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

class CRMSalesOrderScreen extends GetView<CRMSalesOrderController> {
  const CRMSalesOrderScreen({Key? key}) : super(key: key);

  completeOrder(int index) async {
    Get.back();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "doc-action": "CO",
    });
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order/${controller.trx.records![index].id}');
    //print(url);

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
      //print(response.body);

      Get.snackbar(
        "Done!".tr,
        "Record has been completed".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
      }
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
                            controller.getSalesOrders();
                          },
                          child: Row(
                            children: [
                              //Icon(Icons.filter_alt),
                              Obx(() => controller.dataAvailable
                                  ? Text("SALES ORDERS: ".tr +
                                      controller.trx.rowcount.toString())
                                  : Text("SALES ORDERS: ".tr)),
                            ],
                          ),
                        ),
                      ),
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
                              controller.getSalesOrders();
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
                              controller.getSalesOrders();
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
                              controller.docNoValue.value == ""
                          ? Colors.white
                          : kNotifColor,
                    )),
                onTap: () {
                  Get.to(const CRMFilterSalesOrder(), arguments: {
                    'selectedUserRadioTile':
                        controller.selectedUserRadioTile.value,
                    'salesRepId': controller.salesRepId,
                    'salesRepName': controller.salesRepName,
                    'businessPartnerId': controller.businessPartnerId.value,
                    'businessPartnerName': controller.businessPartnerName,
                    'docNo': controller.docNoValue.value,
                  });
                }),
            /* SpeedDialChild(
                label: 'New'.tr,
                child: const Icon(MaterialSymbols.assignment_add_outlined),
                onTap: () {
                  Get.toNamed('/SalesOrderCreation');
                }), */
            SpeedDialChild(
                label: 'New'.tr,
                child: const Icon(Symbols.assignment_add),
                onTap: () {
                  Get.toNamed('/SalesOrderCreationBPPricelist');
                })
          ],
        ),

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
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller.searchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.dropdownValue.value == "1"
                                          ? controller
                                              .trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
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
                                                      .searchFilterValue.value
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
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                            .trx
                                                            .records![index]
                                                            .docStatus
                                                            ?.id ==
                                                        "CO" ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .docStatus
                                                            ?.id ==
                                                        "CL"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.toNamed('/SalesOrderLine',
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "bPartnerId": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.id,
                                                  "cLocationBPartner":
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerLocationID
                                                          ?.id,
                                                  "dateOrdered": controller
                                                      .trx
                                                      .records![index]
                                                      .dateOrdered,
                                                  "warehouseId": controller
                                                      .trx
                                                      .records![index]
                                                      .mWarehouseID
                                                      ?.id,
                                                  "currencyId": controller
                                                      .trx
                                                      .records![index]
                                                      .cCurrencyID
                                                      ?.id,
                                                  "docNo": controller
                                                      .trx
                                                      .records![index]
                                                      .documentNo,
                                                  "priceListId": controller
                                                      .trx
                                                      .records![index]
                                                      .mPriceListID
                                                      ?.id,
                                                  "activityId": controller
                                                          .trx
                                                          .records![index]
                                                          .cActivityID
                                                          ?.id ??
                                                      0,
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
                                              if (controller.trx.records![index]
                                                          .docStatus?.id !=
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .docStatus?.id !=
                                                      "CL") {
                                                Get.to(
                                                    const CRMEditSalesOrder(),
                                                    arguments: {
                                                      "id": controller.trx
                                                          .records![index].id,
                                                      "docNo": controller
                                                          .trx
                                                          .records![index]
                                                          .documentNo,
                                                      "docTypeTargetId":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .cDocTypeTargetID!
                                                              .id,
                                                      "BPartnerLocationId":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerLocationID!
                                                              .id,
                                                      "bPartnerId": controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.id,
                                                      "bPartnerName": controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier,
                                                      "isPaid": controller
                                                          .trx
                                                          .records![index]
                                                          .isPaid,
                                                      "pRuleId": controller
                                                          .trx
                                                          .records![index]
                                                          .paymentRule
                                                          ?.id,
                                                      "amt": controller
                                                          .trx
                                                          .records![index]
                                                          .totalLines
                                                          .toString(),
                                                      "taxedAmt": controller
                                                          .trx
                                                          .records![index]
                                                          .grandTotal
                                                          .toString(),
                                                    });
                                              }
                                              //log("info button pressed");
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo} Dt ${controller.trx.records![index].dateOrdered}",
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
                                                    "Net Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trx.records![index].totalLines}"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Taxed Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trx.records![index].grandTotal}"),
                                                ],
                                              ),
                                              Visibility(
                                                visible: controller
                                                        .trx
                                                        .records![index]
                                                        .mpotid !=
                                                    null,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Work Order: ".tr,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.offNamed(
                                                              '/MaintenanceMptask',
                                                              arguments: {
                                                                'notificationId':
                                                                    controller
                                                                        ._trx
                                                                        .records![
                                                                            index]
                                                                        .mpotid
                                                                        ?.id
                                                              });
                                                        },
                                                        child: Text(
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mpotid
                                                                    ?.identifier ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color:
                                                                    kNotifColor))),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  /* IconButton(
                                                    tooltip: 'Editor HTML',
                                                    onPressed: () async {
                                                      controller
                                                          .getContractArticles(
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .id!);
                                                    },
                                                    icon:
                                                        const Icon(Icons.html),
                                                  ), */
                                                  Visibility(
                                                    visible: controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            "CO" &&
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            "CL",
                                                    child: IconButton(
                                                      tooltip:
                                                          'Edit Sales Order'.tr,
                                                      onPressed: () async {
                                                        Get.toNamed(
                                                            '/SalesOrderCreationBPPricelistEdit',
                                                            arguments: {
                                                              "orderId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .id,
                                                              "note": controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .note ??
                                                                  '',
                                                              "docNo": controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .documentNo,
                                                              "priceListId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mPriceListID
                                                                      ?.id,
                                                              "businessPartnerId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerID
                                                                      ?.id,
                                                              "businessPartnerName":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerID
                                                                      ?.identifier,
                                                              "dateOrdered":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .dateOrdered,
                                                              "datePromised":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .datePromised,
                                                              "documentTypeId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cDocTypeTargetID
                                                                      ?.id,
                                                              "paymentTermId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cPaymentTermID
                                                                      ?.id,
                                                              "paymentRuleId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .paymentRule
                                                                      ?.id,
                                                              "bpLocationId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerLocationID
                                                                      ?.id,
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit_document),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Duplicate'.tr,
                                                    onPressed: () async {
                                                      Get.defaultDialog(
                                                        title: 'Duplicate'.tr,
                                                        content: Text(
                                                            "Are you sure you want to duplicate the record?"
                                                                .tr),
                                                        onCancel: () {},
                                                        onConfirm: () async {
                                                          controller
                                                              .getSelectedSalesOrder(
                                                                  index);
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                    icon:
                                                        const Icon(Icons.copy),
                                                  ),
                                                  IconButton(
                                                    tooltip:
                                                        'print Document'.tr,
                                                    onPressed: () async {
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index); */
                                                      controller
                                                          .getDocument(index);
                                                      /* Get.to(
                                                          const PrintDocumentScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          }); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.print),
                                                  ),
                                                  /* IconButton(
                                                    tooltip: 'print POS',
                                                    onPressed: () async {
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index); */
                                                      /* Get.to(
                                                          const PrintPOSScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          }); */
                                                      controller
                                                          .getBusinessPartner(
                                                              index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.receipt),
                                                  ), */
                                                  IconButton(
                                                    tooltip: 'Sign'.tr,
                                                    onPressed: () async {
                                                      Get.to(
                                                          const SignatureSalesOrderScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          });
                                                    },
                                                    icon: const Icon(
                                                        EvaIcons.edit2Outline),
                                                  ),
                                                  Visibility(
                                                    visible: int.parse(
                                                                        controller.list[
                                                                            14],
                                                                        radix: 16)
                                                                    .toRadixString(
                                                                        2)
                                                                    .padLeft(4, "0")
                                                                    .toString()[
                                                                6] !=
                                                            "1" &&
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            'CO',
                                                    child: IconButton(
                                                      tooltip: 'Asset Used'.tr,
                                                      onPressed: () async {
                                                        controller
                                                            .codeFieldController
                                                            .text = '';
                                                        controller
                                                            .assetQtyFieldController
                                                            .text = '1';
                                                        Get.defaultDialog(
                                                            title:
                                                                'Asset Used'.tr,
                                                            content: Column(
                                                              children: [
                                                                Divider(),
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          controller
                                                                              .codeFieldController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelStyle:
                                                                            const TextStyle(color: Colors.white),
                                                                        labelText:
                                                                            "Code".tr,
                                                                        filled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        fillColor:
                                                                            Theme.of(context).cardColor,
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        TextField(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      controller:
                                                                          controller
                                                                              .assetQtyFieldController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelStyle:
                                                                            const TextStyle(color: Colors.white),
                                                                        labelText:
                                                                            "Qty".tr,
                                                                        filled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        fillColor:
                                                                            Theme.of(context).cardColor,
                                                                      ),
                                                                      keyboardType: const TextInputType
                                                                              .numberWithOptions(
                                                                          signed:
                                                                              false,
                                                                          decimal:
                                                                              true),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp("[0-9]"))
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                            onConfirm: () {
                                                              controller
                                                                  .getAssetUsed(
                                                                      index);
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Symbols.build),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            'CO' &&
                                                        int.parse(
                                                                    controller
                                                                        .list[8],
                                                                    radix: 16)
                                                                .toRadixString(2)
                                                                .padLeft(8, "0")
                                                                .toString()[7] ==
                                                            "1",
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .green),
                                                      ),
                                                      onPressed: () async {
                                                        Get.defaultDialog(
                                                          title: 'Complete'.tr,
                                                          content: Text(
                                                              "Are you sure you want to complete the record?"
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            completeOrder(
                                                                index);
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
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller.searchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.dropdownValue.value == "1"
                                          ? controller
                                              .trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
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
                                                      .searchFilterValue.value
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
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                            .trx
                                                            .records![index]
                                                            .docStatus
                                                            ?.id ==
                                                        "CO" ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .docStatus
                                                            ?.id ==
                                                        "CL"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.toNamed('/SalesOrderLine',
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "bPartnerId": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.id,
                                                  "cLocationBPartner":
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerLocationID
                                                          ?.id,
                                                  "dateOrdered": controller
                                                      .trx
                                                      .records![index]
                                                      .dateOrdered,
                                                  "warehouseId": controller
                                                      .trx
                                                      .records![index]
                                                      .mWarehouseID
                                                      ?.id,
                                                  "currencyId": controller
                                                      .trx
                                                      .records![index]
                                                      .cCurrencyID
                                                      ?.id,
                                                  "docNo": controller
                                                      .trx
                                                      .records![index]
                                                      .documentNo,
                                                  "priceListId": controller
                                                      .trx
                                                      .records![index]
                                                      .mPriceListID
                                                      ?.id,
                                                  "activityId": controller
                                                          .trx
                                                          .records![index]
                                                          .cActivityID
                                                          ?.id ??
                                                      0,
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
                                              if (controller.trx.records![index]
                                                          .docStatus?.id !=
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .docStatus?.id !=
                                                      "CL") {
                                                Get.to(
                                                    const CRMEditSalesOrder(),
                                                    arguments: {
                                                      "id": controller.trx
                                                          .records![index].id,
                                                      "docNo": controller
                                                          .trx
                                                          .records![index]
                                                          .documentNo,
                                                      "docTypeTargetId":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .cDocTypeTargetID!
                                                              .id,
                                                      "BPartnerLocationId":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerLocationID!
                                                              .id,
                                                      "bPartnerId": controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.id,
                                                      "bPartnerName": controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier,
                                                      "isPaid": controller
                                                          .trx
                                                          .records![index]
                                                          .isPaid,
                                                      "pRuleId": controller
                                                          .trx
                                                          .records![index]
                                                          .paymentRule
                                                          ?.id,
                                                      "amt": controller
                                                          .trx
                                                          .records![index]
                                                          .totalLines
                                                          .toString(),
                                                      "taxedAmt": controller
                                                          .trx
                                                          .records![index]
                                                          .grandTotal
                                                          .toString(),
                                                    });
                                              }
                                              //log("info button pressed");
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo} Dt ${controller.trx.records![index].dateOrdered}",
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
                                                    "Net Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trx.records![index].totalLines}"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Taxed Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trx.records![index].grandTotal}"),
                                                ],
                                              ),
                                              Visibility(
                                                visible: controller
                                                        .trx
                                                        .records![index]
                                                        .mpotid !=
                                                    null,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Work Order: ".tr,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.offNamed(
                                                              '/MaintenanceMptask',
                                                              arguments: {
                                                                'notificationId':
                                                                    controller
                                                                        ._trx
                                                                        .records![
                                                                            index]
                                                                        .mpotid
                                                                        ?.id
                                                              });
                                                        },
                                                        child: Text(
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mpotid
                                                                    ?.identifier ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color:
                                                                    kNotifColor))),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  /* IconButton(
                                                    tooltip: 'Editor HTML',
                                                    onPressed: () async {
                                                      controller
                                                          .getContractArticles(
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .id!);
                                                    },
                                                    icon:
                                                        const Icon(Icons.html),
                                                  ), */
                                                  Visibility(
                                                    visible: controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            "CO" &&
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            "CL",
                                                    child: IconButton(
                                                      tooltip:
                                                          'Edit Sales Order'.tr,
                                                      onPressed: () async {
                                                        Get.toNamed(
                                                            '/SalesOrderCreationBPPricelistEdit',
                                                            arguments: {
                                                              "orderId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .id,
                                                              "note": controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .note ??
                                                                  '',
                                                              "docNo": controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .documentNo,
                                                              "priceListId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mPriceListID
                                                                      ?.id,
                                                              "businessPartnerId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerID
                                                                      ?.id,
                                                              "businessPartnerName":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerID
                                                                      ?.identifier,
                                                              "dateOrdered":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .dateOrdered,
                                                              "datePromised":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .datePromised,
                                                              "documentTypeId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cDocTypeTargetID
                                                                      ?.id,
                                                              "paymentTermId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cPaymentTermID
                                                                      ?.id,
                                                              "paymentRuleId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .paymentRule
                                                                      ?.id,
                                                              "bpLocationId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerLocationID
                                                                      ?.id,
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit_document),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Duplicate'.tr,
                                                    onPressed: () async {
                                                      Get.defaultDialog(
                                                        title: 'Duplicate'.tr,
                                                        content: Text(
                                                            "Are you sure you want to duplicate the record?"
                                                                .tr),
                                                        onCancel: () {},
                                                        onConfirm: () async {
                                                          controller
                                                              .getSelectedSalesOrder(
                                                                  index);
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                    icon:
                                                        const Icon(Icons.copy),
                                                  ),
                                                  IconButton(
                                                    tooltip:
                                                        'print Document'.tr,
                                                    onPressed: () async {
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index); */
                                                      controller
                                                          .getDocument(index);
                                                      /* Get.to(
                                                          const PrintDocumentScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          }); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.print),
                                                  ),
                                                  /* IconButton(
                                                    tooltip: 'print POS',
                                                    onPressed: () async {
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index); */
                                                      /* Get.to(
                                                          const PrintPOSScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          }); */
                                                      controller
                                                          .getBusinessPartner(
                                                              index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.receipt),
                                                  ), */
                                                  IconButton(
                                                    tooltip: 'Sign'.tr,
                                                    onPressed: () async {
                                                      Get.to(
                                                          const SignatureSalesOrderScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          });
                                                    },
                                                    icon: const Icon(
                                                        EvaIcons.edit2Outline),
                                                  ),
                                                  Visibility(
                                                    visible: int.parse(
                                                                        controller.list[
                                                                            14],
                                                                        radix: 16)
                                                                    .toRadixString(
                                                                        2)
                                                                    .padLeft(4, "0")
                                                                    .toString()[
                                                                6] !=
                                                            "1" &&
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            'CO',
                                                    child: IconButton(
                                                      tooltip: 'Asset Used'.tr,
                                                      onPressed: () async {
                                                        controller
                                                            .codeFieldController
                                                            .text = '';
                                                        controller
                                                            .assetQtyFieldController
                                                            .text = '1';
                                                        Get.defaultDialog(
                                                            title:
                                                                'Asset Used'.tr,
                                                            content: Column(
                                                              children: [
                                                                Divider(),
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          controller
                                                                              .codeFieldController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelStyle:
                                                                            const TextStyle(color: Colors.white),
                                                                        labelText:
                                                                            "Code".tr,
                                                                        filled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        fillColor:
                                                                            Theme.of(context).cardColor,
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        TextField(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      controller:
                                                                          controller
                                                                              .assetQtyFieldController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelStyle:
                                                                            const TextStyle(color: Colors.white),
                                                                        labelText:
                                                                            "Qty".tr,
                                                                        filled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        fillColor:
                                                                            Theme.of(context).cardColor,
                                                                      ),
                                                                      keyboardType: const TextInputType
                                                                              .numberWithOptions(
                                                                          signed:
                                                                              false,
                                                                          decimal:
                                                                              true),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp("[0-9]"))
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                            onConfirm: () {
                                                              controller
                                                                  .getAssetUsed(
                                                                      index);
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Symbols.build),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            'CO' &&
                                                        int.parse(
                                                                    controller
                                                                        .list[8],
                                                                    radix: 16)
                                                                .toRadixString(2)
                                                                .padLeft(8, "0")
                                                                .toString()[7] ==
                                                            "1",
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .green),
                                                      ),
                                                      onPressed: () async {
                                                        Get.defaultDialog(
                                                          title: 'Complete'.tr,
                                                          content: Text(
                                                              "Are you sure you want to complete the record?"
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            completeOrder(
                                                                index);
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
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => Visibility(
                                  visible: controller.searchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.dropdownValue.value == "1"
                                          ? controller
                                              .trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
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
                                                      .searchFilterValue.value
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
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                            .trx
                                                            .records![index]
                                                            .docStatus
                                                            ?.id ==
                                                        "CO" ||
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .docStatus
                                                            ?.id ==
                                                        "CL"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.toNamed('/SalesOrderLine',
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "bPartnerId": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.id,
                                                  "cLocationBPartner":
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerLocationID
                                                          ?.id,
                                                  "dateOrdered": controller
                                                      .trx
                                                      .records![index]
                                                      .dateOrdered,
                                                  "warehouseId": controller
                                                      .trx
                                                      .records![index]
                                                      .mWarehouseID
                                                      ?.id,
                                                  "currencyId": controller
                                                      .trx
                                                      .records![index]
                                                      .cCurrencyID
                                                      ?.id,
                                                  "docNo": controller
                                                      .trx
                                                      .records![index]
                                                      .documentNo,
                                                  "priceListId": controller
                                                      .trx
                                                      .records![index]
                                                      .mPriceListID
                                                      ?.id,
                                                  "activityId": controller
                                                          .trx
                                                          .records![index]
                                                          .cActivityID
                                                          ?.id ??
                                                      0,
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
                                              if (controller.trx.records![index]
                                                          .docStatus?.id !=
                                                      "CO" &&
                                                  controller.trx.records![index]
                                                          .docStatus?.id !=
                                                      "CL") {
                                                Get.to(
                                                    const CRMEditSalesOrder(),
                                                    arguments: {
                                                      "id": controller.trx
                                                          .records![index].id,
                                                      "docNo": controller
                                                          .trx
                                                          .records![index]
                                                          .documentNo,
                                                      "docTypeTargetId":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .cDocTypeTargetID!
                                                              .id,
                                                      "BPartnerLocationId":
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerLocationID!
                                                              .id,
                                                      "bPartnerId": controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.id,
                                                      "bPartnerName": controller
                                                          .trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier,
                                                      "isPaid": controller
                                                          .trx
                                                          .records![index]
                                                          .isPaid,
                                                      "pRuleId": controller
                                                          .trx
                                                          .records![index]
                                                          .paymentRule
                                                          ?.id,
                                                      "amt": controller
                                                          .trx
                                                          .records![index]
                                                          .totalLines
                                                          .toString(),
                                                      "taxedAmt": controller
                                                          .trx
                                                          .records![index]
                                                          .grandTotal
                                                          .toString(),
                                                    });
                                              }
                                              //log("info button pressed");
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo} Dt ${controller.trx.records![index].dateOrdered}",
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
                                                    "Net Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trx.records![index].totalLines}"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Taxed Amount: ".tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      "€${controller.trx.records![index].grandTotal}"),
                                                ],
                                              ),
                                              Visibility(
                                                visible: controller
                                                        .trx
                                                        .records![index]
                                                        .mpotid !=
                                                    null,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Work Order: ".tr,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.offNamed(
                                                              '/MaintenanceMptask',
                                                              arguments: {
                                                                'notificationId':
                                                                    controller
                                                                        ._trx
                                                                        .records![
                                                                            index]
                                                                        .mpotid
                                                                        ?.id
                                                              });
                                                        },
                                                        child: Text(
                                                            controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .mpotid
                                                                    ?.identifier ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color:
                                                                    kNotifColor))),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  /* IconButton(
                                                    tooltip: 'Editor HTML',
                                                    onPressed: () async {
                                                      controller
                                                          .getContractArticles(
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .id!);
                                                    },
                                                    icon:
                                                        const Icon(Icons.html),
                                                  ), */
                                                  Visibility(
                                                    visible: controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            "CO" &&
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            "CL",
                                                    child: IconButton(
                                                      tooltip:
                                                          'Edit Sales Order'.tr,
                                                      onPressed: () async {
                                                        Get.toNamed(
                                                            '/SalesOrderCreationBPPricelistEdit',
                                                            arguments: {
                                                              "orderId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .id,
                                                              "note": controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .note ??
                                                                  '',
                                                              "docNo": controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .documentNo,
                                                              "priceListId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mPriceListID
                                                                      ?.id,
                                                              "businessPartnerId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerID
                                                                      ?.id,
                                                              "businessPartnerName":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerID
                                                                      ?.identifier,
                                                              "dateOrdered":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .dateOrdered,
                                                              "datePromised":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .datePromised,
                                                              "documentTypeId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cDocTypeTargetID
                                                                      ?.id,
                                                              "paymentTermId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cPaymentTermID
                                                                      ?.id,
                                                              "paymentRuleId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .paymentRule
                                                                      ?.id,
                                                              "bpLocationId":
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cBPartnerLocationID
                                                                      ?.id,
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit_document),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Duplicate'.tr,
                                                    onPressed: () async {
                                                      Get.defaultDialog(
                                                        title: 'Duplicate'.tr,
                                                        content: Text(
                                                            "Are you sure you want to duplicate the record?"
                                                                .tr),
                                                        onCancel: () {},
                                                        onConfirm: () async {
                                                          controller
                                                              .getSelectedSalesOrder(
                                                                  index);
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                    icon:
                                                        const Icon(Icons.copy),
                                                  ),
                                                  IconButton(
                                                    tooltip:
                                                        'print Document'.tr,
                                                    onPressed: () async {
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index); */
                                                      controller
                                                          .getDocument(index);
                                                      /* Get.to(
                                                          const PrintDocumentScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          }); */
                                                    },
                                                    icon:
                                                        const Icon(Icons.print),
                                                  ),
                                                  /* IconButton(
                                                    tooltip: 'print POS',
                                                    onPressed: () async {
                                                      /* var isConnected =
                                                            await checkConnection();
                                                        controller
                                                            .editWorkOrderResourceDateTesting(
                                                                isConnected,
                                                                index); */
                                                      /* Get.to(
                                                          const PrintPOSScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          }); */
                                                      controller
                                                          .getBusinessPartner(
                                                              index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.receipt),
                                                  ), */
                                                  IconButton(
                                                    tooltip: 'Sign'.tr,
                                                    onPressed: () async {
                                                      Get.to(
                                                          const SignatureSalesOrderScreen(),
                                                          arguments: {
                                                            "id": controller
                                                                .trx
                                                                .records![index]
                                                                .id,
                                                          });
                                                    },
                                                    icon: const Icon(
                                                        EvaIcons.edit2Outline),
                                                  ),
                                                  Visibility(
                                                    visible: int.parse(
                                                                        controller.list[
                                                                            14],
                                                                        radix: 16)
                                                                    .toRadixString(
                                                                        2)
                                                                    .padLeft(4, "0")
                                                                    .toString()[
                                                                6] !=
                                                            "1" &&
                                                        controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            'CO',
                                                    child: IconButton(
                                                      tooltip: 'Asset Used'.tr,
                                                      onPressed: () async {
                                                        controller
                                                            .codeFieldController
                                                            .text = '';
                                                        controller
                                                            .assetQtyFieldController
                                                            .text = '1';
                                                        Get.defaultDialog(
                                                            title:
                                                                'Asset Used'.tr,
                                                            content: Column(
                                                              children: [
                                                                Divider(),
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          controller
                                                                              .codeFieldController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelStyle:
                                                                            const TextStyle(color: Colors.white),
                                                                        labelText:
                                                                            "Code".tr,
                                                                        filled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        fillColor:
                                                                            Theme.of(context).cardColor,
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        TextField(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      controller:
                                                                          controller
                                                                              .assetQtyFieldController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelStyle:
                                                                            const TextStyle(color: Colors.white),
                                                                        labelText:
                                                                            "Qty".tr,
                                                                        filled:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        fillColor:
                                                                            Theme.of(context).cardColor,
                                                                      ),
                                                                      keyboardType: const TextInputType
                                                                              .numberWithOptions(
                                                                          signed:
                                                                              false,
                                                                          decimal:
                                                                              true),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp("[0-9]"))
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                            onConfirm: () {
                                                              controller
                                                                  .getAssetUsed(
                                                                      index);
                                                            });
                                                      },
                                                      icon: const Icon(
                                                          Symbols.build),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: controller
                                                                .trx
                                                                .records![index]
                                                                .docStatus
                                                                ?.id !=
                                                            'CO' &&
                                                        int.parse(
                                                                    controller
                                                                        .list[8],
                                                                    radix: 16)
                                                                .toRadixString(2)
                                                                .padLeft(8, "0")
                                                                .toString()[7] ==
                                                            "1",
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .green),
                                                      ),
                                                      onPressed: () async {
                                                        Get.defaultDialog(
                                                          title: 'Complete'.tr,
                                                          content: Text(
                                                              "Are you sure you want to complete the record?"
                                                                  .tr),
                                                          onCancel: () {},
                                                          onConfirm: () async {
                                                            completeOrder(
                                                                index);
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

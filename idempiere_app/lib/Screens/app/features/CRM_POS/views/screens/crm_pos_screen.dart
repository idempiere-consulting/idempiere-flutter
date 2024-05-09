// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact_bp_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_POS/models/pos_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_POS/models/posbuttonlayout_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_POS/models/postablerow_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_POS/models/product_category_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/models/product_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/salesorder_defaults_json.dart';
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
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:intl/intl.dart';

import '../../../Portal_Mp_Sales_Order_B2B/views/screens/portal_mp_sales_order_b2b_screen.dart';

// binding
part '../../bindings/crm_pos_binding.dart';

// controller
part '../../controllers/crm_pos_controller.dart';

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

class CRMPOSScreen extends GetView<CRMPOSController> {
  const CRMPOSScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        body: BarcodeKeyboardListener(
          bufferDuration: const Duration(milliseconds: 200),
          onBarcodeScanned: (barcode) {
            print(barcode);
            switch (barcode.substring(0, 3)) {
              case 'fdy':
                controller.getFidelityCard(barcode);
                break;
              case 'adm':
                break;
              default:
                controller.getProductByBarcode(barcode);
            }
          },
          child: SingleChildScrollView(
            child: ResponsiveBuilder(
              mobileBuilder: (context, constraints) {
                return Column(children: const []);
              },
              tabletBuilder: (context, constraints) {
                return Column(children: const []);
              },
              desktopBuilder: (context, constraints) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height,
                        child: StaggeredGrid.count(
                          crossAxisCount: 100,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 55,
                              mainAxisCellCount: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() => Text(
                                            controller.currentProductName.value,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          )),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() => Text(
                                            '${controller.currentProductQuantity.value}    X    ${controller.currentProductPrice.value}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 55,
                              mainAxisCellCount: 20,
                              child: SingleChildScrollView(
                                child: Obx(
                                  () => controller.tableAvailable.value
                                      ? DataTable(
                                          //minWidth: 10,
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  ''.tr,
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Code'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Product'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Expanded(
                                                child: Text(
                                                  'Qty'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Expanded(
                                                child: Text(
                                                  'Price'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Expanded(
                                                child: Text(
                                                  'Discount'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Expanded(
                                                child: Text(
                                                  'Discounted Price'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Expanded(
                                                child: Text(
                                                  'Total'.tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: controller.productList
                                              .map((e) => DataRow(
                                                      color:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  (states) {
                                                        // If the button is pressed, return green, otherwise blue
                                                        if (e.rowType == "R") {
                                                          return Color.fromARGB(
                                                              255, 80, 83, 29);
                                                        }
                                                        return null;
                                                      }),
                                                      selected: e.number ==
                                                          controller.rowNumber,
                                                      cells: [
                                                        DataCell(IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .tableAvailable
                                                                .value = false;

                                                            controller
                                                                .productList
                                                                .removeAt(
                                                                    e.number! -
                                                                        1);
                                                            controller
                                                                .rowQtyFieldController
                                                                .removeAt(
                                                                    e.number! -
                                                                        1);
                                                            controller
                                                                .totalFieldController
                                                                .removeAt(
                                                                    e.number! -
                                                                        1);
                                                            var last = 0;
                                                            if (controller
                                                                .productList
                                                                .isNotEmpty) {
                                                              for (var i = 0;
                                                                  i <
                                                                      controller
                                                                          .productList
                                                                          .length;
                                                                  i++) {
                                                                last = i;
                                                                controller
                                                                    .productList[
                                                                        i]
                                                                    .number = i + 1;
                                                              }
                                                              controller
                                                                      .rowNumber =
                                                                  last + 1;
                                                            } else {
                                                              controller
                                                                  .rowNumber = 0;
                                                            }

                                                            print(controller
                                                                .rowNumber);

                                                            if (controller
                                                                .productList
                                                                .isNotEmpty) {
                                                              controller
                                                                      .currentProductName
                                                                      .value =
                                                                  controller
                                                                      .productList[
                                                                          last]
                                                                      .productName!;
                                                              controller
                                                                      .currentProductQuantity
                                                                      .value =
                                                                  controller
                                                                      .productList[
                                                                          last]
                                                                      .qty
                                                                      .toString();
                                                              controller
                                                                      .quantityCounted =
                                                                  controller
                                                                      .productList[
                                                                          last]
                                                                      .qty
                                                                      .toString();
                                                              controller
                                                                      .currentProductPrice
                                                                      .value =
                                                                  controller
                                                                      .productList[
                                                                          last]
                                                                      .price!;
                                                            }
                                                            controller
                                                                .tableAvailable
                                                                .value = true;

                                                            controller
                                                                .updateTotal();
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.red),
                                                        )),
                                                        DataCell(Text(
                                                            e.productCode ??
                                                                "N/A")),
                                                        DataCell(Text(
                                                            e.productName ??
                                                                "N/A")),
                                                        DataCell(Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: TextField(
                                                                readOnly: e
                                                                        .number! ==
                                                                    controller
                                                                        .rowNumber,
                                                                onChanged:
                                                                    (value) {
                                                                  if (int.tryParse(
                                                                          value) !=
                                                                      null) {
                                                                    controller
                                                                        .totalFieldController[
                                                                            e.number! -
                                                                                1]
                                                                        .text = (double.parse(value) *
                                                                            e.price!)
                                                                        .toString();
                                                                    controller
                                                                        .productList[
                                                                            e.number! -
                                                                                1]
                                                                        .tot = double.parse(
                                                                            value) *
                                                                        e.price!;
                                                                  } else {
                                                                    controller
                                                                        .rowQtyFieldController[
                                                                            e.number! -
                                                                                1]
                                                                        .text = "1";
                                                                    controller
                                                                        .totalFieldController[
                                                                            e.number! -
                                                                                1]
                                                                        .text = (double.parse(value) *
                                                                            e.price!)
                                                                        .toString();
                                                                  }
                                                                  controller
                                                                      .updateTotal();
                                                                },
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                //readOnly: true,
                                                                controller: controller
                                                                    .rowQtyFieldController[e
                                                                        .number! -
                                                                    1],
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                        DataCell(Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text("${e.price}"),
                                                          ],
                                                        )),
                                                        DataCell(Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                "${e.discount ?? 0.0}%"),
                                                          ],
                                                        )),
                                                        DataCell(Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                "${e.discountedPrice ?? 0.0}"),
                                                          ],
                                                        )),
                                                        DataCell(Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: TextField(
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                readOnly: true,
                                                                controller: controller
                                                                    .totalFieldController[e
                                                                        .number! -
                                                                    1],
                                                              ),
                                                            )
                                                          ],
                                                        ))
                                                      ]))
                                              .toList(),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 23,
                              mainAxisCellCount: 10,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextField(
                                      //controller: nameFieldController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                        prefixIcon:
                                            const Icon(Icons.text_fields),
                                        border: const OutlineInputBorder(),
                                        labelText: 'Invoice Document N°'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      minLines: 1,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextField(
                                      controller:
                                          controller.fidelityFieldController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                        prefixIcon:
                                            const Icon(Icons.text_fields),
                                        border: const OutlineInputBorder(),
                                        labelText: 'Fidelity Card'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      minLines: 1,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 22,
                              mainAxisCellCount: 10,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: GetStorage().read('user')),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                        prefixIcon:
                                            const Icon(Icons.text_fields),
                                        border: const OutlineInputBorder(),
                                        labelText: 'User'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      minLines: 1,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextField(
                                      //controller: nameFieldController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                        prefixIcon:
                                            const Icon(Icons.text_fields),
                                        border: const OutlineInputBorder(),
                                        labelText: 'Date'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      minLines: 1,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 55,
                              mainAxisCellCount: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          'Discount'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          'Amount'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          'Vat'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          'Total + VAT'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          '0'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          '0'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Text(
                                          '0'.tr,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        width: 90,
                                        child: Obx(
                                          () => Text(
                                            "${controller.totalRows.value}",
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 45,
                              mainAxisCellCount: 45,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    TextField(
                                      //controller: nameFieldController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "Search Product...".tr,
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
                                      ),
                                      minLines: 1,
                                      maxLines: 1,
                                      onSubmitted: (value) {
                                        controller
                                            .getProductBySearchField(value);
                                      },
                                    ),
                                    const Divider(),
                                    Flexible(
                                      flex: 9,
                                      child: Obx(
                                        () => controller.dataAvailable.value
                                            ? ListView.builder(
                                                itemCount: controller
                                                    ._trx.records!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Card(
                                                    child: ListTile(
                                                      onTap: () {
                                                        controller
                                                            .setCurrentProduct(
                                                                controller._trx
                                                                        .records![
                                                                    index]);
                                                      },
                                                      title: Text(controller
                                                              ._trx
                                                              .records![index]
                                                              .name ??
                                                          'N/A'),
                                                      subtitle: Text(controller
                                                              ._trx
                                                              .records![index]
                                                              .value ??
                                                          "N/A"),
                                                    ),
                                                  );
                                                })
                                            : Column(
                                                children: const [
                                                  CircularProgressIndicator()
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 18,
                              mainAxisCellCount: 20,
                              child: MasonryGridView.count(
                                shrinkWrap: true,
                                itemCount: 1,
                                crossAxisCount: 2,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                        style: ButtonStyle(backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          // If the button is pressed, return green, otherwise blue
                                          if (controller
                                              .isReturnButtonActive.value) {
                                            return kNotifColor;
                                          }
                                          return null;
                                        })),
                                        onPressed: () {
                                          controller
                                                  .isReturnButtonActive.value =
                                              !controller
                                                  .isReturnButtonActive.value;
                                        },
                                        child: Text(
                                          controller
                                              .functionButtonNameList[index],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        )),
                                  );
                                },
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 17,
                              mainAxisCellCount: 20,
                              child: Obx(
                                () =>
                                    controller.prodCategoryButtonAvailable.value
                                        ? MasonryGridView.count(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                    .prodCategoryButtonList
                                                    .records
                                                    ?.length ??
                                                0,
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 2,
                                            crossAxisSpacing: 2,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                height: 60,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      if (controller
                                                              .prodCategoryButtonList
                                                              .records![index]
                                                              .subKeyLayoutID
                                                              ?.id !=
                                                          null) {
                                                        controller.getPOSProductCategoryButtons(
                                                            controller
                                                                .prodCategoryButtonList
                                                                .records![index]
                                                                .subKeyLayoutID!
                                                                .id!);
                                                      } else if (controller
                                                              .prodCategoryButtonList
                                                              .records![index]
                                                              .mProductCategoryID
                                                              ?.id !=
                                                          null) {
                                                        controller.getProductByProductCategory(
                                                            controller
                                                                .prodCategoryButtonList
                                                                .records![index]
                                                                .mProductCategoryID!
                                                                .id!);
                                                      }
                                                    },
                                                    child: Text(
                                                      controller
                                                              .prodCategoryButtonList
                                                              .records![index]
                                                              .name ??
                                                          "N/A",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    )),
                                              );
                                            },
                                          )
                                        : const SizedBox(),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 20,
                              mainAxisCellCount: 20,
                              child: StaggeredGrid.count(
                                crossAxisCount: 16,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                children: [
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("1");
                                        },
                                        child: const Text(
                                          '1',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("2");
                                        },
                                        child: const Text(
                                          '2',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("3");
                                        },
                                        child: const Text(
                                          '3',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: Tooltip(
                                      message: "Delete character".tr,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            controller
                                                .deleteCurrentProductQtyDigit();
                                          },
                                          child: const Text(
                                            'C',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35),
                                          )),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("4");
                                        },
                                        child: const Text(
                                          '4',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("5");
                                        },
                                        child: const Text(
                                          '5',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("6");
                                        },
                                        child: const Text(
                                          '6',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: Tooltip(
                                      message: "Credit Card".tr,
                                      child: Obx(() => ElevatedButton(
                                          onPressed: () {
                                            controller.creditCardPayment.value =
                                                true;
                                            controller.cashPayment.value =
                                                false;
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: controller
                                                      .creditCardPayment.value
                                                  ? kNotifColor
                                                  : Colors.grey),
                                          child:
                                              const Icon(Icons.credit_card))),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("7");
                                        },
                                        child: const Text(
                                          '7',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("8");
                                        },
                                        child: const Text(
                                          '8',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("9");
                                        },
                                        child: const Text(
                                          '9',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: Tooltip(
                                      message: "Cash".tr,
                                      child: Obx(() => ElevatedButton(
                                            onPressed: () {
                                              controller.creditCardPayment
                                                  .value = false;
                                              controller.cashPayment.value =
                                                  true;
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    controller.cashPayment.value
                                                        ? kNotifColor
                                                        : Colors.grey),
                                            child: const Icon(Icons.payments),
                                          )),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: Tooltip(
                                      message: "Undo".tr,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: const Icon(Icons.undo)),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.setCurrentProductQty("0");
                                        },
                                        child: const Text(
                                          '0',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35),
                                        )),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 8,
                                    mainAxisCellCount: 4,
                                    child: Obx(
                                      () => ElevatedButton(
                                          onPressed: () {
                                            controller.createSalesOrder();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: controller
                                                          .cashPayment.value ||
                                                      controller
                                                          .creditCardPayment
                                                          .value
                                                  ? kNotifColor
                                                  : Colors.grey),
                                          child: Text(
                                            'Total'.tr,
                                            style:
                                                const TextStyle(fontSize: 25),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]);
              },
            ),
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

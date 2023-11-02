// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Price_List/models/price_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_detail.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/businesspartner_location_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/doctype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_term_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/product_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/productcheckout.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/salesorder_defaults_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// binding
part '../../bindings/crm_sales_order_creation_bp_pricelist_binding.dart';

// controller
part '../../controllers/crm_sales_order_creation_bp_pricelist_controller.dart';

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

class CRMSalesOrderCreationBPPricelistScreen
    extends GetView<CRMSalesOrderCreationBPPricelistController> {
  const CRMSalesOrderCreationBPPricelistScreen({Key? key}) : super(key: key);

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
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sales Order Creation'.tr),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              if (controller.filterCount.value > 0) {
                controller.changeFilterMinus();
              } else {
                Get.back();
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () {
                  controller.changeFilterPlus();
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(
                    () => StepProgressIndicator(
                      roundedEdges: const Radius.circular(10),
                      totalSteps: 4,
                      currentStep: controller.filterCount.value + 1,
                      size: 36,
                      onTap: (index) {
                        return () {
                          if (kDebugMode) {
                            print('$index pressed');
                          }
                        };
                      },
                      selectedColor: kNotifColor,
                      unselectedColor: Colors.grey,
                      customStep: (index, color, _) => color == kNotifColor
                          ? index == 0
                              ? Container(
                                  color: color,
                                  child: const Icon(
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
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
                                                          child: Obx(
                                                            () => Text(
                                                              '${controller.counter.value}',
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            )
                          : index == 0
                              ? Container(
                                  color: color,
                                  child: const Icon(
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
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
                                                          child: Obx(
                                                            () => Text(
                                                              '${controller.counter.value}',
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<BPRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .businessPartnerName.value),
                                    displayStringForOption:
                                        controller.displayStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            BPRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((BPRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (BPRecords selection) {
                                      controller.businessPartnerId =
                                          selection.id!;
                                      controller.priceListID =
                                          selection.mPriceListID!.id!;
                                      controller.getProductLists(
                                          selection.mPriceListID!.id!);
                                      controller.getPaymentTerms();
                                      controller.getLocationFromBP();
                                      controller.getSalesOrderDefaultValues();
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Document Type".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.docTypeFlag.value
                          ? DropdownButton(
                              value: controller.dropdownValue.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.dropdownValue.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.dropDownList.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.searchFieldController,
                        autofocus: true,
                        onSubmitted: (String? value) {
                          controller.getPriceListByName();
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.dataAvailable &&
                        controller.filterCount.value == 1,
                    child: controller.dataAvailable
                        ? SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: controller.trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index, context),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item =
                              controller.productList[index].id.toString();
                          return FadeInDown(
                            duration: Duration(milliseconds: 350 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Dismissible(
                                key: Key(item),
                                onDismissed: (direction) {
                                  controller.productList.removeWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          controller.productList[index].id
                                              .toString());
                                  controller.updateTotal();
                                  controller.updateCounter();
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              /* boxShadow: [BoxShadow(
                                                          spreadRadius: 0.5,
                                                          color: black.withOpacity(0.1),
                                                          blurRadius: 1
                                                        )], */
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Container(
                                                    width: 120,
                                                    height: 70,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/404.png"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              controller
                                                  .productList[index].name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "€ ${controller.productList[index].cost}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "x${controller.productList[index].qty}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Obx(() => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                Obx(
                                  () => Text(
                                    "€ ${controller.total.value}",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Location".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.bpLocationAvailable.value
                          ? DropdownButton(
                              value: controller.bpLocationId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.bpLocationId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.bpLocation.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Term".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pTermAvailable.value
                          ? DropdownButton(
                              value: controller.paymentTermId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentTermId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pTerms.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Rule".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pRuleAvailable.value
                          ? DropdownButton(
                              value: controller.paymentRuleId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentRuleId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pRules.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.value,
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Create Order".tr,
                              content: Text(
                                  "Are you sure you want to create the Order?"
                                      .tr),
                              buttonColor: kNotifColor,
                              textConfirm: "Create".tr,
                              textCancel: "Cancel".tr,
                              onConfirm: () {
                                controller.createSalesOrder();
                              });
                        },
                        child: Text('Confirm Order'.tr),
                      ),
                    ),
                  ),
                ),
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Column(children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(
                    () => StepProgressIndicator(
                      roundedEdges: const Radius.circular(10),
                      totalSteps: 4,
                      currentStep: controller.filterCount.value + 1,
                      size: 36,
                      onTap: (index) {
                        return () {
                          if (kDebugMode) {
                            print('$index pressed');
                          }
                        };
                      },
                      selectedColor: kNotifColor,
                      unselectedColor: Colors.grey,
                      customStep: (index, color, _) => color == kNotifColor
                          ? index == 0
                              ? Container(
                                  color: color,
                                  child: const Icon(
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
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
                                                          child: Obx(
                                                            () => Text(
                                                              '${controller.counter.value}',
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            )
                          : index == 0
                              ? Container(
                                  color: color,
                                  child: const Icon(
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
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
                                                          child: Obx(
                                                            () => Text(
                                                              '${controller.counter.value}',
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<BPRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .businessPartnerName.value),
                                    displayStringForOption:
                                        controller.displayStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            BPRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((BPRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (BPRecords selection) {
                                      controller.businessPartnerId =
                                          selection.id!;
                                      controller.priceListID =
                                          selection.mPriceListID!.id!;
                                      controller.getProductLists(
                                          selection.mPriceListID!.id!);
                                      controller.getPaymentTerms();
                                      controller.getLocationFromBP();
                                      controller.getSalesOrderDefaultValues();
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Document Type".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.docTypeFlag.value
                          ? DropdownButton(
                              value: controller.dropdownValue.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.dropdownValue.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.dropDownList.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.searchFieldController,
                        autofocus: true,
                        onSubmitted: (String? value) {
                          controller.getPriceListByName();
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.dataAvailable &&
                        controller.filterCount.value == 1,
                    child: controller.dataAvailable
                        ? SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              itemCount: controller.trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index, context),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item =
                              controller.productList[index].id.toString();
                          return FadeInDown(
                            duration: Duration(milliseconds: 350 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Dismissible(
                                key: Key(item),
                                onDismissed: (direction) {
                                  controller.productList.removeWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          controller.productList[index].id
                                              .toString());
                                  controller.updateTotal();
                                  controller.updateCounter();
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              /* boxShadow: [BoxShadow(
                                                          spreadRadius: 0.5,
                                                          color: black.withOpacity(0.1),
                                                          blurRadius: 1
                                                        )], */
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Container(
                                                    width: 120,
                                                    height: 70,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/404.png"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              controller
                                                  .productList[index].name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "€ ${controller.productList[index].cost}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "x${controller.productList[index].qty}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Obx(() => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                Obx(
                                  () => Text(
                                    "€ ${controller.total.value}",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Location".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.bpLocationAvailable.value
                          ? DropdownButton(
                              value: controller.bpLocationId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.bpLocationId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.bpLocation.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Term".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pTermAvailable.value
                          ? DropdownButton(
                              value: controller.paymentTermId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentTermId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pTerms.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Rule".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pRuleAvailable.value
                          ? DropdownButton(
                              value: controller.paymentRuleId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentRuleId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pRules.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.value,
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Create Order".tr,
                              content: Text(
                                  "Are you sure you want to create the Order?"
                                      .tr
                                      .tr),
                              buttonColor: kNotifColor,
                              textConfirm: "Create".tr,
                              textCancel: "Cancel".tr,
                              onConfirm: () {
                                controller.createSalesOrder();
                              });
                        },
                        child: Text('Confirm Order'.tr),
                      ),
                    ),
                  ),
                ),
              ]);
            },
            desktopBuilder: (context, constraints) {
              return Column(children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(
                    () => StepProgressIndicator(
                      roundedEdges: const Radius.circular(10),
                      totalSteps: 4,
                      currentStep: controller.filterCount.value + 1,
                      size: 36,
                      onTap: (index) {
                        return () {
                          if (kDebugMode) {
                            print('$index pressed');
                          }
                        };
                      },
                      selectedColor: kNotifColor,
                      unselectedColor: Colors.grey,
                      customStep: (index, color, _) => color == kNotifColor
                          ? index == 0
                              ? Container(
                                  color: color,
                                  child: const Icon(
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
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
                                                          child: Obx(
                                                            () => Text(
                                                              '${controller.counter.value}',
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            )
                          : index == 0
                              ? Container(
                                  color: color,
                                  child: const Icon(
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
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
                                                          child: Obx(
                                                            () => Text(
                                                              '${controller.counter.value}',
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<BPRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .businessPartnerName.value),
                                    displayStringForOption:
                                        controller.displayStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            BPRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((BPRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (BPRecords selection) {
                                      controller.businessPartnerId =
                                          selection.id!;
                                      controller.priceListID =
                                          selection.mPriceListID!.id!;
                                      controller.getProductLists(
                                          selection.mPriceListID!.id!);
                                      controller.getPaymentTerms();
                                      controller.getLocationFromBP();
                                      controller.getSalesOrderDefaultValues();
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Document Type".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.docTypeFlag.value
                          ? DropdownButton(
                              value: controller.dropdownValue.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.dropdownValue.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.dropDownList.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.searchFieldController,
                        autofocus: true,
                        onSubmitted: (String? value) {
                          controller.getPriceListByName();
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.dataAvailable &&
                        controller.filterCount.value == 1,
                    child: controller.dataAvailable
                        ? SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: controller.trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index, context),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item =
                              controller.productList[index].id.toString();
                          return FadeInDown(
                            duration: Duration(milliseconds: 350 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Dismissible(
                                key: Key(item),
                                onDismissed: (direction) {
                                  controller.productList.removeWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          controller.productList[index].id
                                              .toString());
                                  controller.updateTotal();
                                  controller.updateCounter();
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              /* boxShadow: [BoxShadow(
                                                          spreadRadius: 0.5,
                                                          color: black.withOpacity(0.1),
                                                          blurRadius: 1
                                                        )], */
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Container(
                                                    width: 120,
                                                    height: 70,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/404.png"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              controller
                                                  .productList[index].name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "€ ${controller.productList[index].cost}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "x${controller.productList[index].qty}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Obx(() => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                Obx(
                                  () => Text(
                                    "€ ${controller.total.value}",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Location".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.bpLocationAvailable.value
                          ? DropdownButton(
                              value: controller.bpLocationId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.bpLocationId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.bpLocation.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Term".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pTermAvailable.value
                          ? DropdownButton(
                              value: controller.paymentTermId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentTermId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pTerms.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Rule".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pRuleAvailable.value
                          ? DropdownButton(
                              value: controller.paymentRuleId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentRuleId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pRules.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.value,
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Create Order".tr,
                              content: Text(
                                  "Are you sure you want to create the Order?"
                                      .tr),
                              buttonColor: kNotifColor,
                              textConfirm: "Create".tr,
                              textCancel: "Cancel".tr,
                              onConfirm: () {
                                controller.createSalesOrder();
                              });
                        },
                        child: Text('Confirm Order'.tr),
                      ),
                    ),
                  ),
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

  Widget buildImageCard(int index, BuildContext context) => GestureDetector(
        onTap: () {
          controller.qtyMultiplierController.text = "1";
          controller.qtyMinFieldController.text =
              controller._trx.records![index].qtyBatchSize.toString();
          controller.qtyFieldController.text =
              controller._trx.records![index].qtyBatchSize.toString();

          controller.descriptionFieldController.text = '';
          Get.defaultDialog(
              title: controller._trx.records![index].name ?? "N/A",
              content: Column(
                children: [
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: controller.descriptionFieldController,
                      minLines: 2,
                      maxLines: 4,
                      //onTap: () {},
                      //onSubmitted: (String? value) {},
                      decoration: InputDecoration(
                        hintText: 'Description..'.tr,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          readOnly: true,
                          textAlign: TextAlign.center,
                          controller: controller.qtyMinFieldController,
                          autofocus: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          //onTap: () {},
                          //onSubmitted: (String? value) {},
                          decoration: InputDecoration(
                            prefixText: controller._trx.records![index].uom,
                            labelStyle: const TextStyle(color: Colors.white),
                            labelText: "${"Qty".tr} Min.",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            isDense: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: controller.qtyMultiplierController,
                          autofocus: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          onChanged: (value) {
                            if (double.tryParse(value) != null) {
                              controller.qtyFieldController.text =
                                  (double.parse(controller
                                              .qtyMinFieldController.text) *
                                          double.parse(controller
                                              .qtyMultiplierController.text))
                                      .toString();
                            } else {
                              controller.qtyFieldController.text = controller
                                  ._trx.records![index].qtyBatchSize
                                  .toString();
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            labelText: "${"Qty".tr} Acq.",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            isDense: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 180,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      readOnly: true,
                      textAlign: TextAlign.center,
                      controller: controller.qtyFieldController,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                      //onTap: () {},
                      //onSubmitted: (String? value) {},
                      decoration: InputDecoration(
                        prefixText: controller._trx.records![index].uom,
                        labelStyle: const TextStyle(color: Colors.white),
                        labelText: "Tot Qty".tr,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ],
              ),
              textConfirm: 'Add'.tr,
              onConfirm: () {
                if (controller.qtyFieldController.text != '0' &&
                    controller.qtyFieldController.text != '') {
                  controller.productList.add(ProductCheckout2(
                      id: controller._trx.records![index].mProductID!.id!,
                      name: controller
                          ._trx.records![index].mProductID!.identifier!,
                      qty: double.parse(controller.qtyFieldController.text),
                      cost: controller._trx.records![index].priceList ?? 0.0,
                      description:
                          controller.descriptionFieldController.text != ''
                              ? controller.descriptionFieldController.text
                              : null));
                  controller.updateCounter();
                  controller.updateTotal();
                }

                Get.back();
              });
        },
        child: Card(
          color: const Color.fromRGBO(64, 75, 96, .9),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: controller._trx.records![index].imageData != null
                      ? Image.memory(
                          const Base64Codec().decode(
                              (controller._trx.records![index].imageData!)
                                  .replaceAll(RegExp(r'\n'), '')),
                          fit: BoxFit.cover,
                        )
                      : controller._trx.records![index].imageUrl != null
                          ? Image.network(
                              controller._trx.records![index].imageUrl!)
                          : const SizedBox(),
                ),
              ),
              ListTile(
                title: Text(
                  controller._trx.records![index].name!.tr,
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "  ${controller._trx.records![index].cCurrencyID?.identifier ?? "?"} ${controller._trx.records![index].priceList}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "${"Last Order".tr}: ${controller._trx.records![index].lastdateOrdered ?? "N/A".tr}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${controller._trx.records![index].qtyOnHand == null || controller._trx.records![index].qtyOnHand == 0 ? "" : "Availability:".tr} ${controller._trx.records![index].qtyOnHand == null || controller._trx.records![index].qtyOnHand == 0 ? "Not Available".tr : controller._trx.records![index].qtyOnHand}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    controller._trx.records![index].qtyOnHand ==
                                                null ||
                                            controller._trx.records![index]
                                                    .qtyOnHand ==
                                                0
                                        ? Colors.red
                                        : kNotifColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

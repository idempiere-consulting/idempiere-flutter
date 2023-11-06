// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/lead.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_create_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_edit_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_create_tasks.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_filters_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/salestagejson.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Price_List/models/price_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/models/product_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_detail.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/doctype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/businesspartner_location_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_term_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/productcheckout.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/salesorder_defaults_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_order_From_Pricelist/models/pricelist_tablerow_json.dart';
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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/portal_mp_sales_order_from_pricelist_binding.dart';

// controller
part '../../controllers/portal_mp_sales_order_from_pricelist_controller.dart';

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

class PortalMpSalesOrderFromPriceListScreen
    extends GetView<PortalMpSalesOrderFromPriceListController> {
  const PortalMpSalesOrderFromPriceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            controller.getPriceList();
                          },
                          child: Row(
                            children: [
                              //Icon(Icons.filter_alt),
                              Obx(() => controller.dataAvailable.value
                                  ? Text("PRODUCTS: ".tr +
                                      controller._trx.rowcount.toString())
                                  : Text("PRODUCTS: ".tr)),
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
                              controller.getPriceList();
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
                              controller.getPriceList();
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
                label: controller.isListShown.value ? 'Checkout' : 'Back'.tr,
                child: Obx(
                  () => Icon(
                    controller.isListShown.value
                        ? MaterialSymbols.shopping_bag
                        : MaterialSymbols.chevron_left,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  controller.isListShown.value = !controller.isListShown.value;
                }),
            SpeedDialChild(
                label: 'Search Product\nfrom outside\nthe Price List'.tr,
                child: Obx(
                  () => Icon(
                    controller.allProdToggle.value
                        ? MaterialSymbols.toggle_on
                        : MaterialSymbols.toggle_off,
                    color: controller.allProdToggle.value
                        ? kNotifColor
                        : Colors.white,
                  ),
                ),
                onTap: () {
                  controller.allProdToggle.value =
                      !controller.allProdToggle.value;
                  controller.getPriceList();
                }),
          ],
        ),

        //key: controller.scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sales Order Creation'.tr),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Obx(() => Visibility(
                  visible: controller.isListShown.value == false,
                  child: IconButton(
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
                      icon: const Icon(Icons.save)),
                )),
          ],
        ),

        body: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(children: [
                Visibility(
                  visible: controller.isListShown.value,
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
                Obx(
                  () => Visibility(
                    visible: controller.isListShown.value,
                    child: Obx(
                      () => controller.dataAvailable.value
                          ? SizedBox(
                              height: size.height,
                              width: double.infinity,
                              child: MasonryGridView.count(
                                shrinkWrap: true,
                                itemCount: controller._trx.records?.length ?? 0,
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                itemBuilder: (context, index) {
                                  return buildImageCard(index, context);
                                },
                              ))
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isListShown.value == false,
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
                                              controller.productList[index]
                                                          .name ==
                                                      "."
                                                  ? "Descriptive Row".tr
                                                  : controller
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
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "${controller.productList[index].qty} ${controller.productList[index].uom}   *",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "€ ${controller.productList[index].cost}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    '${"Total row".tr} € ${controller.productList[index].qty * controller.productList[index].cost}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      visible: controller.isListShown.value == false,
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
                                Text(
                                  "Total".tr,
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
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Column(children: [
                Visibility(
                  visible: controller.isListShown.value,
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
                Obx(
                  () => Visibility(
                    visible: controller.isListShown.value,
                    child: Obx(
                      () => controller.dataAvailable.value
                          ? SizedBox(
                              height: size.height,
                              width: double.infinity,
                              child: MasonryGridView.count(
                                shrinkWrap: true,
                                itemCount: controller._trx.records?.length ?? 0,
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                itemBuilder: (context, index) {
                                  return buildImageCard(index, context);
                                },
                              ))
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isListShown.value == false,
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
                                              controller.productList[index]
                                                          .name ==
                                                      "."
                                                  ? "Descriptive Row".tr
                                                  : controller
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
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "${controller.productList[index].qty} ${controller.productList[index].uom}   *",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "€ ${controller.productList[index].cost}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    '${"Total row".tr} € ${controller.productList[index].qty * controller.productList[index].cost}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      visible: controller.isListShown.value == false,
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
                                Text(
                                  "Total".tr,
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
              ]);
            },
            desktopBuilder: (context, constraints) {
              return Column(children: [
                Visibility(
                  visible: controller.isListShown.value,
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
                Obx(
                  () => Visibility(
                    visible: controller.isListShown.value,
                    child: Obx(
                      () => controller.dataAvailable.value
                          ? SizedBox(
                              height: size.height,
                              width: double.infinity,
                              child: MasonryGridView.count(
                                shrinkWrap: true,
                                itemCount: controller._trx.records?.length ?? 0,
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                itemBuilder: (context, index) {
                                  return buildImageCard(index, context);
                                },
                              ))
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isListShown.value == false,
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
                                              controller.productList[index]
                                                          .name ==
                                                      "."
                                                  ? "Descriptive Row".tr
                                                  : controller
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
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "${controller.productList[index].qty} ${controller.productList[index].uom}   *",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "€ ${controller.productList[index].cost}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    '${"Total row".tr} € ${controller.productList[index].qty * controller.productList[index].cost}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      visible: controller.isListShown.value == false,
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
                                Text(
                                  "Total".tr,
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
                        labelText: 'Nota Prodotto',
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
                              : null,
                      uom: controller._trx.records![index].uom));
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );

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

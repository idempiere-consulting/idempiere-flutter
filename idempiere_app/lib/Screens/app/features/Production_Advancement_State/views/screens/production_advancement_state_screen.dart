// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/lead.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_create_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_edit_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_create_tasks.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_filters_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/salestagejson.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Course_Quiz/models/resource_json.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/models/doc_attachments_json.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_image.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/models/attachment_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order_B2B/views/screens/portal_mp_sales_order_b2b_screen.dart';
import 'package:idempiere_app/Screens/app/features/Production_Advancement_State/models/locator_json.dart';
import 'package:idempiere_app/Screens/app/features/Production_Advancement_State/models/ppcostcollector_json.dart';
import 'package:idempiere_app/Screens/app/features/Production_Advancement_State/models/productionline_json.dart';
import 'package:idempiere_app/Screens/app/features/Production_Advancement_State/models/workflownode_json.dart';
import 'package:idempiere_app/Screens/app/features/Production_Order/models/productionorder_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload/models/loadunloadjson.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload_Line/models/loadunloadjsonline.dart';
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
import 'package:pdf/pdf.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/production_advancement_state_binding.dart';

// controller
part '../../controllers/production_advancement_state_controller.dart';

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

class ProductionAdvancementStateScreen
    extends GetView<ProductionAdvancementStateController> {
  const ProductionAdvancementStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        drawer: (ResponsiveBuilder.isDesktop(context))
            ? null
            : Drawer(
                child: Padding(
                  padding: const EdgeInsets.only(top: kSpacing),
                  child: _Sidebar(data: controller.getSelectedProject()),
                ),
              ),
        body: BarcodeKeyboardListener(
          bufferDuration: const Duration(milliseconds: 200),
          onBarcodeScanned: (barcode) {
            print(barcode.replaceAll(RegExp(r'-'), "/"));
            controller
                .getProductionOrder(barcode.replaceAll(RegExp(r'-'), "/"));
          },
          child: SingleChildScrollView(
            child: ResponsiveBuilder(
              mobileBuilder: (context, constraints) {
                return Column(children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: controller.getAllResources(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<RRecords>(
                                  direction: AxisDirection.down,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    onTap: () {
                                      controller.resourceFieldController.text =
                                          "";
                                    },
                                    onChanged: (value) {},
                                    controller:
                                        controller.resourceFieldController,
                                    //autofocus: true,

                                    decoration: InputDecoration(
                                      labelText: 'Resource'.tr,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: const Icon(EvaIcons.person),
                                      hintText: "search..",
                                      //isDense: true,
                                      fillColor: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return snapshot.data!.where((element) =>
                                        (element.name ?? "")
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      //leading: Icon(Icons.shopping_cart),
                                      title: Text(suggestion.name ?? ""),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    controller.resourceId = suggestion.id!;
                                    controller.resourceFieldController.text =
                                        suggestion.name!;
                                    if (controller.nodeId.value != "") {
                                      controller
                                          .searchPhase(controller.nodeId.value);
                                    }
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: controller.getAllProduction(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<POJRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<POJRecords>(
                                  direction: AxisDirection.down,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    onTap: () {
                                      controller
                                          .documentNoFieldController.text = "";
                                    },
                                    onChanged: (value) {},
                                    controller:
                                        controller.documentNoFieldController,
                                    //autofocus: true,

                                    decoration: InputDecoration(
                                      labelText: 'DocumentNo'.tr,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: const Icon(EvaIcons.search),
                                      hintText: "search..",
                                      //isDense: true,
                                      fillColor: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return snapshot.data!.where((element) =>
                                        (element.documentNo ?? "")
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      //leading: Icon(Icons.shopping_cart),
                                      title: Text(suggestion.documentNo ?? ""),
                                      subtitle: Text(
                                          suggestion.cbPartnerID?.identifier ??
                                              ""),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    controller.getProductionOrder(
                                        suggestion.documentNo!.toLowerCase());
                                    controller.documentNoFieldController.text =
                                        suggestion.documentNo!;
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                  /* Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
                      controller: controller.documentNoFieldController,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.text_fields),
                        border: const OutlineInputBorder(),
                        labelText: 'DocumentNo'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onSubmitted: (value) {
                        controller.getProductionOrder(value.toLowerCase());
                      },
                    ),
                  ), */
                  Obx(
                    () => Visibility(
                      replacement: SizedBox(),
                      visible: controller._nodeListdataAvailable.value,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 10, bottom: 10, right: 10),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Phase'.tr,
                            //filled: true,
                            border: const OutlineInputBorder(
                                /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                ),
                            prefixIcon: const Icon(EvaIcons.list),
                            //hintText: "search..",
                            isDense: true,
                            //fillColor: Theme.of(context).cardColor,
                          ),
                          child: DropdownButton(
                            isDense: true,
                            underline: const SizedBox(),
                            hint: Text("Select a Phase".tr),
                            isExpanded: true,
                            value: controller.nodeId.value == ""
                                ? null
                                : controller.nodeId.value,
                            elevation: 16,
                            onChanged: (newValue) {
                              controller.nodeId.value = newValue as String;

                              controller.advancementStatusDateStart.value = "";
                              controller.phaseDuration.value = 0.0;
                              controller.advancementStatusID = 0;
                              controller.phaseStatus.value = "";

                              controller.searchPhase(controller.nodeId.value);

                              //print(dropdownValue);
                            },
                            items: controller.nodeList.records!.map((list) {
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
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => controller._dataAvailable.value
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller._trx.records?[0]
                                                  .documentNo ??
                                              "N/A",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${"Qty".tr}: ${controller._trx.records?[0].productionQty ?? 0.0}",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${"CDL".tr}: ",
                                        ),
                                        Text(
                                          "${"Qty Prod".tr}: ${controller._trx.records?[0].actualQty ?? 0}",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${"Product".tr}: ${controller._trx.records?[0].mProductID?.identifier}",
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(
                                  () => Visibility(
                                    replacement: ElevatedButton(
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        // If the button is pressed, return green, otherwise blue

                                        return Colors.grey;
                                      })),
                                      onPressed: () {},
                                      child: Text(
                                        "Start",
                                      ),
                                    ),
                                    visible:
                                        controller.phaseStatus.value == "START",
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        // If the button is pressed, return green, otherwise blue

                                        return kNotifColor;
                                      })),
                                      onPressed: () {
                                        controller
                                            .createAdvancementStateRecord();
                                      },
                                      child: Text(
                                        "Start",
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    replacement: ElevatedButton(
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        // If the button is pressed, return green, otherwise blue

                                        return Colors.grey;
                                      })),
                                      onPressed: () {},
                                      child: Text(
                                        "Stop",
                                      ),
                                    ),
                                    visible:
                                        controller.phaseStatus.value == "STOP",
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        // If the button is pressed, return green, otherwise blue

                                        return kNotifColor;
                                      })),
                                      onPressed: () {
                                        controller.editAdvancementStateRecord();
                                      },
                                      child: Text(
                                        "Stop",
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    replacement: ElevatedButton(
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        // If the button is pressed, return green, otherwise blue

                                        return Colors.grey;
                                      })),
                                      onPressed: () {},
                                      child: Text(
                                        "Start/Stop",
                                      ),
                                    ),
                                    visible:
                                        controller.phaseStatus.value == "START",
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        // If the button is pressed, return green, otherwise blue

                                        return kNotifColor;
                                      })),
                                      onPressed: () {
                                        controller.hoursFieldController.text =
                                            "";
                                        Get.defaultDialog(
                                          title: 'Hours Done'.tr,
                                          onConfirm: () {
                                            controller
                                                .createAdvancementStateRecordByStartStopButton();
                                          },
                                          content: Column(
                                            children: [
                                              TextField(
                                                autofocus: true,
                                                controller: controller
                                                    .hoursFieldController,
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp("[0-9.]"))
                                                ],
                                                decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                      Icons.timelapse),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Hours'.tr,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Start/Stop",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Visibility(
                                  visible: controller
                                          .advancementStatusDateStart.value !=
                                      "",
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "START   ",
                                      ),
                                      Text(
                                        controller.advancementStatusDateStart
                                                    .value !=
                                                ""
                                            ? DateFormat('dd-MM-yyyy  kk:mm')
                                                .format(DateTime.parse(controller
                                                    .advancementStatusDateStart
                                                    .value))
                                            : "",
                                      ),
                                    ],
                                  )),
                            ),
                            Obx(
                              () => Visibility(
                                  visible: controller.advancementStatusDateStart
                                              .value !=
                                          "" &&
                                      controller.phaseDuration.value != 0.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "STOP   ",
                                      ),
                                      Text(
                                        controller.advancementStatusDateStart
                                                        .value !=
                                                    "" &&
                                                controller
                                                        .phaseDuration.value !=
                                                    0.0
                                            ? DateFormat('dd-MM-yyyy  kk:mm')
                                                .format(DateTime.parse(controller
                                                        .advancementStatusDateStart
                                                        .value)
                                                    .add(Duration(
                                                        minutes: (controller
                                                                    .phaseDuration
                                                                    .value *
                                                                60)
                                                            .toInt())))
                                            : "",
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue

                                return kNotifColor;
                              })),
                              onPressed: () {
                                controller.unloadProductFieldController.text =
                                    "";
                                controller.unloadQtyFieldController.text = "1";
                                controller.unloadProductId = 0;
                                controller.noteFieldController.text = "";
                                controller.widthFieldController.text = "";
                                controller.heightFieldController.text = "";
                                controller.widthFieldController.text = "";
                                controller.lengthFieldController.text = "";
                                Get.defaultDialog(
                                  title: 'Add Material'.tr,
                                  textConfirm: 'Confirm'.tr,
                                  onConfirm: () {
                                    controller.createProductionLine();
                                  },
                                  content: Column(
                                    children: [
                                      FutureBuilder(
                                        future: controller.getAllProducts(),
                                        builder: (BuildContext ctx,
                                                AsyncSnapshot<List<PRecords>>
                                                    snapshot) =>
                                            snapshot.hasData
                                                ? TypeAheadField<PRecords>(
                                                    direction: AxisDirection.up,
                                                    //getImmediateSuggestions: true,
                                                    textFieldConfiguration:
                                                        TextFieldConfiguration(
                                                      onChanged: (value) {
                                                        if (value == "") {
                                                          controller
                                                              .unloadProductId = 0;
                                                        }
                                                      },
                                                      controller: controller
                                                          .unloadProductFieldController,
                                                      //autofocus: true,

                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Product'.tr,
                                                        //filled: true,
                                                        border: const OutlineInputBorder(
                                                            /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                                                            ),
                                                        prefixIcon: const Icon(
                                                            EvaIcons.search),
                                                        //hintText: "search..",
                                                        isDense: true,
                                                        //fillColor: Theme.of(context).cardColor,
                                                      ),
                                                    ),
                                                    suggestionsCallback:
                                                        (pattern) async {
                                                      return snapshot.data!
                                                          .where((element) =>
                                                              ("${element.value}_${element.name}")
                                                                  .toLowerCase()
                                                                  .contains(pattern
                                                                      .toLowerCase()));
                                                    },
                                                    itemBuilder:
                                                        (context, suggestion) {
                                                      return ListTile(
                                                        //leading: Icon(Icons.shopping_cart),
                                                        title: Text(
                                                            suggestion.name ??
                                                                ""),
                                                        subtitle: Text(
                                                            suggestion.value ??
                                                                ""),
                                                      );
                                                    },
                                                    onSuggestionSelected:
                                                        (suggestion) {
                                                      controller
                                                          .unloadProductFieldController
                                                          .text = suggestion.name!;
                                                      controller
                                                              .unloadProductId =
                                                          suggestion.id!;
                                                    },
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        //focusNode: focusNode,
                                        controller:
                                            controller.unloadQtyFieldController,
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
                                            signed: true, decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9.-]"))
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Symbols.dialpad),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Quantity'.tr,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        //focusNode: focusNode,
                                        controller:
                                            controller.noteFieldController,

                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.text_fields),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Note'.tr,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        //focusNode: focusNode,
                                        controller:
                                            controller.widthFieldController,
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
                                            signed: true, decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]"))
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.square_foot),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Width'.tr,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        //focusNode: focusNode,
                                        controller:
                                            controller.heightFieldController,
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
                                            signed: true, decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]"))
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.square_foot),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Height'.tr,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        //focusNode: focusNode,
                                        controller:
                                            controller.lengthFieldController,
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
                                            signed: true, decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]"))
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.square_foot),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Length'.tr,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Symbols.add),
                                  Text(
                                    "Add Material".tr,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 400,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Production Components".tr,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        var search = controller
                                            .prodRowList.records!
                                            .where((element) =>
                                                element.mInventoryLineID?.id !=
                                                null);
                                        if (search.isNotEmpty) {
                                          controller.getInventoryByLineID(search
                                              .first.mInventoryLineID!.id!);
                                        } else {
                                          controller.createInventory();
                                        }
                                      },
                                      icon: Icon(Icons.get_app_sharp))
                                ],
                              ),
                            ),
                            Divider(),
                            Obx(
                              () => Visibility(
                                visible:
                                    controller._prodLinedataAvailable.value,
                                child: Expanded(
                                  child: ListView.builder(
                                      itemCount: controller
                                          .prodRowList.records!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    64, 75, 96, .9)),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: kSpacing),
                                              title: Text(controller
                                                      .prodRowList
                                                      .records![index]
                                                      .mProductID
                                                      ?.identifier ??
                                                  "N/A"),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Visibility(
                                                    visible: controller
                                                                .prodRowList
                                                                .records![index]
                                                                .width !=
                                                            null &&
                                                        controller
                                                                .prodRowList
                                                                .records![index]
                                                                .height !=
                                                            null &&
                                                        controller
                                                                .prodRowList
                                                                .records![index]
                                                                .length !=
                                                            null,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            "${"Volume".tr}: ${controller.prodRowList.records![index].width}x${controller.prodRowList.records![index].height}x${controller.prodRowList.records![index].length}"),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "${"Qty Planned".tr}: ${controller.prodRowList.records![index].plannedQty}"),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "${"Qty Used".tr}: ${controller.prodRowList.records![index].qtyUsed}"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: controller
                                                          .prodRowList
                                                          .records![index]
                                                          .mInventoryLineID
                                                          ?.id ==
                                                      null
                                                  ? Icon(
                                                      Icons.warehouse_sharp,
                                                      color: Colors.yellow,
                                                    )
                                                  : Icon(
                                                      Icons.check,
                                                      color: kNotifColor,
                                                    ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]);
              },
              tabletBuilder: (context, constraints) {
                return Column(children: []);
              },
              desktopBuilder: (context, constraints) {
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        child: StaggeredGrid.count(
                          crossAxisCount: 20,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 2,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 10,
                              mainAxisCellCount: 1,
                              child: SizedBox(
                                child: Card(
                                  child: Row(
                                    children: [
                                      FutureBuilder(
                                        future: controller.getAllResources(),
                                        builder: (BuildContext ctx,
                                                AsyncSnapshot<List<RRecords>>
                                                    snapshot) =>
                                            snapshot.hasData
                                                ? Expanded(
                                                    child: TypeAheadField<
                                                        RRecords>(
                                                      direction:
                                                          AxisDirection.down,
                                                      //getImmediateSuggestions: true,
                                                      textFieldConfiguration:
                                                          TextFieldConfiguration(
                                                        onTap: () {
                                                          controller
                                                              .resourceFieldController
                                                              .text = "";
                                                        },
                                                        onChanged: (value) {},
                                                        controller: controller
                                                            .resourceFieldController,
                                                        //autofocus: true,

                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Resource'.tr,
                                                          filled: true,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          prefixIcon:
                                                              const Icon(
                                                                  EvaIcons
                                                                      .person),
                                                          hintText: "search..",
                                                          //isDense: true,
                                                          fillColor:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                        ),
                                                      ),
                                                      suggestionsCallback:
                                                          (pattern) async {
                                                        return snapshot.data!.where(
                                                            (element) => (element
                                                                        .name ??
                                                                    "")
                                                                .toLowerCase()
                                                                .contains(pattern
                                                                    .toLowerCase()));
                                                      },
                                                      itemBuilder: (context,
                                                          suggestion) {
                                                        return ListTile(
                                                          //leading: Icon(Icons.shopping_cart),
                                                          title: Text(
                                                              suggestion.name ??
                                                                  ""),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) {
                                                        controller.resourceId =
                                                            suggestion.id!;
                                                        controller
                                                                .resourceFieldController
                                                                .text =
                                                            suggestion.name!;
                                                        if (controller
                                                                .nodeId.value !=
                                                            "") {
                                                          controller
                                                              .searchPhase(
                                                                  controller
                                                                      .nodeId
                                                                      .value);
                                                        }
                                                      },
                                                    ),
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1,
                              child: SizedBox(
                                child: Card(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Symbols.search)),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1,
                              child: SizedBox(
                                child: Card(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Symbols.search)),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1,
                              child: SizedBox(),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: SizedBox(
                                child: Card(
                                  child: Row(
                                    children: [
                                      FutureBuilder(
                                        future: controller.getAllProduction(),
                                        builder: (BuildContext ctx,
                                                AsyncSnapshot<List<POJRecords>>
                                                    snapshot) =>
                                            snapshot.hasData
                                                ? Expanded(
                                                    child: TypeAheadField<
                                                        POJRecords>(
                                                      direction:
                                                          AxisDirection.down,
                                                      //getImmediateSuggestions: true,
                                                      textFieldConfiguration:
                                                          TextFieldConfiguration(
                                                        onTap: () {
                                                          controller
                                                              .documentNoFieldController
                                                              .text = "";
                                                        },
                                                        onChanged: (value) {},
                                                        controller: controller
                                                            .documentNoFieldController,
                                                        //autofocus: true,

                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'DocumentNo'.tr,
                                                          filled: true,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          prefixIcon:
                                                              const Icon(
                                                                  EvaIcons
                                                                      .search),
                                                          hintText: "search..",
                                                          //isDense: true,
                                                          fillColor:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                        ),
                                                      ),
                                                      suggestionsCallback:
                                                          (pattern) async {
                                                        return snapshot.data!.where(
                                                            (element) => (element
                                                                        .documentNo ??
                                                                    "")
                                                                .toLowerCase()
                                                                .contains(pattern
                                                                    .toLowerCase()));
                                                      },
                                                      itemBuilder: (context,
                                                          suggestion) {
                                                        return ListTile(
                                                          //leading: Icon(Icons.shopping_cart),
                                                          title: Text(suggestion
                                                                  .documentNo ??
                                                              ""),
                                                          subtitle: Text(suggestion
                                                                  .cbPartnerID
                                                                  ?.identifier ??
                                                              ""),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) {
                                                        controller
                                                            .getProductionOrder(
                                                                suggestion
                                                                    .documentNo!
                                                                    .toLowerCase());
                                                        controller
                                                                .documentNoFieldController
                                                                .text =
                                                            suggestion
                                                                .documentNo!;
                                                      },
                                                    ),
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: SizedBox(
                                child: Card(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Symbols.search)),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                                crossAxisCellCount: 11,
                                mainAxisCellCount: 1,
                                child: Obx(
                                  () => Visibility(
                                    replacement: Card(),
                                    visible:
                                        controller._nodeListdataAvailable.value,
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Phase'.tr,
                                        //filled: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.list),
                                        //hintText: "search..",
                                        isDense: true,
                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                      child: DropdownButton(
                                        isDense: true,
                                        underline: const SizedBox(),
                                        hint: Text("Select a Phase".tr),
                                        isExpanded: true,
                                        value: controller.nodeId.value == ""
                                            ? null
                                            : controller.nodeId.value,
                                        elevation: 16,
                                        onChanged: (newValue) {
                                          controller.nodeId.value =
                                              newValue as String;

                                          controller.advancementStatusDateStart
                                              .value = "";
                                          controller.phaseDuration.value = 0.0;
                                          controller.advancementStatusID = 0;
                                          controller.phaseStatus.value = "";

                                          controller.searchPhase(
                                              controller.nodeId.value);

                                          //print(dropdownValue);
                                        },
                                        items: controller.nodeList.records!
                                            .map((list) {
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
                                )),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 9,
                              mainAxisCellCount: 4,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(
                                            () => Visibility(
                                              replacement: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                  // If the button is pressed, return green, otherwise blue

                                                  return Colors.grey;
                                                })),
                                                onPressed: () {},
                                                child: Text("Start",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                              ),
                                              visible: controller
                                                      .phaseStatus.value ==
                                                  "START",
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                  // If the button is pressed, return green, otherwise blue

                                                  return kNotifColor;
                                                })),
                                                onPressed: () {
                                                  controller
                                                      .createAdvancementStateRecord();
                                                },
                                                child: Text("Start",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => Visibility(
                                              replacement: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                  // If the button is pressed, return green, otherwise blue

                                                  return Colors.grey;
                                                })),
                                                onPressed: () {},
                                                child: Text(
                                                  "Stop",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                              visible: controller
                                                      .phaseStatus.value ==
                                                  "STOP",
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                  // If the button is pressed, return green, otherwise blue

                                                  return kNotifColor;
                                                })),
                                                onPressed: () {
                                                  controller
                                                      .editAdvancementStateRecord();
                                                },
                                                child: Text(
                                                  "Stop",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => Visibility(
                                              replacement: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                  // If the button is pressed, return green, otherwise blue

                                                  return Colors.grey;
                                                })),
                                                onPressed: () {},
                                                child: Text(
                                                  "Start/Stop",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                              visible: controller
                                                      .phaseStatus.value ==
                                                  "START",
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                  // If the button is pressed, return green, otherwise blue

                                                  return kNotifColor;
                                                })),
                                                onPressed: () {
                                                  controller
                                                      .hoursFieldController
                                                      .text = "";
                                                  Get.defaultDialog(
                                                    title: 'Hours Done'.tr,
                                                    onConfirm: () {
                                                      controller
                                                          .createAdvancementStateRecordByStartStopButton();
                                                    },
                                                    content: Column(
                                                      children: [
                                                        TextField(
                                                          autofocus: true,
                                                          controller: controller
                                                              .hoursFieldController,
                                                          keyboardType:
                                                              const TextInputType
                                                                      .numberWithOptions(
                                                                  signed: true,
                                                                  decimal:
                                                                      true),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    "[0-9.]"))
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon:
                                                                const Icon(Icons
                                                                    .timelapse),
                                                            border:
                                                                const OutlineInputBorder(),
                                                            labelText:
                                                                'Hours'.tr,
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .always,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Start/Stop",
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () => Visibility(
                                            visible: controller
                                                    .advancementStatusDateStart
                                                    .value !=
                                                "",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("START   ",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                Text(
                                                    controller.advancementStatusDateStart
                                                                .value !=
                                                            ""
                                                        ? DateFormat(
                                                                'dd-MM-yyyy  kk:mm')
                                                            .format(DateTime
                                                                .parse(controller
                                                                    .advancementStatusDateStart
                                                                    .value))
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                              ],
                                            )),
                                      ),
                                      Obx(
                                        () => Visibility(
                                            visible: controller
                                                        .advancementStatusDateStart
                                                        .value !=
                                                    "" &&
                                                controller
                                                        .phaseDuration.value !=
                                                    0.0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("STOP   ",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                Text(
                                                    controller.advancementStatusDateStart
                                                                    .value !=
                                                                "" &&
                                                            controller
                                                                    .phaseDuration
                                                                    .value !=
                                                                0.0
                                                        ? DateFormat('dd-MM-yyyy  kk:mm')
                                                            .format(DateTime.parse(
                                                                    controller
                                                                        .advancementStatusDateStart
                                                                        .value)
                                                                .add(Duration(
                                                                    minutes: (controller.phaseDuration.value * 60).toInt())))
                                                        : "",
                                                    style: TextStyle(fontSize: 25)),
                                              ],
                                            )),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          // If the button is pressed, return green, otherwise blue

                                          return kNotifColor;
                                        })),
                                        onPressed: () {
                                          controller
                                              .unloadProductFieldController
                                              .text = "";
                                          controller.unloadQtyFieldController
                                              .text = "1";
                                          controller.unloadProductId = 0;
                                          controller.noteFieldController.text =
                                              "";
                                          controller.widthFieldController.text =
                                              "";
                                          controller
                                              .heightFieldController.text = "";
                                          controller.widthFieldController.text =
                                              "";
                                          controller
                                              .lengthFieldController.text = "";
                                          Get.defaultDialog(
                                            title: 'Add Material'.tr,
                                            textConfirm: 'Confirm'.tr,
                                            onConfirm: () {
                                              controller.createProductionLine();
                                            },
                                            content: Column(
                                              children: [
                                                FutureBuilder(
                                                  future: controller
                                                      .getAllProducts(),
                                                  builder: (BuildContext ctx,
                                                          AsyncSnapshot<
                                                                  List<
                                                                      PRecords>>
                                                              snapshot) =>
                                                      snapshot.hasData
                                                          ? TypeAheadField<
                                                              PRecords>(
                                                              direction:
                                                                  AxisDirection
                                                                      .up,
                                                              //getImmediateSuggestions: true,
                                                              textFieldConfiguration:
                                                                  TextFieldConfiguration(
                                                                onChanged:
                                                                    (value) {
                                                                  if (value ==
                                                                      "") {
                                                                    controller
                                                                        .unloadProductId = 0;
                                                                  }
                                                                },
                                                                controller:
                                                                    controller
                                                                        .unloadProductFieldController,
                                                                //autofocus: true,

                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Product'
                                                                          .tr,
                                                                  //filled: true,
                                                                  border: const OutlineInputBorder(
                                                                      /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                                                      ),
                                                                  prefixIcon:
                                                                      const Icon(
                                                                          EvaIcons
                                                                              .search),
                                                                  //hintText: "search..",
                                                                  isDense: true,
                                                                  //fillColor: Theme.of(context).cardColor,
                                                                ),
                                                              ),
                                                              suggestionsCallback:
                                                                  (pattern) async {
                                                                return snapshot
                                                                    .data!
                                                                    .where((element) => ("${element.value}_${element.name}")
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            pattern.toLowerCase()));
                                                              },
                                                              itemBuilder:
                                                                  (context,
                                                                      suggestion) {
                                                                return ListTile(
                                                                  //leading: Icon(Icons.shopping_cart),
                                                                  title: Text(
                                                                      suggestion
                                                                              .name ??
                                                                          ""),
                                                                  subtitle: Text(
                                                                      suggestion
                                                                              .value ??
                                                                          ""),
                                                                );
                                                              },
                                                              onSuggestionSelected:
                                                                  (suggestion) {
                                                                controller
                                                                        .unloadProductFieldController
                                                                        .text =
                                                                    suggestion
                                                                        .name!;
                                                                controller
                                                                        .unloadProductId =
                                                                    suggestion
                                                                        .id!;
                                                              },
                                                            )
                                                          : const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  //focusNode: focusNode,
                                                  controller: controller
                                                      .unloadQtyFieldController,
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          signed: true,
                                                          decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp("[0-9.-]"))
                                                  ],
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                        Symbols.dialpad),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Quantity'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  //focusNode: focusNode,
                                                  controller: controller
                                                      .noteFieldController,

                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                        Icons.text_fields),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Note'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  //focusNode: focusNode,
                                                  controller: controller
                                                      .widthFieldController,
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          signed: true,
                                                          decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp("[0-9]"))
                                                  ],
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                        Icons.square_foot),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Width'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  //focusNode: focusNode,
                                                  controller: controller
                                                      .heightFieldController,
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          signed: true,
                                                          decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp("[0-9]"))
                                                  ],
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                        Icons.square_foot),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Height'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  //focusNode: focusNode,
                                                  controller: controller
                                                      .lengthFieldController,
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          signed: true,
                                                          decimal: true),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp("[0-9]"))
                                                  ],
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                        Icons.square_foot),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Length'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Symbols.add),
                                            Text(
                                              "Add Material".tr,
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 11,
                              mainAxisCellCount: 3,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Obx(
                                    () => controller._dataAvailable.value
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller._trx.records?[0]
                                                            .documentNo ??
                                                        "N/A",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${"Qty".tr}: ${controller._trx.records?[0].productionQty ?? 0.0}",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${"CDL".tr}: ",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${"Qty Prod".tr}: ${controller._trx.records?[0].actualQty ?? 0}",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${"Product".tr}: ${controller._trx.records?[0].mProductID?.identifier}",
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 7,
                              mainAxisCellCount: 6,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Production Components".tr,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  var search = controller
                                                      .prodRowList.records!
                                                      .where((element) =>
                                                          element
                                                              .mInventoryLineID
                                                              ?.id !=
                                                          null);
                                                  if (search.isNotEmpty) {
                                                    controller
                                                        .getInventoryByLineID(
                                                            search
                                                                .first
                                                                .mInventoryLineID!
                                                                .id!);
                                                  } else {
                                                    controller
                                                        .createInventory();
                                                  }
                                                },
                                                icon: Icon(Icons.get_app_sharp))
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                              ._prodLinedataAvailable.value,
                                          child: Expanded(
                                            child: ListView.builder(
                                                itemCount: controller
                                                    .prodRowList
                                                    .records!
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Card(
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      64,
                                                                      75,
                                                                      96,
                                                                      .9)),
                                                      child: ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    kSpacing),
                                                        title: Text(controller
                                                                .prodRowList
                                                                .records![index]
                                                                .mProductID
                                                                ?.identifier ??
                                                            "N/A"),
                                                        subtitle: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Visibility(
                                                              visible: controller
                                                                          .prodRowList
                                                                          .records![
                                                                              index]
                                                                          .width !=
                                                                      null &&
                                                                  controller
                                                                          .prodRowList
                                                                          .records![
                                                                              index]
                                                                          .height !=
                                                                      null &&
                                                                  controller
                                                                          .prodRowList
                                                                          .records![
                                                                              index]
                                                                          .length !=
                                                                      null,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "${"Volume".tr}: ${controller.prodRowList.records![index].width}x${controller.prodRowList.records![index].height}x${controller.prodRowList.records![index].length}"),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    "${"Qty Planned".tr}: ${controller.prodRowList.records![index].plannedQty}"),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    "${"Qty Used".tr}: ${controller.prodRowList.records![index].qtyUsed}"),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        trailing: controller
                                                                    .prodRowList
                                                                    .records![
                                                                        index]
                                                                    .mInventoryLineID
                                                                    ?.id ==
                                                                null
                                                            ? Icon(
                                                                Icons
                                                                    .warehouse_sharp,
                                                                color: Colors
                                                                    .yellow,
                                                              )
                                                            : Icon(
                                                                Icons.check,
                                                                color:
                                                                    kNotifColor,
                                                              ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                                crossAxisCellCount: 7,
                                mainAxisCellCount: 6,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Summary".tr,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("All".tr))
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Obx(
                                          () =>
                                              controller.summaryAvailable.value
                                                  ? Expanded(
                                                      child: ListView.builder(
                                                          primary: false,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          shrinkWrap: true,
                                                          itemCount: controller
                                                              .summeryPhaseList
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              child: Card(
                                                                child:
                                                                    ExpansionTile(
                                                                  title: Text(
                                                                    controller
                                                                            .summeryPhaseList[
                                                                        index],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  childrenPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                  children: [
                                                                    ListView.builder(
                                                                        primary: false,
                                                                        scrollDirection: Axis.vertical,
                                                                        shrinkWrap: true,
                                                                        itemCount: controller.summaryPhase.records!.length,
                                                                        itemBuilder: (BuildContext context, int index2) {
                                                                          return controller.summeryPhaseListId[index] == controller.summaryPhase.records![index2].mProductionNodeID!.id!
                                                                              ? ListTile(
                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal: kSpacing),
                                                                                  leading: Text(
                                                                                    controller.summaryPhase.records![index2].docStatus!.id!,
                                                                                  ),
                                                                                  title: Text(
                                                                                    controller.summaryPhase.records![index2].sResourceID?.identifier ?? 'N/A',
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      color: kFontColorPallets[0],
                                                                                    ),
                                                                                  ),
                                                                                  subtitle: Text(
                                                                                    controller.summaryPhase.records![index2].movementDate!.substring(0, 10),
                                                                                    style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      color: kFontColorPallets[2],
                                                                                    ),
                                                                                  ),
                                                                                  trailing: Text('${controller.summaryPhase.records![index2].durationReal ?? 0} Ore'),
                                                                                )
                                                                              : const SizedBox();
                                                                        }),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  : SizedBox(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 6,
                              mainAxisCellCount: 6,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Images".tr,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Obx(
                                        () => controller
                                                .attachmentsAvailable.value
                                            ? Expanded(
                                                child: ListView.builder(
                                                    primary: false,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: controller
                                                        .attachments
                                                        .attachments!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  kBorderRadius),
                                                        ),
                                                        child: ListTile(
                                                          onTap: () async {
                                                            final ip =
                                                                GetStorage()
                                                                    .read('ip');
                                                            String
                                                                authorization =
                                                                'Bearer ${GetStorage().read('token')}';
                                                            final protocol =
                                                                GetStorage().read(
                                                                    'protocol');
                                                            var url = Uri.parse(
                                                                '$protocol://$ip/api/v1/models/m_production/1000001/attachments/${controller.attachments.attachments![index].name!}');
                                                            var response =
                                                                await http.get(
                                                              url,
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
                                                              if (controller
                                                                      .attachments
                                                                      .attachments![
                                                                          index]
                                                                      .contentType ==
                                                                  "application/pdf") {
                                                                final bytes =
                                                                    response
                                                                        .bodyBytes;

                                                                if (Platform
                                                                    .isAndroid) {
                                                                  await Printing.layoutPdf(
                                                                      onLayout: (PdfPageFormat
                                                                              format) async =>
                                                                          bytes);
                                                                } else {
                                                                  final dir =
                                                                      await getApplicationDocumentsDirectory();
                                                                  final file = File(
                                                                      '${dir.path}/${controller.attachments.attachments![index].name!}');
                                                                  await file
                                                                      .writeAsBytes(
                                                                          bytes,
                                                                          flush:
                                                                              true);
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          'file://${'${dir.path}/${controller.attachments.attachments![index].name!}'}'),
                                                                      mode: LaunchMode
                                                                          .externalNonBrowserApplication);
                                                                }
                                                              }

                                                              if (controller
                                                                      .attachments
                                                                      .attachments![
                                                                          index]
                                                                      .contentType ==
                                                                  "image/jpeg") {
                                                                var image64 =
                                                                    base64.encode(
                                                                        response
                                                                            .bodyBytes);
                                                                Get.to(
                                                                    const DeskDocAttachmentsImage(),
                                                                    arguments: {
                                                                      "base64":
                                                                          image64
                                                                    });
                                                              }
                                                            }
                                                          },
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      kSpacing),
                                                          title: Text(controller
                                                                  .attachments
                                                                  .attachments![
                                                                      index]
                                                                  .name ??
                                                              ""),
                                                          subtitle: Text(
                                                            controller
                                                                    .attachments
                                                                    .attachments![
                                                                        index]
                                                                    .contentType ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  kFontColorPallets[
                                                                      2],
                                                            ),
                                                          ),
                                                          leading: IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Symbols.image,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                          /* trailing: IconButton(
                                                                          onPressed: () {}, icon: Icon(Symbols.image)), */
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : SizedBox(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

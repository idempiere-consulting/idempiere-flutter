// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/models/invoice_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Invoice/models/portal_mp_invoice_line_json.dart';
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
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/portal_mp_invoice_binding.dart';

// controller
part '../../controllers/portal_mp_invoice_controller.dart';

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

class PortalMpInvoiceScreen extends GetView<PortalMpInvoiceController> {
  const PortalMpInvoiceScreen({Key? key}) : super(key: key);

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
            : */ Drawer(
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
                          ? Text("INVOICES: ".tr + controller.trx.rowcount.toString())
                          : Text("INVOICES: ".tr)),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateLead());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ), */
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getInvoices();
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
                          value: controller.invoiceDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.invoiceDropdownValue.value = newValue!;

                            //print(invoiceDropdownValue);
                          },
                          items: controller.invoiceDropDownList.map((list) {
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
                          controller: controller.invoiceSearchFieldController,
                          onSubmitted: (String? value) {
                            controller.invoiceSearchFilterValue.value =
                                controller.invoiceSearchFieldController.text;
                          },
                          decoration:  InputDecoration(
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
                                  visible: controller.invoiceSearchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.invoiceDropdownValue.value == "1"
                                          ? controller
                                              .trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .invoiceSearchFilterValue.value
                                                  .toLowerCase())
                                          : controller.invoiceDropdownValue.value ==
                                                  "2"
                                              ? controller.trx.records![index]
                                                  .dateInvoiced
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller
                                                      .invoiceSearchFilterValue.value
                                                      .toLowerCase())
                                              : controller.invoiceDropdownValue.value ==
                                                      "3"
                                                  ? controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID!
                                                      .identifier
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(controller.invoiceSearchFilterValue.value.toLowerCase())
                                                  : controller.invoiceDropdownValue.value == "4"
                                                      ? controller.trx.records![index].description.toString().toLowerCase().contains(controller.invoiceSearchFilterValue.value.toLowerCase())
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
                                              color: Colors.green,
                                            ),
                                            tooltip: 'Edit Invoice'.tr,
                                            onPressed: () {
                                              //log("info button pressed");
                                              /* Get.to(const EditLead(), arguments: {
                                            "id": controller
                                                .trx.records![index].id,
                                            "name": controller
                                                .trx.records![index].name,
                                            "leadStatus": controller
                                                    .trx
                                                    .records![index]
                                                    .Status
                                                    ?.id ??
                                                "",
                                            "bpName": controller
                                                .trx.records![index].bPName,
                                            "Tel": controller
                                                .trx.records![index].phone,
                                            "eMail": controller
                                                .trx.records![index].eMail,
                                            "salesRep": controller
                                                    .trx
                                                    .records![index]
                                                    .salesRepID
                                                    ?.identifier ??
                                                ""
                                          }); */
                                            },
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                        .trx
                                                        .records![index]
                                                        .docStatus
                                                        ?.id ==
                                                    "CO"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.offNamed('/PortalMpInvoiceLine',
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "docNo": controller
                                                      .trx
                                                      .records![index]
                                                      .documentNo,
                                                  "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "priceListId": controller
                                                      .trx
                                                      .records![index]
                                                      .mPriceListID,
                                                  "dateOrdered": controller
                                                      .trx
                                                      .records![index]
                                                      .dateInvoiced,
                                                });
                                          },
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo} Dt ${controller.trx.records![index].dateInvoiced}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Row(
                                          children: <Widget>[
                                            const Icon(Icons.linear_scale,
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
                                        /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */
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
                                                      "€${controller.trx.records![index].grandTotal}"),
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
                          ? Text("INVOICES: ".tr + controller.trx.rowcount.toString())
                          : Text("INVOICES: ".tr)),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateLead());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ), */
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getInvoices();
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
                          value: controller.invoiceDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.invoiceDropdownValue.value = newValue!;

                            //print(invoiceDropdownValue);
                          },
                          items: controller.invoiceDropDownList.map((list) {
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
                          controller: controller.invoiceSearchFieldController,
                          onSubmitted: (String? value) {
                            controller.invoiceSearchFilterValue.value =
                                controller.invoiceSearchFieldController.text;
                          },
                          decoration:  InputDecoration(
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
                                  visible: controller.invoiceSearchFilterValue.value ==
                                          ""
                                      ? true
                                      : controller.invoiceDropdownValue.value == "1"
                                          ? controller
                                              .trx.records![index].documentNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller
                                                  .invoiceSearchFilterValue.value
                                                  .toLowerCase())
                                          : controller.invoiceDropdownValue.value ==
                                                  "2"
                                              ? controller.trx.records![index]
                                                  .dateInvoiced
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller
                                                      .invoiceSearchFilterValue.value
                                                      .toLowerCase())
                                              : controller.invoiceDropdownValue.value ==
                                                      "3"
                                                  ? controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID!
                                                      .identifier
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(controller.invoiceSearchFilterValue.value.toLowerCase())
                                                  : controller.invoiceDropdownValue.value == "4"
                                                      ? controller.trx.records![index].description.toString().toLowerCase().contains(controller.invoiceSearchFilterValue.value.toLowerCase())
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
                                              color: Colors.green,
                                            ),
                                            tooltip: 'Edit Invoice'.tr,
                                            onPressed: () {
                                              //log("info button pressed");
                                              /* Get.to(const EditLead(), arguments: {
                                            "id": controller
                                                .trx.records![index].id,
                                            "name": controller
                                                .trx.records![index].name,
                                            "leadStatus": controller
                                                    .trx
                                                    .records![index]
                                                    .Status
                                                    ?.id ??
                                                "",
                                            "bpName": controller
                                                .trx.records![index].bPName,
                                            "Tel": controller
                                                .trx.records![index].phone,
                                            "eMail": controller
                                                .trx.records![index].eMail,
                                            "salesRep": controller
                                                    .trx
                                                    .records![index]
                                                    .salesRepID
                                                    ?.identifier ??
                                                ""
                                          }); */
                                            },
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.article,
                                            color: controller
                                                        .trx
                                                        .records![index]
                                                        .docStatus
                                                        ?.id ==
                                                    "CO"
                                                ? Colors.green
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            Get.offNamed('/PortalMpInvoiceLine',
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "docNo": controller
                                                      .trx
                                                      .records![index]
                                                      .documentNo,
                                                  "bPartner": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID
                                                      ?.identifier,
                                                  "priceListId": controller
                                                      .trx
                                                      .records![index]
                                                      .mPriceListID,
                                                  "dateOrdered": controller
                                                      .trx
                                                      .records![index]
                                                      .dateInvoiced,
                                                });
                                          },
                                        ),
                                        title: Text(
                                          "Nr ${controller.trx.records![index].documentNo} Dt ${controller.trx.records![index].dateInvoiced}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Row(
                                          children: <Widget>[
                                            const Icon(Icons.linear_scale,
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
                                        /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */
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
                                                      "€${controller.trx.records![index].grandTotal}"),
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
                            Flexible(flex: 5, child: _buildProfile(data: controller.getProfil())),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Obx(() => controller.dataAvailable
                                  ? Text("INVOICES: ".tr + controller.trx.rowcount.toString())
                                  : Text("INVOICES: ".tr)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getInvoices();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),                            
                          ],
                        ),
                        _buildInvoicesFilter(),
                        const SizedBox(height: kSpacing),
                        Obx(
                          () => controller.dataAvailable
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: controller.trx.rowcount,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Obx (() => Visibility(
                                      visible: controller.invoiceSearchFilterValue.value ==
                                                ""
                                            ? true
                                            : controller.invoiceDropdownValue.value == "1"
                                                ? controller.trx.records![index].documentNo
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(controller
                                                        .invoiceSearchFilterValue.value
                                                        .toLowerCase())
                                            : controller.invoiceDropdownValue.value == "2"
                                                    ? (controller
                                                        .trx.records![index].dateInvoiced ?? "")
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(controller
                                                            .invoiceSearchFilterValue.value
                                                            .toLowerCase())
                                            : controller.invoiceDropdownValue.value == "3"
                                                    ? (controller
                                                        .trx.records![index].cDocTypeID?.identifier ?? "")
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(controller
                                                            .invoiceSearchFilterValue.value
                                                            .toLowerCase())
                                            : true,
                                    
                                      child: Card(
                                        elevation: 8.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        child: Obx( () => controller.selectedCard == index ? 
                                          _buildCard(Theme.of(context).cardColor, context, index) : 
                                          _buildCard(const Color.fromRGBO(64, 75, 96, .9), context, index),
                                      ),
                                    )));
                                  },
                                )
                              : const Center(child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing ),
                        _buildHeader(),
                        const SizedBox(height: kSpacing * 6.5),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                              //width: 100,
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: 
                              Obx( () => controller.dataAvailable ? 
                                SingleChildScrollView(
                                  child: Container(
                                    //margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                    margin: const EdgeInsets.only(right: 10.0, left: 10.0, /* top: kSpacing * 7.7 */ bottom: 6.0),
                                    color: const Color.fromRGBO(64, 75, 96, .9),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container( 
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'DocumentNo'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .documentNo ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Business Partner'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .cBPartnerID?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Document Type'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .cDocTypeTargetID?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Date Invoiced'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .dateInvoiced ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Payment Rule'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .paymentRule?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'Payment Term'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .cPaymentTermID?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(255, 255, 255, 255)
                                                ),
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: const OutlineInputBorder(),
                                                labelText: 'SalesRep'.tr,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                hintText: controller.trx.records![controller.selectedCard]
                                                .salesRepID?.identifier ?? '',
                                                enabled: false
                                              ),
                                            ),
                                          ),
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: 200,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromARGB(255, 255, 255, 255)
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    border: const OutlineInputBorder(),
                                                    labelText: 'Lines Amount'.tr,
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintText:  ( controller.trx.records![controller.selectedCard]
                                                      .totalLines ?? "").toString(),
                                                    enabled: false
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //const SizedBox(width: kSpacing * 2,),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: SizedBox(
                                                width: 200,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromARGB(255, 255, 255, 255)
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    border: const OutlineInputBorder(),
                                                    labelText: 'Charge Amount'.tr,
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintText: (controller.trx.records![controller.selectedCard]
                                                    .chargeAmt ?? "").toString(),
                                                    enabled: false
                                            ),
                                          ),
                                              ),
                                        ), 
                                      ],),
                                    ]),
                                  )),
                                ) : const Center(child: CircularProgressIndicator()) 
                                )),
                            ),
                          ],
                        ),
                      ]
                    )),
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
                                  ? Text("LINES: ".tr + controller.trx1.rowcount.toString())
                                  : Text("LINES: ".tr)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getInvoiceLines();
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
                              height: MediaQuery.of(context).size.height / 1.3,
                              child: 
                              Obx( () => controller.showData ? 
                              
                                SingleChildScrollView(
                                  child: ListView.builder(
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: controller.trx1.rowcount,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Obx(() => Visibility(
                                visible: controller.linesSearchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.linesDropdownValue.value == "1"
                                        ? (controller.trx1.records![index].mProductID?.identifier ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .linesSearchFilterValue.value
                                                .toLowerCase())
                                        : controller.linesDropdownValue.value == "2"
                                            ? (controller
                                                .trx1.records![index].line ?? "")
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .linesSearchFilterValue.value
                                                    .toLowerCase())
                                        : controller.linesDropdownValue.value == "3"
                                            ? (controller
                                                .trx1.records![index].name ?? "")
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .linesSearchFilterValue.value
                                                    .toLowerCase())
                                        : controller.linesDropdownValue.value == "4"
                                            ? (controller
                                                .trx1.records![index].lineTotalAmt ?? "")
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .linesSearchFilterValue.value
                                                    .toLowerCase())
                                                : true,
                                child: _buildLineCard(context, index)));
                                    }
                                  ),
                                )
                            : Center(child: Text('No Invoice Selected'.tr)) 
                            )),
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

  Widget _buildCard(Color selectionColor, context, index){
    return Container(
      decoration: BoxDecoration(
          color: selectionColor),
      child: ExpansionTile(
        trailing: IconButton(
          icon: const Icon(
            Icons.article,
            color: Colors.green,
          ),
          onPressed: () {
            controller.selectedCard = index;
            controller.invoiceId = controller.trx.records?[index].id;
            controller.getInvoiceLines();
          },
        ),
        title: Text(
          '${'DocumentNo'.tr} ${controller.trx.records![index].documentNo!}',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            const Icon(Icons.payments,
                color: Colors.green),
            Expanded(
              child: Text(
                controller.trx.records![index].cBPartnerID?.identifier ??
                    "",
                style: const TextStyle(
                    color: Colors.white),
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('${'Document Type'.tr}: '),
                        Text(controller.trx.records![index].cDocTypeTargetID?.identifier ?? "",)
                      ],
                    ),
                    Row(
                      children: [
                        Text('${'Date Invoiced'.tr}: '),
                        Text(controller.trx.records![index].dateInvoiced ?? "",)
                      ],
                    ),                    
                  ],
                ),
              ],
            ),
          );
  }

  _buildInvoicesFilter(){
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
              value: controller.invoiceDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.invoiceDropdownValue.value = newValue!;
              },
              items: controller.invoiceDropDownList.map((list) {
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
              controller: controller.invoiceSearchFieldController,
              onSubmitted: (String? value) {
                controller.invoiceSearchFilterValue.value =
                    controller.invoiceSearchFieldController.text;
              },
              decoration:  InputDecoration(
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

  Widget _buildLinesFilter(){
    return Row(children: [
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
    ],);
  }

  Widget _buildLineCard(context, index){
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, .9)),
      child: ExpansionTile(
        title: Text(
          controller.trx1.records![index].mProductID?.identifier ?? "",
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Expanded(
          child: Column(
            children: <Widget>[
              /* Container(
                margin: const EdgeInsets.only(right: 5),
                child: const Icon(Icons.payments,
                    color: Colors.green),
              ), */
              Row(
                children: [
                  Text(
                    '${'LineNo'.tr}: ',
                    style: const TextStyle(
                        color: Colors.white),
                  ),
                  Text((controller.trx1.records![index].line ??
                        "").toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),)
                ],
              ),
              Row(
                children: [
                  Text(
                    '${'Name'.tr}: ',
                    style: const TextStyle(
                        color: Colors.white),
                  ),
                  Text(controller.trx1.records![index].name ??
                        "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ))
                ],
              ),
              Row(
                children: [
                  Text(
                    '${'Line Amount'.tr}: ',
                    style: const TextStyle(
                        color: Colors.white),
                  ),
                  Text((controller.trx1.records![index].lineTotalAmt ??
                        "").toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      )
                ],
              ),
            ],
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('${'Description'.tr}: '),
                        Text(controller.trx1.records![index].description ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('${'Price'.tr}: '),
                        Text((controller.trx1.records![index].priceEntered ?? "").toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('${'List Price'.tr}: '),
                        Text((controller.trx1.records![index].priceList ?? "").toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('${'Tax'.tr}: '),
                        Text(controller.trx1.records![index].cTaxID?.identifier ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

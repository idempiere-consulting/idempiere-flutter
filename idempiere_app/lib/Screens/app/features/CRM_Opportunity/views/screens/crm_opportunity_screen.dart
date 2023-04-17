// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/salesrep.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/opportunity.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/salestagejson.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_edit_opportunity.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_create.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_create_tasks.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
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
import 'package:path_provider/path_provider.dart';

// binding
part '../../bindings/crm_opportunity_binding.dart';

// controller
part '../../controllers/crm_opportunity_controller.dart';

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

class CRMOpportunityScreen extends GetView<CRMOpportunityController> {
  const CRMOpportunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Get.to(const CreateOpportunity());
          },
          child: const Icon(MaterialSymbols.add_business),
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
                          ? Text("OPPORTUNITY: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("OPPORTUNITY: ".tr)),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateOpportunity());
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
                          controller.getOpportunities();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: TextButton(
                        onPressed: () {
                          //controller.changeFilter();
                          //print("hello");
                        },
                        child: const Text('filter'),
                        //Text(controller.value.value),
                      ),
                    ), */
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                      visible: false,
                      child: Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: controller.searchFieldController,
                            onSubmitted: (String? value) {
                              /* controller.searchFilterValue.value =
                                    controller.searchFieldController.text; */
                              controller.getOpportunities();
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(EvaIcons.search),
                              hintText: "search..",
                              isDense: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                            controller.saleStageValue.value = "";
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
                    Obx(
                      () => Visibility(
                        visible: controller.dropdownValue.value == "1",
                        child: Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: FutureBuilder(
                              future: controller.getAllBPs(),
                              builder: (BuildContext ctx,
                                      AsyncSnapshot<List<BPRecords>>
                                          snapshot) =>
                                  snapshot.hasData
                                      ? TypeAheadField<BPRecords>(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            //autofocus: true,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.italic),
                                            decoration: InputDecoration(
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon:
                                                  const Icon(EvaIcons.search),
                                              hintText: "search..",
                                              isDense: true,
                                              fillColor:
                                                  Theme.of(context).cardColor,
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            return snapshot.data!.where(
                                                (element) => (element.name ??
                                                        "")
                                                    .toLowerCase()
                                                    .contains(
                                                        pattern.toLowerCase()));
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              //leading: Icon(Icons.shopping_cart),
                                              title:
                                                  Text(suggestion.name ?? ""),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            controller.businessPartnerId =
                                                suggestion.id!;
                                            controller.getOpportunities();
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.dropdownValue.value == "2",
                        child: Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: FutureBuilder(
                              future: controller.getAllProducts(),
                              builder: (BuildContext ctx,
                                      AsyncSnapshot<List<PRecords>> snapshot) =>
                                  snapshot.hasData
                                      ? TypeAheadField<PRecords>(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            //autofocus: true,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.italic),
                                            decoration: InputDecoration(
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon:
                                                  const Icon(EvaIcons.search),
                                              hintText: "search..",
                                              isDense: true,
                                              fillColor:
                                                  Theme.of(context).cardColor,
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            return snapshot.data!.where((element) =>
                                                ("${element.value}_${element.name}")
                                                    .toLowerCase()
                                                    .contains(
                                                        pattern.toLowerCase()));
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              //leading: Icon(Icons.shopping_cart),
                                              title:
                                                  Text(suggestion.name ?? ""),
                                              subtitle:
                                                  Text(suggestion.value ?? ""),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            controller.productId =
                                                suggestion.id!;
                                            controller.getOpportunities();
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.dropdownValue.value == "3",
                        child: Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: FutureBuilder(
                              future: controller.getAllSalesRep(),
                              builder: (BuildContext ctx,
                                      AsyncSnapshot<List<CRecords>> snapshot) =>
                                  snapshot.hasData
                                      ? TypeAheadField<CRecords>(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            //autofocus: true,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .copyWith(
                                                    fontStyle:
                                                        FontStyle.italic),
                                            decoration: InputDecoration(
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon:
                                                  const Icon(EvaIcons.search),
                                              hintText: "search..",
                                              isDense: true,
                                              fillColor:
                                                  Theme.of(context).cardColor,
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) async {
                                            return snapshot.data!.where(
                                                (element) => (element.name ??
                                                        "")
                                                    .toLowerCase()
                                                    .contains(
                                                        pattern.toLowerCase()));
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              //leading: Icon(Icons.shopping_cart),
                                              title:
                                                  Text(suggestion.name ?? ""),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            controller.salesRepId =
                                                suggestion.id!;
                                            controller.getOpportunities();
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.dropdownValue.value == "4",
                        child: Flexible(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Obx(() => DropdownButton(
                                  underline: const SizedBox(),
                                  hint: Text("Select a Sale Stage".tr),
                                  isExpanded: true,
                                  value: controller.saleStageValue.value == ""
                                      ? null
                                      : controller.saleStageValue.value,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    controller.saleStageValue.value =
                                        newValue as String;
                                    controller.getOpportunities();
                                    //print(dropdownValue);
                                  },
                                  items: controller.salestages.records!
                                      .map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (controller.pagesCount > 1) {
                          controller.pagesCount.value -= 1;
                          controller.getOpportunities();
                        }
                      },
                      icon: const Icon(Icons.skip_previous),
                    ),
                    Obx(() => Text(
                        "${controller.pagesCount.value}/${controller.pagesTot.value}")),
                    IconButton(
                      onPressed: () {
                        if (controller.pagesCount < controller.pagesTot.value) {
                          controller.pagesCount.value += 1;
                          controller.getOpportunities();
                        }
                      },
                      icon: const Icon(Icons.skip_next),
                    )
                  ],
                ),
                //const SizedBox(height: kSpacing),
                Obx(() => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
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
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Edit Opportunity'.tr,
                                    onPressed: () {
                                      Get.to(const EditOpportunity(),
                                          arguments: {
                                            "id": controller
                                                .trx.records![index].id,
                                            "SaleStageID": controller
                                                .trx
                                                .records![index]
                                                .cSalesStageID!
                                                .id,
                                            "salesRep": controller
                                                    .trx
                                                    .records![index]
                                                    .salesRepID
                                                    ?.identifier ??
                                                "",
                                            "productName": controller
                                                    .trx
                                                    .records![index]
                                                    .mProductID
                                                    ?.identifier ??
                                                "",
                                            "productId": controller
                                                    .trx
                                                    .records![index]
                                                    .mProductID
                                                    ?.id ??
                                                0,
                                            "opportunityAmt": controller
                                                    .trx
                                                    .records![index]
                                                    .opportunityAmt ??
                                                0,
                                            "cBPartnerID": controller
                                                    .trx
                                                    .records![index]
                                                    .cBPartnerID
                                                    ?.id ??
                                                0,
                                            "cBPartnerName": controller
                                                    .trx
                                                    .records![index]
                                                    .cBPartnerID
                                                    ?.identifier ??
                                                "",
                                            "Description": controller
                                                    .trx
                                                    .records![index]
                                                    .description ??
                                                "",
                                            "Note": controller
                                                    .trx.records![index].note ??
                                                "",
                                            "Probability": controller
                                                    .trx
                                                    .records![index]
                                                    .probability ??
                                                0,
                                            "CampaignName": controller
                                                    .trx
                                                    .records![index]
                                                    .cCampaignID
                                                    ?.identifier ??
                                                "",
                                            "CampaignId": controller
                                                    .trx
                                                    .records![index]
                                                    .cCampaignID
                                                    ?.id ??
                                                "",
                                          });
                                    },
                                  ),
                                ),
                                title: Text(
                                  controller.trx.records![index].cBPartnerID
                                          ?.identifier ??
                                      "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Row(
                                  children: <Widget>[
                                    const Icon(Icons.linear_scale,
                                        color: Colors.yellowAccent),
                                    Text(
                                      controller.trx.records![index]
                                              .cSalesStageID!.identifier ??
                                          "??",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
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
                                      Row(
                                        children: [
                                          Text(
                                            "${'ContactBP'.tr}: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(controller.trx.records![index]
                                                  .aDUserID?.identifier ??
                                              ""),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'Description'.tr}: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx
                                                    .records![index]
                                                    .description ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'Product'.tr}: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx
                                                    .records![index]
                                                    .mProductID
                                                    ?.identifier ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'OpportunityAmt'.tr}: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "€${controller.trx.records![index].opportunityAmt}"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'SalesRep'.tr}: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(controller.trx.records![index]
                                                  .salesRepID?.identifier ??
                                              ""),
                                        ],
                                      ),
                                      Visibility(
                                        visible: controller._trx.records![index]
                                                .latestJPToDoID !=
                                            null,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${'Latest Appointment'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  controller
                                                          ._trx
                                                          .records![index]
                                                          .latestJPToDoName ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: kNotifColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ),
                                            onPressed: () async {
                                              Get.defaultDialog(
                                                title: 'Create Sales Order'.tr,
                                                content: Text(
                                                    "Are you sure you want to create a Sales Order from Opportunity?"
                                                        .tr),
                                                onCancel: () {},
                                                onConfirm: () async {
                                                  final ip =
                                                      GetStorage().read('ip');
                                                  String authorization =
                                                      'Bearer ${GetStorage().read('token')}';
                                                  final msg = jsonEncode({
                                                    "DocAction": "CO",
                                                  });
                                                  final protocol = GetStorage()
                                                      .read('protocol');
                                                  var url = Uri.parse(
                                                      '$protocol://$ip/api/v1/models/c_opportunity/${controller.trx.records![index].id}');

                                                  var response = await http.put(
                                                    url,
                                                    body: msg,
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json',
                                                      'Authorization':
                                                          authorization,
                                                    },
                                                  );
                                                  if (response.statusCode ==
                                                      200) {
                                                    //print("done!");
                                                    /* completeOrder(
                                                                index); */
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
                                                },
                                              );
                                            },
                                            tooltip: "Create Sales Order".tr,
                                            icon: const Icon(
                                                Icons.description_outlined),
                                          ),
                                          IconButton(
                                            tooltip: "Create Appointment".tr,
                                            onPressed: () {
                                              Get.to(
                                                  const CreateOpportunityTasks(),
                                                  arguments: {
                                                    "opportunityId": controller
                                                        ._trx
                                                        .records![index]
                                                        .id,
                                                    "opportunityName":
                                                        controller
                                                            ._trx
                                                            .records![index]
                                                            .description,
                                                    "bPartnerId": controller
                                                            ._trx
                                                            .records![index]
                                                            .cBPartnerID
                                                            ?.id ??
                                                        0,
                                                  });
                                            },
                                            icon: const Icon(Icons.add_task),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator())),
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
                          ? Text("OPPORTUNITY: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("OPPORTUNITY: ".tr)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateOpportunity());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getOpportunities();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: TextButton(
                        onPressed: () {
                          //controller.changeFilter();
                          //print("hello");
                        },
                        child: const Text('filter'),
                        //Text(controller.value.value),
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
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            controller.searchFilterValue.value =
                                controller.searchFieldController.text;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_outlined),
                            border: OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(() => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(
                            () => Visibility(
                              visible: controller.searchFilterValue.value == ""
                                  ? true
                                  : controller.dropdownValue.value == "1"
                                      ? controller.trx.records![index].cBPartnerID!.identifier
                                          .toString()
                                          .toLowerCase()
                                          .contains(controller.searchFilterValue.value
                                              .toLowerCase())
                                      : controller.dropdownValue.value == "2"
                                          ? (controller.trx.records![index].mProductID?.identifier ?? "")
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller.searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
                                                  "3"
                                              ? controller.trx.records![index]
                                                  .salesRepID!.identifier
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller.searchFilterValue.value
                                                      .toLowerCase())
                                              : controller.dropdownValue.value ==
                                                      "4"
                                                  ? controller
                                                      .trx
                                                      .records![index]
                                                      .cSalesStageID!
                                                      .identifier
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(controller.searchFilterValue.value.toLowerCase())
                                                  : true,
                              child: Card(
                                elevation: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ExpansionTile(
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
                                        icon: const Icon(
                                          Icons.paid,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Opportunity',
                                        onPressed: () {
                                          Get.to(const EditOpportunity(),
                                              arguments: {
                                                "id": controller
                                                    .trx.records![index].id,
                                                "SaleStageID": controller
                                                    .trx
                                                    .records![index]
                                                    .cSalesStageID!
                                                    .id,
                                                "salesRep": controller
                                                        .trx
                                                        .records![index]
                                                        .salesRepID
                                                        ?.identifier ??
                                                    "",
                                                "productName": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier ??
                                                    "",
                                                "productId": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.id ??
                                                    0,
                                                "opportunityAmt": controller
                                                        .trx
                                                        .records![index]
                                                        .opportunityAmt ??
                                                    0,
                                                "cBPartnerID": controller
                                                        .trx
                                                        .records![index]
                                                        .cBPartnerID
                                                        ?.id ??
                                                    0,
                                                "cBPartnerName": controller
                                                        .trx
                                                        .records![index]
                                                        .cBPartnerID
                                                        ?.identifier ??
                                                    "",
                                                "Description": controller
                                                        .trx
                                                        .records![index]
                                                        .description ??
                                                    "",
                                              });
                                        },
                                      ),
                                    ),
                                    title: Text(
                                      controller.trx.records![index].cBPartnerID
                                              ?.identifier ??
                                          "???",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Row(
                                      children: <Widget>[
                                        const Icon(Icons.linear_scale,
                                            color: Colors.yellowAccent),
                                        Text(
                                          controller.trx.records![index]
                                                  .cSalesStageID!.identifier ??
                                              "??",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
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
                                          Row(
                                            children: [
                                              Text(
                                                "${'ContactBP'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .aDUserID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${'Product'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .mProductID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${'OpportunityAmt'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "€${controller.trx.records![index].opportunityAmt}"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${'SalesRep'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .salesRepID!
                                                      .identifier ??
                                                  ""),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator())),
              ]);
            },
            desktopBuilder: (context, constraints) {
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
                          ? Text("OPPORTUNITY: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("OPPORTUNITY: ".tr)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateOpportunity());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getOpportunities();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: TextButton(
                        onPressed: () {
                          //controller.changeFilter();
                          //print("hello");
                        },
                        child: const Text('filter'),
                        //Text(controller.value.value),
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
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            controller.searchFilterValue.value =
                                controller.searchFieldController.text;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_outlined),
                            border: OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(() => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(
                            () => Visibility(
                              visible: /* controller.searchFilterValue.value == ""
                                  ? true
                                  : controller.dropdownValue.value == "1"
                                      ? controller.trx.records![index].cBPartnerID!.identifier
                                          .toString()
                                          .toLowerCase()
                                          .contains(controller.searchFilterValue.value
                                              .toLowerCase())
                                      : controller.dropdownValue.value == "2"
                                          ? (controller.trx.records![index].mProductID?.identifier ?? "")
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller.searchFilterValue.value
                                                  .toLowerCase())
                                          : controller.dropdownValue.value ==
                                                  "3"
                                              ? controller.trx.records![index]
                                                  .salesRepID!.identifier
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(controller.searchFilterValue.value
                                                      .toLowerCase())
                                              : controller.dropdownValue.value ==
                                                      "4"
                                                  ? controller
                                                      .trx
                                                      .records![index]
                                                      .cSalesStageID!
                                                      .identifier
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(controller.searchFilterValue.value.toLowerCase())
                                                  : */
                                  true,
                              child: Card(
                                elevation: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ExpansionTile(
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
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Opportunity',
                                        onPressed: () {
                                          Get.to(const EditOpportunity(),
                                              arguments: {
                                                "id": controller
                                                    .trx.records![index].id,
                                                "SaleStageID": controller
                                                    .trx
                                                    .records![index]
                                                    .cSalesStageID!
                                                    .id,
                                                "salesRep": controller
                                                        .trx
                                                        .records![index]
                                                        .salesRepID
                                                        ?.identifier ??
                                                    "",
                                                "productName": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.identifier ??
                                                    "",
                                                "productId": controller
                                                        .trx
                                                        .records![index]
                                                        .mProductID
                                                        ?.id ??
                                                    0,
                                                "opportunityAmt": controller
                                                        .trx
                                                        .records![index]
                                                        .opportunityAmt ??
                                                    0,
                                                "cBPartnerID": controller
                                                        .trx
                                                        .records![index]
                                                        .cBPartnerID
                                                        ?.id ??
                                                    0,
                                                "cBPartnerName": controller
                                                        .trx
                                                        .records![index]
                                                        .cBPartnerID
                                                        ?.identifier ??
                                                    "",
                                                "Description": controller
                                                        .trx
                                                        .records![index]
                                                        .description ??
                                                    "",
                                              });
                                        },
                                      ),
                                    ),
                                    title: Text(
                                      controller.trx.records![index].cBPartnerID
                                              ?.identifier ??
                                          "???",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Row(
                                      children: <Widget>[
                                        const Icon(Icons.linear_scale,
                                            color: Colors.yellowAccent),
                                        Text(
                                          controller.trx.records![index]
                                                  .cSalesStageID!.identifier ??
                                              "??",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
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
                                          Row(
                                            children: [
                                              Text(
                                                "${'ContactBP'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .aDUserID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${'Product'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .mProductID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${'OpportunityAmt'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "€${controller.trx.records![index].opportunityAmt}"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${'SalesRep'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .records![index]
                                                      .salesRepID!
                                                      .identifier ??
                                                  ""),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator())),
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
}

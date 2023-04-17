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
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact_bp_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/views/screens/crm_edit_contact_bp.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_create_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/crm_contact_bp_binding.dart';

// controller
part '../../controllers/crm_contact_bp_controller.dart';

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

class CRMContactBPScreen extends GetView<CRMContactBPController> {
  const CRMContactBPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        /* floatingActionButton: FloatingActionButton.small(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            //Get.to(const CreateOpportunity());
          },
          child: const Icon(MaterialSymbols.person_add_outlined),
        ), */
        //key: controller.scaffoldKey,
        drawer: /* (ResponsiveBuilder.isDesktop(context))
            ? null
            :  */
            Drawer(
          child: _Sidebar(data: controller.getSelectedProject()),
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
                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text("CONTACTS: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("CONTACTS: ".tr)),
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
                          controller.pagesCount.value = 1;
                          controller.getContacts();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
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
                    Obx(
                      () => Visibility(
                        visible: controller.dropdownValue.value != "2",
                        child: Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: controller.searchFieldController,
                              onSubmitted: (String? value) {
                                /* controller.searchFilterValue.value =
                                  controller.searchFieldController.text; */
                                controller.getContacts();
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
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.dropdownValue.value == "2",
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
                                            controller.getContacts();
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
                    /* Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            controller.searchFilterValue.value = 
                                controller.searchFieldController.text;
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
                    ), */
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (controller.pagesCount > 1) {
                          controller.pagesCount.value -= 1;
                          controller.getContacts();
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
                          controller.getContacts();
                        }
                      },
                      icon: const Icon(Icons.skip_next),
                    )
                  ],
                ),
                //const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records!.length,
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
                                      tooltip: 'Edit Contact'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
                                        Get.to(const EditContactBP(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "bpName": controller
                                                  .trx
                                                  .records![index]
                                                  .cBPartnerID!
                                                  .identifier,
                                              "Tel": controller
                                                  .trx.records![index].phone,
                                              "eMail": controller
                                                  .trx.records![index].eMail,
                                            });
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.records![index].name ??
                                        "???",
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
                                          controller.trx.records![index]
                                                  .cBPartnerID!.identifier ??
                                              "??",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      tooltip: 'Zoom Business Partner'.tr,
                                      onPressed: () {
                                        Get.offNamed('/CustomerBP', arguments: {
                                          'notificationId': controller.trx
                                              .records![index].cBPartnerID?.id,
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        color: kNotifColor,
                                      )),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.call,
                                                color: Colors.green,
                                              ),
                                              tooltip: 'Call',
                                              onPressed: () {
                                                //log("info button pressed");
                                                if (controller
                                                        .trx
                                                        .records![index]
                                                        .phone ==
                                                    null) {
                                                  log("info button pressed");
                                                } else {
                                                  controller.makePhoneCall(
                                                      controller.trx
                                                          .records![index].phone
                                                          .toString());
                                                }
                                              },
                                            ),
                                            Text(controller.trx.records![index]
                                                    .phone ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.mail,
                                                color: Colors.white,
                                              ),
                                              tooltip: 'EMail',
                                              onPressed: () {
                                                if (controller
                                                        .trx
                                                        .records![index]
                                                        .eMail ==
                                                    null) {
                                                  log("mail button pressed");
                                                } else {
                                                  controller.writeMailTo(
                                                      controller.trx
                                                          .records![index].eMail
                                                          .toString());
                                                }
                                              },
                                            ),
                                            Text(controller.trx.records![index]
                                                    .eMail ??
                                                ""),
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
                          ? Text("CONTACTS: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("CONTACTS: ".tr)),
                    ),
                    Container(
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getContacts();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
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
                            return Obx(
                              () => Visibility(
                                visible: controller.searchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.dropdownValue.value == "1"
                                        ? controller.trx.records![index].name
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .searchFilterValue.value
                                                .toLowerCase())
                                        : controller.dropdownValue.value == "2"
                                            ? controller.trx.records![index]
                                                .cBPartnerID!.identifier
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .searchFilterValue.value
                                                    .toLowerCase())
                                            : controller.dropdownValue.value ==
                                                    "3"
                                                ? controller
                                                    .trx.records![index].phone
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        controller.searchFilterValue.value.toLowerCase())
                                                : controller.dropdownValue.value == "4"
                                                    ? controller.trx.records![index].eMail.toString().toLowerCase().contains(controller.searchFilterValue.value.toLowerCase())
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
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          tooltip: 'Edit Contact'.tr,
                                          onPressed: () {
                                            //log("info button pressed");
                                            Get.to(const EditContactBP(),
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "name": controller
                                                      .trx.records![index].name,
                                                  "bpName": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID!
                                                      .identifier,
                                                  "Tel": controller.trx
                                                      .records![index].phone,
                                                  "eMail": controller.trx
                                                      .records![index].eMail,
                                                });
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller.trx.records![index].name ??
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
                                                    .cBPartnerID!.identifier ??
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
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.call,
                                                    color: Colors.green,
                                                  ),
                                                  tooltip: 'Call',
                                                  onPressed: () {
                                                    //log("info button pressed");
                                                    if (controller
                                                            .trx
                                                            .records![index]
                                                            .phone ==
                                                        null) {
                                                      log("info button pressed");
                                                    } else {
                                                      controller.makePhoneCall(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .phone
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .records![index]
                                                        .phone ??
                                                    ""),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.mail,
                                                    color: Colors.white,
                                                  ),
                                                  tooltip: 'EMail',
                                                  onPressed: () {
                                                    if (controller
                                                            .trx
                                                            .records![index]
                                                            .eMail ==
                                                        null) {
                                                      log("mail button pressed");
                                                    } else {
                                                      controller.writeMailTo(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .eMail
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .records![index]
                                                        .eMail ??
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
                      : const Center(child: CircularProgressIndicator()),
                ),
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
                          ? Text("CONTACTS: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("CONTACTS: ".tr)),
                    ),
                    Container(
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getContacts();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
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
                            return Obx(
                              () => Visibility(
                                visible: controller.searchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.dropdownValue.value == "1"
                                        ? controller.trx.records![index].name
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .searchFilterValue.value
                                                .toLowerCase())
                                        : controller.dropdownValue.value == "2"
                                            ? controller.trx.records![index]
                                                .cBPartnerID!.identifier
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .searchFilterValue.value
                                                    .toLowerCase())
                                            : controller.dropdownValue.value ==
                                                    "3"
                                                ? controller
                                                    .trx.records![index].phone
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        controller.searchFilterValue.value.toLowerCase())
                                                : controller.dropdownValue.value == "4"
                                                    ? controller.trx.records![index].eMail.toString().toLowerCase().contains(controller.searchFilterValue.value.toLowerCase())
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
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          tooltip: 'Edit Contact'.tr,
                                          onPressed: () {
                                            //log("info button pressed");
                                            Get.to(const EditContactBP(),
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "name": controller
                                                      .trx.records![index].name,
                                                  "bpName": controller
                                                      .trx
                                                      .records![index]
                                                      .cBPartnerID!
                                                      .identifier,
                                                  "Tel": controller.trx
                                                      .records![index].phone,
                                                  "eMail": controller.trx
                                                      .records![index].eMail,
                                                });
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller.trx.records![index].name ??
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
                                                    .cBPartnerID!.identifier ??
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
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.call,
                                                    color: Colors.green,
                                                  ),
                                                  tooltip: 'Call',
                                                  onPressed: () {
                                                    //log("info button pressed");
                                                    if (controller
                                                            .trx
                                                            .records![index]
                                                            .phone ==
                                                        null) {
                                                      log("info button pressed");
                                                    } else {
                                                      controller.makePhoneCall(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .phone
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .records![index]
                                                        .phone ??
                                                    ""),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.mail,
                                                    color: Colors.white,
                                                  ),
                                                  tooltip: 'EMail',
                                                  onPressed: () {
                                                    if (controller
                                                            .trx
                                                            .records![index]
                                                            .eMail ==
                                                        null) {
                                                      log("mail button pressed");
                                                    } else {
                                                      controller.writeMailTo(
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .eMail
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .records![index]
                                                        .eMail ??
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

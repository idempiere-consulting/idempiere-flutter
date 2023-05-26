// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/lead.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_create_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_edit_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_create_tasks.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_filters_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/salestagejson.dart';
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
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/crm_leads_binding.dart';

// controller
part '../../controllers/crm_leads_controller.dart';

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

class CRMLeadScreen extends GetView<CRMLeadController> {
  const CRMLeadScreen({Key? key}) : super(key: key);

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
                            controller.getLeads();
                          },
                          child: Row(
                            children: [
                              //Icon(Icons.filter_alt),
                              Obx(() => controller.dataAvailable
                                  ? Text("LEAD: ".tr +
                                      controller.trx.rowcount.toString())
                                  : Text("LEAD: ".tr)),
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
                              controller.getLeads();
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
                              controller.getLeads();
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
                      MaterialSymbols.filter_alt_filled,
                      color: controller.selectedUserRadioTile.value == 0 &&
                              controller.nameValue.value == "" &&
                              controller.mailValue.value == "" &&
                              controller.phoneValue.value == "" &&
                              controller.sectorId.value == "0" &&
                              controller.statusId.value == "0" &&
                              controller.sizeId.value == "0" &&
                              controller.campaignId.value == "0" &&
                              controller.sourceId.value == "0"
                          ? Colors.white
                          : kNotifColor,
                    )),
                onTap: () {
                  Get.to(() => const CRMFilterLead(), arguments: {
                    "sectorId": controller.sectorId.value,
                    "selectedUserRadioTile":
                        controller.selectedUserRadioTile.value,
                    'name': controller.nameValue.value,
                    'mail': controller.mailValue.value,
                    'phone': controller.phoneValue.value,
                    "statusId": controller.statusId.value,
                    'sizeId': controller.sizeId.value,
                    'campaignId': controller.campaignId.value,
                    'sourceId': controller.sourceId.value,
                  });
                }),
            SpeedDialChild(
                label: 'New'.tr,
                child: const Icon(MaterialSymbols.person_add),
                onTap: () {
                  Get.to(() => const CreateLead());
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
                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */

                //const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.windowrecords!.length,
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
                                      tooltip: 'Edit Lead'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
                                        Get.to(const EditLead(), arguments: {
                                          "id": controller
                                              .trx.windowrecords![index].id,
                                          "name": controller.trx
                                                  .windowrecords![index].name ??
                                              "",
                                          "description": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .description ??
                                              "",
                                          "note": controller.trx
                                                  .windowrecords![index].note ??
                                              "",
                                          "leadStatus": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadStatus
                                                  ?.id ??
                                              "",
                                          "bpName": controller
                                              .trx.windowrecords![index].bPName,
                                          "businessPartner": controller
                                              .trx
                                              .windowrecords![index]
                                              .cbPartnerID
                                              ?.identifier,
                                          "Tel": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .phone ??
                                              "",
                                          "eMail": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .eMail ??
                                              "",
                                          "url": controller.trx
                                                  .windowrecords![index].url ??
                                              "",
                                          "size": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .litLeadSizeID
                                                  ?.id ??
                                              "",
                                          "source": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadSource
                                                  ?.id ??
                                              "",
                                          "sector": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .litIndustrySectorID
                                                  ?.id ??
                                              "",
                                          "campaign": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .cCampaignID
                                                  ?.id ??
                                              "",
                                          "address": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPLocationID
                                                  ?.identifier ??
                                              "",
                                          "salesRep": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID
                                                  ?.identifier ??
                                              ""
                                        });
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.windowrecords![index].name ??
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
                                        controller.trx.windowrecords![index]
                                                .leadStatus?.identifier ??
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
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPName !=
                                              null,
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Business Partner: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .bPName ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPLocationID !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                  )),
                                              Expanded(
                                                child: Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .bPLocationID
                                                        ?.identifier ??
                                                    ""),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .phone !=
                                              null,
                                          child: Row(
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
                                                          .windowrecords![index]
                                                          .phone ==
                                                      null) {
                                                    log("info button pressed");
                                                  } else {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .windowrecords![
                                                                index]
                                                            .phone
                                                            .toString());
                                                    controller
                                                        .createPhoneCallActivity(
                                                            controller
                                                                .trx
                                                                .windowrecords![
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .phone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .eMail !=
                                              null,
                                          child: Row(
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
                                                          .windowrecords![index]
                                                          .eMail ==
                                                      null) {
                                                    log("mail button pressed");
                                                  } else {
                                                    controller.writeMailTo(
                                                        controller
                                                            .trx
                                                            .windowrecords![
                                                                index]
                                                            .eMail
                                                            .toString());
                                                    controller
                                                        .createEmailActivity(
                                                            controller
                                                                .trx
                                                                .windowrecords![
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .eMail ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"SalesRep".tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .salesRepID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .windowrecords![index]
                                                  .latestJPToDoID !=
                                              null,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${'Latest Appointment'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            ._trx
                                                            .windowrecords![
                                                                index]
                                                            .latestJPToDoName ??
                                                        "",
                                                    style: TextStyle(
                                                        color: controller
                                                                    ._trx
                                                                    .windowrecords![
                                                                        index]
                                                                    .latestJPToDoStatus ==
                                                                'CO'
                                                            ? kNotifColor
                                                            : Colors.yellow),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .windowrecords![index]
                                                  .latestActivityID !=
                                              null,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${'Latest Activity'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            ._trx
                                                            .windowrecords![
                                                                index]
                                                            .latestActivityName ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: kNotifColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              tooltip: "Create Appointment".tr,
                                              onPressed: () {
                                                Get.to(const CreateLeadTasks(),
                                                    arguments: {
                                                      "leadId": controller
                                                          ._trx
                                                          .windowrecords![index]
                                                          .id,
                                                      "leadName": controller
                                                          ._trx
                                                          .windowrecords![index]
                                                          .name,
                                                      /* "bPartnerId": controller
                                                            ._trx
                                                            .records![index]
                                                            .cBPartnerID
                                                            ?.id ??
                                                        0, */
                                                    });
                                              },
                                              icon: const Icon(Icons.add_task),
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .windowrecords![index]
                                                      .cbPartnerID ==
                                                  null,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  controller.convertLead(index);
                                                },
                                                child: Text("Convert Lead".tr),
                                              ),
                                            ),
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
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */

                //const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.windowrecords!.length,
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
                                      tooltip: 'Edit Lead'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
                                        Get.to(const EditLead(), arguments: {
                                          "id": controller
                                              .trx.windowrecords![index].id,
                                          "name": controller.trx
                                                  .windowrecords![index].name ??
                                              "",
                                          "description": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .description ??
                                              "",
                                          "note": controller.trx
                                                  .windowrecords![index].note ??
                                              "",
                                          "leadStatus": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadStatus
                                                  ?.id ??
                                              "",
                                          "bpName": controller
                                              .trx.windowrecords![index].bPName,
                                          "businessPartner": controller
                                              .trx
                                              .windowrecords![index]
                                              .cbPartnerID
                                              ?.identifier,
                                          "Tel": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .phone ??
                                              "",
                                          "eMail": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .eMail ??
                                              "",
                                          "url": controller.trx
                                                  .windowrecords![index].url ??
                                              "",
                                          "size": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .litLeadSizeID
                                                  ?.id ??
                                              "",
                                          "source": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadSource
                                                  ?.id ??
                                              "",
                                          "sector": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .litIndustrySectorID
                                                  ?.id ??
                                              "",
                                          "campaign": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .cCampaignID
                                                  ?.id ??
                                              "",
                                          "address": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPLocationID
                                                  ?.identifier ??
                                              "",
                                          "salesRep": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID
                                                  ?.identifier ??
                                              ""
                                        });
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.windowrecords![index].name ??
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
                                        controller.trx.windowrecords![index]
                                                .leadStatus?.identifier ??
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
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPName !=
                                              null,
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Business Partner: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .bPName ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPLocationID !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                  )),
                                              Expanded(
                                                child: Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .bPLocationID
                                                        ?.identifier ??
                                                    ""),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .phone !=
                                              null,
                                          child: Row(
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
                                                          .windowrecords![index]
                                                          .phone ==
                                                      null) {
                                                    log("info button pressed");
                                                  } else {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .windowrecords![
                                                                index]
                                                            .phone
                                                            .toString());
                                                    controller
                                                        .createPhoneCallActivity(
                                                            controller
                                                                .trx
                                                                .windowrecords![
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .phone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .eMail !=
                                              null,
                                          child: Row(
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
                                                          .windowrecords![index]
                                                          .eMail ==
                                                      null) {
                                                    log("mail button pressed");
                                                  } else {
                                                    controller.writeMailTo(
                                                        controller
                                                            .trx
                                                            .windowrecords![
                                                                index]
                                                            .eMail
                                                            .toString());
                                                    controller
                                                        .createEmailActivity(
                                                            controller
                                                                .trx
                                                                .windowrecords![
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .eMail ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"SalesRep".tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .salesRepID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .windowrecords![index]
                                                  .latestJPToDoID !=
                                              null,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${'Latest Appointment'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            ._trx
                                                            .windowrecords![
                                                                index]
                                                            .latestJPToDoName ??
                                                        "",
                                                    style: TextStyle(
                                                        color: controller
                                                                    ._trx
                                                                    .windowrecords![
                                                                        index]
                                                                    .latestJPToDoStatus ==
                                                                'CO'
                                                            ? kNotifColor
                                                            : Colors.yellow),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .windowrecords![index]
                                                  .latestActivityID !=
                                              null,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${'Latest Activity'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            ._trx
                                                            .windowrecords![
                                                                index]
                                                            .latestActivityName ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: kNotifColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              tooltip: "Create Appointment".tr,
                                              onPressed: () {
                                                Get.to(const CreateLeadTasks(),
                                                    arguments: {
                                                      "leadId": controller
                                                          ._trx
                                                          .windowrecords![index]
                                                          .id,
                                                      "leadName": controller
                                                          ._trx
                                                          .windowrecords![index]
                                                          .name,
                                                      /* "bPartnerId": controller
                                                            ._trx
                                                            .records![index]
                                                            .cBPartnerID
                                                            ?.id ??
                                                        0, */
                                                    });
                                              },
                                              icon: const Icon(Icons.add_task),
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .windowrecords![index]
                                                      .cbPartnerID ==
                                                  null,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  controller.convertLead(index);
                                                },
                                                child: Text("Convert Lead".tr),
                                              ),
                                            ),
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
            desktopBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */

                //const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.windowrecords!.length,
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
                                      tooltip: 'Edit Lead'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
                                        Get.to(const EditLead(), arguments: {
                                          "id": controller
                                              .trx.windowrecords![index].id,
                                          "name": controller.trx
                                                  .windowrecords![index].name ??
                                              "",
                                          "description": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .description ??
                                              "",
                                          "note": controller.trx
                                                  .windowrecords![index].note ??
                                              "",
                                          "leadStatus": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadStatus
                                                  ?.id ??
                                              "",
                                          "bpName": controller
                                              .trx.windowrecords![index].bPName,
                                          "businessPartner": controller
                                              .trx
                                              .windowrecords![index]
                                              .cbPartnerID
                                              ?.identifier,
                                          "Tel": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .phone ??
                                              "",
                                          "eMail": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .eMail ??
                                              "",
                                          "url": controller.trx
                                                  .windowrecords![index].url ??
                                              "",
                                          "size": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .litLeadSizeID
                                                  ?.id ??
                                              "",
                                          "source": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadSource
                                                  ?.id ??
                                              "",
                                          "sector": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .litIndustrySectorID
                                                  ?.id ??
                                              "",
                                          "campaign": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .cCampaignID
                                                  ?.id ??
                                              "",
                                          "address": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPLocationID
                                                  ?.identifier ??
                                              "",
                                          "salesRep": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID
                                                  ?.identifier ??
                                              ""
                                        });
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.windowrecords![index].name ??
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
                                        controller.trx.windowrecords![index]
                                                .leadStatus?.identifier ??
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
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPName !=
                                              null,
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Business Partner: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .bPName ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .bPLocationID !=
                                              null,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                  )),
                                              Expanded(
                                                child: Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .bPLocationID
                                                        ?.identifier ??
                                                    ""),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .phone !=
                                              null,
                                          child: Row(
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
                                                          .windowrecords![index]
                                                          .phone ==
                                                      null) {
                                                    log("info button pressed");
                                                  } else {
                                                    controller.makePhoneCall(
                                                        controller
                                                            .trx
                                                            .windowrecords![
                                                                index]
                                                            .phone
                                                            .toString());
                                                    controller
                                                        .createPhoneCallActivity(
                                                            controller
                                                                .trx
                                                                .windowrecords![
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .phone ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .eMail !=
                                              null,
                                          child: Row(
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
                                                          .windowrecords![index]
                                                          .eMail ==
                                                      null) {
                                                    log("mail button pressed");
                                                  } else {
                                                    controller.writeMailTo(
                                                        controller
                                                            .trx
                                                            .windowrecords![
                                                                index]
                                                            .eMail
                                                            .toString());
                                                    controller
                                                        .createEmailActivity(
                                                            controller
                                                                .trx
                                                                .windowrecords![
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .eMail ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${"SalesRep".tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .salesRepID
                                                      ?.identifier ??
                                                  ""),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .windowrecords![index]
                                                  .latestJPToDoID !=
                                              null,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${'Latest Appointment'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            ._trx
                                                            .windowrecords![
                                                                index]
                                                            .latestJPToDoName ??
                                                        "",
                                                    style: TextStyle(
                                                        color: controller
                                                                    ._trx
                                                                    .windowrecords![
                                                                        index]
                                                                    .latestJPToDoStatus ==
                                                                'CO'
                                                            ? kNotifColor
                                                            : Colors.yellow),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  ._trx
                                                  .windowrecords![index]
                                                  .latestActivityID !=
                                              null,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${'Latest Activity'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            ._trx
                                                            .windowrecords![
                                                                index]
                                                            .latestActivityName ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: kNotifColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              tooltip: "Create Appointment".tr,
                                              onPressed: () {
                                                Get.to(const CreateLeadTasks(),
                                                    arguments: {
                                                      "leadId": controller
                                                          ._trx
                                                          .windowrecords![index]
                                                          .id,
                                                      "leadName": controller
                                                          ._trx
                                                          .windowrecords![index]
                                                          .name,
                                                      /* "bPartnerId": controller
                                                            ._trx
                                                            .records![index]
                                                            .cBPartnerID
                                                            ?.id ??
                                                        0, */
                                                    });
                                              },
                                              icon: const Icon(Icons.add_task),
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .windowrecords![index]
                                                      .cbPartnerID ==
                                                  null,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                ),
                                                onPressed: () async {
                                                  controller.convertLead(index);
                                                },
                                                child: Text("Convert Lead".tr),
                                              ),
                                            ),
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

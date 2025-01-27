library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/ticketsjson.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/tickettypejson.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/views/screens/ticketclient_create_ticket.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/views/screens/ticketclient_ticket_calendar.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/views/screens/ticketcliet_chat_ticket.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Internal_Ticket/views/screens/ticketinternal_image_ticket.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
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
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/ticketclient_ticket_binding.dart';

// controller
part '../../controllers/ticketclient_ticket_controller.dart';

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

class TicketClientTicketScreen extends GetView<TicketClientTicketController> {
  const TicketClientTicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('Dashboard'.tr);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: (ResponsiveBuilder.isDesktop(context))
            ? null
            : BottomAppBar(
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
                                  controller.getTickets();
                                },
                                child: Row(
                                  children: [
                                    //Icon(Icons.filter_alt),
                                    Obx(() => controller.dataAvailable
                                        ? Text("TICKETS: ".tr +
                                            controller.trx.rowcount.toString())
                                        : Text("TICKETS: ".tr)),
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
                                    controller.getTickets();
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
                                    controller.getTickets();
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
        floatingActionButton: (ResponsiveBuilder.isDesktop(context))
            ? null
            : SpeedDial(
                animatedIcon: AnimatedIcons.home_menu,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                /*  buttonSize: const Size(, 45),
        childrenButtonSize: const Size(45, 45), */
                children: [
                  /* SpeedDialChild(
                label: 'Filter'.tr,
                child: Obx(() => Icon(
                      MaterialSymbols.filter_alt_filled,
                      color: controller.businessPartnerId2.value == 0 &&
                              controller.dateStartValue.value == "" &&
                              controller.dateEndValue.value == ""
                          ? Colors.white
                          : kNotifColor,
                    )),
                onTap: () {
                  Get.to(() => const TicketInternalFilterTicket(), arguments: {
                    'businessPartnerId': controller.businessPartnerId2.value,
                    'businessPartnerName': controller.businessPartnerName,
                    'dateStart': controller.dateStartValue.value,
                    'dateEnd': controller.dateEndValue.value,
                  });
                }), */
                  SpeedDialChild(
                      label: 'New'.tr,
                      child: const Icon(Symbols.assignment_add),
                      onTap: () {
                        controller.openTicketType();
                      }),
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
                Obx(
                  () => controller.dataAvailable
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
                                        Icons.chat,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Open Chat'.tr,
                                      onPressed: () {
                                        Get.to(const TicketClientChat(),
                                            arguments: {
                                              "ticketid": controller
                                                  .trx.records![index].id
                                            });
                                        //log("info button pressed");
                                        /* Get.to(const EditLead(), arguments: {
                                          "id": controller
                                              .trx.windowrecords![index].id,
                                          "name": controller.trx
                                                  .windowrecords![index].name ??
                                              "",
                                          "leadStatus": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadStatus
                                                  ?.id ??
                                              "",
                                          "bpName": controller
                                              .trx.windowrecords![index].bPName,
                                          "Tel": controller.trx
                                                  .windowrecords![index].phone ??
                                              "",
                                          "eMail": controller.trx
                                                  .windowrecords![index].eMail ??
                                              "",
                                          "salesRep": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID
                                                  ?.identifier ??
                                              ""
                                        }); */
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${controller.trx.records![index].documentNo} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.trx.records![index].created!))}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .name ??
                                                  "???",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(Icons.linear_scale,
                                          color: controller.trx.records![index]
                                                  .rStatusID!.identifier!
                                                  .contains('NEW')
                                              ? Colors.yellow
                                              : controller
                                                          .trx
                                                          .records![index]
                                                          .rStatusID!
                                                          .identifier!
                                                          .contains('ODV') ||
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .rStatusID!
                                                          .identifier!
                                                          .contains('CONF') ||
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .rStatusID!
                                                          .identifier!
                                                          .contains('OK')
                                                  ? Colors.orange
                                                  : controller
                                                              .trx
                                                              .records![index]
                                                              .rStatusID!
                                                              .identifier!
                                                              .contains(
                                                                  'ASSIGN') ||
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .rStatusID!
                                                              .identifier!
                                                              .contains('WORKING')
                                                      ? kNotifColor
                                                      : controller.trx.records![index].rStatusID!.identifier!.contains('CLOSE99') || controller.trx.records![index].rStatusID!.identifier!.contains('CLOSE')
                                                          ? Colors.lightBlue
                                                          : Colors.white),
                                      Expanded(
                                        child: Text(
                                          controller.trx.records![index]
                                                  .rStatusID?.identifier ??
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
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${'Type'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .rRequestTypeID
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Summary'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .summary ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Priority'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .priority
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].mProductID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Product'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].cOrderID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'S. Order'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Flexible(
                                                child: TextButton(
                                                  onPressed: () {
                                                    Get.offNamed(
                                                        '/PortalMpSalesOrder',
                                                        arguments: {
                                                          'notificationId':
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .cOrderID
                                                                  ?.id
                                                        });
                                                  },
                                                  child: Text(
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cOrderID
                                                            ?.identifier ??
                                                        "N/A",
                                                    style: const TextStyle(
                                                        color: kNotifColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                  .trx
                                                  .records![index]
                                                  .rStatusID!
                                                  .identifier!
                                                  .contains('CONF'),
                                              child: IconButton(
                                                tooltip: 'Pending Confirm'.tr,
                                                icon: const Icon(
                                                  Icons.pending_actions,
                                                  color: Colors.yellow,
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .confirmCheckBoxValue
                                                      .value = false;
                                                  Get.defaultDialog(
                                                    title: 'Pending Confirm'.tr,
                                                    textConfirm: 'Proceed'.tr,
                                                    onCancel: () {},
                                                    onConfirm: () {
                                                      if (controller
                                                              .confirmCheckBoxValue
                                                              .value ==
                                                          true) {
                                                        controller
                                                            .confirmTicket(
                                                                index);
                                                        Get.back();
                                                      }
                                                    },
                                                    content: Column(
                                                      children: [
                                                        Visibility(
                                                          visible: controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .cOrderID !=
                                                              null,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: TextField(
                                                              minLines: 1,
                                                              maxLines: 3,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cOrderID
                                                                      ?.identifier),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .text_fields),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                labelText:
                                                                    'Sales Order'
                                                                        .tr,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID !=
                                                                  null &&
                                                              controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cOrderID ==
                                                                  null,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: TextField(
                                                              minLines: 1,
                                                              maxLines: 3,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID
                                                                      ?.identifier),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .text_fields),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                labelText:
                                                                    'Product'
                                                                        .tr,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID !=
                                                                  null &&
                                                              controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cOrderID ==
                                                                  null,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: TextField(
                                                              minLines: 1,
                                                              maxLines: 3,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .requestAmt
                                                                      .toString()),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .text_fields),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                labelText:
                                                                    'Amount'.tr,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Divider(),
                                                        Obx(
                                                          () =>
                                                              CheckboxListTile(
                                                            title: Text(
                                                                'Confirm Pending Action'
                                                                    .tr),
                                                            value: controller
                                                                .confirmCheckBoxValue
                                                                .value,
                                                            activeColor:
                                                                kPrimaryColor,
                                                            onChanged:
                                                                (bool? value) {
                                                              controller
                                                                  .confirmCheckBoxValue
                                                                  .value = value!;
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                          ),
                                                        ),
                                                        Divider(),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.event_note),
                                              onPressed: () {
                                                Get.to(
                                                    () =>
                                                        const TicketClientTicketCalendar(),
                                                    arguments: {
                                                      "requestId": controller
                                                          ._trx
                                                          .records![index]
                                                          .id
                                                    });
                                              },
                                            ),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.attach_file),
                                              onPressed: () {
                                                controller
                                                    .getTicketAttachment(index);
                                              },
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
                Obx(
                  () => controller.dataAvailable
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
                                        Icons.chat,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Open Chat'.tr,
                                      onPressed: () {
                                        Get.to(const TicketClientChat(),
                                            arguments: {
                                              "ticketid": controller
                                                  .trx.records![index].id
                                            });
                                        //log("info button pressed");
                                        /* Get.to(const EditLead(), arguments: {
                                          "id": controller
                                              .trx.windowrecords![index].id,
                                          "name": controller.trx
                                                  .windowrecords![index].name ??
                                              "",
                                          "leadStatus": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .leadStatus
                                                  ?.id ??
                                              "",
                                          "bpName": controller
                                              .trx.windowrecords![index].bPName,
                                          "Tel": controller.trx
                                                  .windowrecords![index].phone ??
                                              "",
                                          "eMail": controller.trx
                                                  .windowrecords![index].eMail ??
                                              "",
                                          "salesRep": controller
                                                  .trx
                                                  .windowrecords![index]
                                                  .salesRepID
                                                  ?.identifier ??
                                              ""
                                        }); */
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${controller.trx.records![index].documentNo} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.trx.records![index].created!))}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .name ??
                                                  "???",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(Icons.linear_scale,
                                          color: controller.trx.records![index]
                                                  .rStatusID!.identifier!
                                                  .contains('NEW')
                                              ? Colors.yellow
                                              : controller
                                                          .trx
                                                          .records![index]
                                                          .rStatusID!
                                                          .identifier!
                                                          .contains('ODV') ||
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .rStatusID!
                                                          .identifier!
                                                          .contains('CONF') ||
                                                      controller
                                                          .trx
                                                          .records![index]
                                                          .rStatusID!
                                                          .identifier!
                                                          .contains('OK')
                                                  ? Colors.orange
                                                  : controller
                                                              .trx
                                                              .records![index]
                                                              .rStatusID!
                                                              .identifier!
                                                              .contains(
                                                                  'ASSIGN') ||
                                                          controller
                                                              .trx
                                                              .records![index]
                                                              .rStatusID!
                                                              .identifier!
                                                              .contains('WORKING')
                                                      ? kNotifColor
                                                      : controller.trx.records![index].rStatusID!.identifier!.contains('CLOSE99') || controller.trx.records![index].rStatusID!.identifier!.contains('CLOSE')
                                                          ? Colors.lightBlue
                                                          : Colors.white),
                                      Expanded(
                                        child: Text(
                                          controller.trx.records![index]
                                                  .rStatusID?.identifier ??
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
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${'Type'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .rRequestTypeID
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Summary'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .summary ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Priority'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .priority
                                                      ?.identifier ??
                                                  ""),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].mProductID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'Product'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        ),
                                        Visibility(
                                          visible: controller.trx
                                                  .records![index].cOrderID !=
                                              null,
                                          child: Row(
                                            children: [
                                              Text(
                                                "${'S. Order'.tr}: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Flexible(
                                                child: TextButton(
                                                  onPressed: () {
                                                    Get.offNamed(
                                                        '/PortalMpSalesOrder',
                                                        arguments: {
                                                          'notificationId':
                                                              controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .cOrderID
                                                                  ?.id
                                                        });
                                                  },
                                                  child: Text(
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .cOrderID
                                                            ?.identifier ??
                                                        "N/A",
                                                    style: const TextStyle(
                                                        color: kNotifColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: controller
                                                  .trx
                                                  .records![index]
                                                  .rStatusID!
                                                  .identifier!
                                                  .contains('CONF'),
                                              child: IconButton(
                                                tooltip: 'Pending Confirm'.tr,
                                                icon: const Icon(
                                                  Icons.pending_actions,
                                                  color: Colors.yellow,
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .confirmCheckBoxValue
                                                      .value = false;
                                                  Get.defaultDialog(
                                                    title: 'Pending Confirm'.tr,
                                                    textConfirm: 'Proceed'.tr,
                                                    onCancel: () {},
                                                    onConfirm: () {
                                                      if (controller
                                                              .confirmCheckBoxValue
                                                              .value ==
                                                          true) {
                                                        controller
                                                            .confirmTicket(
                                                                index);
                                                        Get.back();
                                                      }
                                                    },
                                                    content: Column(
                                                      children: [
                                                        Visibility(
                                                          visible: controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .cOrderID !=
                                                              null,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: TextField(
                                                              minLines: 1,
                                                              maxLines: 3,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cOrderID
                                                                      ?.identifier),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .text_fields),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                labelText:
                                                                    'Sales Order'
                                                                        .tr,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID !=
                                                                  null &&
                                                              controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cOrderID ==
                                                                  null,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: TextField(
                                                              minLines: 1,
                                                              maxLines: 3,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID
                                                                      ?.identifier),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .text_fields),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                labelText:
                                                                    'Product'
                                                                        .tr,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .mProductID !=
                                                                  null &&
                                                              controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cOrderID ==
                                                                  null,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: TextField(
                                                              minLines: 1,
                                                              maxLines: 3,
                                                              readOnly: true,
                                                              controller: TextEditingController(
                                                                  text: controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .requestAmt
                                                                      .toString()),
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                prefixIcon:
                                                                    const Icon(Icons
                                                                        .text_fields),
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                labelText:
                                                                    'Amount'.tr,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Divider(),
                                                        Obx(
                                                          () =>
                                                              CheckboxListTile(
                                                            title: Text(
                                                                'Confirm Pending Action'
                                                                    .tr),
                                                            value: controller
                                                                .confirmCheckBoxValue
                                                                .value,
                                                            activeColor:
                                                                kPrimaryColor,
                                                            onChanged:
                                                                (bool? value) {
                                                              controller
                                                                  .confirmCheckBoxValue
                                                                  .value = value!;
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                          ),
                                                        ),
                                                        Divider(),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.event_note),
                                              onPressed: () {
                                                Get.to(
                                                    () =>
                                                        const TicketClientTicketCalendar(),
                                                    arguments: {
                                                      "requestId": controller
                                                          ._trx
                                                          .records![index]
                                                          .id
                                                    });
                                              },
                                            ),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.attach_file),
                                              onPressed: () {
                                                controller
                                                    .getTicketAttachment(index);
                                              },
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
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: kSpacing),
                          _buildHeaderDesktop(),
                          //const SizedBox(height: kSpacing * 2),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Row(
                              children: [
                                Obx(
                                  () => Visibility(
                                    visible: controller.showLines.value,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.showLines.value = false;
                                          controller.showHeader.value = true;
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.chevron_left),
                                            Text('Back'.tr),
                                          ],
                                        )),
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: controller.showLines.value,
                                    child: IconButton(
                                      onPressed: () {
                                        Get.to(const TicketClientChat(),
                                            arguments: {
                                              "ticketid": controller.requestId,
                                            });
                                      },
                                      icon: Icon(Icons.message,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: controller.showLines.value,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller.checkcloseTicket(
                                              controller.requestId);
                                        },
                                        child: Text("Close Ticket".tr)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.showHeader.value,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: StaggeredGrid.count(
                                  crossAxisCount: 9,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 2,
                                  children: [
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 9,
                                      mainAxisCellCount: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        controller
                                                            .getTicketsDesktop();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          //Icon(Icons.filter_alt),
                                                          Obx(() => controller
                                                                  ._desktopDataAvailable
                                                                  .value
                                                              ? Text("TICKET: "
                                                                      .tr +
                                                                  controller
                                                                      ._trxDesktop
                                                                      .rowcount
                                                                      .toString())
                                                              : Text("TICKET: "
                                                                  .tr)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.assignment_add,
                                                      color: Colors.white,
                                                    ),
                                                    tooltip: 'New'.tr,
                                                    onPressed: () {
                                                      controller
                                                          .openTicketType();
                                                    },
                                                  ),
                                                  /* Container(
                                                    width: 200,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: TextField(
                                                      controller: controller
                                                          .desktopDocNosearchFieldController,
                                                      onSubmitted: (value) {
                                                        controller
                                                            .getTicketsDesktop();
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Document N°'.tr,
                                                        //filled: true,
                                                        border:
                                                            const OutlineInputBorder(),
                                                        prefixIcon: const Icon(
                                                            EvaIcons.search),
                                                        isDense: true,
                                                      ),
                                                      minLines: 1,
                                                      maxLines: 1,
                                                    ),
                                                  ), */
                                                ],
                                              )
                                            ],
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        if (controller
                                                                .desktopPagesCount >
                                                            1) {
                                                          controller
                                                              .desktopPagesCount
                                                              .value -= 1;
                                                          controller
                                                              .getTicketsDesktop();
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.skip_previous),
                                                    ),
                                                    Obx(() => Text(
                                                        "${controller.desktopPagesCount.value}/${controller.desktopPagesTot.value}")),
                                                    IconButton(
                                                      onPressed: () {
                                                        if (controller
                                                                .desktopPagesCount <
                                                            controller
                                                                .desktopPagesTot
                                                                .value) {
                                                          controller
                                                              .desktopPagesCount
                                                              .value += 1;
                                                          controller
                                                              .getTicketsDesktop();
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.skip_next),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 9,
                                      mainAxisCellCount: 5,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Obx(
                                          () => controller
                                                  ._desktopDataAvailable.value
                                              ? DataTable(
                                                  columns: <DataColumn>[
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Status',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Document N°',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Summary'.tr,
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: controller.headerRows,
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.linesDataAvailable.value &&
                                  controller.showLines.value,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: StaggeredGrid.count(
                                  crossAxisCount: 9,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 2,
                                  children: [
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 3,
                                      mainAxisCellCount: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: controller
                                                  .desktopDocNoFieldController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                prefixIcon: const Icon(
                                                    Icons.text_fields),
                                                border:
                                                    const OutlineInputBorder(),
                                                labelText: 'Document N°'.tr,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                              ),
                                              minLines: 1,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: controller
                                                  .desktopDocTypeFieldController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                prefixIcon: const Icon(
                                                    Icons.text_fields),
                                                border:
                                                    const OutlineInputBorder(),
                                                labelText: 'Document Status'.tr,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                              ),
                                              minLines: 1,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: controller
                                                  .desktopAssignedToFieldController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                prefixIcon: const Icon(
                                                    Icons.text_fields),
                                                border:
                                                    const OutlineInputBorder(),
                                                labelText: 'Assigned To'.tr,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                              ),
                                              minLines: 1,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 3,
                                      mainAxisCellCount: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: controller
                                                  .desktopNameFieldController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                prefixIcon: const Icon(
                                                    Icons.text_fields),
                                                border:
                                                    const OutlineInputBorder(),
                                                labelText: 'Title'.tr,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                              ),
                                              minLines: 1,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: controller
                                                  .desktopDescriptionFieldController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                prefixIcon: const Icon(
                                                    Icons.text_fields),
                                                border:
                                                    const OutlineInputBorder(),
                                                labelText: 'Description'.tr,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                              ),
                                              minLines: 1,
                                              maxLines: 4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 3,
                                      mainAxisCellCount: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: controller
                                                  .desktopDateFromFieldController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                prefixIcon:
                                                    const Icon(Icons.event),
                                                border:
                                                    const OutlineInputBorder(),
                                                labelText: 'Date'.tr,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                              ),
                                              minLines: 1,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        if (controller
                                                                .desktopLinePagesCount >
                                                            1) {
                                                          controller
                                                              .desktopLinePagesCount
                                                              .value -= 1;
                                                          controller
                                                              .getTicketLineDesktop();
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.skip_previous),
                                                    ),
                                                    Obx(() => Text(
                                                        "${controller.desktopLinePagesCount.value}/${controller.desktopLinePagesTot.value}")),
                                                    IconButton(
                                                      onPressed: () {
                                                        if (controller
                                                                .desktopLinePagesCount <
                                                            controller
                                                                .desktopLinePagesTot
                                                                .value) {
                                                          controller
                                                              .desktopLinePagesCount
                                                              .value += 1;
                                                          controller
                                                              .getTicketLineDesktop();
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.skip_next),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 9,
                                      mainAxisCellCount: 4,
                                      child: Obx(
                                        () => controller
                                                ._desktopDataAvailable.value
                                            ? DataTable(
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Name'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Description'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Date'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                rows: controller.lineRows,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /*_buildProgress(),
                      const SizedBox(height: kSpacing * 2),
                      const SizedBox(height: kSpacing * 2),
                      const SizedBox(height: kSpacing), */
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing / 2),
                        _buildProfile(data: controller.getProfil()),
                        const Divider(thickness: 1),
                        const SizedBox(height: kSpacing),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
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
            children: [
              Expanded(
                child: _Header(
                  buttonList: TypeJson.fromJson({
                    "types": [
                      {"id": "0", "name": "No Filter".tr},
                    ]
                  }).types,
                  dropDownValue: controller.quickFilterDropdownValue,
                  onChanged: controller.setQuickFilterValue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDesktop({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Header(
                  buttonList: TypeJson.fromJson({
                    "types": [
                      {"id": "0", "name": "No Filter".tr},
                    ]
                  }).types,
                  dropDownValue: controller.quickFilterDropdownValue,
                  onChanged: controller.setQuickFilterValue,
                ),
              ),
            ],
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
}

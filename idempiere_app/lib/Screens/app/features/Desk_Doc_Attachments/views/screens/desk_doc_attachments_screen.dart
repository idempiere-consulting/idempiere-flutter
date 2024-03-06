// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/models/contract_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/views/screens/crm_contract_filter_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/views/screens/crm_edit_contract.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract_Line/models/contract_line_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/models/doc_attachments_json.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_filter_screen.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_image.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_video.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_view_attachment.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/models/attachment_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/models/courseparticipant_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/courselist_json.dart';
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
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';

// binding
part '../../bindings/desk_doc_attachments_binding.dart';

// controller
part '../../controllers/desk_doc_attachments_controller.dart';

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

class DeskDocAttachmentsScreen extends GetView<DeskDocAttachmentsController> {
  const DeskDocAttachmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
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
                                  controller.getDocs();
                                },
                                child: Row(
                                  children: [
                                    //Icon(Icons.filter_alt),
                                    Obx(() => controller.dataAvailable
                                        ? Text("DOCUMENTS: ".tr +
                                            controller.trx.rowcount.toString())
                                        : Text("DOCUMENTS: ".tr)),
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
                                    controller.getDocs();
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
                                    controller.getDocs();
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
                  SpeedDialChild(
                      label: 'Filter'.tr,
                      child: Obx(() => Icon(
                            Symbols.filter_alt,
                            color: controller.businessPartnerId.value == 0 &&
                                    controller.docNoValue.value == "" &&
                                    controller.docTypeId.value == "0"
                                ? Colors.white
                                : kNotifColor,
                          )),
                      onTap: () {
                        Get.to(() => const DeskDocAttachmentsFilter(),
                            arguments: {
                              'businessPartnerId':
                                  controller.businessPartnerId.value,
                              'businessPartnerName':
                                  controller.businessPartnerName,
                              'docNo': controller.docNoValue.value,
                              "docTypeId": controller.docTypeId.value,
                            });
                      }),
                ],
              ),
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
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(
                              () => Visibility(
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
                                        : controller.dropdownValue.value == "2"
                                            ? controller.trx.records![index]
                                                .cBPartnerID!.identifier
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
                                        color: Color.fromRGBO(64, 75, 96, .9)),
                                    child: ExpansionTile(
                                      trailing: IconButton(
                                        tooltip: 'Attachments'.tr,
                                        icon: const Icon(
                                          Icons.article,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          Get.to(
                                              () =>
                                                  const DeskDocAttachmentsViewAttachmentScreen(),
                                              arguments: {
                                                "recordId": controller.trx
                                                    .records![index].recordID,
                                                "tableName": controller
                                                    .trx.records![index].name,
                                              });
                                        },
                                      ),
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
                                            Symbols.attach_file_add,
                                            color: kNotifColor,
                                          ),
                                          tooltip: 'Attach'.tr,
                                          onPressed: () {
                                            controller.attachFile(index);
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller.trx.records![index].name!.tr,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                      subtitle: Column(
                                        children: [
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              const Icon(
                                                  Symbols.quick_reference,
                                                  color: Colors.white),
                                              Expanded(
                                                child: Text(
                                                  controller.trx.records![index]
                                                      .documentNo!,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.handshake,
                                                  color: Colors.white),
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
                                            IconButton(
                                                onPressed: () {
                                                  Get.to(
                                                      () => const VideoApp());
                                                },
                                                icon: Icon(
                                                    Symbols.video_camera_front))
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
                          itemCount: controller.trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(
                              () => Visibility(
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
                                        : controller.dropdownValue.value == "2"
                                            ? controller.trx.records![index]
                                                .cBPartnerID!.identifier
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
                                        color: Color.fromRGBO(64, 75, 96, .9)),
                                    child: ExpansionTile(
                                      trailing: IconButton(
                                        tooltip: 'Attachments'.tr,
                                        icon: const Icon(
                                          Icons.article,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          Get.to(
                                              () =>
                                                  const DeskDocAttachmentsViewAttachmentScreen(),
                                              arguments: {
                                                "recordId": controller.trx
                                                    .records![index].recordID,
                                                "tableName": controller
                                                    .trx.records![index].name,
                                              });
                                        },
                                      ),
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
                                            Symbols.attach_file_add,
                                            color: kNotifColor,
                                          ),
                                          tooltip: 'Attach'.tr,
                                          onPressed: () {
                                            controller.attachFile(index);
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller.trx.records![index].name!.tr,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                      subtitle: Column(
                                        children: [
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              const Icon(
                                                  Symbols.quick_reference,
                                                  color: Colors.white),
                                              Expanded(
                                                child: Text(
                                                  controller.trx.records![index]
                                                      .documentNo!,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.handshake,
                                                  color: Colors.white),
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
                                            IconButton(
                                                onPressed: () {
                                                  Get.to(
                                                      () => const VideoApp());
                                                },
                                                icon: Icon(
                                                    Symbols.video_camera_front))
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
                          child:
                              _Sidebar(data: controller.getSelectedProject())),
                    ),
                    Flexible(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: kSpacing),
                            _buildHeader(),
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
                                                              .getDocsDesktop();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            //Icon(Icons.filter_alt),
                                                            Obx(() => controller
                                                                    ._desktopDataAvailable
                                                                    .value
                                                                ? Text("DOCUMENTS: "
                                                                        .tr +
                                                                    controller
                                                                        ._trxDesktop
                                                                        .rowcount
                                                                        .toString())
                                                                : Text(
                                                                    "DOCUMENTS: "
                                                                        .tr)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: TextField(
                                                        controller: controller
                                                            .desktopDocNosearchFieldController,
                                                        onSubmitted: (value) {
                                                          controller
                                                              .getDocsDesktop();
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Document N°'.tr,
                                                          //filled: true,
                                                          border:
                                                              const OutlineInputBorder(),
                                                          prefixIcon:
                                                              const Icon(
                                                                  EvaIcons
                                                                      .search),
                                                          isDense: true,
                                                        ),
                                                        minLines: 1,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: InputDecorator(
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Document Type'
                                                                  .tr,
                                                          //filled: true,
                                                          border: const OutlineInputBorder(
                                                              /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                                              ),
                                                          prefixIcon:
                                                              const Icon(
                                                                  EvaIcons
                                                                      .list),
                                                          //hintText: "search..",
                                                          isDense: true,
                                                          //fillColor: Theme.of(context).cardColor,
                                                        ),
                                                        child: Obx(
                                                          () => DropdownButton(
                                                            isDense: true,
                                                            underline:
                                                                const SizedBox(),
                                                            hint: Text(
                                                                "Select a Document Type"
                                                                    .tr),
                                                            isExpanded: true,
                                                            value: controller
                                                                        .desktopDocTypeId
                                                                        .value ==
                                                                    ""
                                                                ? null
                                                                : controller
                                                                    .desktopDocTypeId
                                                                    .value,
                                                            elevation: 16,
                                                            onChanged:
                                                                (newValue) {
                                                              controller
                                                                      .desktopDocTypeId
                                                                      .value =
                                                                  newValue
                                                                      as String;
                                                              controller
                                                                  .getDocsDesktop();
                                                              //print(dropdownValue);
                                                            },
                                                            items: controller
                                                                .getTypes()!
                                                                .map((list) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: list.id
                                                                    .toString(),
                                                                child: Text(
                                                                  list.name
                                                                      .toString(),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                                .getDocsDesktop();
                                                          }
                                                        },
                                                        icon: const Icon(Icons
                                                            .skip_previous),
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
                                                                .getDocsDesktop();
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
                                                            'Window'.tr,
                                                            style: const TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Text(
                                                            'Document N°'.tr,
                                                            style: const TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Text(
                                                            'Business Partner'
                                                                .tr,
                                                            style: const TextStyle(
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
                                                  //isDense: true,
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
                                                maxLines: 4,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextField(
                                                controller: controller
                                                    .desktopDocTypeFieldController,
                                                decoration: InputDecoration(
                                                  //isDense: true,
                                                  //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                  prefixIcon: const Icon(
                                                      Icons.text_fields),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Document Type'.tr,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                ),
                                                minLines: 1,
                                                maxLines: 4,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextField(
                                                controller: controller
                                                    .desktopBusinessPartnerFieldController,
                                                decoration: InputDecoration(
                                                  //isDense: true,
                                                  //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                  prefixIcon: const Icon(
                                                      Icons.handshake),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText:
                                                      'Business Partner'.tr,
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
                                                    .desktopNameFieldController,
                                                decoration: InputDecoration(
                                                  //isDense: true,
                                                  //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                  prefixIcon: const Icon(
                                                      Icons.text_fields),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Name'.tr,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                ),
                                                minLines: 2,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextField(
                                                controller: controller
                                                    .desktopDescriptionFieldController,
                                                decoration: InputDecoration(
                                                  //isDense: true,
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
                                                minLines: 5,
                                                maxLines: 5,
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
                                                  //isDense: true,
                                                  //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                  prefixIcon:
                                                      const Icon(Icons.event),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Date From'.tr,
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
                                                    .desktopDateToFieldController,
                                                decoration: InputDecoration(
                                                  //isDense: true,
                                                  //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                  prefixIcon:
                                                      const Icon(Icons.event),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Date To'.tr,
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
                                                    .desktopFrequencyFieldController,
                                                decoration: InputDecoration(
                                                  //isDense: true,
                                                  //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                                  prefixIcon: const Icon(
                                                      Icons.timelapse),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Frequency'.tr,
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
                                                                .getContractLineDesktop();
                                                          }
                                                        },
                                                        icon: const Icon(Icons
                                                            .skip_previous),
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
                                                                .getContractLineDesktop();
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
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'U.o.M.'.tr,
                                                          style: const TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Quantity'.tr,
                                                          style: const TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                        child: Text(
                                                          'Amount'.tr,
                                                          style: const TextStyle(
                                                              fontStyle:
                                                                  FontStyle
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
                          Obx(
                            () => Visibility(
                              visible: controller.selectedDocumentId.value != 0,
                              child: Container(
                                height: 400,
                                margin: const EdgeInsets.only(
                                    top: kSpacing, left: 5, right: 5),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: kSpacing,
                                          top: kSpacing,
                                          bottom: 5,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Attachments".tr}:    ".tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      controller
                                                          .desktopAttachFile();
                                                    },
                                                    child: const Icon(Symbols
                                                        .attach_file_add)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                              .participantsDataAvailable.value,
                                          replacement: const Divider(),
                                          child: Expanded(
                                            child: ListView.builder(
                                                //shrinkWrap: true,
                                                itemCount: controller
                                                    ._attachmentsDesktop
                                                    .attachments!
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal:
                                                                kSpacing),
                                                    title: Text(
                                                      controller
                                                              ._attachmentsDesktop
                                                              .attachments![
                                                                  index]
                                                              .name ??
                                                          'N/A',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      final ip = GetStorage()
                                                          .read('ip');
                                                      String authorization =
                                                          'Bearer ${GetStorage().read('token')}';
                                                      final protocol =
                                                          GetStorage()
                                                              .read('protocol');
                                                      var url = Uri.parse(
                                                          '$protocol://$ip/api/v1/models/${controller.selectedDocumentTable}/${controller.selectedDocumentId}/attachments/${controller._attachmentsDesktop.attachments![index].name!}');
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
                                                      if (response.statusCode ==
                                                          200) {
                                                        if (controller
                                                                ._attachmentsDesktop
                                                                .attachments![
                                                                    index]
                                                                .contentType! ==
                                                            "application/pdf") {
                                                          final bytes = response
                                                              .bodyBytes;

                                                          if (Platform
                                                              .isAndroid) {
                                                            await Printing.layoutPdf(
                                                                onLayout:
                                                                    (PdfPageFormat
                                                                            format) async =>
                                                                        bytes);
                                                          } else {
                                                            final dir =
                                                                await getApplicationDocumentsDirectory();
                                                            final file = File(
                                                                '${dir.path}/${controller._attachmentsDesktop.attachments![index].name!}');
                                                            await file
                                                                .writeAsBytes(
                                                                    bytes,
                                                                    flush:
                                                                        true);
                                                            await launchUrl(
                                                                Uri.parse(
                                                                    'file://${'${dir.path}/${controller._attachmentsDesktop.attachments![index].name!}'}'),
                                                                mode: LaunchMode
                                                                    .externalNonBrowserApplication);
                                                          }
                                                        }

                                                        if (controller
                                                                ._attachmentsDesktop
                                                                .attachments![
                                                                    index]
                                                                .contentType! ==
                                                            "image/jpeg") {
                                                          var image64 = base64
                                                              .encode(response
                                                                  .bodyBytes);
                                                          Get.to(
                                                              const DeskDocAttachmentsImage(),
                                                              arguments: {
                                                                "base64":
                                                                    image64
                                                              });
                                                        }
                                                      } else {
                                                        print(response.body);
                                                      }
                                                    },
                                                    trailing: IconButton(
                                                      onPressed: () async {
                                                        controller
                                                            .desktopDeleteAttachedFile(
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                        Symbols.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                          ),
                        ],
                      ),
                    )
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

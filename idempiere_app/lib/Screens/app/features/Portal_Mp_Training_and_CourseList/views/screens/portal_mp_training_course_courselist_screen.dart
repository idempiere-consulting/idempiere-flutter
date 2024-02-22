// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/models/contract_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract_Line/models/contract_line_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/models/attachment_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/models/archive_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/models/courseparticipant_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/models/trainingcourse_student_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/views/screens/portal_mp_training_course_courselist_filter_screen.dart';
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
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/portal_mp_training_course_courselist_binding.dart';

// controller
part '../../controllers/portal_mp_training_course_courselist_controller.dart';

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

class PortalMpTrainingCourseCourseListScreen
    extends GetView<PortalMpTrainingCourseCourseListController> {
  const PortalMpTrainingCourseCourseListScreen({Key? key}) : super(key: key);

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
                                  controller.getContracts();
                                },
                                child: Row(
                                  children: [
                                    //Icon(Icons.filter_alt),
                                    Obx(() => controller.dataAvailable
                                        ? Text("CONTRACTS: ".tr +
                                            controller.trx.rowcount.toString())
                                        : Text("CONTRACTS: ".tr)),
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
                                    controller.getContracts();
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
                                    controller.getContracts();
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
                            color: controller.docNoValue.value == "" &&
                                    controller.docTypeId.value == "0"
                                ? Colors.white
                                : kNotifColor,
                          )),
                      onTap: () {
                        Get.to(const PortalMPFilterCourseList(), arguments: {
                          'docNo': controller.docNoValue.value,
                          "docTypeId": controller.docTypeId.value,
                        });
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
                                        icon: const Icon(
                                          Icons.article,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          Get.toNamed('/ContractLine',
                                              arguments: {
                                                "id": controller
                                                    .trx.records![index].id,
                                                "bPartner": controller
                                                    .trx
                                                    .records![index]
                                                    .cBPartnerID
                                                    ?.identifier,
                                                "bPartnerId": controller
                                                    .trx
                                                    .records![index]
                                                    .cBPartnerID
                                                    ?.id,
                                                "docNo": controller.trx
                                                    .records![index].documentNo,
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
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                          tooltip: 'Edit Contract'.tr,
                                          onPressed: () {
                                            //log("info button pressed");
                                            /*  Get.to(const PortalMPEditContract(),
                                                arguments: {
                                                  "id": controller
                                                      .trx.records![index].id,
                                                  "name": controller
                                                          .trx
                                                          .records![index]
                                                          .name ??
                                                      "",
                                                  "docNo": controller
                                                          .trx
                                                          .records![index]
                                                          .documentNo ??
                                                      "",
                                                  "businessPartnerId":
                                                      controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerID
                                                              ?.id ??
                                                          0,
                                                  "businessPartnerName":
                                                      controller
                                                              .trx
                                                              .records![index]
                                                              .cBPartnerID
                                                              ?.identifier ??
                                                          "",
                                                  "description": controller
                                                      .trx
                                                      .records![index]
                                                      .description,
                                                  "dateFrom": controller
                                                      .trx
                                                      .records![index]
                                                      .validfromdate,
                                                  "dateTo": controller
                                                      .trx
                                                      .records![index]
                                                      .validtodate,
                                                  "frequencyTypeId": controller
                                                          .trx
                                                          .records![index]
                                                          .frequencyType
                                                          ?.id ??
                                                      "0",
                                                  "paymentTermId": controller
                                                      ._trx
                                                      .records![index]
                                                      .cPaymentTermID
                                                      ?.id,
                                                  "paymentRuleId": controller
                                                      ._trx
                                                      .records![index]
                                                      .paymentRule
                                                      ?.id,
                                                  "frequencyNextDate":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .frequencyNextDate,
                                                }); */
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller.trx.records![index]
                                                .documentNo ??
                                            "???",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              const Icon(Symbols.topic,
                                                  color: Colors.white),
                                              Expanded(
                                                child: Text(
                                                  controller
                                                          .trx
                                                          .records![index]
                                                          .cDocTypeTargetID
                                                          ?.identifier ??
                                                      "??",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Name".tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          .trx
                                                          .records![index]
                                                          .name ??
                                                      ""),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Description".tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          .trx
                                                          .records![index]
                                                          .name ??
                                                      ""),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Validity Date from".tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .validfromdate!
                                                      .substring(0, 10)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Validity Date to".tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                      .trx
                                                      .records![index]
                                                      .validtodate!
                                                      .substring(0, 10)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Frequency".tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          .trx
                                                          .records![index]
                                                          .frequencyType
                                                          ?.identifier ??
                                                      ""),
                                                ),
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
            tabletBuilder: (context, constraints) {
              return Column(children: const []);
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
                                                            .getCourseListsDesktop();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          //Icon(Icons.filter_alt),
                                                          Obx(() => controller
                                                                  ._desktopDataAvailable
                                                                  .value
                                                              ? Text("COURSES: "
                                                                      .tr +
                                                                  controller
                                                                      ._trxDesktop
                                                                      .rowcount
                                                                      .toString())
                                                              : Text("COURSES: "
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
                                                            .getCourseListsDesktop();
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
                                                  ),
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
                                                              .getCourseListsDesktop();
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
                                                              .getCourseListsDesktop();
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
                                                          'Course N°'.tr,
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
                                                          'Date'.tr,
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
                                                          'Description'.tr,
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
                                                prefixIcon:
                                                    const Icon(Icons.handshake),
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
                                                prefixIcon:
                                                    const Icon(Icons.timelapse),
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
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'U.o.M.'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Quantity'.tr,
                                                        style: const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Expanded(
                                                      child: Text(
                                                        'Amount'.tr,
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
                        Obx(
                          () => Visibility(
                            visible:
                                controller.desktopSelectedMaintainID.value != 0,
                            child: Container(
                              height: 250,
                              margin: const EdgeInsets.only(
                                  top: kSpacing, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                "${"Participants".tr}:    ".tr,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    controller
                                                        .desktopParticipantNameFieldController
                                                        .text = "";
                                                    controller
                                                        .desktopParticipantSurnameFieldController
                                                        .text = "";

                                                    controller
                                                        .desktopParticipantBirthPlaceFieldController
                                                        .text = "";
                                                    controller
                                                        .desktopParticipantBirthDateFieldController
                                                        .text = "";

                                                    controller
                                                        .desktopParticipantEmailFieldController
                                                        .text = "";

                                                    controller
                                                        .desktopParticipantRoleFieldController
                                                        .text = "";
                                                    controller
                                                        .desktopParticipantNationalIDNumberFieldController
                                                        .text = "";
                                                    controller
                                                        .desktopIsConfirmedCheckBox
                                                        .value = false;
                                                    Get.defaultDialog(
                                                        title:
                                                            'Insert Participant'
                                                                .tr,
                                                        onConfirm: () {
                                                          controller
                                                              .insertParticipantDesktop();
                                                        },
                                                        onCancel: () {},
                                                        content: Column(
                                                          children: [
                                                            TextField(
                                                              controller: controller
                                                                  .desktopParticipantNameFieldController,
                                                              minLines: 1,
                                                              maxLines: 1,
                                                              //onTap: () {},
                                                              //onSubmitted: (String? value) {},
                                                              decoration:
                                                                  InputDecoration(
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                                labelText:
                                                                    'Name'.tr,
                                                                labelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                //hintText: 'Description..'.tr,
                                                                filled: true,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                ),
                                                                isDense: true,
                                                                fillColor: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantSurnameFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Surname'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantBirthPlaceFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Birth Place'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child:
                                                                  DateTimePicker(
                                                                locale: Locale(
                                                                    'languageCalendar'
                                                                        .tr),
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Birth Date'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                                type:
                                                                    DateTimePickerType
                                                                        .date,
                                                                initialValue:
                                                                    controller
                                                                        .desktopParticipantBirthDateFieldController
                                                                        .text,
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100),
                                                                //dateLabelText: 'Ship Date'.tr,
                                                                //icon: const Icon(Icons.event),
                                                                onChanged:
                                                                    (val) {
                                                                  //print(DateTime.parse(val));
                                                                  //print(val);

                                                                  controller
                                                                          .desktopParticipantBirthDateFieldController
                                                                          .text =
                                                                      val.substring(
                                                                          0,
                                                                          10);

                                                                  //print(date);
                                                                },
                                                                validator:
                                                                    (val) {
                                                                  //print(val);
                                                                  return null;
                                                                },
                                                                // ignore: avoid_print
                                                                onSaved: (val) =>
                                                                    print(val),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantEmailFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Email'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantRoleFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Work Role'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantNationalIDNumberFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Tax ID Code'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Obx(
                                                              () =>
                                                                  CheckboxListTile(
                                                                title: Text(
                                                                    'Confirmed'
                                                                        .tr),
                                                                value: controller
                                                                    .desktopIsConfirmedCheckBox
                                                                    .value,
                                                                activeColor:
                                                                    kPrimaryColor,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  controller
                                                                      .desktopIsConfirmedCheckBox
                                                                      .value = value!;
                                                                },
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                              ),
                                                            ),
                                                          ],
                                                        ));
                                                  },
                                                  child:
                                                      const Icon(Symbols.add)),
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
                                                  ._participantDesktop
                                                  .records!
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: kSpacing),
                                                  title: Text(
                                                    "${controller._participantDesktop.records![index].name ?? 'N/A'} ${controller._participantDesktop.records![index].surName ?? 'N/A'}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: controller
                                                              ._participantDesktop
                                                              .records![index]
                                                              .isConfirmed!
                                                          ? kNotifColor
                                                          : Colors.yellow,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    controller
                                                        .desktopParticipantNameFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .name ??
                                                        '';
                                                    controller
                                                        .desktopParticipantSurnameFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .surName ??
                                                        '';

                                                    controller
                                                        .desktopParticipantBirthPlaceFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .birthCity ??
                                                        '';
                                                    controller
                                                        .desktopParticipantBirthDateFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .birthday ??
                                                        '';

                                                    controller
                                                        .desktopParticipantEmailFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .eMailUser ??
                                                        '';

                                                    controller
                                                        .desktopParticipantRoleFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .description ??
                                                        '';
                                                    controller
                                                        .desktopParticipantNationalIDNumberFieldController
                                                        .text = controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .note ??
                                                        '';
                                                    controller
                                                            .desktopIsConfirmedCheckBox
                                                            .value =
                                                        controller
                                                            ._participantDesktop
                                                            .records![index]
                                                            .isConfirmed!;
                                                    Get.defaultDialog(
                                                        title:
                                                            'Edit Participant'
                                                                .tr,
                                                        onConfirm: () {
                                                          controller
                                                              .editParticipantDesktop(
                                                                  controller
                                                                      ._participantDesktop
                                                                      .records![
                                                                          index]
                                                                      .id!);
                                                        },
                                                        onCancel: () {},
                                                        content: Column(
                                                          children: [
                                                            TextField(
                                                              controller: controller
                                                                  .desktopParticipantNameFieldController,
                                                              minLines: 1,
                                                              maxLines: 1,
                                                              //onTap: () {},
                                                              //onSubmitted: (String? value) {},
                                                              decoration:
                                                                  InputDecoration(
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                                labelText:
                                                                    'Name'.tr,
                                                                labelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                //hintText: 'Description..'.tr,
                                                                filled: true,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                ),
                                                                isDense: true,
                                                                fillColor: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantSurnameFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Surname'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantBirthPlaceFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Birth Place'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child:
                                                                  DateTimePicker(
                                                                locale: Locale(
                                                                    'languageCalendar'
                                                                        .tr),
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Birth Date'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                                type:
                                                                    DateTimePickerType
                                                                        .date,
                                                                initialValue:
                                                                    controller
                                                                        .desktopParticipantBirthDateFieldController
                                                                        .text,
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100),
                                                                //dateLabelText: 'Ship Date'.tr,
                                                                //icon: const Icon(Icons.event),
                                                                onChanged:
                                                                    (val) {
                                                                  //print(DateTime.parse(val));
                                                                  //print(val);

                                                                  controller
                                                                          .desktopParticipantBirthDateFieldController
                                                                          .text =
                                                                      val.substring(
                                                                          0,
                                                                          10);

                                                                  //print(date);
                                                                },
                                                                validator:
                                                                    (val) {
                                                                  //print(val);
                                                                  return null;
                                                                },
                                                                // ignore: avoid_print
                                                                onSaved: (val) =>
                                                                    print(val),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantEmailFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Email'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantRoleFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Work Role'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: TextField(
                                                                controller:
                                                                    controller
                                                                        .desktopParticipantNationalIDNumberFieldController,
                                                                minLines: 1,
                                                                maxLines: 1,
                                                                //onTap: () {},
                                                                //onSubmitted: (String? value) {},
                                                                decoration:
                                                                    InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .always,
                                                                  labelText:
                                                                      'Tax ID Code'
                                                                          .tr,
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                  //hintText: 'Description..'.tr,
                                                                  filled: true,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                  isDense: true,
                                                                  fillColor: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Obx(
                                                              () =>
                                                                  CheckboxListTile(
                                                                title: Text(
                                                                    'Confirmed'
                                                                        .tr),
                                                                value: controller
                                                                    .desktopIsConfirmedCheckBox
                                                                    .value,
                                                                activeColor:
                                                                    kPrimaryColor,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  controller
                                                                      .desktopIsConfirmedCheckBox
                                                                      .value = value!;
                                                                },
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                              ),
                                                            ),
                                                          ],
                                                        ));
                                                  },
                                                  trailing: IconButton(
                                                    onPressed: () async {
                                                      controller
                                                          .deleteParticipantDesktop(
                                                              controller
                                                                  ._participantDesktop
                                                                  .records![
                                                                      index]
                                                                  .id!);
                                                    },
                                                    icon: const Icon(
                                                      Symbols.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
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

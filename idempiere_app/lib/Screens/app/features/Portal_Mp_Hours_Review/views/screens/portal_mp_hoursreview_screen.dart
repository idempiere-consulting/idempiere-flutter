// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Hours_Review/models/hoursreview_json.dart';
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
part '../../bindings/portal_mp_hoursreview_binding.dart';

// controller
part '../../controllers/portal_mp_hoursreview_controller.dart';

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

class PortalMpHoursReviewScreen extends GetView<PortalMpHoursReviewController> {
  const PortalMpHoursReviewScreen({Key? key}) : super(key: key);

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
                                  controller.getHours();
                                },
                                child: Row(
                                  children: [
                                    //Icon(Icons.filter_alt),
                                    Obx(() => controller.dataAvailable
                                        ? Text("TASKS: ".tr +
                                            controller.trx.rowcount.toString())
                                        : Text("TASKS: ".tr)),
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
                                    controller.getHours();
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
                                    controller.getHours();
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
                Container(
                  height: 180,
                  margin:
                      const EdgeInsets.only(left: kSpacing, right: kSpacing),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    child: Column(
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
                                    "${"Summary".tr}: ".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: kSpacing,
                                  bottom: 5,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Obx(
                                          () => Text(
                                              "${controller.totalHours} ${"Total Hours".tr}"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Obx(
                                          () => Text(
                                              "${controller.invoicedHours} ${"Invoiced Hours".tr}"),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {},
                                            child:
                                                Text('Print Hours Review'.tr))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
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
                                      icon: Icon(
                                        Icons.info,
                                        color: (controller.trx.records![index]
                                                    .isDoNotInvoice ??
                                                true)
                                            ? kNotifColor
                                            : Colors.deepOrange,
                                      ),
                                      tooltip: (controller.trx.records![index]
                                                  .isDoNotInvoice ??
                                              true)
                                          ? 'Support'.tr
                                          : 'Invoiced'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
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

                                  subtitle: Column(
                                    children: [
                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .description ??
                                                  "??",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                      '${controller.trx.records![index].qty} ${"Hrs".tr}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [],
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
              return Column(children: []);
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
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    controller.getHours();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      //Icon(Icons.filter_alt),
                                                      Obx(() => controller
                                                              ._dataAvailable
                                                              .value
                                                          ? Text("TASKS: ".tr +
                                                              controller
                                                                  ._trx.rowcount
                                                                  .toString())
                                                          : Text("TASKS: ".tr)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              /* Container(
                                                width: 200,
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                child: TextField(
                                                  controller: controller
                                                      .desktopsearchFieldController,
                                                  onSubmitted: (value) {
                                                    controller.getHours();
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: 'Document N°'.tr,
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
                                                    if (controller.pagesCount >
                                                        1) {
                                                      controller.pagesCount
                                                          .value -= 1;
                                                      controller.getHours();
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.skip_previous),
                                                ),
                                                Obx(() => Text(
                                                    "${controller.pagesCount.value}/${controller.pagesTot.value}")),
                                                IconButton(
                                                  onPressed: () {
                                                    if (controller.pagesCount <
                                                        controller
                                                            .pagesTot.value) {
                                                      controller.pagesCount
                                                          .value += 1;
                                                      controller.getHours();
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
                                      () => controller._dataAvailable.value
                                          ? DataTable(
                                              columns: <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    ''.tr,
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Name'.tr,
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Description'.tr,
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Hours'.tr,
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                              ],
                                              rows: controller.headerRows,
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        Container(
                          height: 180,
                          margin: const EdgeInsets.only(
                              left: kSpacing, right: kSpacing),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                            child: Column(
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
                                            "${"Summary".tr}: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          top: kSpacing,
                                          bottom: 5,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Obx(
                                                  () => Text(
                                                      "${controller.totalHours} ${"Total Hours".tr}"),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Obx(
                                                  () => Text(
                                                      "${controller.invoicedHours} ${"Invoiced Hours".tr}"),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {},
                                                    child:
                                                        Text('Print Report'.tr))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

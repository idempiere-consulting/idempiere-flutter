// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/lead.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_List/models/anomaly_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpwarehouse/models/warehousestock_json.dart';
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
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/maintenance_mpwarehouse_binding.dart';

// controller
part '../../controllers/maintenance_mpwarehouse_controller.dart';

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

class MaintenanceMpwarehouseScreen
    extends GetView<MaintenanceMpwarehouseController> {
  const MaintenanceMpwarehouseScreen({Key? key}) : super(key: key);

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
                            controller.getWarehouseStock();
                          },
                          child: Row(
                            children: [
                              //Icon(Icons.filter_alt),
                              Obx(() => controller.dataAvailable
                                  ? Text("PRODUCT: ".tr +
                                      controller.trx.rowcount.toString())
                                  : Text("PRODUCT: ".tr)),
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
                              controller.getWarehouseStock();
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
                              controller.getWarehouseStock();
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
                      Symbols.filter_alt,
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
                  /* Get.to(() => const CRMFilterLead(), arguments: {
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
                  }); */
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
                                        color: Colors.grey,
                                      ),
                                      tooltip: 'Edit'.tr,
                                      onPressed: () {},
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.warehouse,
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                            child: Text(
                                              controller
                                                      .trx
                                                      .records![index]
                                                      .mWarehouseID
                                                      ?.identifier ??
                                                  "???",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.trx.records![index]
                                                      .mProductID?.identifier ??
                                                  "???",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${"In Stock".tr}: ",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${controller.trx.records![index].qtyOnHand}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
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
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [],
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
              return Column(children: []);
            },
            desktopBuilder: (context, constraints) {
              return Column(children: []);
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

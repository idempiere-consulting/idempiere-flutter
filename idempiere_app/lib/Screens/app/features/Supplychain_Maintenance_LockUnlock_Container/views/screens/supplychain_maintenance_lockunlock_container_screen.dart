// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_POS/models/product_category_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/models/mpmaintaincontractjson.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/reflist_resource_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Maintenance_Switch_Resource/views/screens/supplychain_edit_maintenance_switch_resource_screen.dart';
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
import 'package:path_provider/path_provider.dart';

// binding
part '../../bindings/supplychain_maintenance_lockunlock_container_binding.dart';

// controller
part '../../controllers/supplychain_maintenance_lockunlock_controller.dart';

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

class SupplychainMaintenanceLockUnlockContainerScreen
    extends GetView<SupplychainMaintenanceLockUnlockContainerController> {
  const SupplychainMaintenanceLockUnlockContainerScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BarcodeKeyboardListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: (barcode) {},
        child: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: controller.containerFieldController,
                    onChanged: (value) {
                      controller.containerName.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Container'.tr,

                      //filled: true,
                      border: const OutlineInputBorder(
                          /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                          ),
                      prefixIcon: const Icon(Icons.local_shipping),
                      //hintText: "search..",
                      isDense: true,
                      //fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Divider(),
                Obx(
                  () => controller.containerName.value != ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.containerFieldController.text !=
                                "") {
                              controller.getMaintainResourcesByContainer("L");
                            }
                          },
                          child: Text('Unlock'.tr),
                        )
                      : SizedBox(),
                ),
                Divider(),
                Obx(
                  () => controller.containerName.value != ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.containerFieldController.text !=
                                "") {
                              controller.getMaintainResourcesByContainer("U");
                            }
                          },
                          child: Text('Lock'.tr),
                        )
                      : SizedBox(),
                ),
                Divider(),
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: controller.containerFieldController,
                    onChanged: (value) {
                      controller.containerName.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Container'.tr,

                      //filled: true,
                      border: const OutlineInputBorder(
                          /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                          ),
                      prefixIcon: const Icon(Icons.local_shipping),
                      //hintText: "search..",
                      isDense: true,
                      //fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Divider(),
                Obx(
                  () => controller.containerName.value != ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.containerFieldController.text !=
                                "") {
                              controller.getMaintainResourcesByContainer("L");
                            }
                          },
                          child: Text('Unlock'.tr),
                        )
                      : SizedBox(),
                ),
                Obx(
                  () => controller.containerName.value != ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.containerFieldController.text !=
                                "") {
                              controller.getMaintainResourcesByContainer("U");
                            }
                          },
                          child: Text('Lock'.tr),
                        )
                      : SizedBox(),
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
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: controller.containerFieldController,
                    onChanged: (value) {
                      controller.containerName.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Container'.tr,

                      //filled: true,
                      border: const OutlineInputBorder(
                          /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                          ),
                      prefixIcon: const Icon(Icons.local_shipping),
                      //hintText: "search..",
                      isDense: true,
                      //fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Divider(),
                Obx(
                  () => controller.containerName.value != ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.containerFieldController.text !=
                                "") {
                              controller.getMaintainResourcesByContainer("L");
                            }
                          },
                          child: Text('Unlock'.tr),
                        )
                      : SizedBox(),
                ),
                Obx(
                  () => controller.containerName.value != ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.containerFieldController.text !=
                                "") {
                              controller.getMaintainResourcesByContainer("U");
                            }
                          },
                          child: Text('Lock'.tr),
                        )
                      : SizedBox(),
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

// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
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
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// binding
part '../../bindings/settings_binding.dart';

// controller
part '../../controllers/settings_controller.dart';

// models
part '../../models/profile.dart';

// component
part '../components/active_project_card.dart';
part '../components/header.dart';
part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GetStorage().write(
            'isUserPreferencesSync', controller.isUserPreferencesSync.value);
        GetStorage().write(
            'isBusinessPartnerSync', controller.isBusinessPartnerSync.value);
        GetStorage().write('isjpTODOSync', controller.isjpTODOSync.value);
        GetStorage().write('isProductSync', controller.isProductSync.value);
        GetStorage().write('isWorkOrderSync', controller.isWorkOrderSync.value);
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              GetStorage().write('isUserPreferencesSync',
                  controller.isUserPreferencesSync.value);
              GetStorage().write('isBusinessPartnerSync',
                  controller.isBusinessPartnerSync.value);
              GetStorage().write('isjpTODOSync', controller.isjpTODOSync.value);
              GetStorage()
                  .write('isProductSync', controller.isProductSync.value);
              GetStorage()
                  .write('isWorkOrderSync', controller.isWorkOrderSync.value);
              Get.offNamed('/Dashboard');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(
                children: [
                  Obx(() => SettingsList(
                        shrinkWrap: true,
                        sections: [
                          SettingsSection(
                            margin: const EdgeInsetsDirectional.all(8.0),
                            title: Text('Sync Data'.tr),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                title: Text('Re-Sync All'.tr),
                                leading: const Icon(Icons.sync),
                                onPressed: (context) {
                                  controller.reSyncAll();
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('User Preferences'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isUserPreferencesSyncing.value ==
                                            false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue:
                                    controller.isUserPreferencesSync.value,
                                onToggle: (bool value) {
                                  controller.isUserPreferencesSync.value =
                                      value;
                                  //GetStorage().write('isUserPreferencesSync', value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Business Partners'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isBusinessPartnerSyncing.value ==
                                            false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue:
                                    controller.isBusinessPartnerSync.value,
                                onToggle: (bool value) {
                                  controller.isBusinessPartnerSync.value =
                                      value;
                                  //GetStorage().write('isBusinessPartnerSync', controller.isBusinessPartnerSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Event Calendar'.tr),
                                leading:
                                    controller.isjpTODOSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isjpTODOSync.value,
                                onToggle: (bool value) {
                                  controller.isjpTODOSync.value = value;
                                  //GetStorage().write('isjpTODOSync', controller.isjpTODOSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Products'.tr),
                                leading:
                                    controller.isProductSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isProductSync.value,
                                onToggle: (bool value) {
                                  controller.isProductSync.value = value;
                                  //GetStorage().write('isProductSync', controller.isProductSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Work Orders'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isWorkOrderSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isWorkOrderSync.value,
                                onToggle: (bool value) {
                                  controller.isWorkOrderSync.value = value;
                                  //GetStorage().write('isWorkOrderSync', controller.isWorkOrderSync.value);
                                },
                              ),
                            ],
                          ),
                          SettingsSection(
                            margin: const EdgeInsetsDirectional.all(8.0),
                            title: Text('Language'.tr),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: const Icon(Icons.language),
                                title: Text('Language'.tr),
                                value: Text('Italian'.tr),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              );
            },
            tabletBuilder: (context, constraints) {
              return Column(
                children: [
                  Obx(() => SettingsList(
                        shrinkWrap: true,
                        sections: [
                          SettingsSection(
                            margin: const EdgeInsetsDirectional.all(8.0),
                            title: Text('Sync Data'.tr),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                title: Text('Re-Sync All'.tr),
                                leading: const Icon(Icons.sync),
                                onPressed: (context) {
                                  controller.reSyncAll();
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('User Preferences'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isUserPreferencesSyncing.value ==
                                            false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue:
                                    controller.isUserPreferencesSync.value,
                                onToggle: (bool value) {
                                  controller.isUserPreferencesSync.value =
                                      value;
                                  //GetStorage().write('isUserPreferencesSync', value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Business Partners'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isBusinessPartnerSyncing.value ==
                                            false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue:
                                    controller.isBusinessPartnerSync.value,
                                onToggle: (bool value) {
                                  controller.isBusinessPartnerSync.value =
                                      value;
                                  //GetStorage().write('isBusinessPartnerSync', controller.isBusinessPartnerSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Event Calendar'.tr),
                                leading:
                                    controller.isjpTODOSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isjpTODOSync.value,
                                onToggle: (bool value) {
                                  controller.isjpTODOSync.value = value;
                                  //GetStorage().write('isjpTODOSync', controller.isjpTODOSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Products'.tr),
                                leading:
                                    controller.isProductSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isProductSync.value,
                                onToggle: (bool value) {
                                  controller.isProductSync.value = value;
                                  //GetStorage().write('isProductSync', controller.isProductSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Work Orders'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isWorkOrderSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isWorkOrderSync.value,
                                onToggle: (bool value) {
                                  controller.isWorkOrderSync.value = value;
                                  //GetStorage().write('isWorkOrderSync', controller.isWorkOrderSync.value);
                                },
                              ),
                            ],
                          ),
                          SettingsSection(
                            margin: const EdgeInsetsDirectional.all(8.0),
                            title: Text('Language'.tr),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: const Icon(Icons.language),
                                title: Text('Language'.tr),
                                value: Text('Italian'.tr),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              );
            },
            desktopBuilder: (context, constraints) {
              return Column(
                children: [
                  Obx(() => SettingsList(
                        shrinkWrap: true,
                        sections: [
                          SettingsSection(
                            margin: const EdgeInsetsDirectional.all(8.0),
                            title: Text('Sync Data'.tr),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                title: Text('Re-Sync All'.tr),
                                leading: const Icon(Icons.sync),
                                onPressed: (context) {
                                  controller.reSyncAll();
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('User Preferences'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isUserPreferencesSyncing.value ==
                                            false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue:
                                    controller.isUserPreferencesSync.value,
                                onToggle: (bool value) {
                                  controller.isUserPreferencesSync.value =
                                      value;
                                  //GetStorage().write('isUserPreferencesSync', value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Business Partners'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isBusinessPartnerSyncing.value ==
                                            false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue:
                                    controller.isBusinessPartnerSync.value,
                                onToggle: (bool value) {
                                  controller.isBusinessPartnerSync.value =
                                      value;
                                  //GetStorage().write('isBusinessPartnerSync', controller.isBusinessPartnerSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Event Calendar'.tr),
                                leading:
                                    controller.isjpTODOSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isjpTODOSync.value,
                                onToggle: (bool value) {
                                  controller.isjpTODOSync.value = value;
                                  //GetStorage().write('isjpTODOSync', controller.isjpTODOSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Products'.tr),
                                leading:
                                    controller.isProductSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isProductSync.value,
                                onToggle: (bool value) {
                                  controller.isProductSync.value = value;
                                  //GetStorage().write('isProductSync', controller.isProductSync.value);
                                },
                              ),
                              SettingsTile.switchTile(
                                title: Text('Work Orders'.tr),
                                // ignore: prefer_const_constructors
                                leading:
                                    controller.isWorkOrderSyncing.value == false
                                        ? const Icon(Icons.cloud_download)
                                        : const CircularProgressIndicator(),
                                initialValue: controller.isWorkOrderSync.value,
                                onToggle: (bool value) {
                                  controller.isWorkOrderSync.value = value;
                                  //GetStorage().write('isWorkOrderSync', controller.isWorkOrderSync.value);
                                },
                              ),
                            ],
                          ),
                          SettingsSection(
                            margin: const EdgeInsetsDirectional.all(8.0),
                            title: Text('Language'.tr),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: const Icon(Icons.language),
                                title: Text('Language'.tr),
                                value: Text('Italian'.tr),
                              ),
                            ],
                          ),
                        ],
                      )),
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

  Widget _buildTaskOverview({
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

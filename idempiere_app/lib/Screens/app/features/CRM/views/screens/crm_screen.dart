// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';

//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphic/graphic.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM/models/lead_funnel_data_json.dart';

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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

// binding
part '../../bindings/crm_binding.dart';

// controller
part '../../controllers/crm_controller.dart';

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

class CRMScreen extends GetView<CRMController> {
  const CRMScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');

        return false;
      },
      child: Scaffold(
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
              //  _buildProfile(data: controller.getProfil()),
              //  const SizedBox(height: kSpacing),
              //  _buildProgress(axis: Axis.vertical),
              //  const SizedBox(height: kSpacing),
              //  _buildTeamMember(data: controller.getMember()),
              /*  const SizedBox(height: kSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: GetPremiumCard(onPressed: () {}),
              ), */
              /* /* const SizedBox(height: kSpacing * 2),
              _buildTaskOverview(
                data: controller.getAllTask(),
                headerAxis: Axis.vertical,
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing * 2),
              _buildActiveProject(
                data: controller.getActiveProject(),
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ), */
              const SizedBox(height: kSpacing),
              _buildRecentMessages(data: controller.getChatting()), */
              Obx(
                () => Visibility(
                  visible: controller.dataAvailable,
                  child: Container(
                    child: const Text(
                      'Lead Status',
                      style: TextStyle(
                        fontSize: 20, /* color: Colors.black */
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.dataAvailable,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 350,
                      height: 300,
                      child: Obx(() => controller.dataAvailable
                          ? Chart(
                              padding: (_) => const EdgeInsets.all(10),
                              data: controller.funnelData,
                              variables: {
                                'Name': Variable(
                                  accessor: (Map map) => map['Name'] as String,
                                ),
                                'tot': Variable(
                                  accessor: (Map map) => map['tot'] as num,
                                  scale: LinearScale(
                                      min: 0 - controller.charScale,
                                      max: controller.charScale),
                                ),
                              },
                              transforms: [
                                Sort(
                                  compare: (a, b) =>
                                      ((b['tot'] as num) - (a['tot'] as num))
                                          .toInt(),
                                )
                              ],
                              elements: [
                                IntervalElement(
                                  label: LabelAttr(
                                      encoder: (tuple) => Label(
                                            "${tuple['tot']}" /* "${tuple['Name']}:\n${tuple['tot']}" */,
                                            LabelStyle(
                                              style: Defaults.runeStyle,
                                              textAlign: TextAlign.center,
                                              textScaleFactor:
                                                  1.5, /* offset: Offset.lerp(Offset.fromDirection(0.33), Offset.fromDirection(-10), 50) */
                                            ),
                                          )),
                                  shape: ShapeAttr(value: FunnelShape()),
                                  color: ColorAttr(
                                    variable: 'Name',
                                    values: Defaults.colors10,
                                  ),
                                  modifiers: [SymmetricModifier()],
                                )
                              ],
                              coord: RectCoord(
                                  transposed: true, verticalRange: [1, 0]),
                            )
                          : const Center(child: CircularProgressIndicator()))),
                ),
              ),
              // ignore: avoid_unnecessary_containers
              Obx(() => Visibility(
                    visible: controller.dataAvailable,
                    child: Obx(() => controller.dataAvailable
                        ? ListView.builder(
                            primary: false,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: controller.funnelData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.circle,
                                  color: Defaults.colors10[index],
                                  size: 15,
                                ),
                                title:
                                    Text(controller.funnelData[index]['Name']),
                              );
                            },
                          )
                        : const Center(child: CircularProgressIndicator())),
                  )),
            ]);
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              //  _buildProfile(data: controller.getProfil()),
              //  const SizedBox(height: kSpacing),
              //  _buildProgress(axis: Axis.vertical),
              //  const SizedBox(height: kSpacing),
              //  _buildTeamMember(data: controller.getMember()),
              /*  const SizedBox(height: kSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: GetPremiumCard(onPressed: () {}),
              ), */
              /* /* const SizedBox(height: kSpacing * 2),
              _buildTaskOverview(
                data: controller.getAllTask(),
                headerAxis: Axis.vertical,
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing * 2),
              _buildActiveProject(
                data: controller.getActiveProject(),
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ), */
              const SizedBox(height: kSpacing),
              _buildRecentMessages(data: controller.getChatting()), */
              Container(
                child: const Text(
                  'Lead Status',
                  style: TextStyle(
                    fontSize: 20, /* color: Colors.black */
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  height: 300,
                  child: Obx(() => controller.dataAvailable
                      ? Chart(
                          padding: (_) => const EdgeInsets.all(10),
                          data: controller.funnelData,
                          variables: {
                            'Name': Variable(
                              accessor: (Map map) => map['Name'] as String,
                            ),
                            'tot': Variable(
                              accessor: (Map map) => map['tot'] as num,
                              scale: LinearScale(
                                  min: 0 - controller.charScale,
                                  max: controller.charScale),
                            ),
                          },
                          transforms: [
                            Sort(
                              compare: (a, b) =>
                                  ((b['tot'] as num) - (a['tot'] as num))
                                      .toInt(),
                            )
                          ],
                          elements: [
                            IntervalElement(
                              label: LabelAttr(
                                  encoder: (tuple) => Label(
                                        "${tuple['tot']}" /* "${tuple['Name']}:\n${tuple['tot']}" */,
                                        LabelStyle(
                                            style: Defaults.runeStyle,
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.5),
                                      )),
                              shape: ShapeAttr(value: FunnelShape()),
                              color: ColorAttr(
                                variable: 'Name',
                                values: Defaults.colors10,
                              ),
                              modifiers: [SymmetricModifier()],
                            )
                          ],
                          coord: RectCoord(
                              transposed: true, verticalRange: [1, 0]),
                        )
                      : const Center(child: CircularProgressIndicator()))),
              Obx(() => controller.dataAvailable
                  ? ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: controller.funnelData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: Defaults.colors10[index],
                            size: 15,
                          ),
                          title: Text(controller.funnelData[index]['Name']),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()))
            ]);
          },
          desktopBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              //  _buildProfile(data: controller.getProfil()),
              //  const SizedBox(height: kSpacing),
              //  _buildProgress(axis: Axis.vertical),
              //  const SizedBox(height: kSpacing),
              //  _buildTeamMember(data: controller.getMember()),
              /*  const SizedBox(height: kSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: GetPremiumCard(onPressed: () {}),
              ), */
              /* /* const SizedBox(height: kSpacing * 2),
              _buildTaskOverview(
                data: controller.getAllTask(),
                headerAxis: Axis.vertical,
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing * 2),
              _buildActiveProject(
                data: controller.getActiveProject(),
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ), */
              const SizedBox(height: kSpacing),
              _buildRecentMessages(data: controller.getChatting()), */
              Container(
                child: const Text(
                  'Lead Status',
                  style: TextStyle(
                    fontSize: 20, /* color: Colors.black */
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  height: 300,
                  child: Obx(() => controller.dataAvailable
                      ? Chart(
                          padding: (_) => const EdgeInsets.all(10),
                          data: controller.funnelData,
                          variables: {
                            'Name': Variable(
                              accessor: (Map map) => map['Name'] as String,
                            ),
                            'tot': Variable(
                              accessor: (Map map) => map['tot'] as num,
                              scale: LinearScale(
                                  min: 0 - controller.charScale,
                                  max: controller.charScale),
                            ),
                          },
                          transforms: [
                            Sort(
                              compare: (a, b) =>
                                  ((b['tot'] as num) - (a['tot'] as num))
                                      .toInt(),
                            )
                          ],
                          elements: [
                            IntervalElement(
                              label: LabelAttr(
                                  encoder: (tuple) => Label(
                                      "${tuple['tot']}" /* "${tuple['Name']}:\n${tuple['tot']}" */,
                                      LabelStyle(
                                        style: Defaults.runeStyle,
                                        textAlign: TextAlign.center,
                                        textScaleFactor:
                                            1.5, /* offset: Offset.lerp(Offset.fromDirection(0.33), Offset.fromDirection(-10), 50) */
                                      ))),
                              shape: ShapeAttr(value: FunnelShape()),
                              color: ColorAttr(
                                variable: 'Name',
                                values: Defaults.colors10,
                              ),
                              modifiers: [SymmetricModifier()],
                            )
                          ],
                          coord: RectCoord(
                              transposed: true, verticalRange: [1, 0]),
                        )
                      : const Center(child: CircularProgressIndicator()))),
              Container(
                alignment: Alignment.center,
                width: size.width,
                child: Obx(() => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.funnelData.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: Defaults.colors10[index],
                              size: 15,
                            ),
                            title: Text(controller.funnelData[index]['Name']),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator())),
              ),
            ]);
          },
        )),
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

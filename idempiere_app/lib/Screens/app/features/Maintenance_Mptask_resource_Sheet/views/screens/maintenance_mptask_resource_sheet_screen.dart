library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_edit_mptask_resource_screen.dart';
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
import 'package:idempiere_app/constants.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/maintenance_mptask_resource_sheet_binding.dart';

// controller
part '../../controllers/maintenance_mptask_resource_sheet_controller.dart';

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

class MaintenanceMpResourceSheetScreen
    extends GetView<MaintenanceMpResourceSheetController> {
  const MaintenanceMpResourceSheetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: IconButton(
              onPressed: () {
                controller.changeFilterMinus();
              },
              icon: const Icon(Icons.skip_previous),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: IconButton(
              onPressed: () {
                controller.changeFilterPlus();
              },
              icon: const Icon(Icons.skip_next),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                print(controller.nameFieldController.text);
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
        //centerTitle: true,
        title: Text('Prod'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.prodFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Type',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.nameFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Marca',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.modelFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Model',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.serialNoFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Serial No',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.lotFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Lot number',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: '',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Construction Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date1 = val.substring(0, 10);

                          //print(date);
                        },
                        validator: (val) {
                          //print(val);
                          return null;
                        },
                        // ignore: avoid_print
                        onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.expectedDurationFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.timelapse_sharp),
                          border: OutlineInputBorder(),
                          labelText: 'Expected Duration (years)',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: '',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Purchase Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date2 = val.substring(0, 10);

                          //print(date);
                        },
                        validator: (val) {
                          //print(val);
                          return null;
                        },
                        // ignore: avoid_print
                        onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: '',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'First Use Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date3 = val.substring(0, 10);

                          //print(date);
                        },
                        validator: (val) {
                          //print(val);
                          return null;
                        },
                        // ignore: avoid_print
                        onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.companyFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.handshake),
                          border: OutlineInputBorder(),
                          labelText: 'Company Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.userFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_pin_outlined),
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        maxLines: 5,
                        controller: controller.noteFieldController,
                        decoration: const InputDecoration(
                          //prefixIcon: Icon(Icons.person_pin_outlined),
                          border: OutlineInputBorder(),
                          labelText: 'Note',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: CheckboxListTile(
                        title: const Text(
                            'The product can keep on being in service'),
                        value: controller.checkboxState.value,
                        activeColor: kPrimaryColor,
                        onChanged: (bool? value) {
                          controller.checkboxState.value = value!;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: "Sign",
                              onPressed: () {},
                              icon: const Icon(EvaIcons.edit2Outline),
                            ),
                            const Text("Sign"),
                          ]),
                    ),
                  ),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Text('WIP');
          },
          desktopBuilder: (context, constraints) {
            return Text('WIP');
          },
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

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
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact_bp_json.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Resource/views/screens/employee_edit_resource.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Resource/views/screens/employee_resource_filter_screen.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Resource_Calendar_Slot/views/screens/create_employee_resource_calendar_slot_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Vehicle/models/asset_json.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Vehicle/views/screens/vehicle_equipment_edit_vehicle.dart';
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
import 'package:material_symbols_icons/symbols.dart';
import 'package:table_calendar/table_calendar.dart';

// binding
part '../../bindings/employee_resource_calendar_slot_binding.dart';

// controller
part '../../controllers/employee_resource_calendar_slot_controller.dart';

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

class EmployeeResourceCalendarSlotScreen
    extends GetView<EmployeeResourceCalendarSlotController> {
  const EmployeeResourceCalendarSlotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${controller.args['name'] ?? 'N/A'}"),
      ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            //const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            Column(
              children: [
                Obx(
                  () => controller.flag.value
                      ? TableCalendar(
                          locale: 'languageCalendar'.tr,
                          focusedDay: controller.focusedDay.value,
                          firstDay: DateTime(2000),
                          lastDay: DateTime(2100),
                          calendarFormat: controller.format,
                          calendarStyle: const CalendarStyle(
                            markerDecoration: BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                            todayDecoration: BoxDecoration(
                              color: Colors.deepPurple,
                            ),
                          ),
                          headerStyle: const HeaderStyle(
                            //formatButtonVisible: false,
                            formatButtonShowsNext: false,
                          ),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          daysOfWeekVisible: true,
                          onFormatChanged: (CalendarFormat format) {
                            controller.format = format;
                          },
                          onDaySelected:
                              (DateTime selectDay, DateTime focusDay) {
                            controller.selectedDay.value = selectDay;
                            controller.focusedDay.value = focusDay;
                            controller.getEventsfromDay2(selectDay);

                            //print(focusedDay);
                          },
                          onDayLongPressed: (selectedDay, focusedDay) {
                            Get.to(
                                () =>
                                    const EmployeeResourceCreateCalendarSlot(),
                                arguments: {
                                  "resourceId": controller.args["id"],
                                  "date": selectedDay
                                });
                          },
                          selectedDayPredicate: (DateTime date) {
                            return isSameDay(
                                controller.selectedDay.value, date);
                          },
                          onHeaderLongPressed: (date) {},
                          eventLoader: controller.getEventsfromDay,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.listAvailable.value,
                child: Flexible(
                  child: ListView.builder(
                      itemCount: controller.selectedDayEventList.length,
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
                                  tooltip: 'Edit Event'.tr,
                                  onPressed: () {},
                                ),
                              ),
                              title: Text(
                                controller.selectedDayEventList[index]
                                        .createdby ??
                                    'N/A',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.timelapse,
                                  color: controller.selectedDayEventList[index]
                                              .statusId ==
                                          "DR"
                                      ? Colors.yellow
                                      : controller.selectedDayEventList[index]
                                                  .statusId ==
                                              "CO"
                                          ? Colors.green
                                          : controller
                                                      .selectedDayEventList[
                                                          index]
                                                      .statusId ==
                                                  "IN"
                                              ? Colors.grey
                                              : controller
                                                          .selectedDayEventList[
                                                              index]
                                                          .statusId ==
                                                      "PR"
                                                  ? Colors.orange
                                                  : controller
                                                              .selectedDayEventList[
                                                                  index]
                                                              .statusId ==
                                                          "IP"
                                                      ? Colors.white
                                                      : controller
                                                                  .selectedDayEventList[
                                                                      index]
                                                                  .statusId ==
                                                              "CF"
                                                          ? Colors.lightGreen
                                                          : controller
                                                                      .selectedDayEventList[
                                                                          index]
                                                                      .statusId ==
                                                                  "NY"
                                                              ? Colors.red
                                                              : controller
                                                                          .selectedDayEventList[
                                                                              index]
                                                                          .statusId ==
                                                                      "WP"
                                                                  ? Colors
                                                                      .yellow
                                                                  : Colors.red,
                                ),
                                onPressed: () {},
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        controller
                                            .selectedDayEventList[index].title,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.event,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${controller.selectedDayEventList[index].startDate}   ${controller.selectedDayEventList[index].scheduledStartTime} - ${controller.selectedDayEventList[index].scheduledEndTime}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              children: [],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Column(children: const []);
        },
        desktopBuilder: (context, constraints) {
          return Column(children: const []);
        },
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

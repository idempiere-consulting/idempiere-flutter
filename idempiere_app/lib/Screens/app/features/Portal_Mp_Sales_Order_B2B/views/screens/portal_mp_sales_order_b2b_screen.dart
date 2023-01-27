library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order_B2B/models/b2b_productcategory_json.dart';
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
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../CRM_Product_List/models/product_list_json.dart';

// binding
part '../../bindings/portal_mp_sales_order_b2b_binding.dart';

// controller
part '../../controllers/portal_mp_sales_order_b2b_controller.dart';

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

class PortalMpSalesOrderB2BScreen
    extends GetView<PortalMpSalesOrderB2BController> {
  const PortalMpSalesOrderB2BScreen({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
            const SizedBox(height: kSpacing),
            /* const SizedBox(height: kSpacing * 2),
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
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
            const SizedBox(height: kSpacing),
            /* const SizedBox(height: kSpacing * 2),
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
                      _buildHeader(),
                      const SizedBox(height: kSpacing * 2),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, bottom: 8.0),
                        child: Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  if (controller
                                          .prodCategoriesAvailable.value ==
                                      false) {
                                    controller.productsAvailable.value = false;
                                    controller.prodCategoriesAvailable.value =
                                        true;
                                  }
                                },
                                child: Text(
                                  "Category".tr,
                                  style: TextStyle(
                                      color: controller
                                              .prodCategoriesAvailable.value
                                          ? Colors.grey
                                          : Colors.deepPurpleAccent),
                                ),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                  visible: controller.productsAvailable.value,
                                  child: const Text(
                                    "  >  ",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                            ),
                            Obx(
                              () => Visibility(
                                  visible: controller.productsAvailable.value,
                                  child: Text(
                                    controller.chosenCategoryName.value,
                                    style: const TextStyle(color: Colors.grey),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Visibility(
                            visible: controller.prodCategoriesAvailable.value,
                            child: StaggeredGrid.count(
                              crossAxisCount: 4,
                              children: List.generate(
                                  controller.prodCategories.records!.length,
                                  (index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.chosenCategoryName.value =
                                        controller.prodCategories
                                            .records![index].name!;
                                    controller.getFilteredProducts(controller
                                        .prodCategories.records![index].id!);
                                  },
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: controller
                                                        .prodCategories
                                                        .records![index]
                                                        .image64 !=
                                                    null
                                                ? Image.memory(
                                                    const Base64Codec().decode(
                                                        (controller
                                                                .prodCategories
                                                                .records![index]
                                                                .image64!)
                                                            .replaceAll(
                                                                RegExp(r'\n'),
                                                                '')),
                                                    fit: BoxFit.cover,
                                                  )
                                                : const Text("no image"),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            controller.prodCategories
                                                    .records![index].name ??
                                                "",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          /* subtitle: Column(
                                        children: [
                                          Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              controller.trx.records![index].name ?? "??",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                                          ),
                                        ],
                                      ), */
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )),
                      Obx(() => Visibility(
                            visible: controller.productsAvailable.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Flexible(flex: 3, child: SizedBox()),
                                Flexible(
                                  flex: 8,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.4),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                MultiSelectBottomSheetField(
                                                    buttonIcon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    initialChildSize: 0.4,
                                                    listType:
                                                        MultiSelectListType
                                                            .CHIP,
                                                    searchable: true,
                                                    buttonText: Text("Color"),
                                                    title: Text("Animals"),
                                                    items: controller._items,
                                                    onConfirm: (values) {
                                                      controller
                                                              ._selectedAnimals2 =
                                                          values
                                                              as List<Animal>;
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay
                                                            .none()),
                                                /* controller._selectedAnimals2 ==
                                                              null ||
                                                          controller
                                                              ._selectedAnimals2
                                                              .isEmpty
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.all(10),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "None selected",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ))
                                                      : Container(), */
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.4),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                MultiSelectBottomSheetField(
                                                    buttonIcon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    initialChildSize: 0.4,
                                                    listType:
                                                        MultiSelectListType
                                                            .CHIP,
                                                    searchable: true,
                                                    buttonText: Text("Size"),
                                                    title: Text("Animals"),
                                                    items: controller._items,
                                                    onConfirm: (values) {
                                                      controller
                                                              ._selectedAnimals2 =
                                                          values
                                                              as List<Animal>;
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay
                                                            .none()),
                                                /* controller._selectedAnimals2 ==
                                                              null ||
                                                          controller
                                                              ._selectedAnimals2
                                                              .isEmpty
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.all(10),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "None selected",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                          ))
                                                      : Container(), */
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 15),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.4),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                MultiSelectBottomSheetField(
                                                    buttonIcon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    initialChildSize: 0.4,
                                                    listType:
                                                        MultiSelectListType
                                                            .CHIP,
                                                    searchable: true,
                                                    buttonText:
                                                        Text("Material"),
                                                    title: Text("Animals"),
                                                    items: controller._items,
                                                    onConfirm: (values) {
                                                      controller
                                                              ._selectedAnimals2 =
                                                          values
                                                              as List<Animal>;
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay
                                                            .none()),
                                                /* controller._selectedAnimals2 ==
                                                            null ||
                                                        controller
                                                            ._selectedAnimals2
                                                            .isEmpty
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "None selected",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        ))
                                                    : Container(), */
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.4),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                MultiSelectBottomSheetField(
                                                    buttonIcon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    initialChildSize: 0.4,
                                                    listType:
                                                        MultiSelectListType
                                                            .CHIP,
                                                    searchable: true,
                                                    buttonText:
                                                        Text("Trading Mark"),
                                                    title: Text("Animals"),
                                                    items: controller._items,
                                                    onConfirm: (values) {
                                                      controller
                                                              ._selectedAnimals2 =
                                                          values
                                                              as List<Animal>;
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay
                                                            .none()),
                                                /* controller._selectedAnimals2 ==
                                                            null ||
                                                        controller
                                                            ._selectedAnimals2
                                                            .isEmpty
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "None selected",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        ))
                                                    : Container(), */
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 15),
                                      child: Row(
                                        children: [
                                          Text(
                                            controller.filteredProds.rowcount
                                                    .toString() +
                                                " Products",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StaggeredGrid.count(
                                      crossAxisCount: 3,
                                      children: List.generate(
                                          controller.filteredProds.records!
                                              .length, (index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              margin: EdgeInsets.zero,
                                              /* shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ), */
                                              child: Column(
                                                children: [
                                                  Container(
                                                    /* margin:
                                                        const EdgeInsets.all(8), */
                                                    child: ClipRRect(
                                                      /* borderRadius:
                                                          BorderRadius.circular(
                                                              8), */
                                                      child: controller
                                                                  .filteredProds
                                                                  .records![
                                                                      index]
                                                                  .imageData !=
                                                              null
                                                          ? Image.memory(
                                                              const Base64Codec().decode((controller
                                                                      .filteredProds
                                                                      .records![
                                                                          index]
                                                                      .imageData!)
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r'\n'),
                                                                      '')),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : const Text(
                                                              "no image"),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      controller
                                                              .filteredProds
                                                              .records![index]
                                                              .name ??
                                                          "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Row(
                                                      children: const [
                                                        Text("Disponibilità: "),
                                                        Text("3"),
                                                      ],
                                                    ),
                                                    /* subtitle: Column(
                                                  children: [
                                                    Row(
                                                            children: <Widget>[
                                                              Expanded(
                                    child: Text(
                                      controller.trx.records![index].name ?? "??",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                                              ),
                                                            ],
                                                    ),
                                                  ],
                                                ), */
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ]),
                                ),
                                const Flexible(flex: 2, child: SizedBox()),
                              ],
                            ),
                          )),
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
                    /*  Obx(() => Visibility(
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          visible: controller.calendarFlag.value,
                          child: Obx(
                            () => TableCalendar(
                              locale: 'languageCalendar'.tr,
                              focusedDay: controller.focusedDay.value,
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              calendarFormat: controller.format.value,
                              calendarStyle: const CalendarStyle(
                                markerDecoration: BoxDecoration(
                                    color: Colors.yellow,
                                    shape: BoxShape.circle),
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
                              onFormatChanged: (CalendarFormat _format) {
                                controller.format.value = _format;
                              },
                              onDaySelected:
                                  (DateTime selectDay, DateTime focusDay) {
                                controller.selectedDay.value = selectDay;
                                controller.focusedDay.value = focusDay;
                                controller.eventFlag.value = false;
                                controller.eventFlag.value = true;
                              },
                              selectedDayPredicate: (DateTime date) {
                                return isSameDay(
                                    controller.selectedDay.value, date);
                              },
                              onHeaderLongPressed: (date) {
                                /* Get.off(const CreateCalendarEvent(),
                            arguments: {"adUserId": adUserId}); */
                              },
                              eventLoader: _getEventsfromDay,
                            ),
                          ),
                        )), */
                    /*  Obx(() => Visibility(
                        visible: controller.eventFlag.value,
                        child: _buildDayEvents())), */
                  ],
                ),
              )
            ],
          );

          /* Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
            const SizedBox(height: kSpacing),
            _buildProgress(axis: Axis.vertical),
            const SizedBox(height: kSpacing),
            _buildTeamMember(data: controller.getMember()),
            const SizedBox(height: kSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: GetPremiumCard(onPressed: () {}),
            ),
            /* const SizedBox(height: kSpacing * 2),
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
            _buildRecentMessages(data: controller.getChatting()),
          ]);
 */
        },
      )),
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

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? kNotifColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

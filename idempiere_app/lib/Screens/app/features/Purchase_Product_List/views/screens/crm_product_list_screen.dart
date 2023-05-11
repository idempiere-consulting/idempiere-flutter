// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/models/product_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_detail.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_filter_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Product_List/views/screens/crm_product_list_detail.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Product_List/views/screens/crm_product_list_filter_screen.dart';
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

// binding
part '../../bindings/crm_product_list_binding.dart';

// controller
part '../../controllers/crm_product_list_controller.dart';

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

class PurchaseProductListScreen extends GetView<PurchaseProductListController> {
  const PurchaseProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            controller.getProductLists();
                          },
                          child: Row(
                            children: [
                              //Icon(Icons.filter_alt),
                              Obx(() => controller.dataAvailable
                                  ? Text("PRODUCTS: ".tr +
                                      controller.trx.rowcount.toString())
                                  : Text("PRODUCTS: ".tr)),
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
                              controller.getProductLists();
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
                              controller.getProductLists();
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
                child: Obx(
                  () => Icon(
                    MaterialSymbols.filter_alt_filled,
                    color: controller.value.value == "" &&
                            controller.name.value == "" &&
                            controller.description.value == ""
                        ? Colors.white
                        : kNotifColor,
                  ),
                ),
                onTap: () {
                  Get.to(const PurchaseFilterProductList(), arguments: {
                    'value': controller.value.value,
                    'name': controller.name.value,
                    'description': controller.description.value,
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
                //_buildProfile(data: controller.getProfil()),
                //const SizedBox(height: kSpacing),

                Obx(
                  () => controller.dataAvailable
                      ? MasonryGridView.count(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: controller.trx.records?.length ?? 0,
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          itemBuilder: (context, index) {
                            return buildImageCard(index);
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                //_buildProfile(data: controller.getProfil()),
                //const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text("Product List: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("Product List: ".tr)),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateLead());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ), */
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getProductLists();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            for (var i = 0; i < controller.trx.rowcount!; i++) {
                              if (value.toString().toLowerCase() ==
                                  controller.trx.records![i].value!
                                      .toLowerCase()) {
                                Get.to(const ProductListDetail(), arguments: {
                                  "id": controller.trx.records![i].id,
                                });
                              }
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Product Value'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(
                  () => controller.dataAvailable
                      ? SizedBox(
                          height: size.height,
                          width: double.infinity,
                          child: MasonryGridView.count(
                            shrinkWrap: true,
                            itemCount: controller.trx.records?.length ?? 0,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemBuilder: (context, index) {
                              return buildImageCard(index);
                            },
                          ))
                      : const Center(child: CircularProgressIndicator()),
                ),
              ]);
            },
            desktopBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                //_buildProfile(data: controller.getProfil()),
                //const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text("Product List: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("Product List: ".tr)),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateLead());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ), */
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getProductLists();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            for (var i = 0; i < controller.trx.rowcount!; i++) {
                              if (value.toString().toLowerCase() ==
                                  controller.trx.records![i].value!
                                      .toLowerCase()) {
                                Get.to(const ProductListDetail(), arguments: {
                                  "id": controller.trx.records![i].id,
                                });
                              }
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Product Value'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(
                  () => controller.dataAvailable
                      ? SizedBox(
                          height: size.height,
                          width: double.infinity,
                          child: MasonryGridView.count(
                            shrinkWrap: true,
                            itemCount: controller.trx.records?.length ?? 0,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemBuilder: (context, index) {
                              return buildImageCard(index);
                            },
                          ))
                      : const Center(child: CircularProgressIndicator()),
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

  Widget buildImageCard(int index) => GestureDetector(
        onTap: () {
          Get.to(const PurchaseProductListDetail(), arguments: {
            "id": controller.trx.records![index].id,
            "add": false,
            "image": controller.trx.records![index].imageData,
            "imageUrl": controller.trx.records![index].imageUrl,
          });
        },
        child: Card(
          color: const Color.fromRGBO(64, 75, 96, .9),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: controller.trx.records![index].imageData != null
                      ? Image.memory(
                          const Base64Codec().decode(
                              (controller.trx.records![index].imageData!)
                                  .replaceAll(RegExp(r'\n'), '')),
                          fit: BoxFit.cover,
                        )
                      : controller.trx.records![index].imageUrl != null
                          ? Image.network(
                              controller.trx.records![index].imageUrl!)
                          : const Text('no image'),
                ),
              ),
              ListTile(
                title: Text(
                  "  € ${controller.trx.records![index].price != null ? controller.trx.records![index].price.toString() : " "}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
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
                ),
              ),
            ],
          ),
        ),
      );
}





/* Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.records?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(const ProductListDetail(), arguments: {
                                  "id": controller.trx.records![index].id,
                                });
                              },
                              child: Card(
                                elevation: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 6.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 1, bottom: 10),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white24))),
                                        child: controller.trx.records![index]
                                                    .imageData !=
                                                null
                                            ? Image.memory(const Base64Codec()
                                                .decode((controller
                                                        .trx
                                                        .records![index]
                                                        .imageData!)
                                                    .replaceAll(
                                                        RegExp(r'\n'), '')))
                                            : const Text("no image"),
                                      ),
                                      ListTile(
                                        /* tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0), */
                                        /* leading: Container(
                                          padding:
                                              const EdgeInsets.only(right: 12.0),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.white24))),
                                          child: controller.trx.records![index]
                                                      .imageData !=
                                                  null
                                              ? Image.memory(const Base64Codec()
                                                  .decode((controller
                                                          .trx
                                                          .records![index]
                                                          .imageData!)
                                                      .replaceAll(
                                                          RegExp(r'\n'), '')))
                                              : Text("no image"),
                                        ), */

                                        title: Text(
                                          "  €" +
                                              controller
                                                  .trx.records![index].price
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                        subtitle: Column(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                /* const Icon(Icons.,
                                                    color: Colors.yellowAccent), */
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                            .trx
                                                            .records![index]
                                                            .name ??
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ), */

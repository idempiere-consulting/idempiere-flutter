// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Price_List/models/price_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Price_List/views/screens/crm_price_list_detail.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_detail.dart';
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
import 'package:path_provider/path_provider.dart';

// binding
part '../../bindings/crm_price_list_binding.dart';

// controller
part '../../controllers/crm_price_list_controller.dart';

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

class CRMPriceListScreen extends GetView<CRMPriceListController> {
  const CRMPriceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        floatingActionButton: Obx(
          () => Visibility(
            visible: controller.businessPartnerId.value > 0 &&
                controller.priceListId > 0,
            child: FloatingActionButton(
              backgroundColor: kNotifColor,
              //foregroundColor: kNotifColor,
              onPressed: () {
                if (controller._isListShown.value) {
                  controller._isListShown.value = false;
                } else {
                  //controller.getPriceList();
                  controller._isListShown.value = true;
                  controller.getPriceList();
                }
              },
              child: Obx(
                () => Icon(
                  controller._isListShown.value == false
                      ? Icons.find_in_page
                      : Icons.skip_previous,
                  color: Colors.white,
                ),
              ),
            ),
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
                _buildHeader(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                const SizedBox(height: 10),
                Obx(
                  () => Visibility(
                    visible: controller._isListShown.value == true,
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
                                "id": controller.trx.records![i].mProductID?.id,
                                "price": controller.trx.records![i].priceList,
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller._isListShown.value == false,
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller._isListShown.value == false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<BPRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .businessPartnerName.value),
                                    displayStringForOption:
                                        controller.displayStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            BPRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((BPRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (BPRecords selection) {
                                      controller.businessPartnerId.value =
                                          selection.id!;
                                      controller.priceListId.value =
                                          selection.mPriceListID!.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller._isListShown.value,
                    child: Obx(
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
                  ),
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
                      child: Obx(() => controller.dataAvailable
                          ? Text("Product List: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("Product List: ".tr)),
                      margin: const EdgeInsets.only(left: 15),
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
                          controller.getPriceList();
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
                      child: Obx(() => controller.dataAvailable
                          ? Text("Product List: ".tr +
                              controller.trx.rowcount.toString())
                          : Text("Product List: ".tr)),
                      margin: const EdgeInsets.only(left: 15),
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
                          controller.getPriceList();
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

  Widget buildImageCard(int index) => GestureDetector(
        onTap: () {
          Get.to(const PriceListDetail(), arguments: {
            "id": controller.trx.records![index].mProductID?.id,
            "price": controller.trx.records![index].priceList,
            "add": false,
            "image": controller.trx.records![index].imageData,
          });
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
                  borderRadius: BorderRadius.circular(8),
                  child: controller.trx.records![index].imageData != null
                      ? Image.memory(
                          const Base64Codec().decode(
                              (controller.trx.records![index].imageData!)
                                  .replaceAll(RegExp(r'\n'), '')),
                          fit: BoxFit.cover,
                        )
                      : const Text("no image"),
                ),
              ),
              ListTile(
                title: Text(
                  "  ${controller.trx.records![index].cCurrencyID?.identifier ?? "?"} " +
                      controller.trx.records![index].priceList.toString(),
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

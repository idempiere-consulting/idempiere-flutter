// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Price_List/models/price_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/productcheckout.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_Contract/models/documenttype_json.dart';
//import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/print_pos_page.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Request/views/screens/purchase_request_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Request_Creation_Edit/models/requisition_line_json.dart';
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
import 'package:idempiere_app/components/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:step_progress_indicator/step_progress_indicator.dart';

// binding
part '../../bindings/purchase_request_creation_edit_binding.dart';

// controller
part '../../controllers/purchase_request_creation_edit_controller.dart';

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

class PurchaseRequestCreationEditScreen
    extends GetView<PurchaseRequestCreationEditController> {
  const PurchaseRequestCreationEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sales Order Creation'.tr),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Obx(
                  () => StepProgressIndicator(
                    roundedEdges: const Radius.circular(10),
                    totalSteps: 2,
                    currentStep: controller.filterCount.value + 1,
                    size: 36,
                    onTap: (index) {
                      return () {
                        switch (index) {
                          case 1:
                            controller.filterCount.value = index;

                            break;
                          case 2:
                            controller.filterCount.value = index;

                            break;
                          default:
                            controller.filterCount.value = index;

                            break;
                        }
                      };
                    },
                    selectedColor: kNotifColor,
                    unselectedColor: Colors.grey,
                    customStep: (index, color, _) => color == kNotifColor
                        ? index == 0
                            ? Container(
                                color: color,
                                child: const Icon(
                                  Symbols.list,
                                  color: Colors.white,
                                ),
                              )
                            : index == 1
                                ? Container(
                                    color: color,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: <Widget>[
                                            const Icon(Symbols.quick_reorder),
                                            Obx(
                                              () => Visibility(
                                                visible:
                                                    controller.counter.value !=
                                                            0
                                                        ? true
                                                        : false,
                                                child: Positioned(
                                                  right: 1,
                                                  top: 1,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 12,
                                                      minHeight: 12,
                                                    ),
                                                    child: Obx(
                                                      () => Text(
                                                        '${controller.counter.value}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                : Container(
                                    color: color,
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  )
                        : index == 0
                            ? Container(
                                color: color,
                                child: const Icon(
                                  Symbols.list,
                                  color: Colors.white,
                                ),
                              )
                            : index == 1
                                ? Container(
                                    color: color,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: <Widget>[
                                            const Icon(Symbols.quick_reorder),
                                            Obx(
                                              () => Visibility(
                                                visible:
                                                    controller.counter.value !=
                                                            0
                                                        ? true
                                                        : false,
                                                child: Positioned(
                                                  right: 1,
                                                  top: 1,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 12,
                                                      minHeight: 12,
                                                    ),
                                                    child: Obx(
                                                      () => Text(
                                                        '${controller.counter.value}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                : Container(
                                    color: color,
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
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
                      onTap: () {
                        controller.searchFieldController.text = '';
                      },
                      controller: controller.searchFieldController,
                      onSubmitted: (value) {
                        controller.getAllProducts(context);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(EvaIcons.search),
                        hintText: "Search Product...".tr,
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.dataAvailable.value &&
                      controller.filterCount.value == 0,
                  child: controller.dataAvailable.value
                      ? Expanded(
                          child: SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: controller._trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index, context),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              Visibility(
                  visible: controller.filterCount.value == 1,
                  child: const Divider()),
              Obx(
                () => Visibility(
                  visible: controller.filterCount.value == 1 &&
                      controller.prodListAvailable.value,
                  child: Flexible(
                    child: SizedBox(
                      child: ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.productList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                controller.productList[index].id.toString();
                            return FadeInDown(
                              duration: Duration(milliseconds: 350 * index),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Dismissible(
                                  key: Key(item),
                                  onDismissed: (direction) {
                                    controller.prodListAvailable.value = false;

                                    for (var i = 0;
                                        i < controller.productList.length;
                                        i++) {
                                      if (controller.productList[i].id ==
                                          controller.productList[index].id) {
                                        if (controller.productList[index]
                                                .orderLineID !=
                                            null) {
                                          controller.deletedPRLinesWithID.add(
                                              controller.productList[index]
                                                  .orderLineID!);
                                        }
                                        controller.productList.removeAt(index);
                                      }
                                    }
                                    controller.prodListAvailable.value = true;
                                    controller.updateCounter();
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                /* boxShadow: [BoxShadow(
                                                            spreadRadius: 0.5,
                                                            color: black.withOpacity(0.1),
                                                            blurRadius: 1
                                                          )], */
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: Container(
                                                      width: 120,
                                                      height: 70,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/404.png"),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                controller.productList[index]
                                                            .name ==
                                                        "."
                                                    ? "Descriptive Row".tr
                                                    : controller
                                                        .productList[index]
                                                        .name,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Text(
                                                      "${controller.productList[index].qty} ${controller.productList[index].uom}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      tooltip: 'Edit Row'.tr,
                                                      onPressed: () {
                                                        controller
                                                                .qtyFieldController
                                                                .text =
                                                            controller
                                                                .productList[
                                                                    index]
                                                                .qty
                                                                .toString();
                                                        Get.defaultDialog(
                                                          title: controller
                                                              .productList[
                                                                  index]
                                                              .name,
                                                          onConfirm: () {
                                                            controller
                                                                .prodListAvailable
                                                                .value = false;
                                                            if (double.tryParse(
                                                                    controller
                                                                        .qtyFieldController
                                                                        .text) !=
                                                                null) {
                                                              controller
                                                                      .productList[
                                                                          index]
                                                                      .qty =
                                                                  double.parse(
                                                                      controller
                                                                          .qtyFieldController
                                                                          .text);
                                                              controller
                                                                  .updateCounter();
                                                              controller
                                                                  .prodListAvailable
                                                                  .value = true;
                                                              Get.back();
                                                            }
                                                          },
                                                          content: Column(
                                                            children: [
                                                              const Divider(),
                                                              Container(
                                                                width: 100,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      controller
                                                                          .qtyFieldController,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                    ),
                                                                    //prefixIcon: const Icon(EvaIcons.search),
                                                                    prefixText: controller
                                                                        ._trx
                                                                        .records![
                                                                            index]
                                                                        .uom,
                                                                    labelText:
                                                                        'Qty'
                                                                            .tr,
                                                                    isDense:
                                                                        true,
                                                                    fillColor: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit))
                                                ],
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: controller.filterCount.value == 1,
                  child: const Divider()),
              Obx(
                () => Visibility(
                  visible: controller.filterCount.value == 1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: DateTimePicker(
                      readOnly: true,
                      locale: Locale('languageCalendar'.tr),
                      decoration: InputDecoration(
                        labelText: 'Request Date'.tr,
                        //filled: true,
                        border: const OutlineInputBorder(
                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                            ),
                        prefixIcon: const Icon(Icons.event),
                        //hintText: "search..",
                        isDense: true,
                        //fillColor: Theme.of(context).cardColor,
                      ),
                      type: DateTimePickerType.date,
                      initialValue:
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),

                      onChanged: (val) {},
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
                  visible: controller.filterCount.value == 1,
                  child: RoundedButton(
                    text: 'Confirm Request'.tr,
                    press: () {
                      Get.defaultDialog(
                          title: "Edit Request".tr,
                          content: Text(
                              "Are you sure you want to edit the Request?".tr),
                          buttonColor: kNotifColor,
                          textConfirm: "Edit".tr,
                          textCancel: "Cancel".tr,
                          onConfirm: () {
                            Get.back();

                            for (var element
                                in controller.deletedPRLinesWithID) {
                              controller.deletePurchaseRequestLines(element);
                            }

                            for (var element in controller.productList) {
                              if (element.orderLineID == null) {
                                controller.createPurchaseRequestLines(
                                    element.id, element.qty);
                              } else {
                                controller.editPurchaseRequestLines(
                                    element.orderLineID!, element.qty);
                              }
                            }
                            Get.back();
                            Get.snackbar(
                              "Done",
                              "The record has been edited".tr,
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.filterCount.value == 1,
                  child: const SizedBox(
                    height: 10,
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
      ),
    );
  }

  Widget buildImageCard(int index, BuildContext context) => GestureDetector(
        onTap: () {
          controller.qtyFieldController.text = '1';
          Get.defaultDialog(
            title: controller._trx.records![index].name ?? 'N/A',
            onConfirm: () {
              if (double.tryParse(controller.qtyFieldController.text) != null) {
                controller.productList.add(ProductCheckout2(
                    id: controller._trx.records![index].id!,
                    name: controller._trx.records![index].name!,
                    qty: double.parse(controller.qtyFieldController.text),
                    uom: controller._trx.records![index].uom,
                    cost: 0.0));
                controller.updateCounter();
                Get.back();
              }
            },
            content: Column(
              children: [
                const Divider(),
                Container(
                  width: 100,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: controller.qtyFieldController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      //prefixIcon: const Icon(EvaIcons.search),
                      prefixText: controller._trx.records![index].uom,
                      labelText: 'Qty'.tr,
                      isDense: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ],
            ),
          );
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
                  child: controller._trx.records![index].imageData != null
                      ? Image.memory(
                          const Base64Codec().decode(
                              (controller._trx.records![index].imageData!)
                                  .replaceAll(RegExp(r'\n'), '')),
                          fit: BoxFit.cover,
                        )
                      : controller._trx.records![index].imageUrl != null
                          ? Image.network(
                              controller._trx.records![index].imageUrl!)
                          : const SizedBox(),
                ),
              ),
              ListTile(
                title: Text(
                  "${controller._trx.records![index].value}_${controller._trx.records![index].name!.tr}",
                ),
                subtitle: Column(
                  children: const [],
                ),
              ),
            ],
          ),
        ),
      );

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

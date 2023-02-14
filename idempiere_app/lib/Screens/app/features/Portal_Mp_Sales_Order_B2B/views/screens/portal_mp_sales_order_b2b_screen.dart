// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/businesspartner_location_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/productcheckout.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/salesorder_defaults_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order_B2B/models/b2b_productcategory_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order_B2B/models/b2bprodstock_json.dart';
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
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/doctype_json.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Maintenance_Mptask_resource/models/product_json.dart';

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
            //_buildProfile(data: controller.getProfil()),
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
            //_buildProfile(data: controller.getProfil()),
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
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: kSpacing),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                const TodayText(),
                                const SizedBox(width: kSpacing),
                                Expanded(
                                    child: TextField(
                                  controller: controller.searchFieldController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    hintText: "search..",
                                    isDense: true,
                                    fillColor: Theme.of(context).cardColor,
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    controller.getFilteredProducts3();
                                    //if (onSearch != null) onSearch!(controller.text);
                                  },
                                  textInputAction: TextInputAction.search,
                                  style: TextStyle(color: kFontColorPallets[1]),
                                )),
                              ],
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: kSpacing * 2),
                      Obx(
                        () => Visibility(
                          visible:
                              controller.shoppingCartAvailable.value == false,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 40, bottom: 8.0),
                            child: Row(
                              children: [
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      if (controller
                                              .prodCategoriesAvailable.value ==
                                          false) {
                                        controller.productFilterAvailable
                                            .value = false;
                                        controller.productsAvailable.value =
                                            false;
                                        controller.productDetailAvailable
                                            .value = false;
                                        controller.prodCategoriesAvailable
                                            .value = true;
                                        controller.prodStockAvailable.value =
                                            false;
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
                                      visible: controller
                                              .prodCategoriesAvailable.value ==
                                          false,
                                      child: const Text(
                                        "  >  ",
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                Obx(
                                  () => Visibility(
                                      visible: controller
                                              .prodCategoriesAvailable.value ==
                                          false,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (controller
                                              .productDetailAvailable.value) {
                                            controller.productDetailAvailable
                                                .value = false;
                                            controller.productFilterAvailable
                                                .value = true;
                                            controller.productsAvailable.value =
                                                true;
                                            controller.chosenDetailSize.value =
                                                "";
                                            controller.prodStockAvailable
                                                .value = false;
                                          }
                                        },
                                        child: Text(
                                          controller.chosenCategoryName.value,
                                          style: TextStyle(
                                              color: controller
                                                          .productDetailAvailable
                                                          .value ==
                                                      false
                                                  ? Colors.grey
                                                  : Colors.deepPurpleAccent),
                                        ),
                                      )),
                                ),
                                Obx(
                                  () => Visibility(
                                      visible: controller
                                          .productDetailAvailable.value,
                                      child: const Text(
                                        "  >  ",
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                ),
                                Obx(
                                  () => Visibility(
                                      visible: controller
                                          .productDetailAvailable.value,
                                      child: Text(
                                        controller.chosenProductName.value,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() => Visibility(
                            visible: controller.prodCategoriesAvailable.value &&
                                controller.shoppingCartAvailable.value == false,
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
                                    controller.cat = controller
                                        .prodCategories.records![index].id!;
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
                                                : Image.network(
                                                    'https://freesvg.org/img/Simple-Image-Not-Found-Icon.png'),
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
                            visible: controller.productFilterAvailable.value &&
                                controller.shoppingCartAvailable.value == false,
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
                                            margin: const EdgeInsets.all(4),
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
                                                        Text("Color".tr),
                                                    title: Text("Colors".tr),
                                                    items:
                                                        controller._colorItems,
                                                    onConfirm: (values) {
                                                      controller
                                                          .colorUrlFilter = "";
                                                      controller
                                                              ._selectedColors =
                                                          values;
                                                      var flag = false;
                                                      for (var element
                                                          in controller
                                                              ._selectedColors) {
                                                        if (controller
                                                                .colorUrlFilter ==
                                                            "") {
                                                          flag = true;
                                                          controller
                                                              .colorUrlFilter = controller
                                                                  .colorUrlFilter +
                                                              " AND (AD_PrintColor_ID eq ${element.id}";
                                                        } else {
                                                          controller
                                                              .colorUrlFilter = controller
                                                                  .colorUrlFilter +
                                                              " OR AD_PrintColor_ID eq ${element.id}";
                                                          flag = true;
                                                        }
                                                      }
                                                      if (flag) {
                                                        controller
                                                                .colorUrlFilter =
                                                            controller
                                                                    .colorUrlFilter +
                                                                ")";
                                                      }
                                                      controller
                                                          .getFilteredProducts2(
                                                              controller.cat);
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
                                          /* Container(
                                            margin: const EdgeInsets.all(4),
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
                                                    buttonText: Text("Size".tr),
                                                    title: Text("Sizes".tr),
                                                    items:
                                                        controller._sizeItems,
                                                    onConfirm: (values) {
                                                      controller.sizeUrlFilter =
                                                          "";
                                                      controller
                                                              ._selectedSizes =
                                                          values;
                                                      var flag = false;
                                                      for (var element
                                                          in controller
                                                              ._selectedSizes) {
                                                        if (controller
                                                                .sizeUrlFilter ==
                                                            "") {
                                                          flag = true;
                                                          controller
                                                              .sizeUrlFilter = controller
                                                                  .sizeUrlFilter +
                                                              " AND (lit_ProductSize_ID eq ${element.id}";
                                                        } else {
                                                          controller
                                                              .sizeUrlFilter = controller
                                                                  .sizeUrlFilter +
                                                              " OR lit_ProductSize_ID eq ${element.id}";
                                                          flag = true;
                                                        }
                                                      }
                                                      if (flag) {
                                                        controller
                                                                .sizeUrlFilter =
                                                            controller
                                                                    .sizeUrlFilter +
                                                                ")";
                                                      }
                                                      controller
                                                          .getFilteredProducts2(
                                                              controller.cat);
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay
                                                            .none()),
                                              ],
                                            ),
                                          ), */
                                        ],
                                      ),
                                    ),
                                    /* Padding(
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
                                    ), */
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 15),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => Visibility(
                                              visible: controller
                                                  .productsAvailable.value,
                                              child: Text(
                                                controller.filteredProds
                                                        .records!.length
                                                        .toString() +
                                                    " Products",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () => Visibility(
                                        visible:
                                            controller.productsAvailable.value,
                                        child: StaggeredGrid.count(
                                          crossAxisCount: 3,
                                          children: List.generate(
                                              controller.filteredProds.records!
                                                  .length, (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                controller.detailDropDownSizes =
                                                    [];
                                                controller.qtyFieldController
                                                    .text = "1";
                                                controller.chosenProductName
                                                        .value =
                                                    controller.filteredProds
                                                        .records![index].name!;

                                                for (var element
                                                    in controller.skuProducts) {
                                                  if (element.sku ==
                                                      controller
                                                          .filteredProds
                                                          .records![index]
                                                          .sku) {
                                                    controller
                                                        .detailDropDownSizes
                                                        .add(FilterSize(
                                                            id: element
                                                                .litProductSizeID!
                                                                .id!,
                                                            name: element
                                                                .litProductSizeID!
                                                                .identifier!));
                                                  }
                                                }
                                                controller.getProduct(controller
                                                    .filteredProds
                                                    .records![index]
                                                    .id!);

                                                /* controller.chosenDetailSize
                                                        .value =
                                                    controller._sizes[0].id
                                                        .toString(); */

                                                controller.detailIndex = index;
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  /* shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ), */
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
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
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(controller
                                                                    .filteredProds
                                                                    .records![
                                                                        index]
                                                                    .imageUrl ??
                                                                'https://freesvg.org/img/Simple-Image-Not-Found-Icon.png'),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                          controller
                                                                  .filteredProds
                                                                  .records![
                                                                      index]
                                                                  .name ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        /* subtitle: Row(
                                                          children: [
                                                            Visibility(
                                                              visible: controller
                                                                          .filteredProds
                                                                          .records![
                                                                              index]
                                                                          .qtyAvailable !=
                                                                      null &&
                                                                  controller
                                                                          .filteredProds
                                                                          .records![
                                                                              index]
                                                                          .qtyAvailable
                                                                          .toString() !=
                                                                      "0",
                                                              child: Text(
                                                                  "${"Available".tr}: "),
                                                            ),
                                                            Visibility(
                                                              visible: controller
                                                                          .filteredProds
                                                                          .records![
                                                                              index]
                                                                          .qtyAvailable !=
                                                                      null &&
                                                                  controller
                                                                          .filteredProds
                                                                          .records![
                                                                              index]
                                                                          .qtyAvailable
                                                                          .toString() !=
                                                                      "0",
                                                              child: Text(controller
                                                                  .filteredProds
                                                                  .records![
                                                                      index]
                                                                  .qtyAvailable
                                                                  .toString()),
                                                            ),
                                                            Visibility(
                                                              visible: controller
                                                                      .filteredProds
                                                                      .records![
                                                                          index]
                                                                      .qtyAvailable
                                                                      .toString() ==
                                                                  "0",
                                                              child: Text(
                                                                "Not Available"
                                                                    .tr,
                                                                style:
                                                                    const TextStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        ), */
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
                                      ),
                                    ),
                                  ]),
                                ),
                                const Flexible(flex: 2, child: SizedBox()),
                              ],
                            ),
                          )),
                      Obx(
                        () =>
                            controller.productDetailAvailable.value &&
                                    controller.shoppingCartAvailable.value ==
                                        false
                                ? Visibility(
                                    visible:
                                        controller.productDetailAvailable.value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: StaggeredGrid.count(
                                        crossAxisCount: 8,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        children: [
                                          StaggeredGridTile.count(
                                            crossAxisCellCount: 4,
                                            mainAxisCellCount: 6,
                                            child: ClipRRect(
                                              /* borderRadius:
                                                            BorderRadius.circular(
                                                                8), */
                                              child: controller
                                                          .filteredProds
                                                          .records?[0]
                                                          .imageData !=
                                                      null
                                                  ? Image.memory(
                                                      const Base64Codec()
                                                          .decode((controller
                                                                  .filteredProds
                                                                  .records![
                                                                      controller
                                                                          .detailIndex]
                                                                  .imageData!)
                                                              .replaceAll(
                                                                  RegExp(r'\n'),
                                                                  '')),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(controller
                                                          .filteredProds
                                                          .records![controller
                                                              .detailIndex]
                                                          .imageUrl ??
                                                      'https://freesvg.org/img/Simple-Image-Not-Found-Icon.png'),
                                            ),
                                          ),
                                          StaggeredGridTile.count(
                                            crossAxisCellCount: 4,
                                            mainAxisCellCount: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            controller
                                                                    .prodDetail
                                                                    .records![0]
                                                                    .name ??
                                                                "",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                                  .prodDetail
                                                                  .records![0]
                                                                  .mProductCategoryID!
                                                                  .identifier ??
                                                              "N/A",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 30),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            "EUR ${controller.filteredProds.records![controller.detailIndex].price.toString()}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(() => DropdownButton(
                                                            hint: Text(
                                                                'Choose a Size'
                                                                    .tr),

                                                            value: controller
                                                                        .chosenDetailSize
                                                                        .value ==
                                                                    ""
                                                                ? null
                                                                : controller
                                                                    .chosenDetailSize
                                                                    .value,
                                                            //icon: const Icon(Icons.arrow_downward),
                                                            elevation: 16,
                                                            //style: const TextStyle(color: Colors.deepPurple),
                                                            /* underline: Container(
                                                                  height: 2,
                                                                  color: Colors.deepPurpleAccent,
                                                                ), */
                                                            onChanged:
                                                                (newValue) {
                                                              //print(newValue);
                                                              controller
                                                                      .chosenDetailSize
                                                                      .value =
                                                                  newValue
                                                                      .toString();

                                                              for (var element
                                                                  in controller
                                                                      ._sizes) {
                                                                if (element.id
                                                                        .toString() ==
                                                                    controller
                                                                        .chosenDetailSize
                                                                        .value) {
                                                                  controller
                                                                          .chosenDetailSizeName =
                                                                      element
                                                                          .name;
                                                                }
                                                              }

                                                              /* print(controller
                                                                  .filteredProds
                                                                  .records![
                                                                      controller
                                                                          .detailIndex]
                                                                  .sku! +
                                                              "." +
                                                              controller
                                                                  .chosenDetailSizeName);  */

                                                              var search = controller.skuProducts.where((element) =>
                                                                  element
                                                                      .value ==
                                                                  controller
                                                                          .filteredProds
                                                                          .records![controller
                                                                              .detailIndex]
                                                                          .sku! +
                                                                      "." +
                                                                      controller
                                                                          .chosenDetailSizeName);

                                                              if (search
                                                                  .isNotEmpty) {
                                                                /* print(
                                                                    "trovato"); */
                                                                controller
                                                                    .getProdB2BStock(
                                                                        search
                                                                            .first
                                                                            .id!);
                                                              }
                                                            },
                                                            items: controller
                                                                .detailDropDownSizes
                                                                .map((list) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                  list.name
                                                                      .toString(),
                                                                ),
                                                                value: list.id
                                                                    .toString(),
                                                              );
                                                            }).toList(),
                                                          ))
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextField(
                                                      controller: controller
                                                          .qtyFieldController,
                                                      keyboardType:
                                                          const TextInputType
                                                                  .numberWithOptions(
                                                              signed: true,
                                                              decimal: true),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                                RegExp("[0-9]"))
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                            Icons.scale),
                                                        border:
                                                            const OutlineInputBorder(),
                                                        labelText:
                                                            'Quantity'.tr,
                                                        floatingLabelBehavior:
                                                            FloatingLabelBehavior
                                                                .always,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    //height: 80,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 40,
                                                            bottom: 20),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                var list = controller
                                                                    .productList
                                                                    .where((element) =>
                                                                        element
                                                                            .id ==
                                                                        controller
                                                                            .prodDetail
                                                                            .records![0]
                                                                            .id!);

                                                                if (list
                                                                    .isEmpty) {
                                                                  if (controller
                                                                          .chosenDetailSize
                                                                          .value !=
                                                                      "") {
                                                                    var search = controller.skuProducts.where((element) =>
                                                                        element
                                                                            .value ==
                                                                        controller.filteredProds.records![controller.detailIndex].sku! +
                                                                            "." +
                                                                            controller.chosenDetailSizeName);
                                                                    controller
                                                                        .productList
                                                                        .add(
                                                                            ProductCheckout(
                                                                      id: search
                                                                          .first
                                                                          .id!,
                                                                      name: controller
                                                                          .prodDetail
                                                                          .records![
                                                                              0]
                                                                          .name!,
                                                                      qty: int
                                                                          .parse(
                                                                        controller
                                                                            .qtyFieldController
                                                                            .text,
                                                                      ),
                                                                      cost: controller
                                                                              .filteredProds
                                                                              .records![controller.detailIndex]
                                                                              .price ??
                                                                          0,
                                                                      adPrintColorID: controller
                                                                          .filteredProds
                                                                          .records![
                                                                              controller.detailIndex]
                                                                          .adPrintColorID,
                                                                      litProductSizeID: LitProductSizeID(
                                                                          id: int.parse(controller
                                                                              .chosenDetailSize
                                                                              .value),
                                                                          identifier:
                                                                              controller.chosenDetailSizeName),
                                                                      imageData: controller
                                                                          .filteredProds
                                                                          .records![
                                                                              controller.detailIndex]
                                                                          .imageData,
                                                                      imageUrl: controller
                                                                          .filteredProds
                                                                          .records![
                                                                              controller.detailIndex]
                                                                          .imageUrl,
                                                                    ));

                                                                    controller
                                                                        .shoppingCartCounter
                                                                        .value++;
                                                                    controller
                                                                        .updateTotal();
                                                                    controller
                                                                        .productDetailAvailable
                                                                        .value = false;
                                                                    controller
                                                                        .productFilterAvailable
                                                                        .value = true;
                                                                    controller
                                                                        .productsAvailable
                                                                        .value = true;
                                                                    controller
                                                                        .chosenDetailSize
                                                                        .value = "";
                                                                  }
                                                                } else {
                                                                  controller
                                                                      .qtyFieldController
                                                                      .text = "1";
                                                                  controller
                                                                      .shoppingCartAvailable
                                                                      .value = true;
                                                                  controller
                                                                      .prodStockAvailable
                                                                      .value = false;
                                                                }
                                                              },
                                                              child: Text(
                                                                (controller.productList.where((element) =>
                                                                        element
                                                                            .id ==
                                                                        controller
                                                                            .prodDetail
                                                                            .records![0]
                                                                            .id!)).isEmpty
                                                                    ? "Add to Cart".tr
                                                                    : "Item added, go to your Cart".tr,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  /* ExpansionTile(
                                                title: Text(
                                                    "Composition and Washing Instructions"),
                                              ), */
                                                  Obx(
                                                    () => controller
                                                            .prodStockAvailable
                                                            .value
                                                        ? ExpansionTile(
                                                            initiallyExpanded:
                                                                true,
                                                            title: Text(
                                                                "Product Stock"
                                                                    .tr,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 8.0,
                                                                    bottom: 8.0,
                                                                    left: 15,
                                                                    right: 15,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${"Warehouse".tr}: ",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text((controller.currentStock.qtyOnHand ?? 0)
                                                                              .toString()),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${"Headquarter".tr}: ",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text((controller.providerStock.qtyAvailable ?? 0)
                                                                              .toString()),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${"Restock".tr}: ",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text((controller.futureStock.qtyOrdered ?? 0)
                                                                              .toString()),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${"Restock Date".tr}: ",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(controller.futureStock.litDateReStock ??
                                                                              ""),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ])
                                                        : const SizedBox(),
                                                  ),
                                                  Visibility(
                                                    visible: controller
                                                            .prodDetail
                                                            .records![0]
                                                            .description !=
                                                        null,
                                                    child: ExpansionTile(
                                                        initiallyExpanded: true,
                                                        title: Text(
                                                            "Product Description"
                                                                .tr,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 8.0,
                                                              bottom: 8.0,
                                                              left: 15,
                                                              right: 15,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(controller
                                                                            .prodDetail
                                                                            .records![0]
                                                                            .description ??
                                                                        "N/A"),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          /* StaggeredGridTile.count(
                                  crossAxisCellCount: 4,
                                  mainAxisCellCount: 2,
                                  child: Tile(index: 1),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: 2,
                                  child: Tile(index: 2),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: 2,
                                  child: Tile(index: 3),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 8,
                                  mainAxisCellCount: 4,
                                  child: Tile(index: 4),
                                ), */
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                      ),
                      Obx(
                        () => controller.shoppingCartAvailable.value
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            controller.shoppingCartAvailable
                                                .value = false;
                                          },
                                          child: Text("Back".tr)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          fit: FlexFit.tight,
                                          flex: 6,
                                          child: Container(
                                              color:
                                                  Theme.of(context).cardColor,
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "${"Cart".tr} (${controller.shoppingCartCounter.value} ${"products".tr})",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20)),
                                                    ],
                                                  ),
                                                  ListView.builder(
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .productList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final item = controller
                                                            .productList[index]
                                                            .id
                                                            .toString();
                                                        return FadeInDown(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  350 * index),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10),
                                                            child: Dismissible(
                                                              key: Key(item),
                                                              onDismissed:
                                                                  (direction) {
                                                                controller
                                                                    .productList
                                                                    .removeWhere((element) =>
                                                                        element
                                                                            .id
                                                                            .toString() ==
                                                                        controller
                                                                            .productList[index]
                                                                            .id
                                                                            .toString());
                                                                controller
                                                                    .shoppingCartCounter
                                                                    .value--;
                                                                controller
                                                                    .updateTotal();
                                                                //controller.updateCounter();
                                                              },
                                                              child: Card(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.grey,
                                                                            /* boxShadow: [BoxShadow(
                                                              spreadRadius: 0.5,
                                                              color: black.withOpacity(0.1),
                                                              blurRadius: 1
                                                            )], */
                                                                            borderRadius: BorderRadius.circular(20)),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              80,
                                                                          //height: 120,
                                                                          child:
                                                                              ClipRRect(
                                                                            //borderRadius: BorderRadius.circular(8),
                                                                            child: controller.productList[index].imageData != null
                                                                                ? Image.memory(
                                                                                    const Base64Codec().decode((controller.productList[index].imageData!).replaceAll(RegExp(r'\n'), '')),
                                                                                    fit: BoxFit.cover,
                                                                                  )
                                                                                : Image.network(controller.productList[index].imageUrl ?? 'https://freesvg.org/img/Simple-Image-Not-Found-Icon.png'),
                                                                          ),

                                                                          //decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/404.png"), fit: BoxFit.cover)),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            controller.productList[index].name,
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                controller.productList[index].adPrintColorID != null,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${"Color".tr}: ${controller.productList[index].adPrintColorID?.identifier ?? ""}",
                                                                                  style: const TextStyle(color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                controller.productList[index].litProductSizeID != null,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${"Size".tr}: ${controller.productList[index].litProductSizeID?.identifier ?? ""}",
                                                                                  style: const TextStyle(color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: <Widget>[
                                                                              Text(
                                                                                "€ " + controller.productList[index].cost.toString(),
                                                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                                              ),
                                                                              Container(
                                                                                margin: const EdgeInsets.only(right: 10),
                                                                                child: Text(
                                                                                  "x${controller.productList[index].qty}",
                                                                                  style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      })
                                                ],
                                              ))),
                                      Flexible(
                                          flex: 4,
                                          child: Container(
                                            color: Theme.of(context).cardColor,
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Total".tr,
                                                        style: const TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Subtotal".tr),
                                                    Obx(
                                                      () => Text(
                                                        "EUR ${controller.total.value}",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              controller
                                                                  .createSalesOrder();
                                                            },
                                                            child: Text(
                                                                "Proceed".tr)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      )

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                            backgroundImage: controller.getProfil().photo),
                        title: Text(
                          controller.getProfil().name,
                          style: TextStyle(
                              fontSize: 14, color: kFontColorPallets[0]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          controller.getProfil().email,
                          style: TextStyle(
                              fontSize: 12, color: kFontColorPallets[2]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        /* trailing: IconButton(
                            onPressed: onPressedNotification,
                            icon: const Icon(EvaIcons.bellOutline),
                            tooltip: "notification",
                          ), */
                        trailing: Stack(
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(Icons.shopping_bag_outlined),
                                onPressed: () {
                                  controller.shoppingCartAvailable.value = true;
                                  controller.prodStockAvailable.value = false;
                                }),
                            Obx(
                              () => Visibility(
                                visible:
                                    controller.shoppingCartCounter.value != 0
                                        ? true
                                        : false,
                                child: Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      '${controller.shoppingCartCounter.value}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 7,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
          Expanded(
              child: Row(
            children: [
              const TodayText(),
              const SizedBox(width: kSpacing),
              Expanded(child: SearchField()),
            ],
          )),
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

  Widget _buildProfile({required _Profile data, required int counter}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ProfilTile(
        data: data,
        onPressedNotification: () {
          //Get.toNamed('/Notification');
        },
        counter: counter,
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

class FilterColor {
  final int id;
  final String name;

  FilterColor({
    required this.id,
    required this.name,
  });
}

class FilterSize {
  final int id;
  final String name;

  FilterSize({
    required this.id,
    required this.name,
  });
}

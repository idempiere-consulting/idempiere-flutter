// ignore_for_file: unused_element

library dashboard;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/businesspartner_location_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_term_json.dart';
//import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/product_list_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/productcheckout.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/salesorder_defaults_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_Contract/models/documenttype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_Contract/models/organization_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
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
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../CRM_Contact_BP/models/contact.dart';

// binding
part '../../bindings/crm_sales_order_contract_creation_binding.dart';

// controller
part '../../controllers/crm_sales_order_contract_creation_controller.dart';

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

class CRMSalesOrderContractCreationScreen
    extends GetView<CRMSalesOrderContractCreationController> {
  const CRMSalesOrderContractCreationScreen({Key? key}) : super(key: key);

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
        appBar: AppBar(
          centerTitle: true,
          title: Text('Contract Creation'.tr),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              if (controller.filterCount.value > 0) {
                controller.changeFilterMinus();
              } else {
                Get.back();
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () {
                  controller.changeFilterPlus();
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(children: [
                //const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(
                    () => StepProgressIndicator(
                      roundedEdges: const Radius.circular(10),
                      totalSteps: 4,
                      currentStep: controller.filterCount.value + 1,
                      size: 36,
                      onTap: (index) {
                        return () {
                          if (kDebugMode) {
                            print('$index pressed');
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
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.topic_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Positioned(
                                                        right: 1,
                                                        top: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
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
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.topic_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Positioned(
                                                        right: 1,
                                                        top: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
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
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
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
                                      controller.businessPartnerId =
                                          selection.id!;
                                      controller.getBusinessPartner("0");
                                      controller.getSalesOrderDefaultValues();
                                      controller.getDefaultPaymentTermsFromBP();
                                      controller.getLocationFromBP();
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
                    visible: controller.filterCount.value == 0,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.createBusinessPartner();
                        },
                        child: Text('New Business Partner'.tr)),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.nameFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.ivaFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.payments),
                          border: const OutlineInputBorder(),
                          labelText: 'P. IVA'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.addressFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.home),
                          border: const OutlineInputBorder(),
                          labelText: 'Address'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 3,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.technicianFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.build),
                          border: const OutlineInputBorder(),
                          labelText: 'SalesRep'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 0,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SalesRep".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllSalesReps(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<Records>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .technicianFieldController.text),
                                    displayStringForOption:
                                        controller.displayTechStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<Records>.empty();
                                      }
                                      return snapshot.data!
                                          .where((Records option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (Records selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.technicianFieldController
                                          .text = selection.name!;
                                      controller.technicianId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Organization".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllOrgs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<ORecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<ORecords>(
                                    initialValue: TextEditingValue(
                                        text:
                                            controller.orgFieldController.text),
                                    displayStringForOption:
                                        controller.displayOrgStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<ORecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((ORecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (ORecords selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.orgFieldController.text =
                                          selection.name!;
                                      controller.orgId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Document Type".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getSalesOrderDocTypes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<DTRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<DTRecords>(
                                    initialValue: TextEditingValue(
                                        text:
                                            controller.docFieldController.text),
                                    displayStringForOption:
                                        controller.displayDocStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            DTRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((DTRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (DTRecords selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.docFieldController.text =
                                          selection.name!;
                                      controller.docId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 20),
                      /*  decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: DateTimePicker(
                        //locale: Locale('languageCalendar'.tr),
                        type: DateTimePickerType.date,
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Contract Date'.tr,
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date = val.substring(0, 10);

                          //print(date);
                        },
                        validator: (val) {
                          //print(val);
                          return null;
                        },
                        //onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        //readOnly: true,
                        controller: controller.descriptionFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Object'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 3,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      padding: const EdgeInsets.only(left: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Search by product".tr,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllProducts(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<PRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<PRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .prodFieldController.text),
                                    displayStringForOption:
                                        controller.displayProdStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<PRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((PRecords option) {
                                        return ("${option.value}_${option.name}")
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (PRecords selection) {
                                      //print(salesrepValue);
                                      controller.productNameFieldController
                                          .text = selection.name!;
                                      controller.descriptionFieldController
                                          .text = selection.description ?? "";
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
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        //readOnly: true,
                        controller: controller.productNameFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        //readOnly: true,
                        controller:
                            controller.productDescriptionFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Description'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        controller: controller.productQtyFieldController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.scale),
                          border: const OutlineInputBorder(),
                          labelText: 'Quantity'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        controller: controller.productPriceFieldController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(EvaIcons.pricetagsOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Price'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),

                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("Add Product"))),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: const Divider()),
                ),
                /* Obx(
                  () => Visibility(
                    visible: controller.dataAvailable &&
                        controller.filterCount.value == 2,
                    child: controller.dataAvailable
                        ? SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            //height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: controller._trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ), */
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Term".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pTermAvailable.value
                          ? DropdownButton(
                              value: controller.paymentTermId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentTermId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pTerms.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Rule".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pRuleAvailable.value
                          ? DropdownButton(
                              value: controller.paymentRuleId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentRuleId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pRules.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.value,
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
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
                                  controller.productList.removeWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          controller.productList[index].id
                                              .toString());
                                  controller.updateTotal();
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
                                                            fit: BoxFit.cover)),
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
                                              controller
                                                  .productList[index].name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "€ ${controller.productList[index].cost}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "x${controller.productList[index].qty}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                        }),
                  ),
                ),
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Column(children: [
                //const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(
                    () => StepProgressIndicator(
                      roundedEdges: const Radius.circular(10),
                      totalSteps: 4,
                      currentStep: controller.filterCount.value + 1,
                      size: 36,
                      onTap: (index) {
                        return () {
                          if (kDebugMode) {
                            print('$index pressed');
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
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.topic_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Positioned(
                                                        right: 1,
                                                        top: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
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
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.topic_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Positioned(
                                                        right: 1,
                                                        top: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
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
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
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
                                      controller.businessPartnerId =
                                          selection.id!;
                                      controller.getBusinessPartner("0");
                                      controller.getSalesOrderDefaultValues();
                                      controller.getDefaultPaymentTermsFromBP();
                                      controller.getLocationFromBP();
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
                    visible: controller.filterCount.value == 0,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.createBusinessPartner();
                        },
                        child: Text('New Business Partner'.tr)),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.nameFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.ivaFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.payments),
                          border: const OutlineInputBorder(),
                          labelText: 'P. IVA'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.addressFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.home),
                          border: const OutlineInputBorder(),
                          labelText: 'Address'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 3,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.technicianFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.build),
                          border: const OutlineInputBorder(),
                          labelText: 'SalesRep'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 0,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SalesRep".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllSalesReps(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<Records>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .technicianFieldController.text),
                                    displayStringForOption:
                                        controller.displayTechStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<Records>.empty();
                                      }
                                      return snapshot.data!
                                          .where((Records option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (Records selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.technicianFieldController
                                          .text = selection.name!;
                                      controller.technicianId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Organization".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllOrgs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<ORecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<ORecords>(
                                    initialValue: TextEditingValue(
                                        text:
                                            controller.orgFieldController.text),
                                    displayStringForOption:
                                        controller.displayOrgStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<ORecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((ORecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (ORecords selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.orgFieldController.text =
                                          selection.name!;
                                      controller.orgId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Document Type".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getSalesOrderDocTypes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<DTRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<DTRecords>(
                                    initialValue: TextEditingValue(
                                        text:
                                            controller.docFieldController.text),
                                    displayStringForOption:
                                        controller.displayDocStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            DTRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((DTRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (DTRecords selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.docFieldController.text =
                                          selection.name!;
                                      controller.docId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 20),
                      /*  decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: DateTimePicker(
                        //locale: Locale('languageCalendar'.tr),
                        type: DateTimePickerType.date,
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Contract Date'.tr,
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date = val.substring(0, 10);

                          //print(date);
                        },
                        validator: (val) {
                          //print(val);
                          return null;
                        },
                        //onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        //readOnly: true,
                        controller: controller.descriptionFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Object'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 3,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      padding: const EdgeInsets.only(left: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Search by product".tr,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllProducts(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<PRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<PRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .prodFieldController.text),
                                    displayStringForOption:
                                        controller.displayProdStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<PRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((PRecords option) {
                                        return ("${option.value}_${option.name}")
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (PRecords selection) {
                                      //print(salesrepValue);
                                      controller.productNameFieldController
                                          .text = selection.name!;
                                      controller.descriptionFieldController
                                          .text = selection.description ?? "";
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
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        //readOnly: true,
                        controller: controller.productNameFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        //readOnly: true,
                        controller:
                            controller.productDescriptionFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Description'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        controller: controller.productQtyFieldController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.scale),
                          border: const OutlineInputBorder(),
                          labelText: 'Quantity'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        controller: controller.productPriceFieldController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(EvaIcons.pricetagsOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Price'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),

                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("Add Product"))),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: const Divider()),
                ),
                /* Obx(
                  () => Visibility(
                    visible: controller.dataAvailable &&
                        controller.filterCount.value == 2,
                    child: controller.dataAvailable
                        ? SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            //height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: controller._trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ), */
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Term".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pTermAvailable.value
                          ? DropdownButton(
                              value: controller.paymentTermId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentTermId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pTerms.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Rule".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pRuleAvailable.value
                          ? DropdownButton(
                              value: controller.paymentRuleId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentRuleId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pRules.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.value,
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
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
                                  controller.productList.removeWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          controller.productList[index].id
                                              .toString());
                                  controller.updateTotal();
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
                                                            fit: BoxFit.cover)),
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
                                              controller
                                                  .productList[index].name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "€ ${controller.productList[index].cost}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "x${controller.productList[index].qty}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                        }),
                  ),
                ),
              ]);
            },
            desktopBuilder: (context, constraints) {
              return Column(children: [
                //const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(
                    () => StepProgressIndicator(
                      roundedEdges: const Radius.circular(10),
                      totalSteps: 4,
                      currentStep: controller.filterCount.value + 1,
                      size: 36,
                      onTap: (index) {
                        return () {
                          if (kDebugMode) {
                            print('$index pressed');
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
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.topic_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Positioned(
                                                        right: 1,
                                                        top: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
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
                                    Icons.handshake,
                                    color: Colors.white,
                                  ),
                                )
                              : index == 1
                                  ? Container(
                                      color: color,
                                      child: const Icon(
                                        Icons.topic_outlined,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index == 2
                                      ? Container(
                                          color: color,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: <Widget>[
                                                  const Icon(Icons
                                                      .shopping_cart_checkout),
                                                  Obx(
                                                    () => Visibility(
                                                      visible: controller
                                                                  .counter
                                                                  .value !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Positioned(
                                                        right: 1,
                                                        top: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      : index == 3
                                          ? Container(
                                              color: color,
                                              child: const Icon(
                                                Icons.payment,
                                                color: Colors.white,
                                              ),
                                            )
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
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
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
                                      controller.businessPartnerId =
                                          selection.id!;
                                      controller.getBusinessPartner("0");
                                      controller.getSalesOrderDefaultValues();
                                      controller.getDefaultPaymentTermsFromBP();
                                      controller.getLocationFromBP();
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
                    visible: controller.filterCount.value == 0,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.createBusinessPartner();
                        },
                        child: Text('New Business Partner'.tr)),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.nameFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.ivaFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.payments),
                          border: const OutlineInputBorder(),
                          labelText: 'P. IVA'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.addressFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.home),
                          border: const OutlineInputBorder(),
                          labelText: 'Address'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 3,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        //maxLines: 5,
                        readOnly: true,
                        controller: controller.technicianFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.build),
                          border: const OutlineInputBorder(),
                          labelText: 'SalesRep'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 0,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SalesRep".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllSalesReps(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<Records>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .technicianFieldController.text),
                                    displayStringForOption:
                                        controller.displayTechStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<Records>.empty();
                                      }
                                      return snapshot.data!
                                          .where((Records option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (Records selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.technicianFieldController
                                          .text = selection.name!;
                                      controller.technicianId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Organization".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllOrgs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<ORecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<ORecords>(
                                    initialValue: TextEditingValue(
                                        text:
                                            controller.orgFieldController.text),
                                    displayStringForOption:
                                        controller.displayOrgStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<ORecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((ORecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (ORecords selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.orgFieldController.text =
                                          selection.name!;
                                      controller.orgId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Document Type".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getSalesOrderDocTypes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<DTRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<DTRecords>(
                                    initialValue: TextEditingValue(
                                        text:
                                            controller.docFieldController.text),
                                    displayStringForOption:
                                        controller.displayDocStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            DTRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((DTRecords option) {
                                        return option.name!
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (DTRecords selection) {
                                      //debugPrint(
                                      //'You just selected ${_displayStringForOption(selection)}');
                                      controller.docFieldController.text =
                                          selection.name!;
                                      controller.docId = selection.id!;

                                      //print(salesrepValue);
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
                    visible: controller.filterCount.value == 1 ||
                        controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 20),
                      /*  decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: DateTimePicker(
                        //locale: Locale('languageCalendar'.tr),
                        type: DateTimePickerType.date,
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Contract Date'.tr,
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date = val.substring(0, 10);

                          //print(date);
                        },
                        validator: (val) {
                          //print(val);
                          return null;
                        },
                        //onSaved: (val) => print(val),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        //readOnly: true,
                        controller: controller.descriptionFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Object'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 3,
                      child: const Divider()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      padding: const EdgeInsets.only(left: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Search by product".tr,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAllProducts(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<PRecords>> snapshot) =>
                            snapshot.hasData
                                ? Autocomplete<PRecords>(
                                    initialValue: TextEditingValue(
                                        text: controller
                                            .prodFieldController.text),
                                    displayStringForOption:
                                        controller.displayProdStringForOption,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<PRecords>.empty();
                                      }
                                      return snapshot.data!
                                          .where((PRecords option) {
                                        return ("${option.value}_${option.name}")
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (PRecords selection) {
                                      //print(salesrepValue);
                                      controller.productNameFieldController
                                          .text = selection.name!;
                                      controller.descriptionFieldController
                                          .text = selection.description ?? "";
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
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        //readOnly: true,
                        controller: controller.productNameFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        //readOnly: true,
                        controller:
                            controller.productDescriptionFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Description'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        controller: controller.productQtyFieldController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.scale),
                          border: const OutlineInputBorder(),
                          labelText: 'Quantity'.tr,
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
                      margin: const EdgeInsets.all(20),
                      child: TextField(
                        controller: controller.productPriceFieldController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(EvaIcons.pricetagsOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Price'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),

                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("Add Product"))),
                ),
                Obx(
                  () => Visibility(
                      visible: controller.filterCount.value == 2,
                      child: const Divider()),
                ),
                /* Obx(
                  () => Visibility(
                    visible: controller.dataAvailable &&
                        controller.filterCount.value == 2,
                    child: controller.dataAvailable
                        ? SizedBox(
                            //margin: const EdgeInsets.only(top: 10),
                            //height: size.height,
                            width: double.infinity,
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              itemCount: controller._trx.records?.length ?? 0,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemBuilder: (BuildContext context, index) =>
                                  buildImageCard(index),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ), */
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Term".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pTermAvailable.value
                          ? DropdownButton(
                              value: controller.paymentTermId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentTermId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pTerms.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Rule".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      /* decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, 
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ), */
                      margin: const EdgeInsets.all(10),
                      child: controller.pRuleAvailable.value
                          ? DropdownButton(
                              value: controller.paymentRuleId.value,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                controller.paymentRuleId.value = newValue!;

                                //print(dropdownValue);
                              },
                              items: controller.pRules.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.value,
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 3,
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
                                  controller.productList.removeWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          controller.productList[index].id
                                              .toString());
                                  controller.updateTotal();
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
                                                            fit: BoxFit.cover)),
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
                                              controller
                                                  .productList[index].name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "€ ${controller.productList[index].cost}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    "x${controller.productList[index].qty}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                        }),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  /* Widget buildImageCard(int index) => GestureDetector(
        onTap: () {
          Get.to(const ProductListDetail(), arguments: {
            "id": controller._trx.records![index].id,
            "add": true,
            "priceStd": controller._trx.records![index].price,
            "priceList": controller._trx.records![index].pricelist,
            "page": "createContract",
          });
        },
        child: Card(
          //color: Color.fromRGBO(38, 40, 55, 1),
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
                      : const Text("no image"),
                ),
              ),
              ListTile(
                title: Text(
                  "  €" + controller._trx.records![index].price.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            controller._trx.records![index].name ?? "??",
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
      ); */

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

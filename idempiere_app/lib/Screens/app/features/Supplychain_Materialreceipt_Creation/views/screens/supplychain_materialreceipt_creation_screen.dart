// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/models/orginfo_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/models/rvbpartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_create_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_Contract/models/documenttype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/shipment_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_edit.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/models/shipmentline_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/views/screens/supplychain_materialreceipt_edit.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/views/screens/supplychain_materialreceipt_filter_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Line/models/salesorderline_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt_Creation/models/materialreceipt_purchaseorder_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt_Creation/views/screens/supplychain_materialreceipt_create_orderlines.dart';
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
import 'package:path_provider/path_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/supplychain_materialreceipt_creation_binding.dart';

// controller
part '../../controllers/supplychain_materialreceipt_creation_controller.dart';

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

class SupplychainMaterialreceiptCreationScreen
    extends GetView<SupplychainMaterialreceiptCreationController> {
  const SupplychainMaterialreceiptCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController orderListController = ScrollController();
    Size size = MediaQuery.of(context).size;
    //getSalesRepAutoComplete();
/*     Size size = MediaQuery.of(context).size; */
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Material Receipt'.tr),
      ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => StepProgressIndicator(
                  roundedEdges: const Radius.circular(10),
                  totalSteps: 3,
                  currentStep: controller.currentStep.value,
                  size: 36,
                  onTap: (index) {
                    return () {
                      switch (index) {
                        case 0:
                          controller.currentStep.value = index + 1;

                          break;
                        case 1:
                          controller.currentStep.value = index + 1;

                          break;
                        case 2:
                          controller.currentStep.value = index + 1;

                          break;
                        default:
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
                                    MaterialSymbols.playlist_add,
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
                                            children: const <Widget>[
                                              Icon(
                                                  Icons.shopping_cart_checkout),
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
                                    MaterialSymbols.playlist_add,
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
                                            children: const <Widget>[
                                              Icon(
                                                  Icons.shopping_cart_checkout),
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
              Obx(
                () => Visibility(
                  visible: controller.currentStep.value == 1,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 20),
                    child: FutureBuilder(
                      future: controller.getAllBPs(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<BPRecords>> snapshot) =>
                          snapshot.hasData
                              ? TypeAheadField<BPRecords>(
                                  direction: AxisDirection.down,
                                  //getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == "") {
                                        controller.businessPartnerId = 0;
                                      }
                                    },
                                    controller:
                                        controller.bpSearchFieldController,
                                    //autofocus: true,

                                    decoration: InputDecoration(
                                      //filled: true,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.handshake),
                                      //hintText: "Business Partner",
                                      labelText: 'Business Partner',
                                      isDense: true,
                                      fillColor: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return snapshot.data!.where((element) =>
                                        (element.name ?? "")
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      //leading: Icon(Icons.shopping_cart),
                                      title: Text(suggestion.name ?? ""),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    controller.bpSearchFieldController.text =
                                        suggestion.name!;
                                    controller.businessPartnerId =
                                        suggestion.id!;
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
                  visible: controller.currentStep.value == 1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: controller.documentDateFieldController,
                      decoration: InputDecoration(
                        //filled: true,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        labelText: 'Document Date'.tr,
                        hintText: "DD/MM/YYYY",
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.currentStep.value == 1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: controller.docNoFieldController,
                      decoration: InputDecoration(
                        //filled: true,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.text_fields),
                        //hintText: "Business Partner",
                        labelText: 'DocumentNo'.tr,
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.currentStep.value == 2,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: controller.docNoFieldController,
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(EvaIcons.search),
                        hintText: "Search Order...",
                        isDense: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.orderListAvailable.value == true &&
                      controller.currentStep.value == 2,
                  child: SizedBox(
                    height: size.height * 0.65,
                    child: ListView.builder(
                        //primary: true,
                        controller: orderListController,
                        //scrollDirection: Axis.vertical,
                        //shrinkWrap: true,
                        itemCount: controller.orderList.records!.length,
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
                                    child: Checkbox(
                                        value: false,
                                        onChanged: (newvalue) {})),
                                title: Text(
                                  controller.orderList.records![index]
                                          .documentNo ??
                                      '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(children: [
                                  Row(
                                    children: [
                                      Text(
                                        controller.orderList.records![index]
                                                .dateOrdered ??
                                            '',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ]),
                                trailing: IconButton(
                                    onPressed: () {
                                      Get.to(
                                          () =>
                                              const SupplychainCreateMaterialReceiptOrderLine(),
                                          arguments: {
                                            "id": controller
                                                .orderList.records![index].id,
                                            "docNo": controller.orderList
                                                .records![index].documentNo,
                                            "businessPartnerName": controller
                                                .orderList
                                                .records![index]
                                                .cBPartnerID
                                                ?.identifier,
                                          });
                                    },
                                    icon: const Icon(
                                        Icons.manage_search_outlined)),
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    children: const [],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.currentStep.value == 3,
                  child: Flexible(
                    flex: 9,
                    child: ListView.builder(
                        //primary: true,
                        //controller: orderListController,
                        //scrollDirection: Axis.vertical,
                        //shrinkWrap: true,
                        itemCount: controller.orderLineList.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ListTile(
                                /*  tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0), */
                                /* leading: Container(
                                        padding: const EdgeInsets.only(right: 12.0),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white24))),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          tooltip: ''.tr,
                                          onPressed: () {},
                                        ),
                                      ), */

                                title: Text(
                                  controller.orderLineList.records![index]
                                          .mProductID?.identifier ??
                                      "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Order: ".tr,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          controller
                                                  .orderLineList
                                                  .records![index]
                                                  .cOrderID
                                                  ?.identifier ??
                                              '',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Vendor Code: ".tr,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          controller
                                                  .orderLineList
                                                  .records![index]
                                                  .vendorProductNo ??
                                              'N/A',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              margin: const EdgeInsets.all(1),
                                              child: TextField(
                                                textAlign: TextAlign.end,
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: controller
                                                            .orderLineList
                                                            .records![index]
                                                            .qtyOrdered!
                                                            .toInt()
                                                            .toString()),
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Ordered'.tr,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              margin: const EdgeInsets.all(1),
                                              child: TextField(
                                                textAlign: TextAlign.end,
                                                readOnly: true,
                                                controller:
                                                    TextEditingController(
                                                        text: controller
                                                            .orderLineList
                                                            .records![index]
                                                            .qtyReserved!
                                                            .toInt()
                                                            .toString()),
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Reserved'.tr,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              margin: const EdgeInsets.all(1),
                                              child: TextField(
                                                textAlign: TextAlign.end,
                                                controller:
                                                    TextEditingController(
                                                        text: controller
                                                            .orderLineList
                                                            .records![index]
                                                            .qtyRegistered!
                                                            .toString()),
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  labelText: 'Quantity'.tr,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
              Obx(
                () => Visibility(
                  visible: controller.currentStep.value == 3,
                  child: Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Confirm Material Receipt'.tr)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        tabletBuilder: (context, constraints) {
          return Column(
            children: const [],
          );
        },
        desktopBuilder: (context, constraints) {
          return Column(
            children: const [],
          );
        },
      ),
    );
  }
}

class _DateFormatterCustom extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = '${cText.substring(0, 2)}/';
      } else {
        // Insert / char
        cText =
            '${cText.substring(0, pLen)}/${cText.substring(pLen, pLen + 1)}';
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = '${cText.substring(0, 5)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, 5)}/${cText.substring(5, 6)}';
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

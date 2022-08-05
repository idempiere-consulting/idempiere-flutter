// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
//import 'dart:js';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_edit_opportunity.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_create.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Opportunity/models/opportunity.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Opportunity/models/portal_mp_ad_user_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Opportunity/models/salestagejson.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

// binding
part '../../bindings/portal_mp_opportunity_binding.dart';

// controller
part '../../controllers/portal_mp_opportunity_controller.dart';

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

class PortalMpOpportunityScreen extends GetView<PortalMpOpportunityController> {
  const PortalMpOpportunityScreen({Key? key}) : super(key: key);

  sendAttachment(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final msg = jsonEncode({"name": controller.imageName.text, "data": controller.image64});

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/C_Opportunity/$id/attachments');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      
    } else {
      Get.snackbar(
        "Error!".tr,
        "Attachment not sent".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  createOpportunity() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Ad_User_ID": {"id": controller.userNotListed ?
        null :  int.parse(controller.userDropDownValue)},
      "C_BPartner_ID": {"id": GetStorage().read("BusinessPartnerId")},
      "C_SalesStage_ID": {"id": controller.trxSalesStage.records![0].id},
      "OpportunityAmt": 0,
      "C_Currency_ID": 102,
      "Probability": 0,
      "ExpectedCloseDate": controller.opportunityFields[2].text,
      "Description": controller.opportunityFields[5].text,
      "Comments": controller.opportunityFields[3].text, 
      "Note": controller.userNotListed ? 
        controller.opportunityFields[7].text : "",
      "Phone": controller.userNotListed ? 
        controller.opportunityFields[8].text : "",
      "EMail": controller.userNotListed ?
        controller.opportunityFields[9].text : ""
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/C_Opportunity/');
    //print(msg);
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      Get.find<PortalMpOpportunityController>().getOpportunities();
      //print("done!");
      Map<String, dynamic> responseJson = json.decode(response.body);
      int id = responseJson["id"];
      
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
      if(controller.image64 != ""){
        sendAttachment(id);
      }
    } else {
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  updateOpportunity() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Ad_User_ID": {"id": controller.userNotListed ?
        null :  int.parse(controller.userDropDownValue)},
      "C_BPartner_ID": {"id": GetStorage().read("BusinessPartnerId")},
      "C_SalesStage_ID": {"id": controller.trxOpportunity.records!
        [controller.selectedCard].cSalesStageID!.id},
      "OpportunityAmt": controller.trxOpportunity.records!
        [controller.selectedCard].opportunityAmt,
      "C_Currency_ID": {"id": controller.trxOpportunity.records!
        [controller.selectedCard].cCurrencyID!.id},
      "Probability": controller.trxOpportunity.records!
        [controller.selectedCard].probability,
      "ExpectedCloseDate": controller.trxOpportunity.records!
        [controller.selectedCard].expectedCloseDate,
      "Description": controller.opportunityFields[5].text,
      "Comments": controller.opportunityFields[3].text,
      "Note": controller.userNotListed ? 
        controller.opportunityFields[7].text : "",
      "Phone": controller.userNotListed ? 
        controller.opportunityFields[8].text : "",
      "EMail": controller.userNotListed ?
        controller.opportunityFields[9].text : ""
    });
    final opportunityId = controller.trxOpportunity.records!
      [controller.selectedCard].id;
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/C_Opportunity/$opportunityId');
    //print(msg);
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<PortalMpOpportunityController>().getOpportunities();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
      if(controller.image64 != ""){
        sendAttachment(opportunityId!);
      }
    } else {
      Get.snackbar(
        "Error!".tr,
        "Record not updated".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  newOpportunityInput() async{
    controller.initFieldsController(0, true);
    /* if(controller.selectedCourse != 10000){
      controller.showOpportunityDetails = true;
    } else {
      Get.snackbar(
        "Select a course".tr,
        "Please select the course the student will be assigned to".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.yellow,
        ),
      );
    } */
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        drawer: /* (ResponsiveBuilder.isDesktop(context))
            ? null
            : */ Drawer(
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
                Row(
                  children: [
                    Container(
                      child: Obx(() => controller.dataAvailable
                          ? Text("OPPORTUNITY: ".tr + controller.trxOpportunity.rowcount.toString())
                          : Text("OPPORTUNITY: ".tr)),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateOpportunity());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getOpportunities();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: TextButton(
                        onPressed: () {
                          //controller.changeFilter();
                          //print("hello");
                        },
                        child: const Text('filter'),
                        //Text(controller.value.value),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(10),
                      //width: 20,
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: Obx(
                        () => DropdownButton(
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.opportunityDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.opportunityDropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.opportunityDropDownList.map((list) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                list.name.toString(),
                              ),
                              value: list.id,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.opportunitySearchFieldController,
                          onSubmitted: (String? value) {
                            controller.opportunitySearchFilterValue.value =
                                controller.opportunitySearchFieldController.text;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(() => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trxOpportunity.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          
                          return Obx( ()=> Visibility(
                            visible: controller.opportunitySearchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.opportunityDropdownValue.value == "1"
                                        ? controller.trxOpportunity.records![index].cBPartnerID!.identifier
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .opportunitySearchFilterValue.value
                                                .toLowerCase())
                                    : controller.opportunityDropdownValue.value == "2"
                                            ? (controller
                                                .trxOpportunity.records![index].mProductID?.identifier ?? "")
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .opportunitySearchFilterValue.value
                                                    .toLowerCase())
                                    : controller.opportunityDropdownValue.value == "3"
                                            ? controller
                                                .trxOpportunity.records![index].salesRepID!.identifier
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .opportunitySearchFilterValue.value
                                                    .toLowerCase())
                                    : controller.opportunityDropdownValue.value == "4"
                                            ? controller
                                                .trxOpportunity.records![index].cSalesStageID!.identifier
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .opportunitySearchFilterValue.value
                                                    .toLowerCase())
                                            : true,
                            child: Card(
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
                                        Icons.paid,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Opportunity'.tr,
                                      onPressed: () {
                                        Get.to(const EditOpportunity(),
                                            arguments: {
                                              "id": controller
                                                  .trxOpportunity.records![index].id,
                                              "SaleStageID": controller.trxOpportunity.records![index].cSalesStageID!.id,
                                              "salesRep": controller.trxOpportunity.records![index].salesRepID?.identifier ?? "",
                                              "productName": controller.trxOpportunity.records![index].mProductID?.identifier ?? "",
                                              "productId": controller.trxOpportunity.records![index].mProductID?.id ?? 0,
                                              "opportunityAmt": controller.trxOpportunity.records![index].opportunityAmt ?? 0,
                                              "cBPartnerID": controller.trxOpportunity.records![index].cBPartnerID?.id ?? 0,
                                              "cBPartnerName": controller.trxOpportunity.records![index].cBPartnerID?.identifier ?? "",
                                              "Description": controller.trxOpportunity.records![index].description ?? "",
                                            });
                                        
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trxOpportunity.records![index].cBPartnerID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                          
                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(Icons.linear_scale,
                                          color: Colors.yellowAccent),
                                      Text(
                                        controller.trxOpportunity.records![index]
                                                .cSalesStageID!.identifier ??
                                            "??",
                                        style:
                                            const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                             Text(
                                              "${'ContactBP'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxOpportunity.records![index]
                                                    .aDUserID?.identifier ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Product'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxOpportunity.records![index]
                                                    .mProductID?.identifier ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'OpportunityAmt'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("€" +
                                                controller.trxOpportunity.records![index]
                                                    .opportunityAmt
                                                    .toString()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'SalesRep'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxOpportunity.records![index]
                                                    .salesRepID!.identifier ??
                                                ""),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator())),
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
                Row(
                  children: [
                    Container(
                      child: Obx(() => controller.dataAvailable
                          ? Text("OPPORTUNITY: ".tr + controller.trxOpportunity.rowcount.toString())
                          : Text("OPPORTUNITY: ".tr)),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          Get.to(const CreateOpportunity());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getOpportunities();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: TextButton(
                        onPressed: () {
                          //controller.changeFilter();
                          //print("hello");
                        },
                        child: const Text('filter'),
                        //Text(controller.value.value),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(10),
                      //width: 20,
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: Obx(
                        () => DropdownButton(
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.opportunityDropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.opportunityDropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.opportunityDropDownList.map((list) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                list.name.toString(),
                              ),
                              value: list.id,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.opportunitySearchFieldController,
                          onSubmitted: (String? value) {
                            controller.opportunitySearchFilterValue.value =
                                controller.opportunitySearchFieldController.text;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_outlined),
                            border: OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(() => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trxOpportunity.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          
                          return Obx( ()=> Visibility(
                            visible: controller.opportunitySearchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.opportunityDropdownValue.value == "1"
                                        ? controller.trxOpportunity.records![index].cBPartnerID!.identifier
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .opportunitySearchFilterValue.value
                                                .toLowerCase())
                                    : controller.opportunityDropdownValue.value == "2"
                                            ? (controller
                                                .trxOpportunity.records![index].mProductID?.identifier ?? "")
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .opportunitySearchFilterValue.value
                                                    .toLowerCase())
                                    : controller.opportunityDropdownValue.value == "3"
                                            ? controller
                                                .trxOpportunity.records![index].salesRepID!.identifier
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .opportunitySearchFilterValue.value
                                                    .toLowerCase())
                                    : controller.opportunityDropdownValue.value == "4"
                                            ? controller
                                                .trxOpportunity.records![index].cSalesStageID!.identifier
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .opportunitySearchFilterValue.value
                                                    .toLowerCase())
                                            : true,
                            child: Card(
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
                                        Icons.paid,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit Opportunity',
                                      onPressed: () {
                                        Get.to(const EditOpportunity(),
                                            arguments: {
                                              "id": controller
                                                  .trxOpportunity.records![index].id,
                                              "SaleStageID": controller.trxOpportunity.records![index].cSalesStageID!.id,
                                              "salesRep": controller.trxOpportunity.records![index].salesRepID?.identifier ?? "",
                                              "productName": controller.trxOpportunity.records![index].mProductID?.identifier ?? "",
                                              "productId": controller.trxOpportunity.records![index].mProductID?.id ?? 0,
                                              "opportunityAmt": controller.trxOpportunity.records![index].opportunityAmt ?? 0,
                                              "cBPartnerID": controller.trxOpportunity.records![index].cBPartnerID?.id ?? 0,
                                              "cBPartnerName": controller.trxOpportunity.records![index].cBPartnerID?.identifier ?? "",
                                              "Description": controller.trxOpportunity.records![index].description ?? "",
                                            });
                                        
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trxOpportunity.records![index].cBPartnerID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                          
                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(Icons.linear_scale,
                                          color: Colors.yellowAccent),
                                      Text(
                                        controller.trxOpportunity.records![index]
                                                .cSalesStageID!.identifier ??
                                            "??",
                                        style:
                                            const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                             Text(
                                              "${'ContactBP'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxOpportunity.records![index]
                                                    .aDUserID?.identifier ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'Product'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxOpportunity.records![index]
                                                    .mProductID?.identifier ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'OpportunityAmt'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("€" +
                                                controller.trxOpportunity.records![index]
                                                    .opportunityAmt
                                                    .toString()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${'SalesRep'.tr}: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trxOpportunity.records![index]
                                                    .salesRepID!.identifier ??
                                                ""),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator())),
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
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(flex: 5, child: _buildProfile(data: controller.getProfil())),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              child: Obx(() => controller.dataAvailable
                                  ? Text("SALES ORDERS REQUESTS".tr + ': ' + controller.trxOpportunity.rowcount.toString())
                                  : Text("SALES ORDERS REQUESTS".tr + ': ')),
                              margin: const EdgeInsets.only(left: 15),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                onPressed: () {
                                  controller.getOpportunities();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildSalesOrdersFilter(),
                        const SizedBox(height: kSpacing),
                        Obx(
                          () => controller.dataAvailable
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: controller.trxOpportunity.rowcount,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Obx (() => Visibility(
                                      visible: controller.opportunitySearchFilterValue.value ==
                                                ""
                                            ? true
                                            : controller.opportunityDropdownValue.value == "1"
                                                ? controller.trxOpportunity.records![index].documentNo
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(controller
                                                        .opportunitySearchFilterValue.value
                                                        .toLowerCase())
                                            : controller.opportunityDropdownValue.value == "2"
                                                    ? (controller
                                                        .trxOpportunity.records![index].created ?? "")
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(controller
                                                            .opportunitySearchFilterValue.value
                                                            .toLowerCase())
                                            : true,
                                    
                                      child: Card(
                                        elevation: 8.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        child: Obx( () => controller.selectedCard == index ? 
                                          _buildCard(Theme.of(context).cardColor, context, index) : 
                                          _buildCard(const Color.fromRGBO(64, 75, 96, .9), context, index),
                                      ),
                                    )));
                                  },
                                )
                              : const Center(child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 7,
                        child: Column(
                          children: [
                            const SizedBox(height: kSpacing *1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: IconButton(
                                      onPressed: () {
                                        //crea una nuova opportunità quindi verrà fatta una richiesta post
                                        controller.showOpportunityDetails = true;
                                        controller.newOpportunity = true;
                                        controller.image64 = "";
                                        controller.imageName = "";
                                        controller.userNotListed = false;
                                        newOpportunityInput();
                                      },
                                      icon: const Icon(Icons.person_add),
                                      color: Colors.green,
                                      iconSize: 35
                                    ),
                                  ),
                                  SizedBox(
                                    child: IconButton(
                                      onPressed: () {
                                        controller.showOpportunityDetails ? 

                                          controller.newOpportunity ?
                                            createOpportunity() :
                                            updateOpportunity()
                                          
                                          : Get.snackbar(
                                              "Error!".tr,
                                              "Select a request or create a new one".tr,
                                              icon: const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                      },
                                      icon: const Icon(Icons.save),
                                      color: Colors.white,
                                      iconSize: 35
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: kSpacing * 2),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                  //width: 100,
                                  height: MediaQuery.of(context).size.height / 1.3,
                                  child: 
                                  Obx( () => controller.showOpportunityDetails ? 
                                    SingleChildScrollView(
                                      child: _buildOpportunityInput(context)
                                    ) 
                                      : Center(child: Text('No Request Selected'.tr)) 
                                    )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )],
          );
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

  _buildSalesOrdersFilter(){
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          //padding: const EdgeInsets.all(10),
          //width: 20,
          /* decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ), */
          child: Obx(
            () => DropdownButton(
              icon: const Icon(Icons.filter_alt_sharp),
              value: controller.opportunityDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.opportunityDropdownValue.value = newValue!;
              },
              items: controller.opportunityDropDownList.map((list) {
                return DropdownMenuItem<String>(
                  child: Text(
                    list.name.toString(),
                  ),
                  value: list.id,
                );
              }).toList(),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: controller.opportunitySearchFieldController,
              onSubmitted: (String? value) {
                controller.opportunitySearchFilterValue.value =
                    controller.opportunitySearchFieldController.text;
              },
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                border: const OutlineInputBorder(),
                hintText: 'Search'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Color selectionColor, context, index){
    return Container(
      decoration: BoxDecoration(
          color: selectionColor),
      child: ExpansionTile(
        leading: const Icon(
          Icons.handshake,
          color:
            Colors.green
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.green 
          ),
          onPressed: () {
            controller.showOpportunityDetails = false;
            controller.selectedCard = index;
            controller.newOpportunity = false;
            controller.image64 = "";
            controller.imageName = "";
            controller.userNotListed = controller.trxOpportunity.
              records![index].note != null ? true : false;
            controller.initFieldsController(index, false);
          },
        ),
        title: Text(
          'DocumentNo'.tr + ' ' + controller.trxOpportunity.records![index].documentNo!,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        controller.trxOpportunity.records![index].cBPartnerID?.identifier ??
                            "",
                        style: const TextStyle(
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children:[
                      Text('SalesStage'.tr + ': ',
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                      Text(controller.trxOpportunity.records![index].cSalesStageID?.identifier ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                  ),
                  Row(
                    children:[
                      Text('Expected Close Date'.tr + ': ',
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                      Text(controller.trxOpportunity.records![index].expectedCloseDate ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                  )
                ],
              ),
            ),
            
          ],
        ),
        childrenPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
          children: [
          Column(
            children: [
              Row(
                children: [
                  Text('Request Date'.tr + ': '),
                  Text(controller.trxOpportunity.records![index].created!.split('T')[0])
                ],
              ),
              Row(
                children: [
                  Text('Subject'.tr + ': '),
                  controller.trxOpportunity.records![index].description != null ?
                  Text(controller.trxOpportunity.records![index].description!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                    : Text('No Subject'.tr, 
                      style: const TextStyle(
                        fontWeight: FontWeight.w200
                      ),),
                ],
              ),
              Row(
                children: [
                  Text(controller.trxOpportunity.records![index].comments ?? ''),
                ],
              ),
            ],
          )]
        ),
      );
  }

  Widget _buildOpportunityInput(context) {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      margin: const EdgeInsets.only(right: 10.0, left: 10.0, /* top: kSpacing * 7.7 */ bottom: 6.0),
      color: const Color.fromRGBO(64, 75, 96, .9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx( () => controller.newOpportunity ?
              Text("New Sales Order Request".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),) 
                : Text("DocumentNo".tr + ' ' + 
                  (controller.trxOpportunity.records![controller.selectedCard].documentNo ?? '???'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx( () => controller.userNotListed ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: 300,
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                                controller: controller.opportunityFields[7],
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Name'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  enabled: true
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: 300,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.-]"))
                                ],
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                                controller: controller.opportunityFields[8],
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Phone'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  enabled: true
                                  
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: 300,
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                                controller: controller.opportunityFields[9],
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Email'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  enabled: true
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                  : Column(
                    children: [
                      Container(
                      padding: const EdgeInsets.only(left: 40),
                      child: Align(
                        child: Text(
                          "User/Contact".tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: controller.getAdUsers(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<AdRecords>> snapshot) =>
                            snapshot.hasData
                                ? DropdownButton(
                                    value: controller.userDropDownValue,
                                    elevation: 16,
                                    onChanged: (String? newValue) {
                                        controller.userDropDownValue = newValue!;
                                      //print(dropdownValue);
                                    },
                                    items: snapshot.data!.map((list) {
                                      return DropdownMenuItem<String>(
                                        child: Text(
                                          list.name.toString(),
                                        ),
                                        value: list.id.toString(),
                                      );
                                    }).toList(),
                                  )
                        : const Center(
                          child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                    ],
                  ),
                
                  /* Container(
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.grey
                        ),
                        controller: controller.opportunityFields[6],
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'User/Contact'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabled: false
                        ),
                      ),
                    ),
                  ), */
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      title: Text('Not Listed'.tr),
                      value: controller.userNotListed,
                      onChanged: (listed) {
                        controller.userNotListed = listed;
                      } ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(
                  color: Colors.grey
                ),
                controller: controller.opportunityFields[0],
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Business Partner'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabled: false
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(
                  color: Colors.grey
                ),
                controller: controller.opportunityFields[1],
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'SalesStage'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .surname ?? '', */
                  enabled: false
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.grey
                      ),
                      controller: controller.opportunityFields[4],
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'Request Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabled: false,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.grey
                      ),
                      controller: controller.opportunityFields[2],
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'Expected Close Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.opportunityFields[5],
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Subject'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabled: true,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                controller: controller.opportunityFields[3],
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Request Details'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabled: true,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                controller: controller.imageName,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Attachment'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabled: true,
                  prefixIcon:  IconButton(
                    onPressed: () {
                      controller.attachImage();
                    }, 
                    icon: Obx( () => controller.image64 != "" ?
                      const Icon(
                        Icons.attach_file,
                        color: Colors.green ,
                    ) 
                    : const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      )
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.image64 = "";
                      controller.imageName = "";
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  )
                  
                ),
              ),
            ),
          ],
        )
      )
    );
  }

}

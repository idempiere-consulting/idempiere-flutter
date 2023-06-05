// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_survey_lines_json.dart';
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
import 'package:idempiere_app/constants.dart';

// binding
part '../../bindings/course_quiz_binding.dart';

// controller
part '../../controllers/course_quiz_controller.dart';

// models
part '../../models/profile.dart';

// component
////part '../components/active_project_card.dart';
part '../components/header.dart';
//part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class CourseQuizScreen extends GetView<CourseQuizController> {
  const CourseQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: controller.scaffoldKey,
      appBar: AppBar(
        title: Text("Survey".tr),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: "Send Survey".tr,
                    content:
                        Text("Are you sure you want to finish the Survey?".tr),
                    buttonColor: kNotifColor,
                    textConfirm: "Send".tr,
                    textCancel: "Cancel".tr,
                    onConfirm: () {
                      controller.sendQuizLines();
                    });

                //controller.sendQuizLines();
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
                                /* trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.view_list,
                                    color: Colors.green,
                                  ),
                                ), */
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                /* leading: Container(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.work,
                                    ),
                                    onPressed: () {},
                                  ),
                                ), */
                                title: Text(
                                  controller.trx.records![index].name ?? "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                /* subtitle: Row(
                                  children: <Widget>[
                                    const Icon(Icons.event),
                                    Text(
                                      controller.trx.records![index]
                                              .dateWorkStart ??
                                          "??",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ), */
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: controller
                                                .trx.records![index].url !=
                                            null,
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Image.network(
                                            controller
                                                    .trx.records![index].url ??
                                                "",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'Y',
                                          child: RadioListTile<int>(
                                              title: Text("True".tr),
                                              value: 1,
                                              groupValue:
                                                  controller.checkValue[index],
                                              onChanged: (value) {
                                                controller.checkValue[index] =
                                                    1;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'Y',
                                          child: RadioListTile<int>(
                                              title: Text("False".tr),
                                              value: 0,
                                              groupValue:
                                                  controller.checkValue[index],
                                              onChanged: (value) {
                                                controller.checkValue[index] =
                                                    0;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText1 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText1}"),
                                              value: 1,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 1;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText2 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText2}"),
                                              value: 2,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 2;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText3 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText3}"),
                                              value: 3,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 3;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText4 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText4}"),
                                              value: 4,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 4;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText5 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText5}"),
                                              value: 5,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 5;
                                              }),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.trx.records![index]
                                                .lITSurveyType?.id ==
                                            'N',
                                        child: TextField(
                                          controller: controller
                                              .numberfieldController[index],
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9.-]"))
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Answer',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.trx.records![index]
                                                .lITSurveyType?.id ==
                                            'T',
                                        child: TextField(
                                          maxLines: 7,
                                          controller: controller
                                              .textfieldController[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Answer',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'D',
                                          child: DateTimePicker(
                                            type: DateTimePickerType.date,
                                            initialValue:
                                                controller.dateValue[index],
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                            dateLabelText: 'Date',
                                            icon: const Icon(Icons.event),
                                            onChanged: (val) {
                                              //print(DateTime.parse(val));
                                              //print(val);

                                              controller.dateValue[index] =
                                                  val.substring(0, 10);

                                              //print(controller.dateValue[index]);
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]);
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
                                /* trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.view_list,
                                    color: Colors.green,
                                  ),
                                ), */
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                /* leading: Container(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.work,
                                    ),
                                    onPressed: () {},
                                  ),
                                ), */
                                title: Text(
                                  controller.trx.records![index].name ?? "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                /* subtitle: Row(
                                  children: <Widget>[
                                    const Icon(Icons.event),
                                    Text(
                                      controller.trx.records![index]
                                              .dateWorkStart ??
                                          "??",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ), */
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: controller
                                                .trx.records![index].url !=
                                            null,
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Image.network(
                                            controller
                                                    .trx.records![index].url ??
                                                "",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'Y',
                                          child: RadioListTile<int>(
                                              title: Text("True".tr),
                                              value: 1,
                                              groupValue:
                                                  controller.checkValue[index],
                                              onChanged: (value) {
                                                controller.checkValue[index] =
                                                    1;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'Y',
                                          child: RadioListTile<int>(
                                              title: Text("False".tr),
                                              value: 0,
                                              groupValue:
                                                  controller.checkValue[index],
                                              onChanged: (value) {
                                                controller.checkValue[index] =
                                                    0;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText1 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText1}"),
                                              value: 1,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 1;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText2 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText2}"),
                                              value: 2,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 2;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText3 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText3}"),
                                              value: 3,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 3;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText4 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText4}"),
                                              value: 4,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 4;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText5 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText5}"),
                                              value: 5,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 5;
                                              }),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.trx.records![index]
                                                .lITSurveyType?.id ==
                                            'N',
                                        child: TextField(
                                          controller: controller
                                              .numberfieldController[index],
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9.-]"))
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Answer',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.trx.records![index]
                                                .lITSurveyType?.id ==
                                            'T',
                                        child: TextField(
                                          maxLines: 7,
                                          controller: controller
                                              .textfieldController[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Answer',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'D',
                                          child: DateTimePicker(
                                            type: DateTimePickerType.date,
                                            initialValue:
                                                controller.dateValue[index],
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                            dateLabelText: 'Date',
                                            icon: const Icon(Icons.event),
                                            onChanged: (val) {
                                              //print(DateTime.parse(val));
                                              //print(val);

                                              controller.dateValue[index] =
                                                  val.substring(0, 10);

                                              //print(controller.dateValue[index]);
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]);
          },
          desktopBuilder: (context, constraints) {
            return Column(children: [
              Obx(
                () => controller.dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: controller.trx.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
                                /* trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.view_list,
                                    color: Colors.green,
                                  ),
                                ), */
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                /* leading: Container(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.work,
                                    ),
                                    onPressed: () {},
                                  ),
                                ), */
                                title: Text(
                                  controller.trx.records![index].name ?? "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                /* subtitle: Row(
                                  children: <Widget>[
                                    const Icon(Icons.event),
                                    Text(
                                      controller.trx.records![index]
                                              .dateWorkStart ??
                                          "??",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ), */
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: controller
                                                .trx.records![index].url !=
                                            null,
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Image.network(
                                            controller
                                                    .trx.records![index].url ??
                                                "",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'Y',
                                          child: RadioListTile<int>(
                                              title: Text("True".tr),
                                              value: 1,
                                              groupValue:
                                                  controller.checkValue[index],
                                              onChanged: (value) {
                                                controller.checkValue[index] =
                                                    1;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'Y',
                                          child: RadioListTile<int>(
                                              title: Text("False".tr),
                                              value: 0,
                                              groupValue:
                                                  controller.checkValue[index],
                                              onChanged: (value) {
                                                controller.checkValue[index] =
                                                    0;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText1 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText1}"),
                                              value: 1,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 1;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText2 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText2}"),
                                              value: 2,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 2;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText3 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText3}"),
                                              value: 3,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 3;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText4 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText4}"),
                                              value: 4,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 4;
                                              }),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                      .trx
                                                      .records![index]
                                                      .lITText5 !=
                                                  null &&
                                              controller.trx.records![index]
                                                      .lITSurveyType?.id ==
                                                  'M',
                                          child: RadioListTile<int>(
                                              title: Text(
                                                  "${controller.trx.records![index].lITText5}"),
                                              value: 5,
                                              groupValue: controller
                                                  .selectedValue[index],
                                              onChanged: (value) {
                                                controller
                                                    .selectedValue[index] = 5;
                                              }),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.trx.records![index]
                                                .lITSurveyType?.id ==
                                            'N',
                                        child: TextField(
                                          controller: controller
                                              .numberfieldController[index],
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9.-]"))
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Answer',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.trx.records![index]
                                                .lITSurveyType?.id ==
                                            'T',
                                        child: TextField(
                                          maxLines: 7,
                                          controller: controller
                                              .textfieldController[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Answer',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: controller
                                                  .trx
                                                  .records![index]
                                                  .lITSurveyType
                                                  ?.id ==
                                              'D',
                                          child: DateTimePicker(
                                            type: DateTimePickerType.date,
                                            initialValue:
                                                controller.dateValue[index],
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                            dateLabelText: 'Date',
                                            icon: const Icon(Icons.event),
                                            onChanged: (val) {
                                              //print(DateTime.parse(val));
                                              //print(val);

                                              controller.dateValue[index] =
                                                  val.substring(0, 10);

                                              //print(controller.dateValue[index]);
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ]);
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

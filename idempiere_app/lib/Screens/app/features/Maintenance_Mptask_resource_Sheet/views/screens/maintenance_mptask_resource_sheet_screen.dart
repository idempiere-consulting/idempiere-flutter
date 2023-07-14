library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/reflist_resource_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_survey_lines_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Signature_WorkOrderResource/signature_page.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/project_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/shared_components/search_field.dart';
import 'package:idempiere_app/Screens/app/shared_components/selection_button.dart';
import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/today_text.dart';
import 'package:idempiere_app/Screens/app/utils/helpers/app_helpers.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idempiere_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;

// binding
part '../../bindings/maintenance_mptask_resource_sheet_binding.dart';

// controller
part '../../controllers/maintenance_mptask_resource_sheet_controller.dart';

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

class MaintenanceMpResourceSheetScreen
    extends GetView<MaintenanceMpResourceSheetController> {
  const MaintenanceMpResourceSheetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: IconButton(
              onPressed: () {
                controller.changeFilterMinus();
              },
              icon: const Icon(Icons.skip_previous),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: IconButton(
              onPressed: () {
                controller.changeFilterPlus();
              },
              icon: const Icon(Icons.skip_next),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () async {
                //print(controller.nameFieldController.text);
                var isConnected = await checkConnection();

                if (isConnected) {
                  controller.sendAttachedImage(Get.arguments["id"]);
                } else {
                  controller.sendAttachedImageOffline(Get.arguments["id"]);
                }
                //controller.editWorkOrderResource(isConnected);
                controller.sendQuizLines();
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
        //centerTitle: true,
        title: Obx(() => Text(controller.value.value)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => controller.surveyAvailable.value &&
                          controller.filterCount.value == 0
                      ? Obx(
                          () => controller.surveyAvailable.value
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: controller._trx.records!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      elevation: 8.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromRGBO(64, 75, 96, .9)),
                                        child: ExpansionTile(
                                          /* trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.view_list,
                                    color: Colors.green,
                                  ),
                                ), */
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0),
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
                                            controller._trx.records![index]
                                                    .name ??
                                                "???",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                          /* subtitle: Row(
                                  children: <Widget>[
                                    const Icon(Icons.event),
                                    Text(
                                      controller._trx.records![index]
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
                                          childrenPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0),
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: controller
                                                          ._trx
                                                          .records![index]
                                                          .url !=
                                                      null,
                                                  child: Container(
                                                    width: 300,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Image.network(
                                                      controller
                                                              ._trx
                                                              .records![index]
                                                              .url ??
                                                          "",
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                            ._trx
                                                            .records![index]
                                                            .lITSurveyType
                                                            ?.id ==
                                                        'Y',
                                                    child: RadioListTile<int>(
                                                        title: Text("True".tr),
                                                        value: 1,
                                                        groupValue: controller
                                                            .checkValue[index],
                                                        onChanged: (value) {
                                                          controller.checkValue[
                                                              index] = 1;
                                                        }),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                            ._trx
                                                            .records![index]
                                                            .lITSurveyType
                                                            ?.id ==
                                                        'Y',
                                                    child: RadioListTile<int>(
                                                        title: Text("False".tr),
                                                        value: 0,
                                                        groupValue: controller
                                                            .checkValue[index],
                                                        onChanged: (value) {
                                                          controller.checkValue[
                                                              index] = 0;
                                                        }),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                                ._trx
                                                                .records![index]
                                                                .lITText1 !=
                                                            null &&
                                                        controller
                                                                ._trx
                                                                .records![index]
                                                                .lITSurveyType
                                                                ?.id ==
                                                            'M',
                                                    child: RadioListTile<int>(
                                                        title: Text(
                                                            "${controller._trx.records![index].lITText1}"),
                                                        value: 1,
                                                        groupValue: controller
                                                                .selectedValue[
                                                            index],
                                                        onChanged: (value) {
                                                          controller
                                                                  .selectedValue[
                                                              index] = 1;
                                                        }),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                                ._trx
                                                                .records![index]
                                                                .lITText2 !=
                                                            null &&
                                                        controller
                                                                ._trx
                                                                .records![index]
                                                                .lITSurveyType
                                                                ?.id ==
                                                            'M',
                                                    child: RadioListTile<int>(
                                                        title: Text(
                                                            "${controller._trx.records![index].lITText2}"),
                                                        value: 2,
                                                        groupValue: controller
                                                                .selectedValue[
                                                            index],
                                                        onChanged: (value) {
                                                          controller
                                                                  .selectedValue[
                                                              index] = 2;
                                                        }),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                                ._trx
                                                                .records![index]
                                                                .lITText3 !=
                                                            null &&
                                                        controller
                                                                ._trx
                                                                .records![index]
                                                                .lITSurveyType
                                                                ?.id ==
                                                            'M',
                                                    child: RadioListTile<int>(
                                                        title: Text(
                                                            "${controller._trx.records![index].lITText3}"),
                                                        value: 3,
                                                        groupValue: controller
                                                                .selectedValue[
                                                            index],
                                                        onChanged: (value) {
                                                          controller
                                                                  .selectedValue[
                                                              index] = 3;
                                                        }),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                                ._trx
                                                                .records![index]
                                                                .lITText4 !=
                                                            null &&
                                                        controller
                                                                ._trx
                                                                .records![index]
                                                                .lITSurveyType
                                                                ?.id ==
                                                            'M',
                                                    child: RadioListTile<int>(
                                                        title: Text(
                                                            "${controller._trx.records![index].lITText4}"),
                                                        value: 4,
                                                        groupValue: controller
                                                                .selectedValue[
                                                            index],
                                                        onChanged: (value) {
                                                          controller
                                                                  .selectedValue[
                                                              index] = 4;
                                                        }),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                                ._trx
                                                                .records![index]
                                                                .lITText5 !=
                                                            null &&
                                                        controller
                                                                ._trx
                                                                .records![index]
                                                                .lITSurveyType
                                                                ?.id ==
                                                            'M',
                                                    child: RadioListTile<int>(
                                                        title: Text(
                                                            "${controller._trx.records![index].lITText5}"),
                                                        value: 5,
                                                        groupValue: controller
                                                                .selectedValue[
                                                            index],
                                                        onChanged: (value) {
                                                          controller
                                                                  .selectedValue[
                                                              index] = 5;
                                                        }),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: controller
                                                          ._trx
                                                          .records![index]
                                                          .lITSurveyType
                                                          ?.id ==
                                                      'N',
                                                  child: TextField(
                                                    controller: controller
                                                            .numberfieldController[
                                                        index],
                                                    keyboardType:
                                                        const TextInputType
                                                                .numberWithOptions(
                                                            signed: true,
                                                            decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp("[0-9.-]"))
                                                    ],
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Answer',
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: controller
                                                          ._trx
                                                          .records![index]
                                                          .lITSurveyType
                                                          ?.id ==
                                                      'T',
                                                  child: TextField(
                                                    maxLines: 7,
                                                    controller: controller
                                                            .textfieldController[
                                                        index],
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Answer',
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: controller
                                                            ._trx
                                                            .records![index]
                                                            .lITSurveyType
                                                            ?.id ==
                                                        'D',
                                                    child: DateTimePicker(
                                                      type: DateTimePickerType
                                                          .date,
                                                      initialValue: controller
                                                          .dateValue[index],
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                      dateLabelText: 'Date',
                                                      icon: const Icon(
                                                          Icons.event),
                                                      onChanged: (val) {
                                                        //print(DateTime.parse(val));
                                                        //print(val);

                                                        controller.dateValue[
                                                                index] =
                                                            val.substring(
                                                                0, 10);

                                                        //print(controller.dateValue[index]);
                                                      },
                                                      validator: (val) {
                                                        //print(val);
                                                        return null;
                                                      },
                                                      // ignore: avoid_print
                                                      onSaved: (val) =>
                                                          print(val),
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
                              : const Center(
                                  child: CircularProgressIndicator()),
                        )
                      : const SizedBox(),
                  /* ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.surveyLines.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => controller
                                        .surveyLines.records![index].group1 !=
                                    null
                                ? Visibility(
                                    visible: controller.filterCount.value == 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: CheckboxListTile(
                                        title: Text(
                                            '${controller.surveyLines.records![index].name}'),
                                        value: controller.isChecked[index],
                                        activeColor: kPrimaryColor,
                                        onChanged: (bool? value) {
                                          controller.isChecked[index] = value!;
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.filterCount.value == 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                          '${controller.surveyLines.records![index].name}'),
                                    ),
                                  ));
                          },
                        )
                      : const Center(child: CircularProgressIndicator()), */
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        maxLines: 5,
                        controller: controller.noteFieldController,
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'Note'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: CheckboxListTile(
                        title:
                            Text('The product can keep on being in service'.tr),
                        value: controller.checkboxState.value,
                        activeColor: kPrimaryColor,
                        onChanged: (bool? value) {
                          controller.checkboxState.value = value!;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: "Sign".tr,
                              onPressed: () {
                                Get.to(
                                    const SignatureWorkOrderResourceScreen());
                              },
                              icon: controller.flagSign.value
                                  ? const Icon(
                                      EvaIcons.doneAll,
                                      color: Colors.green,
                                    )
                                  : const Icon(EvaIcons.edit2Outline),
                            ),
                            Text("Sign".tr),
                          ]),
                    ),
                  ),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.numberFieldController,
                        onChanged: (value) {
                          controller.lineFieldController.text = (int.parse(
                                      controller.numberFieldController.text) *
                                  10)
                              .toString();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'N°'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
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
                        controller: controller.lineFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'Line N°'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
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
                        controller: controller.locationFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.source),
                          border: const OutlineInputBorder(),
                          labelText: 'Location'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                /* Obx(
                  () => controller.flagRefList.value == true
                      ? Visibility(
                          visible: controller.filterCount.value == 0,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            width: size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              value: controller.dropDownValue.value,
                              style: const TextStyle(fontSize: 12.0),
                              elevation: 16,
                              onChanged: (String? newValue) {
                                //print(newValue);
                                controller.dropDownValue.value = newValue!;
                              },
                              items: controller.refList.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                  value: list.value.toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ), */
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.manufacturerFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.source),
                          border: const OutlineInputBorder(),
                          labelText: 'Manufacturer'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.modelFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Model',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.serialNoFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Serial No',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.manufacturedYearFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.timelapse_sharp),
                          border: const OutlineInputBorder(),
                          labelText: 'Manufactured Year'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.expectedDurationFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.timelapse_sharp),
                          border: OutlineInputBorder(),
                          labelText: 'Expected Duration (months)',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: controller.date2,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Purchase Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date2 = val.substring(0, 10);

                          //print(date);
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: controller.date3,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'First Use Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date3 = val.substring(0, 10);

                          //print(date);
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.userFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'User Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.flagSurveyLines.value
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.surveyLines.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => controller
                                        .surveyLines.records![index].group1 !=
                                    null
                                ? Visibility(
                                    visible: controller.filterCount.value == 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: CheckboxListTile(
                                        title: Text(
                                            '${controller.surveyLines.records![index].name}'),
                                        value: controller.isChecked[index],
                                        activeColor: kPrimaryColor,
                                        onChanged: (bool? value) {
                                          controller.isChecked[index] = value!;
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.filterCount.value == 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                          '${controller.surveyLines.records![index].name}'),
                                    ),
                                  ));
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        maxLines: 5,
                        controller: controller.noteFieldController,
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'Note'.tr,
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
                      margin: const EdgeInsets.all(10),
                      child: CheckboxListTile(
                        title: const Text(
                            'The product can keep on being in service'),
                        value: controller.checkboxState.value,
                        activeColor: kPrimaryColor,
                        onChanged: (bool? value) {
                          controller.checkboxState.value = value!;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: "Sign".tr,
                              onPressed: () {
                                Get.to(
                                    const SignatureWorkOrderResourceScreen());
                              },
                              icon: controller.flagSign.value
                                  ? const Icon(
                                      EvaIcons.doneAll,
                                      color: Colors.green,
                                    )
                                  : const Icon(EvaIcons.edit2Outline),
                            ),
                            Text("Sign".tr),
                          ]),
                    ),
                  ),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.numberFieldController,
                        onChanged: (value) {
                          controller.lineFieldController.text = (int.parse(
                                      controller.numberFieldController.text) *
                                  10)
                              .toString();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'N°'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
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
                        controller: controller.lineFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'Line N°'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
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
                        controller: controller.locationFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.source),
                          border: const OutlineInputBorder(),
                          labelText: 'Location'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                /* Obx(
                  () => controller.flagRefList.value == true
                      ? Visibility(
                          visible: controller.filterCount.value == 0,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            width: size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              value: controller.dropDownValue.value,
                              style: const TextStyle(fontSize: 12.0),
                              elevation: 16,
                              onChanged: (String? newValue) {
                                //print(newValue);
                                controller.dropDownValue.value = newValue!;
                              },
                              items: controller.refList.records!.map((list) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    list.name.toString(),
                                  ),
                                  value: list.value.toString(),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ), */
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.manufacturerFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.source),
                          border: const OutlineInputBorder(),
                          labelText: 'Manufacturer'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.modelFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Model',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.serialNoFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.source),
                          border: OutlineInputBorder(),
                          labelText: 'Serial No',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.manufacturedYearFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.timelapse_sharp),
                          border: const OutlineInputBorder(),
                          labelText: 'Manufactured Year'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: controller.expectedDurationFieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.timelapse_sharp),
                          border: OutlineInputBorder(),
                          labelText: 'Expected Duration (months)',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: controller.date2,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Purchase Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date2 = val.substring(0, 10);

                          //print(date);
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        initialValue: controller.date3,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'First Use Date',
                        icon: const Icon(Icons.event),
                        onChanged: (val) {
                          //print(DateTime.parse(val));
                          //print(val);

                          controller.date3 = val.substring(0, 10);

                          //print(date);
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
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.userFieldController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'User Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.flagSurveyLines.value
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.surveyLines.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() => controller
                                        .surveyLines.records![index].group1 !=
                                    null
                                ? Visibility(
                                    visible: controller.filterCount.value == 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: CheckboxListTile(
                                        title: Text(
                                            '${controller.surveyLines.records![index].name}'),
                                        value: controller.isChecked[index],
                                        activeColor: kPrimaryColor,
                                        onChanged: (bool? value) {
                                          controller.isChecked[index] = value!;
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.filterCount.value == 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                          '${controller.surveyLines.records![index].name}'),
                                    ),
                                  ));
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 1,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        maxLines: 5,
                        controller: controller.noteFieldController,
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.person_pin_outlined),
                          border: const OutlineInputBorder(),
                          labelText: 'Note'.tr,
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
                      margin: const EdgeInsets.all(10),
                      child: CheckboxListTile(
                        title: const Text(
                            'The product can keep on being in service'),
                        value: controller.checkboxState.value,
                        activeColor: kPrimaryColor,
                        onChanged: (bool? value) {
                          controller.checkboxState.value = value!;
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.filterCount.value == 2,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: "Sign".tr,
                              onPressed: () {
                                Get.to(
                                    const SignatureWorkOrderResourceScreen());
                              },
                              icon: controller.flagSign.value
                                  ? const Icon(
                                      EvaIcons.doneAll,
                                      color: Colors.green,
                                    )
                                  : const Icon(EvaIcons.edit2Outline),
                            ),
                            Text("Sign".tr),
                          ]),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

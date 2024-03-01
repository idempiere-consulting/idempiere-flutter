import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_survey_lines_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp/views/screens/portal_mp_screen.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/participant_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/survey_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_Survey/models/trainingcoursejson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TrainingCourseCourseListCorrection extends StatefulWidget {
  const TrainingCourseCourseListCorrection({Key? key}) : super(key: key);

  @override
  State<TrainingCourseCourseListCorrection> createState() =>
      _TrainingCourseCourseListCorrectionState();
}

class _TrainingCourseCourseListCorrectionState
    extends State<TrainingCourseCourseListCorrection> {
  Future<void> sendQuizLines() async {
    var isConnected = await checkConnection();

    if (isConnected) {
      String ip = GetStorage().read('ip');
      String authorization = 'Bearer ${GetStorage().read('token')}';
      final protocol = GetStorage().read('protocol');

      for (var i = 0; i < quizLines.records!.length; i++) {
        switch (quizLines.records![i].lITSurveyType?.id) {
          case 'T':
            var url = Uri.parse(
                '$protocol://$ip/api/v1/models/mp_resource_survey_line/${quizLines.records![i].id}');

            var msg = jsonEncode({
              "LIT_Text1": textfieldController[i].text,
              "LIT_CorrectAnswerValue": numberfieldController[i].text,
            });

            // ignore: unused_local_variable
            var response = await http.put(
              url,
              body: msg,
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': authorization,
              },
            );
            break;
          default:
        }
      }
      Get.snackbar(
        "Done!".tr,
        "The Record has been modified".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.done_all,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Error!".tr,
        "Internet connection unavailable".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.wifi_off_outlined,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> getParticipantQuizReview() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey?\$filter= LIT_SurveyCategory eq \'SU\' and MP_Maintain_Resource_ID eq ${Get.arguments["participantId"]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json =
          SurveyJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        getQuizLines(json.records![0].id!);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getQuizLines(int id) async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey_line?\$filter= mp_resource_survey_ID eq $id and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      quizLines = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      numberfieldController = List.generate(
          quizLines.records!.length,
          (i) => TextEditingController(
              text: quizLines.records![i].lITCorrectAnswerValue));
      textfieldController = List.generate(quizLines.records!.length,
          (i) => TextEditingController(text: quizLines.records![i].lITText1));

      setState(() {
        dataAvailable = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getParticipantQuizReview();
  }

  List<DataRow> headerRows = [];

  bool dataAvailable = false;

  WorkOrderResourceSurveyLinesJson quizLines =
      WorkOrderResourceSurveyLinesJson(records: []);

  List<TextEditingController> numberfieldController = [];
  List<TextEditingController> textfieldController = [];

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Correction'.tr),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                sendQuizLines();
              },
              icon: const Icon(Symbols.save))
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                Visibility(
                  visible: dataAvailable,
                  child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: quizLines.records!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        quizLines.records![index].name ?? 'N/A',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: quizLines
                                          .records![index].lITSurveyType?.id ==
                                      'N',
                                  child: Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(20),
                                    child: TextField(
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: quizLines.records![index]
                                                      .valueNumber !=
                                                  quizLines.records![index]
                                                      .lITCorrectAnswerValue
                                              ? Colors.red
                                              : quizLines.records![index]
                                                          .valueNumber ==
                                                      quizLines.records![index]
                                                          .lITCorrectAnswerValue
                                                  ? kNotifColor
                                                  : Colors.white),
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: quizLines
                                              .records![index].valueNumber),
                                      minLines: 1,
                                      maxLines: 7,
                                      //onTap: () {},
                                      //onSubmitted: (String? value) {},
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Answer'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: quizLines
                                          .records![index].lITSurveyType?.id ==
                                      'T',
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: quizLines
                                              .records![index].valueNumber),
                                      minLines: 1,
                                      maxLines: 7,
                                      //onTap: () {},
                                      //onSubmitted: (String? value) {},
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Answer'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: quizLines
                                          .records![index].lITSurveyType?.id ==
                                      'T',
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: TextField(
                                            controller:
                                                textfieldController[index],
                                            minLines: 1,
                                            maxLines: 7,
                                            //onTap: () {},
                                            //onSubmitted: (String? value) {},
                                            decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              labelText: 'Teacher'.tr,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        padding: const EdgeInsets.only(
                                            right: 20, left: 5),
                                        child: TextField(
                                          textDirection: TextDirection.rtl,
                                          controller:
                                              numberfieldController[index],
                                          minLines: 1,
                                          maxLines: 1,
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9.-]"))
                                          ],
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'Points'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: quizLines.records![index].lITText1 !=
                                          null &&
                                      quizLines.records![index].lITSurveyType
                                              ?.id ==
                                          'M',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "${quizLines.records![index].lITText1}",
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "1" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "1" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "1"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "1"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines.records![index].lITText2 !=
                                          null &&
                                      quizLines.records![index].lITSurveyType
                                              ?.id ==
                                          'M',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "${quizLines.records![index].lITText2}",
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "2" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "2" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "2"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "2"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines.records![index].lITText3 !=
                                          null &&
                                      quizLines.records![index].lITSurveyType
                                              ?.id ==
                                          'M',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "${quizLines.records![index].lITText3}",
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "3" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "3" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "3"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "3"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines.records![index].lITText4 !=
                                          null &&
                                      quizLines.records![index].lITSurveyType
                                              ?.id ==
                                          'M',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "${quizLines.records![index].lITText4}",
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "4" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "4" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "4"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "4"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines.records![index].lITText5 !=
                                          null &&
                                      quizLines.records![index].lITSurveyType
                                              ?.id ==
                                          'M',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "${quizLines.records![index].lITText5}",
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "5" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "5" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "5"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "5"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines
                                          .records![index].lITSurveyType?.id ==
                                      'Y',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "True".tr,
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "Y" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "Y" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "Y"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "Y"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines
                                          .records![index].lITSurveyType?.id ==
                                      'Y',
                                  child: RadioListTile<int>(
                                      title: Text(
                                        "False".tr,
                                        style: TextStyle(
                                            color: quizLines.records![index]
                                                            .valueNumber ==
                                                        "N" &&
                                                    quizLines.records![index]
                                                            .valueNumber !=
                                                        quizLines
                                                            .records![index]
                                                            .lITCorrectAnswerValue
                                                ? Colors.red
                                                : quizLines.records![index]
                                                                .valueNumber ==
                                                            "N" &&
                                                        quizLines
                                                                .records![index]
                                                                .valueNumber ==
                                                            quizLines
                                                                .records![index]
                                                                .lITCorrectAnswerValue
                                                    ? kNotifColor
                                                    : quizLines.records![index]
                                                                .lITCorrectAnswerValue ==
                                                            "N"
                                                        ? kNotifColor
                                                        : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .valueNumber ==
                                              "N"
                                          ? 1
                                          : 0,
                                      groupValue: 1,
                                      onChanged: (value) {}),
                                ),
                                Visibility(
                                  visible: quizLines
                                          .records![index].lITSurveyType?.id ==
                                      'D',
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: DateTimePicker(
                                      style: TextStyle(
                                          color: quizLines.records![index]
                                                      .valueNumber !=
                                                  quizLines.records![index]
                                                      .lITCorrectAnswerValue
                                              ? Colors.red
                                              : quizLines.records![index]
                                                          .valueNumber ==
                                                      quizLines.records![index]
                                                          .lITCorrectAnswerValue
                                                  ? kNotifColor
                                                  : Colors.white),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Date'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      type: DateTimePickerType.date,
                                      initialValue:
                                          quizLines.records![index].dateValue,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),

                                      //icon: const Icon(Icons.event),
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
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
        ),
      ),
    );
  }
}

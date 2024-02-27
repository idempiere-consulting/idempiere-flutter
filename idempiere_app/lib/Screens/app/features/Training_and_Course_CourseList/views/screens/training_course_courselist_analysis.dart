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
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/course_analysis_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/participant_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/survey_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_Survey/models/trainingcoursejson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TrainingCourseCourseListAnalysis extends StatefulWidget {
  const TrainingCourseCourseListAnalysis({Key? key}) : super(key: key);

  @override
  State<TrainingCourseCourseListAnalysis> createState() =>
      _TrainingCourseCourseListAnalysisState();
}

class _TrainingCourseCourseListAnalysisState
    extends State<TrainingCourseCourseListAnalysis> {
  Future<void> getFirstParticipant() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_maintain_resource?\$filter= MP_Maintain_ID eq ${Get.arguments["maintainId"]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          ParticipantJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        getParticipantQuizReview(json.records![0].id!);
      }
    }
  }

  Future<void> getParticipantQuizReview(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey?\$filter= LIT_SurveyCategory eq \'SU\' and MP_Maintain_Resource_ID eq $id');
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
      //print(response.body);
      quizLines = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      numberfieldController = List.generate(
          quizLines.records!.length,
          (i) => TextEditingController(
              text: quizLines.records![i].lITCorrectAnswerValue));
      textfieldController = List.generate(quizLines.records!.length,
          (i) => TextEditingController(text: quizLines.records![i].lITText1));
      getQuizLineStatistic();
    }
  }

  Future<void> getQuizLineStatistic() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_course_analysis_v?\$filter= MP_Maintain_ID eq ${Get.arguments["maintainId"]} and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json = CourseAnalysisJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      wrongAnswerList = List.generate(quizLines.records!.length, (i) => 0);
      correctAnswerList = List.generate(quizLines.records!.length, (i) => 0);

      for (var i = 0; i < quizLines.records!.length; i++) {
        for (var element in json.records!) {
          if (quizLines.records![i].lineNo == element.lineNo) {
            if (element.lITSurveyType?.id != 'T' &&
                element.lITCorrectAnswerValue == element.valueNumber) {
              correctAnswerList[i] = correctAnswerList[i] + 1;
            }
            if (element.lITSurveyType?.id != 'T' &&
                element.lITCorrectAnswerValue != element.valueNumber) {
              wrongAnswerList[i] = wrongAnswerList[i] + 1;
            }
          }
        }
      }

      for (var element in wrongAnswerList) {
        print(element);
      }
      setState(() {
        dataAvailable = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getFirstParticipant();
  }

  List<DataRow> headerRows = [];

  bool dataAvailable = false;

  WorkOrderResourceSurveyLinesJson quizLines =
      WorkOrderResourceSurveyLinesJson(records: []);

  List<TextEditingController> numberfieldController = [];
  List<TextEditingController> textfieldController = [];
  List<int> wrongAnswerList = [];
  List<int> correctAnswerList = [];

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Analysis'.tr),
        centerTitle: true,
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
                            trailing: Visibility(
                              visible: !(correctAnswerList[index] == 0 &&
                                  wrongAnswerList[index] == 0),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                      '${correctAnswerList[index]}/${wrongAnswerList[index] + correctAnswerList[index]}')),
                            ),
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        quizLines.records![index].name ?? 'N/A',
                                        style: TextStyle(
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
                                      style: TextStyle(color: kNotifColor),
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: quizLines.records![index]
                                              .lITCorrectAnswerValue),
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
                                      controller:
                                          TextEditingController(text: ''),
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
                                                        .lITCorrectAnswerValue ==
                                                    "1"
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                                        .lITCorrectAnswerValue ==
                                                    "2"
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                                        .lITCorrectAnswerValue ==
                                                    "3"
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                                        .lITCorrectAnswerValue ==
                                                    "4"
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                                        .lITCorrectAnswerValue ==
                                                    "2"
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                                        .lITCorrectAnswerValue ==
                                                    'Y'
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                                        .lITCorrectAnswerValue ==
                                                    'N'
                                                ? kNotifColor
                                                : Colors.white),
                                      ),
                                      value: quizLines.records![index]
                                                  .lITCorrectAnswerValue ==
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
                                      style: TextStyle(color: kNotifColor),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Date'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      type: DateTimePickerType.date,
                                      initialValue: quizLines.records![index]
                                          .lITCorrectAnswerValue,
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

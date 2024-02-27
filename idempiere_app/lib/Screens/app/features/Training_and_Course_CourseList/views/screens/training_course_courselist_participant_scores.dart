import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp/views/screens/portal_mp_screen.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/participant_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/views/screens/training_course_courselist_correction.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

class TrainingCourseCourseListParticipantScores extends StatefulWidget {
  const TrainingCourseCourseListParticipantScores({Key? key}) : super(key: key);

  @override
  State<TrainingCourseCourseListParticipantScores> createState() =>
      _TrainingCourseCourseListParticipantScoresState();
}

class _TrainingCourseCourseListParticipantScoresState
    extends State<TrainingCourseCourseListParticipantScores> {
  Future<void> getParticipantsScore() async {
    setState(() {
      dataAvailable = false;
    });

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_course_participant_v?\$filter= MP_Maintain_ID eq ${Get.arguments["maintainId"]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);

      var json =
          ParticipantJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < json.records!.length; i++) {
        headerRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Row(
              children: [
                Text(
                    '${json.records![i].name ?? ''} ${json.records![i].surName ?? ''}'),
                Visibility(
                  visible: json.records![i].openAnswersLeft != "0",
                  child: Tooltip(
                    message: 'Open Answers left to correct'.tr,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '${json.records![i].openAnswersLeft}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const TrainingCourseCourseListCorrection(),
                        arguments: {
                          "participantId": json.records![i].id,
                        });
                  },
                  child: Text(json.records![i].decimalPoint.toString())),
            ],
          )),
        ]));
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
    getParticipantsScore();
  }

  List<DataRow> headerRows = [];

  bool dataAvailable = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants Score'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  width: size.width,
                  child: Visibility(
                    visible: dataAvailable,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Name'.tr,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Score'.tr,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ],
                      rows: headerRows,
                    ),
                  ),
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

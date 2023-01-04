// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/models/trainingcourse_student_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/models/courselist_json.dart';
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

// binding
part '../../bindings/portal_mp_training_course_courselist_binding.dart';

// controller
part '../../controllers/portal_mp_training_course_courselist_controller.dart';

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

class PortalMpTrainingCourseCourseListScreen
    extends GetView<PortalMpTrainingCourseCourseListController> {
  const PortalMpTrainingCourseCourseListScreen({Key? key}) : super(key: key);

  Future<Null> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            DateTime.tryParse(controller._studentFields[index].text) != null
                ? DateTime.parse(controller._studentFields[index].text)
                : DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null) {
      controller.date = picked.toString().substring(0, 10);
    }
    controller.initFieldsController(index, false);
  }

  updateOrCreateStudent(index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    //create new student
    if (controller.newStudent) {
      final msg = jsonEncode({
        'AD_Org_ID': {"id": GetStorage().read("organizationid")},
        'AD_Client_ID': {"id": GetStorage().read("clientid")},
        'MP_Maintain_ID': controller.trxCourses
            .records![controller.selectedCourse].mpMaintainParentID?.id,
        'Name': controller.studentFields[0].text,
        'SurName': controller.studentFields[1].text,
        'BirthCity': controller.studentFields[2].text,
        'Birthday': controller.studentFields[3].text,
        'EMailUser': controller.studentFields[4].text,
        'Description': controller.studentFields[5].text,
        'Note': controller.studentFields[6].text
      });
      var url = Uri.parse(
          '$protocol://' + ip + '/api/v1/models/MP_Maintain_Resource/');
      var response = await http.post(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 201) {
        print(response.body);
        Get.find<PortalMpTrainingCourseCourseListController>()
            .getCourseStudents();
        //print("done!");
        Get.snackbar(
          "Done!".tr,
          "The record has been created".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
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

      //update existing user
    } else {
      final msg = jsonEncode({
        'Name': controller.studentFields[0].text,
        'SurName': controller.studentFields[1].text,
        'BirthCity': controller.studentFields[2].text,
        'Birthday': controller.studentFields[3].text,
        'EMailUser': controller.studentFields[4].text,
        'Description': controller.studentFields[5].text,
        'Note': controller.studentFields[6].text
      });
      print(msg);
      var url = Uri.parse('$protocol://' +
          ip +
          '/api/v1/models/MP_Maintain_Resource/${controller.trxStudents.records![index].id}');
      var response = await http.put(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        Get.find<PortalMpTrainingCourseCourseListController>()
            .getCourseStudents();
        //print("done!");
        Get.snackbar(
          "Done!".tr,
          "The record has been updated".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
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
  }

  deleteStudent(index) async {
    if (!controller.newStudent) {
      final ip = GetStorage().read('ip');
      String authorization = 'Bearer ' + GetStorage().read('token');
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse('$protocol://' +
          ip +
          '/api/v1/models/MP_Maintain_Resource/${controller.trxStudents.records![index].id}');
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        await Get.find<PortalMpTrainingCourseCourseListController>()
            .getCourseStudents();
        //if index = 0 will return 1 instead of -1
        index = (index - 1).abs();
        controller.initFieldsController(index, false);
        controller.showStudentDetails = false;
        controller.showStudentDetails = true;
        Get.snackbar(
          "Done!".tr,
          "The record has been deleted".tr,
          isDismissible: true,
          icon: const Icon(
            Icons.delete,
            color: Colors.green,
          ),
        );
      } else {
        //print(response.body);
        Get.snackbar(
          "Error!".tr,
          "Record not deleted".tr,
          isDismissible: true,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      Get.snackbar(
        "Error!".tr,
        "Select a student to delete".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.error,
          color: Colors.yellow,
        ),
      );
    }
  }

  newStudentInput() async {
    controller._showStudentDetails.value = false;
    controller._studentFields[3].text = "";
    controller.initFieldsController(0, true);
    if (controller.selectedCourse != 10000) {
      controller._showStudentDetails.value = true;
    } else {
      Get.snackbar(
        "Select a course".tr,
        "Please select the course the student will be assigned to".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.yellow,
        ),
      );
    }
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
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      child: Obx(() => controller.dataAvailable
                          ? Text('COURSES: '.tr +
                              "${controller.trxCourses.rowcount}")
                          : Text("COURSES: ".tr)),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          //Get.to(const CreateLead());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ), */
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getCourseSurveys();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trxCourses.rowcount,
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
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.auto_stories,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Take the Quiz'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
                                        Get.toNamed('/QuizCourse', arguments: {
                                          "id": controller
                                              .trxCourses.records![index].id,
                                        });
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trxCourses.records![index]
                                            .mProductID?.identifier ??
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
                                      Expanded(
                                        child: Text(
                                          controller.trxCourses.records![index]
                                                  .cBPartnerID?.identifier ??
                                              "??",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
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
                                              "Description: ".tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trxCourses
                                                      .records![index]
                                                      .description ??
                                                  ""),
                                            ),
                                          ],
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
                          ? Text('COURSES: '.tr +
                              "${controller.trxCourses.rowcount}")
                          : Text("COURSES: ".tr)),
                      margin: const EdgeInsets.only(left: 15),
                    ),
                    /* Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        onPressed: () {
                          //Get.to(const CreateLead());
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ), */
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          controller.getCourseSurveys();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trxCourses.rowcount,
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
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.auto_stories,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Take the Quiz'.tr,
                                      onPressed: () {
                                        //log("info button pressed");
                                        Get.toNamed('/QuizCourse', arguments: {
                                          "id": controller
                                              .trxCourses.records![index].id,
                                        });
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trxCourses.records![index]
                                            .mProductID?.identifier ??
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
                                      Expanded(
                                        child: Text(
                                          controller.trxCourses.records![index]
                                                  .cBPartnerID?.identifier ??
                                              "??",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
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
                                              "Description: ".tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(controller
                                                      .trxCourses
                                                      .records![index]
                                                      .description ??
                                                  ""),
                                            ),
                                          ],
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
                      child: Column(children: [
                        const SizedBox(height: kSpacing / 2),
                        _buildProfile(data: controller.getProfil()),
                        const Divider(thickness: 1),
                        //const SizedBox(height: kSpacing),
                        _buildCoursesFilter(),
                        Row(children: [
                          Container(
                            child: Obx(() => controller.dataAvailable
                                ? Text("COURSES: ".tr +
                                    "${controller.trxCourses.rowcount}")
                                : Text("COURSES: ".tr + "")),
                            margin: const EdgeInsets.only(left: 15),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: IconButton(
                              onPressed: () {
                                controller.getCourseSurveys();
                                controller.dataAvailable1 = false;
                                controller.showStudentDetails = false;
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ]),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                //height: kSpacing,
                                height:
                                    MediaQuery.of(context).size.height / 1.3,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Obx(
                                  () => controller.dataAvailable
                                      ? Scrollbar(
                                          child: ListView.builder(
                                            primary: false,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                controller.trxCourses.rowcount,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Obx(() => Visibility(
                                                  visible: controller
                                                              .courseSearchFilterValue
                                                              .value ==
                                                          ""
                                                      ? true
                                                      : controller.courseDropdownValue
                                                                  .value ==
                                                              "1"
                                                          ? (controller.trxCourses.records![index].documentNo ?? "")
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(controller
                                                                  .courseSearchFilterValue
                                                                  .value
                                                                  .toLowerCase())
                                                          : controller.courseDropdownValue
                                                                      .value ==
                                                                  "2"
                                                              ? (controller
                                                                          .trxCourses
                                                                          .records![index]
                                                                          .name ??
                                                                      "")
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(controller.courseSearchFilterValue.value.toLowerCase())
                                                              : controller.courseDropdownValue.value == "3"
                                                                  ? (controller.trxCourses.records![index].cBPartnerID?.identifier ?? "").toString().toLowerCase().contains(controller.courseSearchFilterValue.value.toLowerCase())
                                                                  : true,
                                                  child: Card(
                                                      elevation: 8.0,
                                                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                                      child: Obx(
                                                        () => controller
                                                                    .selectedCourse ==
                                                                index
                                                            ? _buildCourseCard(
                                                                Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                context,
                                                                index)
                                                            : _buildCourseCard(
                                                                const Color
                                                                        .fromRGBO(
                                                                    64,
                                                                    75,
                                                                    96,
                                                                    .9),
                                                                context,
                                                                index),
                                                      ))));
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator()),
                                ),
                              ),
                            )
                          ],
                        ),
                      ])),
                  Flexible(
                      flex: 4,
                      child: Column(children: [
                        const SizedBox(height: kSpacing),
                        _buildHeader(),
                        const SizedBox(height: kSpacing),
                        _buildStudentsFilter(),
                        Row(children: [
                          Container(
                            child: Obx(() => controller.dataAvailable1
                                ? Text("STUDENTS: ".tr +
                                    "${controller.trxStudents.rowcount}")
                                : Text("STUDENTS: ".tr + "")),
                            margin: const EdgeInsets.only(left: 15),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: IconButton(
                              onPressed: () {
                                controller.getCourseStudents();
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ]),
                        Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              //height: kSpacing,
                              height: MediaQuery.of(context).size.height / 1.3,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Obx(
                                () => controller.dataAvailable1
                                    ? Scrollbar(
                                        child: ListView.builder(
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.trxStudents.rowcount,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Obx(() => Visibility(
                                                visible: controller
                                                            .studentSearchFilterValue
                                                            .value ==
                                                        ""
                                                    ? true
                                                    : controller.studentDropdownValue.value ==
                                                            "1"
                                                        ? ((controller.trxStudents.records![index].name ?? "") +
                                                                (controller.trxStudents.records![index].surname ??
                                                                    ""))
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(controller
                                                                .studentSearchFilterValue
                                                                .value
                                                                .toLowerCase())
                                                        : controller.studentDropdownValue.value ==
                                                                "2"
                                                            ? (controller
                                                                        .trxStudents
                                                                        .records![index]
                                                                        .birthcity ??
                                                                    "")
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(controller.studentSearchFilterValue.value.toLowerCase())
                                                            : controller.studentDropdownValue.value == "3"
                                                                ? (controller.trxStudents.records![index].birthday ?? "").toString().toLowerCase().contains(controller.studentSearchFilterValue.value.toLowerCase())
                                                                : true,
                                                child: Card(
                                                  elevation: 8.0,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 6.0),
                                                  child: Obx(
                                                    () => controller
                                                                .selectedStudent ==
                                                            index
                                                        ? _buildStudentCard(
                                                            Theme.of(context)
                                                                .cardColor,
                                                            context,
                                                            index)
                                                        : _buildStudentCard(
                                                            const Color
                                                                    .fromRGBO(
                                                                64, 75, 96, .9),
                                                            context,
                                                            index),
                                                  ),
                                                )));
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Text('No Course Selected'.tr)),
                              ),
                            ))
                          ],
                        ),
                      ])),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing * 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: IconButton(
                                    onPressed: () {
                                      //crea un nuovo studente quindi verrà fatta una richiesta post

                                      controller.newStudent = true;
                                      newStudentInput();
                                    },
                                    icon: const Icon(Icons.person_add),
                                    color: Colors.green,
                                    iconSize: 35),
                              ),
                              SizedBox(
                                child: IconButton(
                                    onPressed: () {
                                      deleteStudent(controller.selectedStudent);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    iconSize: 35),
                              ),
                              SizedBox(
                                child: IconButton(
                                    onPressed: () {
                                      updateOrCreateStudent(
                                          controller.selectedStudent);
                                    },
                                    icon: const Icon(Icons.save),
                                    color: Colors.white,
                                    iconSize: 35),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: kSpacing * 3.8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                  //width: 100,
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: Obx(() => controller
                                          ._showStudentDetails.value
                                      ? _buildStudentInput(context)
                                      : Center(
                                          child:
                                              Text('No Student Selected'.tr)))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
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

  Widget _buildCourseCard(Color selectionColor, context, index) {
    return Container(
      decoration: BoxDecoration(color: selectionColor),
      child: ExpansionTile(
        trailing: IconButton(
            icon: const Icon(
              Icons.article,
              color: Colors.green,
            ),
            onPressed: () {
              controller.selectedCourse = index;
              controller.courseId =
                  controller.trxCourses.records![index].mpMaintainParentID?.id;
              print(controller.courseId);
              controller.showStudentDetails = false;
              controller.getCourseStudents();
            }),
        title: Text(
          "DocumentNo".tr +
              " " +
              controller.trxCourses.records![index].documentNo!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Expanded(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Flexible(
                    child: Text(
                        controller.trxCourses.records![index].name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(
                  width: 50 /* MediaQuery.of(context).size.width / 10, */),
              Row(
                children: [
                  Text("Business Partner".tr + ": ",
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  Flexible(
                    child: Text(
                        controller.trxCourses.records![index].cBPartnerID
                                ?.identifier ??
                            "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          Column(
            children: [
              /* Row(
                children: [
                  Text('Business Partner Location'.tr + ': '),
                ],
              ),
              Row(
                children: [
                  Text(controller.trx.records![index].address1 ?? ''),
                  Text(controller.trx.records![index].city != null ? ', ': ''),
                  Text(controller.trx.records![index].city ?? ''),
                  Text(controller.trx.records![index].postalAdd != null ? ', ': ''),
                  Text(controller.trx.records![index].postalAdd ?? ''),
                ],
              ), */
              Row(
                children: [
                  Text('Description'.tr + ': '),
                  Text(controller.trxCourses.records![index].description ?? '')
                ],
              ),
              Row(
                children: [
                  Text('Organization'.tr + ': '),
                  Text(controller
                          .trxCourses.records![index].aDOrgID?.identifier ??
                      '')
                ],
              ),
              /* Row(
                children: [
                  Text('Date Next Run'.tr + ': '),
                  Text(controller.trx.records![index].dateNextRun ?? '')
                ],
              ),
              Row(
                children: [
                  Text('Date Last Run'.tr + ': '),
                  Text(controller.trx.records![index].dateLastRun ?? '',)
                ],
              ),
              Row(
                children: [
                  Text('ContractNo'.tr + ': '),
                  Text(controller.trx.records![index].cContractID?.identifier ?? '')
                ],
              ), */
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStudentCard(Color selectionColor, context, index) {
    return Container(
      decoration: BoxDecoration(color: selectionColor),
      child: ExpansionTile(
        trailing: IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.green,
            ),
            onPressed: () {
              //non crea un nuovo studente quindi verrà fatta una richiesta put
              controller.newStudent = false;
              controller.initFieldsController(index, false);
              controller.selectedStudent = index;
            }),
        title: Row(
          children: [
            Text(
              (controller.trxStudents.records![index].name != null
                  ? controller.trxStudents.records![index].name! + ' '
                  : ''),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
                (controller.trxStudents.records![index].surname != null
                    ? controller.trxStudents.records![index].surname!
                    : ''),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))
          ],
        ),
        subtitle: Expanded(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "Birthplace".tr + ": ",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(controller.trxStudents.records![index].birthcity ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ],
              ),
              const SizedBox(
                  width: 50 /* MediaQuery.of(context).size.width / 10, */),
              Row(
                children: [
                  Text(
                    'Birthday'.tr + ': ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(controller.trxStudents.records![index].birthday ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInput(BuildContext context) {
    return Container(
        //margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        margin: const EdgeInsets.only(
            right: 10.0, left: 10.0, /* top: kSpacing * 7.7 */ bottom: 6.0),
        color: const Color.fromRGBO(64, 75, 96, .9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.studentFields[0],
                decoration: InputDecoration(
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Name'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .name ?? '', */
                    enabled: true),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.studentFields[1],
                decoration: InputDecoration(
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Surname'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .surname ?? '', */
                    enabled: true),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.studentFields[2],
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Birthplace'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .birthcity ?? '', */
                  enabled: true,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                onTap: () {
                  _selectDate(context, controller.selectedStudent);
                },
                controller: controller.studentFields[3],
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Birthday'.tr,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .birthcity ?? '', */
                  enabled: true,
                ),
              ),
            ),
            /* Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Birthday'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                    Obx(
                      () => controller._showStudentDetails.value
                          ? DateTimePicker(
                              //locale: const Locale('it', 'IT'),
                              type: DateTimePickerType.date,
                              calendarTitle: 'Birthday'.tr,
                              initialValue: controller.studentFields[3].text,
                              firstDate: DateTime(1930),
                              lastDate: DateTime(2100),
                              timeLabelText: 'Birthday'.tr,
                              icon: const Icon(Icons.access_time),
                              onChanged: (date) {
                                controller.studentFields[3].text =
                                    date.substring(0, 10);
                              },
                            )
                          : SizedBox(),
                    )
                  ],
                )), */
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.studentFields[4],
                decoration: InputDecoration(
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Email'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .email ?? '', */
                    enabled: true),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.studentFields[5],
                decoration: InputDecoration(
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Position'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .location ?? '', */
                    enabled: true),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: controller.studentFields[6],
                decoration: InputDecoration(
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'TaxCode'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    /* hintText: controller.trxStudents.records![controller.selectedStudent]
                  .taxcode ?? '', */
                    enabled: true),
              ),
            ),
          ]),
        ));
  }

  Widget _buildCoursesFilter() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Obx(
            () => DropdownButton(
              icon: const Icon(Icons.filter_alt_sharp),
              value: controller.courseDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.courseDropdownValue.value = newValue!;
              },
              items: controller.courseDropDownList.map((list) {
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
              controller: controller.courseSearchFieldController,
              onSubmitted: (String? value) {
                controller.courseSearchFilterValue.value =
                    controller.courseSearchFieldController.text;
              },
              decoration: InputDecoration(
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

  Widget _buildStudentsFilter() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Obx(
            () => DropdownButton(
              icon: const Icon(Icons.filter_alt_sharp),
              value: controller.studentDropdownValue.value,
              elevation: 16,
              onChanged: (String? newValue) {
                controller.studentDropdownValue.value = newValue!;
              },
              items: controller.studentDropDownList.map((list) {
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
              controller: controller.studentSearchFieldController,
              onSubmitted: (String? value) {
                controller.studentSearchFilterValue.value =
                    controller.studentSearchFieldController.text;
              },
              decoration: InputDecoration(
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
}

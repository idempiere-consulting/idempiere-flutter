import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/views/screens/training_course_courselist_screen.dart';

import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class TrainingCourseCourseListFilter extends StatefulWidget {
  const TrainingCourseCourseListFilter({Key? key}) : super(key: key);

  @override
  State<TrainingCourseCourseListFilter> createState() =>
      _TrainingCourseCourseListFilterState();
}

class _TrainingCourseCourseListFilterState
    extends State<TrainingCourseCourseListFilter> {
  applyFilters() {
    if (selectedUserRadioTile > 0) {
      if (selectedUserRadioTile == 2 && teacherId > 0) {
        Get.find<TrainingCourseCourseListController>().userFilter =
            " and AD_User2_ID eq $teacherId";
      } else {
        Get.find<TrainingCourseCourseListController>().userFilter =
            " and AD_User2_ID eq ${GetStorage().read('userId')}";
      }
    } else {
      Get.find<TrainingCourseCourseListController>().userFilter = "";
    }

    if (businessPartnerId > 0) {
      Get.find<TrainingCourseCourseListController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<TrainingCourseCourseListController>().businessPartnerFilter = "";
    }

    Get.find<TrainingCourseCourseListController>().selectedUserRadioTile.value =
        selectedUserRadioTile;
    Get.find<TrainingCourseCourseListController>().businessPartnerId.value =
        businessPartnerId;
    Get.find<TrainingCourseCourseListController>().businessPartnerName =
        businessPartnerFieldController.text;

    Get.find<TrainingCourseCourseListController>().getCourseSurveys();
    Get.back();
  }

  setSelectedUserRadioTile(int val) {
    setState(() {
      selectedUserRadioTile = val;
    });
  }

  Future<List<Records>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= DateLastLogin neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  dynamic args = Get.arguments;

  int selectedUserRadioTile = 0;
  int teacherId = 0;
  late TextEditingController teacherFieldController;

  int businessPartnerId = 0;
  late TextEditingController businessPartnerFieldController;

  @override
  void initState() {
    super.initState();
    selectedUserRadioTile = args['selectedUserRadioTile'] ?? 0;
    teacherId = args['teacherId'] ?? 0;
    teacherFieldController =
        TextEditingController(text: args['teacherName'] ?? "");
    businessPartnerId = args['businessPartnerId'] ?? 0;
    businessPartnerFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: applyFilters, child: Text('Apply Filters'.tr)),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Text('Filters'.tr),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Teacher Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  children: [
                    RadioListTile(
                      value: 0,
                      groupValue: selectedUserRadioTile,
                      title: Text("All".tr),
                      //subtitle: Text("Radio 1 Subtitle"),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      activeColor: Theme.of(context).primaryColor,

                      //selected: true,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedUserRadioTile,
                      title: Text("Mine Only".tr),
                      subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedUserRadioTile,
                      title: FutureBuilder(
                        future: getAllSalesRep(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            teacherId = 0;
                                          });
                                        }
                                      },
                                      controller:
                                          businessPartnerFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Teacher'.tr,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
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
                                      teacherFieldController.text =
                                          suggestion.name!;
                                      teacherId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                      //subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    )
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller:
                                          businessPartnerFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        isDense: true,
                                        prefixIcon: const Icon(EvaIcons.search),
                                        border: const OutlineInputBorder(),
                                        labelText: 'Business Partner'.tr,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
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
                                      businessPartnerFieldController.text =
                                          suggestion.name!;
                                      businessPartnerId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                )
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            );
          },
        ),
      ),
    );
  }
}

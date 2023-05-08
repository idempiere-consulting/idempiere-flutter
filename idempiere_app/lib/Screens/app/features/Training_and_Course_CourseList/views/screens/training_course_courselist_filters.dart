import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/views/screens/training_course_courselist_screen.dart';

import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';
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
    var inputFormat = DateFormat('dd/MM/yyyy');
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

    if (dateStartFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateStartFieldController.text);

        Get.find<TrainingCourseCourseListController>().dateStartFilter =
            " and DateStart ge '${DateFormat('yyyy-MM-dd').format(date)} 00:00:00'";
        Get.find<TrainingCourseCourseListController>().dateStartValue =
            dateStartFieldController.text;
      } catch (e) {
        print(e);
      }
    } else {
      Get.find<TrainingCourseCourseListController>().dateStartFilter = "";
      Get.find<TrainingCourseCourseListController>().dateStartValue = '';
    }

    if (dateEndFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateEndFieldController.text);

        Get.find<TrainingCourseCourseListController>().dateEndFilter =
            " and DateStart le '${DateFormat('yyyy-MM-dd').format(date)} 23:59:59'";
        Get.find<TrainingCourseCourseListController>().dateEndValue =
            dateEndFieldController.text;
      } catch (e) {
        print(e);
      }
    } else {
      Get.find<TrainingCourseCourseListController>().dateEndFilter = "";
      Get.find<TrainingCourseCourseListController>().dateEndValue = '';
    }

    Get.find<TrainingCourseCourseListController>().selectedUserRadioTile.value =
        selectedUserRadioTile;
    Get.find<TrainingCourseCourseListController>().teacherId = teacherId;
    Get.find<TrainingCourseCourseListController>().teacherName =
        teacherFieldController.text;
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
  late TextEditingController dateStartFieldController;
  late TextEditingController dateEndFieldController;

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
    dateStartFieldController =
        TextEditingController(text: args['dateStart'] ?? "");
    dateEndFieldController = TextEditingController(text: args['dateEnd'] ?? "");
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
                                      controller: teacherFieldController,
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateStartFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date From'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateEndFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date To'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
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

part of dashboard;

class PortalMpTrainingCourseCourseListController extends GetxController {
  ContractJSON _trx = ContractJSON(records: []);

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  var businessPartnerFilter =
      GetStorage().read('PortalMPContract_businessPartnerFilter') ?? "";
  var docNoFilter = GetStorage().read('PortalMPContract_docNoFilter') ?? "";
  var docTypeFilter = GetStorage().read('PortalMPContract_docTypeFilter') ?? "";

  var businessPartnerId = 0;
  String businessPartnerName = "";
  var docNoValue = "".obs;
  var docTypeId = "0".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  //DESKTOP VIEW VARIABLES

  int selectedHeaderId = 0;
  int selectedHeaderIndex = 0;

  CourseListJson _trxDesktop = CourseListJson(records: []);

  CourseParticipantJSON _participantDesktop =
      CourseParticipantJSON(records: []);

  ContractLineJSON _trxDesktopLines = ContractLineJSON(records: []);

  var desktopDocNosearchFieldController = TextEditingController();

  TextEditingController desktopDocNoFieldController = TextEditingController();
  TextEditingController desktopDocTypeFieldController = TextEditingController();
  TextEditingController desktopBusinessPartnerFieldController =
      TextEditingController();
  TextEditingController desktopNameFieldController = TextEditingController();
  TextEditingController desktopDescriptionFieldController =
      TextEditingController();
  TextEditingController desktopDateFromFieldController =
      TextEditingController();
  TextEditingController desktopDateToFieldController = TextEditingController();
  TextEditingController desktopFrequencyFieldController =
      TextEditingController();

  TextEditingController desktopParticipantNameFieldController =
      TextEditingController();
  TextEditingController desktopParticipantSurnameFieldController =
      TextEditingController();
  TextEditingController desktopParticipantBirthPlaceFieldController =
      TextEditingController();
  TextEditingController desktopParticipantBirthDateFieldController =
      TextEditingController();
  TextEditingController desktopParticipantEmailFieldController =
      TextEditingController();
  TextEditingController desktopParticipantRoleFieldController =
      TextEditingController();
  TextEditingController desktopParticipantNationalIDNumberFieldController =
      TextEditingController();
  var desktopIsConfirmedCheckBox = false.obs;

  var desktopSelectedMaintainID = 0.obs;

  List<DataRow> headerRows = [];

  List<DataRow> lineRows = [];
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  // ignore: prefer_final_fields
  var _desktopDataAvailable = false.obs;

  var desktopPagesCount = 1.obs;
  var desktopPagesTot = 1.obs;
  var desktopLinePagesCount = 1.obs;
  var desktopLinePagesTot = 1.obs;

  var showHeader = true.obs;
  var headerDataAvailable = false.obs;
  var participantsDataAvailable = false.obs;

  var showLines = false.obs;
  var linesDataAvailable = false.obs;

  //END DESKTOP VIEW VARIABLES

  final json = {
    "types": [
      {"id": "1", "name": "Doc N°"},
      {"id": "2", "name": "Business Partner"},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    super.onInit();
    businessPartnerName =
        GetStorage().read('PortalMPContract_businessPartnerName') ?? "";
    docNoValue.value = GetStorage().read('PortalMPContract_docNo') ?? "";
    docTypeId.value = GetStorage().read('PortalMPContract_docTypeId') ?? "0";
    getBusinessPartner();
    getContracts();

    getADUserID();
  }

  bool get dataAvailable => _dataAvailable.value;
  ContractJSON get trx => _trx;
  //String get value => _value.toString();

  Future<void> getBusinessPartner() async {
    final protocol = GetStorage().read('protocol');
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= Name eq \'$name\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(response.body);

      GetStorage().write('BusinessPartnerName',
          json["records"][0]["C_BPartner_ID"]["identifier"]);
      GetStorage().write(
          'BusinessPartnerId', json["records"][0]["C_BPartner_ID"]["id"]);

      businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
    getCourseListsDesktop();
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getContracts();
  }

  Future<void> getADUserID() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= Name eq \'$name\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      adUserId = json["records"][0]["id"];

      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> writeMailTo(String receiver) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: receiver,
    );
    await launchUrl(launchUri);
  }

  Future<void> getContracts() async {
    _dataAvailable.value = false;
    var apiUrlFilter = [
      "",
      " and SalesRep_ID eq ${GetStorage().read('userId')}"
    ];

    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and C_Contract_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    // ignore: unused_local_variable
    var searchFilter = "";
    if (searchFieldController.text != "" && dropdownValue.value == "1") {
      searchFilter = "and DocumentNo contains ${searchFieldController.text}";
    }
    //var userFilters = [];

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_contract?\$filter= IsSoTrx eq Y and AD_Client_ID eq ${GetStorage().read("clientid")}${apiUrlFilter[filterCount]}$notificationFilter$docNoFilter$docTypeFilter&\$skip=${(pagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx = ContractJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;
      //print(trx.records!.length);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getCourseListsDesktop() async {
    _desktopDataAvailable.value = false;
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and MP_Maintain_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    // ignore: unused_local_variable
    var searchFilter = "";
    if (desktopDocNosearchFieldController.text != "") {
      searchFilter =
          " and contains(DocumentNo,'${desktopDocNosearchFieldController.text}')";
    }
    //var userFilters = [];

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_course_v?\$filter= C_BPartner_ID eq $businessPartnerId and WindowType eq \'T\' and AD_Client_ID eq ${GetStorage().read("clientid")}$notificationFilter$searchFilter&\$skip=${(desktopPagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        //C_BPartner_ID eq $businessPartnerId and
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _trxDesktop =
          CourseListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      desktopPagesTot.value = _trxDesktop.pagecount!;

      headerRows = [];

      for (var i = 0; i < _trxDesktop.records!.length; i++) {
        headerRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        desktopSelectedMaintainID.value =
                            _trxDesktop.records![i].id!;
                        getCourseParticipantsDesktop();
                      },
                      icon: const Icon(Symbols.play_lesson)),
                  Text(_trxDesktop.records![i].documentNo ?? '??'),
                ],
              ), onTap: () {
            Get.defaultDialog(
              title: _trxDesktop.records![i].documentNo ?? 'N/A',
              content: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: _trxDesktop.records![i].name),
                        minLines: 1,
                        maxLines: 1,
                        //onTap: () {},
                        //onSubmitted: (String? value) {},
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Course Name'.tr,
                          labelStyle: const TextStyle(color: Colors.white),
                          //hintText: 'Description..'.tr,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                          fillColor: const Color.fromRGBO(38, 40, 55, 1),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                  text: _trxDesktop
                                      .records![i].mProductID?.identifier),
                              minLines: 1,
                              maxLines: 1,
                              //onTap: () {},
                              //onSubmitted: (String? value) {},
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Product'.tr,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                //hintText: 'Description..'.tr,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                fillColor: const Color.fromRGBO(38, 40, 55, 1),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                  text: _trxDesktop.records![i].teacherName),
                              minLines: 1,
                              maxLines: 1,
                              //onTap: () {},
                              //onSubmitted: (String? value) {},
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Teacher'.tr,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                //hintText: 'Description..'.tr,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                                fillColor: const Color.fromRGBO(38, 40, 55, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: DateTimePicker(
                                readOnly: true,
                                locale: Locale('languageCalendar'.tr),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Course Date'.tr,
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  //hintText: 'Description..'.tr,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  isDense: true,
                                  fillColor:
                                      const Color.fromRGBO(38, 40, 55, 1),
                                ),
                                type: DateTimePickerType.date,
                                initialValue: _trxDesktop.records![i].dateStart,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                //dateLabelText: 'Ship Date'.tr,
                                //icon: const Icon(Icons.event),
                                onChanged: (val) {
                                  //print(DateTime.parse(val));
                                  //print(val);

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
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: _trxDesktop.records![i].litText1),
                                minLines: 1,
                                maxLines: 1,
                                //onTap: () {},
                                //onSubmitted: (String? value) {},
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Medic'.tr,
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  //hintText: 'Description..'.tr,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  isDense: true,
                                  fillColor:
                                      const Color.fromRGBO(38, 40, 55, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: _trxDesktop.records![i].description),
                        minLines: 2,
                        maxLines: 3,
                        //onTap: () {},
                        //onSubmitted: (String? value) {},
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Course Description'.tr,
                          labelStyle: const TextStyle(color: Colors.white),
                          //hintText: 'Description..'.tr,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                          fillColor: const Color.fromRGBO(38, 40, 55, 1),
                        ),
                      ),
                    ),
                    Divider(),
                    ElevatedButton(
                        onPressed: () {
                          getAllParticipantCertificates(
                              _trxDesktop.records![i].id!);
                        },
                        child: Text('Attestati')),
                  ],
                ),
              ),
            );
          }),
          DataCell(Text(_trxDesktop.records![i].dateStart ?? '')),
          DataCell(Text(_trxDesktop.records![i].name ?? '')),
          DataCell(Text(_trxDesktop.records![i].description ?? '')),
        ]));
      }
      //print(trx.records!.length);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _desktopDataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAllParticipantCertificates(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/mp_maintain/$id/attachments');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(utf8.decode(response.bodyBytes));
      var json =
          AttachmentJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      List<String> name = [];

      for (var i = 0; i < json.attachments!.length; i++) {
        if (json.attachments![i].contentType == 'application/pdf') {
          name.add(json.attachments![i].name!);
        }
      }

      Get.back();

      Get.defaultDialog(
        title: 'Attestati',
        content: Column(
          children: [
            Divider(),
            SizedBox(
              height: 300,
              width: 300,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: name.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () async {
                        /* await launchUrl(
                            Uri.parse(
                                'file:///home/vincenzo/Scaricati/Report Course Participation Certificate [RP.2020].pdf.pdf'),
                            mode: LaunchMode.externalNonBrowserApplication); */
                        final ip = GetStorage().read('ip');
                        String authorization =
                            'Bearer ${GetStorage().read('token')}';
                        final protocol = GetStorage().read('protocol');
                        var url = Uri.parse(
                            '$protocol://$ip/api/v1/models/mp_maintain/$id/attachments/${name[index]}');
                        var response = await http.get(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization': authorization,
                          },
                        );
                        if (response.statusCode == 200) {
                          final bytes = response.bodyBytes;

                          if (Platform.isAndroid) {
                            await Printing.layoutPdf(
                                onLayout: (PdfPageFormat format) async =>
                                    bytes);
                          } else {
                            final dir =
                                await getApplicationDocumentsDirectory();
                            print('${dir.path}/$name');
                            final file = File('${dir.path}/$name');
                            await file.writeAsBytes(bytes, flush: true);
                            await launchUrl(
                                Uri.parse('file://${'${dir.path}/$name'}'),
                                mode: LaunchMode.externalNonBrowserApplication);
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: kSpacing),
                      title: Text(name[index]),
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      //throw Exception("Failed to load PDF");
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getCourseParticipantsDesktop() async {
    participantsDataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/MP_Maintain_Resource?\$filter= MP_Maintain_ID eq $desktopSelectedMaintainID and AD_Client_ID eq ${GetStorage().read("clientid")}&\$orderby= Name, SurName');
    var response = await http.get(
      url,
      headers: <String, String>{
        //C_BPartner_ID eq $businessPartnerId and
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      _participantDesktop = CourseParticipantJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      participantsDataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> insertParticipantDesktop() async {
    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Name": desktopParticipantNameFieldController.text,
      "SurName": desktopParticipantSurnameFieldController.text,
      "BirthCity": desktopParticipantBirthPlaceFieldController.text,
      "Birthday": desktopParticipantBirthDateFieldController.text,
      "EMailUser": desktopParticipantEmailFieldController.text,
      'Description': desktopParticipantRoleFieldController.text,
      'Note': desktopParticipantNationalIDNumberFieldController.text,
      'IsConfirmed': desktopIsConfirmedCheckBox.value,
    });

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/training-course/tabs/${'training-course'.tr}/$desktopSelectedMaintainID/${'participant-insertion'.tr}');
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        //C_BPartner_ID eq $businessPartnerId and
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      Get.back();
      getCourseParticipantsDesktop();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> editParticipantDesktop(int id) async {
    var msg = jsonEncode({
      "Name": desktopParticipantNameFieldController.text,
      "SurName": desktopParticipantSurnameFieldController.text,
      "BirthCity": desktopParticipantBirthPlaceFieldController.text,
      "Birthday": desktopParticipantBirthDateFieldController.text,
      "EMailUser": desktopParticipantEmailFieldController.text,
      'Description': desktopParticipantRoleFieldController.text,
      'Note': desktopParticipantNationalIDNumberFieldController.text,
      'IsConfirmed': desktopIsConfirmedCheckBox.value,
    });

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/MP_Maintain_Resource/$id');
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        //C_BPartner_ID eq $businessPartnerId and
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      Get.back();
      getCourseParticipantsDesktop();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> deleteParticipantDesktop(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/MP_Maintain_Resource/$id');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    getCourseParticipantsDesktop();
  }

  Future<void> getContractLineDesktop() async {
    linesDataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_ContractLine?\$filter= C_Contract_ID eq $selectedHeaderId and  AD_Client_ID eq ${GetStorage().read("clientid")}&\$skip=${(desktopLinePagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trxDesktopLines = ContractLineJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      desktopLinePagesTot.value = _trxDesktopLines.pagecount!;

      lineRows = [];

      for (var i = 0; i < _trxDesktopLines.records!.length; i++) {
        lineRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Text(_trxDesktopLines.records![i].name ?? '??'),
          ),
          DataCell(Text(
              _trxDesktopLines.records![i].durationUnit?.identifier ?? '??')),
          DataCell(
            Text((_trxDesktopLines.records![i].qty ?? '??').toString()),
          ),
          DataCell(
            Text((_trxDesktopLines.records![i].amount ?? '??').toString()),
          ),
        ]));
      }

      linesDataAvailable.value = true;
    } else {
      //print(response.body);
    }
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

  // Data
  // ignore: library_private_types_in_public_api
  _Profile getProfil() {
    //"userName": "Flavia Lonardi", "password": "Fl@via2021"
    String userName = GetStorage().read('user') as String;
    String roleName = GetStorage().read('rolename') as String;
    return _Profile(
      photo: const AssetImage(ImageRasterPath.avatar1),
      name: userName,
      email: roleName,
    );
  }

  List<TaskCardData> getAllTask() {
    //List<TaskCardData> list;

    return [
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/leads');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          //log('hallooooo');
        },
        title: "Lead",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar1),
          const AssetImage(ImageRasterPath.avatar2),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {},
        addFunction: () {},
        title: "Landing page UI Design",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {},
        addFunction: () {},
        title: "Landing page UI Design",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.done,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
          const AssetImage(ImageRasterPath.avatar2),
        ],
      ),
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "CRM",
      releaseTime: DateTime.now(),
    );
  }

  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo2),
        projectName: "Taxi Online",
        releaseTime: DateTime.now().add(const Duration(days: 130)),
      ),
      ProjectCardData(
        percent: .5,
        projectImage: const AssetImage(ImageRasterPath.logo3),
        projectName: "E-Movies Mobile",
        releaseTime: DateTime.now().add(const Duration(days: 140)),
      ),
      ProjectCardData(
        percent: .8,
        projectImage: const AssetImage(ImageRasterPath.logo4),
        projectName: "Video Converter App",
        releaseTime: DateTime.now().add(const Duration(days: 100)),
      ),
    ];
  }

  List<ImageProvider> getMember() {
    return const [
      AssetImage(ImageRasterPath.avatar1),
      AssetImage(ImageRasterPath.avatar2),
      AssetImage(ImageRasterPath.avatar3),
      AssetImage(ImageRasterPath.avatar4),
      AssetImage(ImageRasterPath.avatar5),
      AssetImage(ImageRasterPath.avatar6),
    ];
  }

  List<ChattingCardData> getChatting() {
    return const [
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar6),
        isOnline: true,
        name: "Samantha",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar3),
        isOnline: false,
        name: "John",
        lastMessage: "well done john",
        isRead: true,
        totalUnread: 0,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar4),
        isOnline: true,
        name: "Alexander Purwoto",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];
  }
}

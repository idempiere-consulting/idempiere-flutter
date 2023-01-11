part of dashboard;

class MaintenanceMpResourceSheetController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  //var _hasMailSupport = false;

  // ignore: prefer_typing_uninitialized_variables
  //var adUserId;

  late RefListResourceTypeJson refList;
  late WorkOrderResourceSurveyLinesJson surveyLines;
  var flagRefList = false.obs;
  var flagSurveyLines = false.obs;
  var flagSign = false.obs;

  late RxList<bool> isChecked;

  var value = "Info Sheet".obs;
  var productId = Get.arguments["prodId"] ?? 0;
  var productName = Get.arguments["prodName"] ?? "";
  var dropDownValue = "".obs;
  var offline = -1;

  var filters = ["Info Sheet", "Check List", "Sign Sheet"];
  var filterCount = 0.obs;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  var locationFieldController = TextEditingController();
  var locationCodeFieldController = TextEditingController();
  var prodFieldController = TextEditingController();
  var manufacturerFieldController = TextEditingController();
  var modelFieldController = TextEditingController();
  var lotFieldController = TextEditingController();
  var serialNoFieldController = TextEditingController();
  var manufacturedYearFieldController = TextEditingController();
  var numberFieldController = TextEditingController();
  var lineFieldController = TextEditingController();
  //String date1 = "";
  var expectedDurationFieldController = TextEditingController();
  String date2 = "";
  String date3 = "";
  var userFieldController = TextEditingController();
  var noteFieldController = TextEditingController();
  var checkboxState = false.obs;

  @override
  void onInit() {
    checkboxState.value = Get.arguments["valid"] ?? false;
    getSurveyLines();
    super.onInit();
    dropDownValue.value = Get.arguments['resTypeId'] ?? "1.1.2";
    getRefListResourceType();
    //getSurveyLines();
    offline = Get.arguments["offlineid"] ?? -1;
    serialNoFieldController.text = Get.arguments["serNo"] ?? "";
    locationCodeFieldController.text = Get.arguments["locationCode"] ?? "";
    locationFieldController.text = Get.arguments["location"] ?? "";
    prodFieldController.text = Get.arguments["prodName"] ?? "";
    lotFieldController.text = Get.arguments["lot"] ?? "";
    expectedDurationFieldController.text =
        (Get.arguments["manYear"] ?? 0).toString();
    userFieldController.text = Get.arguments["userName"] ?? "";
    manufacturerFieldController.text = Get.arguments["manufacturer"] ?? "";
    modelFieldController.text = Get.arguments["model"] ?? "";
    manufacturedYearFieldController.text =
        (Get.arguments["manufacturedYear"] ?? 0).toString();
    date2 = Get.arguments["purchaseDate"] ?? "";
    date3 = (Get.arguments["serviceDate"]) ?? "";
    noteFieldController.text = Get.arguments["note"] ?? "";
    //getADUserID();
  }

  bool get dataAvailable => _dataAvailable.value;
  //String get value => _value.toString();

  changeFilterPlus() {
    if (filterCount < 2) {
      filterCount.value++;
      value.value = filters[filterCount.value];
    }
    //print(object);

    //value.value = filters[filterCount];
  }

  changeFilterMinus() {
    if (filterCount > 0) {
      filterCount.value--;
      value.value = filters[filterCount.value];
    }

    //value.value = filters[filterCount];
  }

  sendAttachedImage(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final msg = jsonEncode({
      "name": "signature.jpg",
      "data": GetStorage().read('SignatureWorkOrderResource')
    });

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/MP_Maintain_Resource/$id/attachments');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      //print(response.body);
    } else {
      //print(response.body);
    }
    GetStorage().write('SignatureWorkOrderResource', null);
  }

  sendAttachedImageOffline(int id) async {
    final ip = GetStorage().read('ip');
    //String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    //record.offlineId = GetStorage().read('postCallId');
    List<dynamic> list = [];
    if (GetStorage().read('postCallList') == null) {
      var call = jsonEncode({
        "offlineid": GetStorage().read('postCallId'),
        "url": '$protocol://' +
            ip +
            '/api/v1/models/MP_Maintain_Resource/$id/attachments',
        "name": "signature.jpg",
        "data": GetStorage().read('SignatureWorkOrderResource')
      });

      list.add(call);
    } else {
      list = GetStorage().read('postCallList');
      var call = jsonEncode({
        "offlineid": GetStorage().read('postCallId'),
        "url": '$protocol://' +
            ip +
            '/api/v1/models/MP_Maintain_Resource/$id/attachments',
        "name": "signature.jpg",
        "data": GetStorage().read('SignatureWorkOrderResource')
      });
      list.add(call);
    }
    GetStorage().write('postCallId', GetStorage().read('postCallId') + 1);
    GetStorage().write('postCallList', list);
    GetStorage().write('SignatureWorkOrderResource', null);
  }

  sendSurveyLines() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    for (var i = 0; i < isChecked.length; i++) {
      var msg = jsonEncode({"LIT_IsField1": isChecked[i]});

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/models/mp_resource_survey_line/${surveyLines.records![i].id}');
      // ignore: unused_local_variable
      var response = await http.put(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
    }
  }

  sendSurveyLinesOffline() async {
    final ip = GetStorage().read('ip');

    for (var i = 0; i < isChecked.length; i++) {
      var msg = jsonEncode({"LIT_IsField1": isChecked[i]});

      Map calls = {};
      if (GetStorage().read('storedEditAPICalls') == null) {
        calls['http://' +
                ip +
                '/api/v1/models/mp_resource_survey_line/${surveyLines.records![i].id}'] =
            msg;
      } else {
        calls = GetStorage().read('storedEditAPICalls');
        calls['http://' +
                ip +
                '/api/v1/models/mp_resource_survey_line/${surveyLines.records![i].id}'] =
            msg;
      }
      GetStorage().write('storedEditAPICalls', calls);
    }
  }

  Future<void> getSurveyLines() async {
    const filename = "workorderresourcesurveylines";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    flagSurveyLines.value = false;
    WorkOrderResourceSurveyLinesJson surveyLines2 =
        WorkOrderResourceSurveyLinesJson.fromJson(
            jsonDecode(file.readAsStringSync()));
    //print(surveyLines2.records!.length);
    surveyLines2.records!.removeWhere(
        (element) => element.mPMaintainResourceID?.id != Get.arguments["id"]);
    surveyLines = surveyLines2;
    //print(surveyLines.records!.length);
    isChecked = RxList<bool>.filled(surveyLines.records!.length, false);
    for (var i = 0; i < surveyLines.records!.length; i++) {
      isChecked[i] = surveyLines.records![i].lITIsField1 ?? false;
    }
    //print(isChecked[0].obs.value);

    flagSurveyLines.value = true;
  }

  Future<void> getRefListResourceType() async {
    const filename = "reflistresourcetype";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    refList =
        RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));
    flagRefList.value = true;
  }

  editWorkOrderResource(bool isConnected) async {
    //print(now);

    const filename = "workorderresource";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "id": Get.arguments["id"],
      "Mp_Maintain_Task_ID": GetStorage().read('selectedTaskId'),
      "M_Product_ID": {"id": productId},
      "ResourceType": {"id": "BP"},
      "ResourceQty": 1,
      "LIT_ResourceType": {"id": dropDownValue.value},
      "LocationComment": locationFieldController.text,
      "Manufacturer": manufacturerFieldController.text,
      //"Value": locationCodeFieldController.text,
      "SerNo": serialNoFieldController.text,
      //"Lot": lotFieldController.text,
      "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
      "UseLifeYears": int.parse(expectedDurationFieldController.text),
      "Name": noteFieldController.text,
      "LIT_ProductModel": modelFieldController.text,
      "DateOrdered": date2.substring(0, 10),
      "ServiceDate": date3,
      "UserName": userFieldController.text,
      "isValid": checkboxState.value,
      "V_Number": numberFieldController.text,
      "LineNo": int.parse(
          lineFieldController.text == "" ? "0" : lineFieldController.text),
    });

    //print(msg);

    WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    if (Get.arguments["id"] != null && offline == -1) {
      trx.records![Get.arguments["index"]].mProductID!.id = productId;
      trx.records![Get.arguments["index"]].mProductID!.identifier = productName;
      trx.records![Get.arguments["index"]].lITResourceType!.id =
          dropDownValue.value;
      trx.records![Get.arguments["index"]].locationComment =
          locationFieldController.text;
      trx.records![Get.arguments["index"]].manufacturer =
          manufacturerFieldController.text;
      /* trx.records![Get.arguments["index"]].value =
          locationCodeFieldController.text; */
      trx.records![Get.arguments["index"]].serNo = serialNoFieldController.text;
      //trx.records![Get.arguments["index"]].lot = lotFieldController.text;
      trx.records![Get.arguments["index"]].manufacturedYear =
          int.parse(manufacturedYearFieldController.text);
      trx.records![Get.arguments["index"]].useLifeYears =
          int.parse(expectedDurationFieldController.text);
      trx.records![Get.arguments["index"]].name = noteFieldController.text;
      trx.records![Get.arguments["index"]].lITProductModel =
          modelFieldController.text;
      trx.records![Get.arguments["index"]].dateOrdered = date2;
      trx.records![Get.arguments["index"]].serviceDate = date3;
      trx.records![Get.arguments["index"]].userName = userFieldController.text;
      trx.records![Get.arguments["index"]].isValid = checkboxState.value;
      trx.records![Get.arguments["index"]].number = numberFieldController.text;
      trx.records![Get.arguments["index"]].lineNo = int.parse(
          lineFieldController.text == "" ? "0" : lineFieldController.text);

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/preventive-maintenance/tabs/resources/${Get.arguments["id"]}');
      if (isConnected) {
        emptyAPICallStak();
        var response = await http.put(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          if (GetStorage().read('SignatureWorkOrderResource') != null) {
            sendAttachedImage(Get.arguments["id"]);
          }
          sendSurveyLines();
          var data = jsonEncode(trx.toJson());
          file.writeAsStringSync(data);
          Get.find<MaintenanceMpResourceController>().getWorkOrders();
          //print("done!");
          //Get.back();
          Get.snackbar(
            "Fatto!",
            "Il record è stato modificato",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        } else {
          //print(response.body);
          //print(response.statusCode);
          Get.snackbar(
            "Errore!",
            "Il record non è stato modificato",
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      } else {
        sendSurveyLinesOffline();
        if (GetStorage().read('SignatureWorkOrderResource') != null) {
          sendAttachedImageOffline(Get.arguments["id"]);
        }
        var data = jsonEncode(trx.toJson());
        file.writeAsStringSync(data);
        Get.find<MaintenanceMpResourceController>().getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${Get.arguments["id"]}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${Get.arguments["id"]}'] =
              msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.red,
          ),
        );
      }
    }

    if (offline != -1) {
      List<dynamic> list = GetStorage().read('postCallList');

      for (var i = 0; i < list.length; i++) {
        var json = jsonDecode(list[i]);
        if (json["offlineid"] == Get.arguments?["offlineid"]) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];
          var adorg = json["AD_Org_ID"];
          var adclient = json["AD_Client_ID"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "AD_Org_ID": adorg,
            "AD_Client_ID": adclient,
            "M_Product_ID": {"id": productId},
            "IsActive": true,
            "ResourceType": {"id": "BP"},
            "ResourceQty": 1,
            "LIT_ResourceType": {"id": dropDownValue},
            "LocationComment": locationFieldController.text,
            "Manufacturer": manufacturerFieldController.text,
            //"Value": locationCodeFieldController.text,
            "SerNo": serialNoFieldController.text,
            //"Lot": lotFieldController.text,
            "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
            "UseLifeYears": int.parse(expectedDurationFieldController.text),
            "Name": noteFieldController.text,
            "LIT_ProductModel": modelFieldController.text,
            "DateOrdered": date2,
            "ServiceDate": date3,
            "UserName": userFieldController.text,
            "isValid": checkboxState.value,
            "V_Number": numberFieldController.text,
            "LineNo": int.parse(lineFieldController.text == ""
                ? "0"
                : lineFieldController.text),
          });

          list.removeAt(i);
          list.add(call);
          GetStorage().write('postCallList', list);
          Get.snackbar(
            "Salvato!",
            "Il record è stato salvato localmente in attesa di connessione internet.",
            icon: const Icon(
              Icons.save,
              color: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Data
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
          log('hallooooo');
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
      projectName: "iDempiere APP",
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

part of dashboard;

class ProductionAdvancementStateController extends GetxController {
  var phaseStatus = "".obs;
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductionOrderJson _trx = ProductionOrderJson(records: []);

  int productionOrderID = 0;

  WorkFlowNodeJSON nodeList = WorkFlowNodeJSON(records: []);

  ProductionLineJSON prodRowList = ProductionLineJSON(records: []);

  var nodeId = "".obs;

  int advancementStatusID = 0;
  var advancementStatusDateStart = "".obs;
  var phaseDuration = 0.0.obs;

  TextEditingController resourceFieldController = TextEditingController();

  TextEditingController documentNoFieldController = TextEditingController();
  var _dataDocNoAvailable = false.obs;

  int resourceId = 0;

  var _hasCallSupport = false;
  //var _hasMailSupport = false;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  int warehouseID = 0;

  TextEditingController unloadProductFieldController = TextEditingController();
  int unloadProductId = 0;
  TextEditingController unloadQtyFieldController =
      TextEditingController(text: "1");

  TextEditingController widthFieldController = TextEditingController(text: "");

  TextEditingController heightFieldController = TextEditingController(text: "");

  TextEditingController lengthFieldController = TextEditingController(text: "");

  TextEditingController noteFieldController = TextEditingController(text: "");

  int inventoryDocId = 0;

  TextEditingController hoursFieldController = TextEditingController(text: "");

  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  var _prodLinedataAvailable = false.obs;
  var _nodeListdataAvailable = false.obs;

  PPCostCollectorJSON summaryPhase = PPCostCollectorJSON(records: []);
  List<String> summeryPhaseList = [];
  List<int> summeryPhaseListId = [];
  var summaryAvailable = false.obs;
  Map<int, num> phaseTotalHours = {};

  var attachments = AttachmentJSON(attachments: []);
  var attachmentsAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });

    //getProductionOrder();
    //getADUserID();
    getDocType();
    adUserId = GetStorage().read('userId');
    getMyResourceByLoginUser();
  }

  bool get dataAvailable => _dataAvailable.value;
  ProductionOrderJson get trx => _trx;
  //String get value => _value.toString();

  Future<void> makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    if (_hasCallSupport) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
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

  Future<void> searchPhase(String phaseID) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/PP_Cost_Collector?\$filter= DocStatus neq \'CO\' and M_Production_Node_ID eq $phaseID and S_Resource_ID eq $resourceId and M_Production_ID eq $productionOrderID and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var phaseList = PPCostCollectorJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      advancementStatusDateStart.value = "";
      phaseDuration.value = 0.0;
      advancementStatusID = 0;
      phaseStatus.value = "";

      if (phaseList.records!.isEmpty) {
        phaseStatus.value = "START";
      } else {
        if (phaseList.records![0].docStatus?.id == "DR" ||
            phaseList.records![0].docStatus?.id == "IP") {
          advancementStatusDateStart.value =
              phaseList.records![0].movementDate!;
          phaseDuration.value = phaseList.records![0].durationReal!.toDouble();
          advancementStatusID = phaseList.records![0].id!;
          phaseStatus.value = "STOP";
        } else {
          advancementStatusDateStart.value =
              phaseList.records![0].movementDate!;
          phaseDuration.value = phaseList.records![0].durationReal!.toDouble();
          phaseStatus.value = "";
        }
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to search phase");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getAllPhases() async {
    summaryAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/PP_Cost_Collector?\$filter=  M_Production_ID eq $productionOrderID and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      summeryPhaseList = [];
      summeryPhaseListId = [];

      summaryPhase = PPCostCollectorJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in summaryPhase.records!) {
        if (summeryPhaseList.isEmpty) {
          summeryPhaseList.add(element.mProductionNodeID!.identifier!);
          summeryPhaseListId.add(element.mProductionNodeID!.id!);
        }
        if ((summeryPhaseList
            .where((record) => record == element.mProductionNodeID!.identifier!)
            .isEmpty)) {
          summeryPhaseList.add(element.mProductionNodeID!.identifier!);
          summeryPhaseListId.add(element.mProductionNodeID!.id!);
        }
      }

      summaryAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to get summary phase");
    }
  }

  Future<void> getTablesWithAttachments() async {
    attachmentsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_docdms_v/?\$filter=  ((Record_ID eq $productionOrderID and Name eq \'M_Production\') or (Record_ID eq ${_trx.records![0].cbPartnerID?.id} and Name eq \'C_BPartner\') or (Record_ID eq ${_trx.records![0].mProductID?.id} and Name eq \'M_Product\')) and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      attachments.attachments!.removeWhere((element) => true);
      var tablesWithAttachments = DocAttachmentsJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (tablesWithAttachments.records!.isNotEmpty) {
        for (var record in tablesWithAttachments.records!) {
          if ((attachments.attachments!.where((element) =>
              (element.recordId == record.recordID &&
                  element.tableName == record.name))).isEmpty) {
            await getAttachments(record.recordID!, record.name!);
          }
        }
      }
      attachmentsAvailable.value = true;
    } else {
      print(response.body);
    }
  }

  Future<void> getAttachments(int id, String tableName) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/$tableName/$id/attachments');
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
          AttachmentJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < json.attachments!.length; i++) {
        attachments.attachments!.add(Attachments(
            recordId: id,
            tableName: tableName,
            name: json.attachments![0].name,
            contentType: json.attachments![0].contentType));
      }
    } else {
      print(response.body);
    }
  }

  Future<void> getMyResourceByLoginUser() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/S_Resource?\$filter= Name eq \'${GetStorage().read('user')}\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonres = ResourceJson.fromJson(jsondecoded);

      if (jsonres.records!.isNotEmpty) {
        resourceId = jsonres.records![0].id!;
        resourceFieldController.text = jsonres.records![0].name!;
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<List<RRecords>> getAllResources() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/S_Resource?\$filter=  AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonres = ResourceJson.fromJson(jsondecoded);

      return jsonres.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load resources");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getProductionOrder(String barcode) async {
    _dataAvailable.value = false;

    // ignore: unused_local_variable
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and AD_User_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Production?\$filter= contains(tolower(DocumentNo),\'$barcode\') and  AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(pagesCount.value - 1) * 100}');
    //print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);

      _trx = ProductionOrderJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;

      if (_trx.records!.isNotEmpty) {
        advancementStatusDateStart.value = "";
        phaseDuration.value = 0.0;
        advancementStatusID = 0;
        phaseStatus.value = "";
        nodeId.value = "";
        getProductionOrderLines(_trx.records![0].id!);

        productionOrderID = _trx.records![0].id!;

        getWorkFlowNodes(_trx.records![0].aDWorkflowID?.id ?? 0);

        getWarehouseID(_trx.records![0].mLocatorID!.id!);

        //getAttachments();
        getTablesWithAttachments();

        //print(trx.rowcount);
        //print(response.body);
        // ignore: unnecessary_null_comparison
        _dataAvailable.value = _trx != null;
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<List<POJRecords>> getAllProduction() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Production?\$filter=  AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonres = ProductionOrderJson.fromJson(jsondecoded);

      return jsonres.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load production orders");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getProductionOrderLines(int productionID) async {
    _prodLinedataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_productionline_inv_v?\$filter= M_Production_ID eq $productionID and IsEndProduct eq \'N\' and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(pagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      prodRowList = ProductionLineJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      _prodLinedataAvailable.value = true;
    } else {
      print(response.body);
    }
    getAllPhases();
  }

  Future<void> getWorkFlowNodes(int workFlowID) async {
    _nodeListdataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_WF_Node?\$filter= AD_Workflow_ID eq $workFlowID and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(pagesCount.value - 1) * 100}');
    //print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      nodeList = WorkFlowNodeJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      _nodeListdataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getWarehouseID(int locatorID) async {
    _nodeListdataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Locator?\$filter= M_Locator_ID eq $locatorID and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(pagesCount.value - 1) * 100}');
    //print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var locatorList =
          LocatorJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      warehouseID = locatorList.records![0].mWarehouseID!.id!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> createAdvancementStateRecord() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    DateTime now = DateTime.now();
    var n = now.minute; // Number to match
    var l = [0, 15, 30, 45]; // List of values

    var number = l.where((e) => e <= n).toList()..sort();

    //print(number[number.length - 1]);

    var hourTime = "00";

    var minuteTime = "00";

    if (now.hour < 10) {
      hourTime = "0${now.hour}";
    } else {
      hourTime = "${now.hour}";
    }

    if (number[number.length - 1] != 0) {
      minuteTime = number[number.length - 1].toString();
    }
    if (number[number.length - 1] != 0) {
      minuteTime = number[number.length - 1].toString();
    }

    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(now);
    var startTime = '$hourTime:$minuteTime:00Z';

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warewouse_ID": {"id": warehouseID},
      "M_Warehouse_ID": {"id": 1000000},
      "M_Locator_ID": {"id": 1000000},
      "M_Production_ID": {"id": productionOrderID},
      "S_Resource_ID": {"id": resourceId},
      "M_Product_ID": {"id": _trx.records![0].mProductID?.id},
      "M_Production_Node_ID": {"id": int.parse(nodeId.value)},
      "MovementDate": "${date}T$startTime",
    };

    var url =
        Uri.parse('$protocol://$ip/api/v1/windows/activity-control-report');
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      searchPhase(nodeId.value);
      getAllPhases();
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
  }

  Future<void> editAdvancementStateRecord() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    DateTime now = DateTime.now();
    var n = now.minute; // Number to match
    var l = [0, 15, 30, 45]; // List of values

    var number = l.where((e) => e <= n).toList()..sort();

    //print(number[number.length - 1]);

    var hourTime = "00";

    var minuteTime = "00";

    if (now.hour < 10) {
      hourTime = "0${now.hour}";
    } else {
      hourTime = "${now.hour}";
    }

    if (number[number.length - 1] != 0) {
      minuteTime = number[number.length - 1].toString();
    }
    if (number[number.length - 1] != 0) {
      minuteTime = number[number.length - 1].toString();
    }

    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(now);
    var startTime = '$hourTime:$minuteTime:00Z';

    DateTime dateStart = DateTime.parse(advancementStatusDateStart.value);

    DateTime dateStop = DateTime.parse("$date $startTime");

    var totm = dateStop.difference(dateStart).inMinutes;

    double hours = totm / 60;

    var msg = {
      "DocStatus": {"id": "CO"},
      "DurationReal": hours,
    };

    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/activity-control-report/tabs/${"activity-control".tr}/$advancementStatusID/');
    var response = await http.put(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      getAllPhases();
      //print(response.body);
      searchPhase(nodeId.value);
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
  }

  Future<void> createAdvancementStateRecordByStartStopButton() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    DateTime now = DateTime.now();

    DateTime before = now
        .subtract(Duration(minutes: int.parse(hoursFieldController.text) * 60));
    var n = before.minute; // Number to match
    var l = [0, 15, 30, 45]; // List of values

    var number = l.where((e) => e <= n).toList()..sort();

    //print(number[number.length - 1]);

    var hourTime = "00";

    var minuteTime = "00";

    if (before.hour < 10) {
      hourTime = "0${before.hour}";
    } else {
      hourTime = "${before.hour}";
    }

    if (number[number.length - 1] != 0) {
      minuteTime = number[number.length - 1].toString();
    }
    if (number[number.length - 1] != 0) {
      minuteTime = number[number.length - 1].toString();
    }

    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(before);
    var startTime = '$hourTime:$minuteTime:00Z';

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warewouse_ID": {"id": warehouseID},
      "M_Locator_ID": {"id": 1000000},
      "M_Production_ID": {"id": productionOrderID},
      "S_Resource_ID": {"id": resourceId},
      "M_Product_ID": {"id": _trx.records![0].mProductID?.id},
      "M_Production_Node_ID": {"id": int.parse(nodeId.value)},
      "MovementDate": "${date}T$startTime",
      "DocStatus": {"id": "CO"},
      "DurationReal": int.parse(hoursFieldController.text),
    };

    var url =
        Uri.parse('$protocol://$ip/api/v1/windows/activity-control-report');
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      Get.back();
      searchPhase(nodeId.value);
      getAllPhases();
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
  }

  Future<void> createProductionLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": unloadProductId},
      "QtyUsed": int.parse(unloadQtyFieldController.text),
      "Note": noteFieldController.text
    };

    if (widthFieldController.text != "") {
      msg.addAll({"Width": int.parse(widthFieldController.text)});
    }
    if (heightFieldController.text != "") {
      msg.addAll({"Height": int.parse(heightFieldController.text)});
    }
    if (lengthFieldController.text != "") {
      msg.addAll({"Length": int.parse(lengthFieldController.text)});
    }

    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/production-single-product/tabs/${"production-mask".tr}/$productionOrderID/${"production-line-mask".tr}');
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      if (nodeId.value != "") {
        searchPhase(nodeId.value);
      }

      getProductionOrderLines(productionOrderID);
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> getInventoryByLineID(int inventoryLineID) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_InventoryLine?\$filter= M_InventoryLine_ID eq $inventoryLineID and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = LoadUnloadLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      List<PLRecords> list = [];

      if (json.records!.isNotEmpty) {
        for (var element in prodRowList.records!) {
          if (element.mInventoryLineID?.id == null) {
            if (await createInventoryLine(
                json.records![0].mInventoryID!.id!, element)) {
              list.add(element);
            }
          }
        }
        if (list.isEmpty) {
          getProductionOrderLines(productionOrderID);
        } else {
          createInventoryRecursive(list);
        }
      }
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      print(response.body);
    }
  }

  Future<void> createInventory() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_DocType_ID": {"id": inventoryDocId},
      "M_Warehouse_ID": {"id": warehouseID},
      "MovementDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //"DocAction": "CO",
    };

    var url = Uri.parse('$protocol://$ip/api/v1/models/M_Inventory/');
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      List<PLRecords> list = [];
      var json =
          LULRecords.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in prodRowList.records!) {
        if (await createInventoryLine(json.id!, element)) {
          list.add(element);
        }
      }

      if (list.isEmpty) {
        getProductionOrderLines(productionOrderID);
      } else {
        createInventoryRecursive(list);
      }

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
  }

  Future<bool> createInventoryLine(int inventoryID, PLRecords prodLine) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var msg = {
      "M_Inventory_ID": {"id": inventoryID},
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": prodLine.mProductID!.id},
      "M_Locator_ID": {"id": prodLine.mLocatorID!.id!},
      "QtyInternalUse": prodLine.qtyUsed!.toInt(),
      "M_ProductionLine_ID": {"id": prodLine.id},
      "C_Charge_ID": {"id": 1000000},
    };

    var url = Uri.parse('$protocol://$ip/api/v1/models/M_InventoryLine/');
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> createInventoryRecursive(List<PLRecords> record) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_DocType_ID": {"id": inventoryDocId},
      "M_Warehouse_ID": {"id": warehouseID},
      "MovementDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //"DocAction": "CO",
    };

    var url = Uri.parse('$protocol://$ip/api/v1/models/M_Inventory/');
    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      List<PLRecords> list = [];
      var json =
          LULRecords.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in record) {
        if (await createInventoryLine(json.id!, element)) {
          list.add(element);
        }
      }

      if (list.isEmpty) {
        getProductionOrderLines(productionOrderID);
      } else {
        createInventoryRecursive(list);
      }
    } else {}
  }

  Future<void> getDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/C_DocType?\$filter= Name eq \'Internal Use Inventory\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      inventoryDocId = json["records"][0]["id"];
    }
  }

  Future<List<PRecords>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(await file.readAsString());
    var jsonResources = ProductJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
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

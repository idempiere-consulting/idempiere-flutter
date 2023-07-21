part of dashboard;

class MaintenanceMptaskLineController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderTaskLocalJson _trx;
  late WorkOrderTaskLocalJson _trx2;
  var _hasCallSupport = false;
  var args = Get.arguments;
  late OrgInfoJSON orgInfo;

  WorkOrderTaskLocalJson prodCountList = WorkOrderTaskLocalJson(records: []);

  int filterId = 0;

  //var _hasMailSupport = false;
  //var args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  //var adUserId;
  TextEditingController noteFieldController =
      TextEditingController(text: Get.arguments["note"]);
  TextEditingController manualNoteFieldController =
      TextEditingController(text: Get.arguments["manualNote"]);
  TextEditingController requestFieldController =
      TextEditingController(text: Get.arguments["request"]);
  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });
    //print(GetStorage().read('workOrderSync'));
    getWorkOrders();
    setConnect();
    getOrgInfo();
    //getADUserID();
  }

  setFilter(int id) {
    if (filterId != id) {
      filterId = id;
    } else {
      filterId = 0;
    }
    getWorkOrders();
  }

  Future<void> setConnect() async {
    try {
      final String? result = await BluetoothThermalPrinter.connect(
          GetStorage().read('posMacAddress'));
      //print("state conneected $result");
      if (result == "true") {}
    } catch (e) {
      if (kDebugMode) {
        print('nope');
      }
    }
    //printTicket();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderTaskLocalJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getWorkOrders();
  }

  getOrgInfo() async {
    const filename = "adorginfo";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    orgInfo = OrgInfoJSON.fromJson(jsonDecode(file.readAsStringSync()));
  }

  Future<void> printWorkOrderTasksTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      try {
        List<int> bytes = await getWorkOrderTasks();
        // ignore: unused_local_variable
        final result = await BluetoothThermalPrinter.writeBytes(bytes);
      } catch (e) {
        if (kDebugMode) {
          print('nope');
        }
      }
      //print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<List<int>> getWorkOrderTasks() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    var dateString = args["date"];
    DateTime date = DateTime.parse(dateString!);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    bytes += generator.text("${args["org"]}",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(orgInfo.records![0].cLocationID!.identifier!,
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text("P. IVA ${orgInfo.records![0].taxID}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    bytes += generator.text("${"Document Type: ".tr}${args["docType"]}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('${'Document: '.tr}${args["docN"]} $formattedDate',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    bytes += generator.text(
        '${'Request Description'.tr}: ${requestFieldController.text}',
        styles: const PosStyles(align: PosAlign.left),
        linesAfter: 1);
    bytes += generator.text(
        '${'Activity To Do'.tr}: ${noteFieldController.text}',
        styles: const PosStyles(align: PosAlign.left),
        linesAfter: 1);
    bytes += generator.text(
        '${'Activity Done'.tr}: ${manualNoteFieldController.text}',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.hr(ch: '=');

    bytes += generator.text("Product/Service".tr,
        styles: const PosStyles(align: PosAlign.left, bold: true));
    // ignore: unnecessary_null_comparison
    if (_trx != null) {
      for (var line in _trx.records!) {
        bytes += generator.text("${line.mProductID?.identifier}",
            styles: const PosStyles(align: PosAlign.left));
        bytes += generator.text(
            "U.M. ${line.cUOMID?.identifier}    ${"Qty".tr} ${line.qty}",
            styles: const PosStyles(align: PosAlign.center));
        bytes += generator.hr();
      }
    }
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    //DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    bytes += generator.text(dateFormat.format(DateTime.now()),
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    if (args["hasAttachment"] == "true") {
      bytes += generator.text("Firma___________________",
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);
    }

    bytes += generator.cut();
    return bytes;
  }

  deleteTask(int id, int index) async {
    const filename = "workordertask";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/MP_OT_Task/$id');

    if (await checkConnection()) {
      emptyAPICallStak();
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //print("done!");
        Get.snackbar(
          "Fatto!",
          "Il record è stato eliminato",
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        Get.snackbar(
          "Errore!",
          "Record non eliminato",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      List<dynamic> list = [];
      if (GetStorage().read('deleteCallList') == null) {
        var call = jsonEncode({
          "url": '$protocol://$ip/api/v1/models/MP_OT_Task/$id',
        });

        list.add(call);
      } else {
        list = GetStorage().read('deleteCallList');
        var call = jsonEncode({
          "url": '$protocol://$ip/api/v1/models/MP_OT_Task/$id',
        });
        list.add(call);
      }
      GetStorage().write('deleteCallList', list);
      Get.snackbar(
        "Salvato!",
        "Il record è stato salvato localmente in attesa di connessione internet.",
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
    }
    if (GetStorage().read('postCallList') != null &&
        (GetStorage().read('postCallList')).isEmpty == false) {
      List<dynamic> list2 = GetStorage().read('postCallList');

      for (var element in list2) {
        var json = jsonDecode(element);
        if (json["offlineid"] == _trx.records![index].offlineId) {
          list2.remove(element);
        }
        //print(element);
        //print(json["url"]);
      }
      GetStorage().write('postCallList', list2);
    }
    _trx2.records!
        .removeWhere((element) => element.id == _trx.records![index].id);
    var data = jsonEncode(_trx2.toJson());
    file.writeAsStringSync(data);
    //_dataAvailable.value = false;
    getWorkOrders();
    //GetStorage().write('workOrderResourceSync', data);
    //Get.find<MaintenanceMpResourceController>().getWorkOrders();
  }

  editManualNote() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "ManualNote": manualNoteFieldController.text,
    });
    final protocol = GetStorage().read('protocol');

    const filename = "workorder";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    WorkOrderLocalJson wo =
        WorkOrderLocalJson.fromJson(jsonDecode(file.readAsStringSync()));

    for (var element in wo.records!) {
      if (element.id == args["id"]) {
        element.manualNote = manualNoteFieldController.text;
      }
    }

    var url = Uri.parse('$protocol://$ip/api/v1/models/mp_ot/${args["id"]}');
    if (await checkConnection()) {
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
        var data = jsonEncode(wo.toJson());
        file.writeAsStringSync(data);
        Get.find<MaintenanceMptaskController>().getWorkOrders();
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
        if (kDebugMode) {
          print(response.body);
        }
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
      var data = jsonEncode(wo.toJson());
      file.writeAsStringSync(data);
      Get.find<MaintenanceMptaskController>().getWorkOrders();
      Map calls = {};
      if (GetStorage().read('storedEditAPICalls') == null) {
        calls['$protocol://$ip/api/v1/models/mp_ot/${args["id"]}'] = msg;
      } else {
        calls = GetStorage().read('storedEditAPICalls');
        calls['$protocol://$ip/api/v1/models/mp_ot/${args["id"]}'] = msg;
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

  Future<void> getWorkOrders() async {
    /* var apiUrlFilter = ["", " and SalesRep_ID eq $adUserId"];
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/mp_ot?\$filter=AD_Client_ID eq ${GetStorage().read("clientid")}${apiUrlFilter[filterCount]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx = WorkOrderJson.fromJson(jsonDecode(response.body));
      print(trx.records![0].dateTrx);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } */
    _dataAvailable.value = false;
    prodCountList.records = [];
    //print(GetStorage().read('workOrderSync'));
    //print(GetStorage().read('userId'));
    const filename = "workordertask";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(await file.readAsString());
    _trx = WorkOrderTaskLocalJson.fromJson(jsondecoded);
    _trx2 = WorkOrderTaskLocalJson.fromJson(jsondecoded);

    _trx.records!.removeWhere((element) => element.mPOTID?.id != args["id"]);

    if (filterId != 0) {
      _trx.records!
          .removeWhere((element) => element.mProductID?.id != filterId);
    }

    for (var i = 0; i < _trx.records!.length; i++) {
      if (prodCountList.records!
          .where((element) =>
              element.mProductID?.identifier ==
              _trx.records![i].mProductID?.identifier)
          .isEmpty) {
        prodCountList.records!
            .add(TRecords(mProductID: _trx.records![i].mProductID, qty: 1));
      } else {
        for (var j = 0; j < prodCountList.records!.length; j++) {
          if (prodCountList.records![j].mProductID?.identifier ==
              _trx.records![i].mProductID?.identifier) {
            prodCountList.records![j].qty = prodCountList.records![j].qty! + 1;
          }
        }
      }
    }

    //print(_trx.records![0.]);
    // ignore: unnecessary_null_comparison
    _dataAvailable.value = _trx != null;
  }

  Future<void> syncWorkOrderTask() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_task_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        //print(response.body);
      }
      var json = WorkOrderTaskLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderTaskPages(json, index);
      } else {
        const filename = "workordertask";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(utf8.decode(response.bodyBytes));
        //productSync = false;
        if (kDebugMode) {
          print('WorkOrderTask Checked');
        }
        getWorkOrders();

        //checkSyncData();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  syncWorkOrderTaskPages(WorkOrderTaskLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_task_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderTaskLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderTaskPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workordertask";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(jsonEncode(json.toJson()));
        //workOrderSync = false;
        if (kDebugMode) {
          print('WorkOrderTask page Checked');
        }
        getWorkOrders();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
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
      projectName: "Intervento",
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

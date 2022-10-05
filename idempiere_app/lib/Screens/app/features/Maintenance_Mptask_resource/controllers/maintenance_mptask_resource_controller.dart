part of dashboard;

class MaintenanceMpResourceController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderResourceLocalJson _trx;
  late WorkOrderResourceLocalJson _trx2;
  late RefListResourceTypeJson
      _tt /* = RefListResourceTypeJson.fromJson(
      jsonDecode(GetStorage().read('refListResourceTypeCategory'))) */
      ;
  late RefListResourceTypeJson
      _tt2 /* = RefListResourceTypeJson.fromJson(
      jsonDecode(GetStorage().read('refListResourceTypeCategory'))) */
      ;
  //var _hasMailSupport = false;

  var offline = -1;

  var dropDownValue = "A1";
  var dropDownValue2 = "0".obs;

  // ignore: prefer_typing_uninitialized_variables
  //var adUserId;
  DateTime now = DateTime.now();

  var value = "All".obs;

  var filters = ["All", "Unchecked", "Checked"];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  var filter1Available = false.obs;
  var filter2Available = false.obs;

  @override
  void onInit() {
    initializeFilters();

    super.onInit();

    //getADUserID();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderResourceLocalJson get trx => _trx;
  RefListResourceTypeJson get tt => _tt;
  RefListResourceTypeJson get tt2 => _tt2;
  //String get value => _value.toString();

  Future<void> initializeFilters() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/reflistresourcetypecategory.json');

    _tt2 =
        RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));

    _tt = RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));

    _tt2.records?.insert(0, Records(value: "0", name: "All"));
    filter1Available.value = true;
    filter2Available.value = true;
    getWorkOrders();
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 3) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getWorkOrders();
  }

/*   Future<void> getADUserID() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse(
        'http://' + ip + '/api/v1/models/ad_user?\$filter= Name eq \'$name\'');
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

      adUserId = json["records"][0]["id"];

      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    }
  } */

  openResourceType() {
    Get.defaultDialog(
      title: "Resource Type",
      //middleText: "Choose the type of Ticket you want to create",
      //contentPadding: const EdgeInsets.all(2.0),
      content: DropdownButton(
        value: dropDownValue,
        style: const TextStyle(fontSize: 12.0),
        elevation: 16,
        onChanged: (String? newValue) {
          dropDownValue = newValue!;
          Get.back();
          Get.to(const CreateMaintenanceMpResource(),
              arguments: {"id": dropDownValue});
        },
        items: _tt.records!.map((list) {
          return DropdownMenuItem<String>(
            child: Text(
              list.name.toString(),
            ),
            value: list.value,
          );
        }).toList(),
      ),
      barrierDismissible: true,
      /* textCancel: "Cancel",
        textConfirm: "Confirm",
        onConfirm: () {
          Get.back();
          Get.to(const CreateTicketClientTicket(),
              arguments: {"id": dropdownValue});
        } */
    );
  }

  editWorkOrderResourceDateCheck(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String date = dateFormat.format(DateTime.now());

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "LIT_Control1DateFrom": date,
    });

    /*  WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].lITControl1DateFrom = date;
        }
      }

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}');
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
          _dataAvailable.value = false;
          var data = jsonEncode(_trx2.toJson());
          GetStorage().write('workOrderResourceSync', data);
          getWorkOrders();
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
        var data = jsonEncode(_trx2.toJson());
        GetStorage().write('workOrderSync', data);
        getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}'] =
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
        if (json["offlineid"] == _trx.records![index].offlineId) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "LIT_Control1DateFrom": date,
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

  editWorkOrderResourceDateRevision(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String date = dateFormat.format(DateTime.now());

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "LIT_Control1DateFrom": date,
      "LIT_Control2DateFrom": date,
    });

    /* WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].lITControl1DateFrom = date;
          _trx2.records![i].lITControl2DateFrom = date;
        }
      }

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}');
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
          var data = jsonEncode(_trx2.toJson());
          GetStorage().write('workOrderResourceSync', data);
          getWorkOrders();
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
        var data = jsonEncode(_trx2.toJson());
        GetStorage().write('workOrderSync', data);
        getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}'] =
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
        if (json["offlineid"] == _trx.records![index].offlineId) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "LIT_Control1DateFrom": date,
            "LIT_Control2DateFrom": date,
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

  editWorkOrderResourceDateTesting(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String date = dateFormat.format(DateTime.now());

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "LIT_Control1DateFrom": date,
      "LIT_Control2DateFrom": date,
      "LIT_Control3DateFrom": date,
    });

    /*  WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].lITControl1DateFrom = date;
          _trx2.records![i].lITControl2DateFrom = date;
          _trx2.records![i].lITControl3DateFrom = date;
        }
      }

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}');
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
          var data = jsonEncode(_trx2.toJson());
          GetStorage().write('workOrderResourceSync', data);
          getWorkOrders();
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
        var data = jsonEncode(_trx2.toJson());
        GetStorage().write('workOrderSync', data);
        getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/${_trx.records![index].id}'] =
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
        if (json["offlineid"] == _trx.records![index].offlineId) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "LIT_Control1DateFrom": date,
            "LIT_Control2DateFrom": date,
            "LIT_Control3DateFrom": date,
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

  Future<void> getWorkOrders() async {
    _dataAvailable.value = false;
    late List<RRecords> temp;
    var flag = true;
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //print(GetStorage().read('workOrderResourceSync'));

    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
    //print(file.readAsStringSync());
    //print(GetStorage().read('selectedTaskDocNo'));
    _trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));
    _trx2 = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    if (dropDownValue2.value != "0") {
      temp = (_trx.records!.where((element) =>
              element.eDIType?.id == dropDownValue2.value &&
              element.mpOtDocumentno == GetStorage().read('selectedTaskDocNo')))
          .toList();
      //print(temp);
      _trx.records = temp;
      _trx.rowcount = _trx.records?.length;
      flag = false;
    }
    if (filterCount != 0) {
      switch (filterCount) {
        case 1:
          temp = (_trx.records!.where((element) =>
              element.lITControl1DateFrom != formattedDate &&
              element.mpOtDocumentno ==
                  GetStorage().read('selectedTaskDocNo'))).toList();
          //print(temp);
          _trx.records = temp;
          _trx.rowcount = _trx.records?.length;
          flag = false;
          break;
        case 2:
          temp = (_trx.records!.where((element) =>
              element.lITControl1DateFrom == formattedDate &&
              element.mpOtDocumentno ==
                  GetStorage().read('selectedTaskDocNo'))).toList();
          //print(temp);
          _trx.records = temp;
          _trx.rowcount = _trx.records?.length;
          flag = false;
          break;
        default:
      }
    }
    if (flag) {
      temp = (_trx.records!.where((element) =>
              element.mpOtDocumentno == GetStorage().read('selectedTaskDocNo')))
          .toList();
      //print(temp);
      _trx.records = temp;
      _trx.rowcount = _trx.records?.length;
    }

    // ignore: unnecessary_null_comparison
    _dataAvailable.value = _trx != null;
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

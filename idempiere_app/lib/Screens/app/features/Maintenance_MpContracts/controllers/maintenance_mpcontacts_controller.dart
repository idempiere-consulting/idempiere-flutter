part of dashboard;

class MaintenanceMpContractsController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late MPMaintainContractJSON _trx;
  var _hasCallSupport = false;
  //var _hasMailSupport = false;

  String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String startDate = "";
  String startTime = "8:00";
  String endTime = "18:00";
  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var filters = ["Tutti", "Questo Mese", "Prossimo Mese"];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  final json = {
    "types": [
      {"id": "1", "name": "Business Partner"},
      {"id": "2", "name": "N° Doc"},
      {"id": "3", "name": "Phone N°"},
      {"id": "4", "name": "Area"},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  @override
  void onInit() {
    startDate = endDate;
    dropDownList = getTypes()!;
    getContracts();
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });

    getADUserID();
    //adUserId = GetStorage().read('userId');
  }

  bool get dataAvailable => _dataAvailable.value;
  MPMaintainContractJSON get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 3) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getContracts();
  }

  Future<void> getADUserID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse(
        'http://' + ip + '/api/v1/models/ad_user?\$filter= IsSupportUser eq Y');
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
    } else {
      print(response.body);
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

  Future<void> createWorkOrder(int index) async {
    Get.defaultDialog(
      title: 'Create Work Order'.tr,
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: DateTimePicker(
              type: DateTimePickerType.date,
              initialValue: startDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Start Date'.tr,
              icon: const Icon(Icons.event),
              onChanged: (val) {
                startDate = val.substring(0, 10);
                //print(DateTime.parse(val));
                //print(val);
                /* setState(() {
                          dateOrdered = val.substring(0, 10);
                        }); */
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
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: DateTimePicker(
              type: DateTimePickerType.date,
              initialValue: startDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'End Date'.tr,
              icon: const Icon(Icons.event),
              onChanged: (val) {
                endDate = val.substring(0, 10);
                //print(DateTime.parse(val));
                //print(val);
                /* setState(() {
                          dateOrdered = val.substring(0, 10);
                        }); */
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
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: DateTimePicker(
              type: DateTimePickerType.time,
              initialValue: startTime,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              timeLabelText: 'Start Time'.tr,
              //dateLabelText: 'End Date'.tr,
              icon: const Icon(Icons.timer_outlined),
              onChanged: (val) {
                startTime = val;
                //print(startTime);
                print(val);
              },
              validator: (val) {
                //print(val);
                return null;
              },
              // ignore: avoid_print
              onSaved: (val) => print(val),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: DateTimePicker(
              type: DateTimePickerType.time,
              initialValue: endTime,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              timeLabelText: 'End Time'.tr,
              //dateLabelText: 'End Date'.tr,
              icon: const Icon(Icons.timer_outlined),
              onChanged: (val) {
                endTime = val;
                //print(DateTime.parse(val));
                print(val);
                /* setState(() {
                          dateOrdered = val.substring(0, 10);
                        }); */
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
        ],
      ),
      onCancel: () {},
      onConfirm: () async {
        final ip = GetStorage().read('ip');
        String authorization = 'Bearer ' + GetStorage().read('token');
        var msg = jsonEncode({
          "record-id": _trx.records![index].mPMaintainID2,
          "isCreateCalendar": true,
          "DateTrx": startDate,
          "DateTo": endDate,
          "C_DocType_ID": 1000037,
          "StartTime": "$startTime:00Z",
          "EndTime": "$endTime:00Z",
          "AD_User_ID": adUserId,
          "IsAllowCopy": true,

          //"C_DocType_ID": _trx.records![index].litcDocTypeODVID?.id ?? 1000033,
        });

        print(msg);
        final protocol = GetStorage().read('protocol');
        var url = Uri.parse(
            '$protocol://' + ip + '/api/v1/processes/generateworkorder');

        var response = await http.post(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          //print("done!");
          Get.back();
          if (kDebugMode) {
            print(response.body);
          }
          getContracts();
          Get.snackbar(
            "Done!".tr,
            "Sales Order has been created".tr,
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
            "Error!".tr,
            "Sales Order not created".tr,
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> getContracts() async {
    _dataAvailable.value = false;

    var notificationFilter = 0;
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter = Get.arguments['notificationId'];
        Get.arguments['notificationId'] = null;
      }
    }

    //var apiUrlFilter = ["", " and SalesRep_ID eq $adUserId"];
    //var notificationFilter = "";
    /* if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and AD_User_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    } */
    //_dataAvailable.value = false;
    const filename = "maintain";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    //print(response.body);
    _trx = MPMaintainContractJSON.fromJson(jsonDecode(file.readAsStringSync()));
    if (notificationFilter == 0) {
      switch (filterCount) {
        case 1:
          _trx.records!.retainWhere((element) => element.dateNextRun != null
              ? DateTime.parse(element.dateNextRun!).month ==
                  DateTime.now().month
              : false);
          break;
        case 2:
          _trx.records!.retainWhere((element) => element.dateNextRun != null
              ? DateTime.parse(element.dateNextRun!).month ==
                  DateTime.now().month + 1
              : false);
          break;
        default:
      }
    } else {
      _trx.records!.retainWhere((element) => element.id == notificationFilter);
      notificationFilter = 0;
    }

    _dataAvailable.value = _trx != null;

    //print(trx.rowcount);
    //print(response.body);
    // ignore: unnecessary_null_comparison
    //print(_trx.records!.length);
  }

  Future<void> syncMaintain() async {
    _dataAvailable.value = false;
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_mp_maintain_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} and AD_Client_ID eq ${GetStorage().read('clientid')}');

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
      var json = MPMaintainContractJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncMaintainPages(json, index);
      } else {
        const filename = "maintain";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        await file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        getContracts();
        if (kDebugMode) {
          print('Maintain Checked');
        }
        //checkSyncData();
      }
      //syncWorkOrderResourceSurveyLines();

    } else {
      print(response.body);
    }
  }

  syncMaintainPages(MPMaintainContractJSON json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_mp_maintain_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = MPMaintainContractJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncMaintainPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "maintain";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        await file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        //syncWorkOrderTask();
        getContracts();
        if (kDebugMode) {
          print('Maintain Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();

      }
    } else {
      print(response.body);
      //workOrderSync = false;
      //checkSyncData();
    }
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

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

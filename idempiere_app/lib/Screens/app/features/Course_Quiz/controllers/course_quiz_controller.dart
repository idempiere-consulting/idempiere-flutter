part of dashboard;

class CourseQuizController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderResourceSurveyLinesJson _trx;
  //var _hasMailSupport = false;
  late RxList<int> selectedValue;

  late RxList<int> checkValue;

  late RxList<String> dateValue;

  late RxList<String> openAnswerText;

  List<TextEditingController> numberfieldController = [];
  List<TextEditingController> textfieldController = [];

  //final List<TextInputFormatter>? inputFormatters;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();

    getQuiz();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderResourceSurveyLinesJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    //getWorkOrders();
  }

  Future<void> sendQuizLines() async {
    var isConnected = await checkConnection();

    if (isConnected) {
      String ip = GetStorage().read('ip');
      String authorization = 'Bearer ${GetStorage().read('token')}';
      final protocol = GetStorage().read('protocol');

      for (var i = 0; i < _trx.records!.length; i++) {
        switch (_trx.records![i].lITSurveyType?.id) {
          case 'N':
            if (numberfieldController[i].text != "") {
              var url = Uri.parse(
                  '$protocol://$ip/api/v1/models/mp_resource_survey_line/${_trx.records![i].id}');

              var msg = jsonEncode({
                "ValueNumber": numberfieldController[i].text,
              });

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

            break;
          case 'T':
            var url = Uri.parse(
                '$protocol://$ip/api/v1/models/mp_resource_survey_line/${_trx.records![i].id}');

            var msg = jsonEncode({
              "ValueNumber": textfieldController[i].text,
            });

            // ignore: unused_local_variable
            var response = await http.put(
              url,
              body: msg,
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': authorization,
              },
            );
            break;
          case 'D':
            var url = Uri.parse(
                '$protocol://$ip/api/v1/models/mp_resource_survey_line/${_trx.records![i].id}');

            var msg = jsonEncode({
              "DateValue": dateValue[i],
            });

            // ignore: unused_local_variable
            var response = await http.put(
              url,
              body: msg,
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': authorization,
              },
            );
            break;
          case 'M':
            var url = Uri.parse(
                '$protocol://$ip/api/v1/models/mp_resource_survey_line/${_trx.records![i].id}');

            var msg = jsonEncode({
              "ValueNumber": selectedValue[i].toString(),
            });

            // ignore: unused_local_variable
            var response = await http.put(
              url,
              body: msg,
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': authorization,
              },
            );
            break;
          case 'Y':
            if (checkValue[i] != 2) {
              var url = Uri.parse(
                  '$protocol://$ip/api/v1/models/mp_resource_survey_line/${_trx.records![i].id}');

              var msg = jsonEncode({
                "ValueNumber": checkValue[i] == 1 ? "Y" : "N",
              });

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

            break;
          default:
        }
      }
      Get.back();
      Get.snackbar(
        "Done!".tr,
        "You've completed the Quiz".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.done_all,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Error!".tr,
        "Internet connection unavailable".tr,
        isDismissible: true,
        icon: const Icon(
          Icons.wifi_off_outlined,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> getQuiz() async {
    var isConnected = await checkConnection();

    //print(isConnected);

    if (isConnected) {
      emptyAPICallStak();
      _dataAvailable.value = false;
      String ip = GetStorage().read('ip');
      String authorization = 'Bearer ${GetStorage().read('token')}';
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse(
          '$protocol://$ip/api/v1/models/mp_resource_survey?\$filter= MP_Maintain_Resource_ID eq ${Get.arguments["id"]} and LIT_SurveyCategory eq \'SU\' and AD_Client_ID eq ${GetStorage().read('clientid')}');

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
        getQuizLines(json["records"][0]["id"]);
        //GetStorage().write('workOrderSync', response.body);
        //isWorkOrderSyncing.value = false;
      }
    } else {
      Get.snackbar(
        "No internet connection!".tr,
        "Failed to update records.".tr,
        icon: const Icon(
          Icons.signal_wifi_connected_no_internet_4,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> getQuizLines(int identifier) async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey_line?\$filter= mp_resource_survey_ID eq $identifier and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      _trx = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      selectedValue = RxList<int>.filled(_trx.records!.length, 0);
      checkValue = RxList<int>.filled(_trx.records!.length, 2);
      dateValue = RxList<String>.filled(_trx.records!.length, "");
      openAnswerText = RxList<String>.filled(_trx.records!.length, "");
      numberfieldController =
          List.generate(_trx.records!.length, (i) => TextEditingController());
      textfieldController =
          List.generate(_trx.records!.length, (i) => TextEditingController());

      _dataAvailable.value = true;
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
      projectName: "iDempiere APPP",
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

class Provider extends GetConnect {
  Future<void> getLeads() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    //print(authorization);
    //String clientid = GetStorage().read('clientid');
    /* final response = await get(
      'http://' + ip + '/api/v1/windows/lead',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    } */

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/lead');
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
      //print(json['window-records'][0]);
      return json;
    } else {
      return Future.error(response.body);
    }
  }
}

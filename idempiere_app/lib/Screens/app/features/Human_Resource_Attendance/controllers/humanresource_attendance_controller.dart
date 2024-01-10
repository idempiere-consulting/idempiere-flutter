part of dashboard;

class HumanResourceAttendanceController extends GetxController {
  DateTime today = DateTime.now();
  var employeePresenceAvailable = false.obs;

  EmployeePresenceJSON employeePresence = EmployeePresenceJSON(records: []);

  int employeeLatenesses = 0;

  int employeeNonAttendances = 0;

  var organizationId = "".obs;

  int userId = 0;

  TextEditingController userSearchFieldController = TextEditingController();

  var dropdownValue =
      "${Get.arguments != null ? Get.arguments['presenceValue'] : "0"}".obs;

  var dateRangeDropdownValue = "0".obs;

  var dateRangeDropdownList = [];

  List<Types> dropDownList = [];

  final presence = {
    "types": [
      {"id": "0", "name": "All(singular)".tr},
      {"id": "ABSENT".tr, "name": "ABSENCES".tr},
      {"id": "ATTENDED".tr, "name": "RITARDO/ANOMALIA".tr},
    ]
  };

  final dateRange = {
    "types": [
      {"id": "0", "name": "All".tr},
      {"id": "1".tr, "name": "Last Month".tr},
      {"id": "2".tr, "name": "Last Week".tr},
      {"id": "3".tr, "name": "Yesterday".tr},
      {"id": "4".tr, "name": "Today".tr},
    ]
  };

  Map<String, String> dateRangeFilter = {};

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(presence);

    return dJson.types;
  }

  List<Types>? getDateRange() {
    var dJson = TypeJson.fromJson(dateRange);

    return dJson.types;
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    dateRangeDropdownList = getDateRange()!;
    super.onInit();
    dateRangeFilter.addAll({
      "0": "",
      "1":
          " and day ge '${DateFormat('yyyy-MM-dd').format(today.subtract(const Duration(days: 30)))}'",
      "2":
          " and day ge '${DateFormat('yyyy-MM-dd').format(today.subtract(const Duration(days: 7)))}'",
      "3":
          " and day eq '${DateFormat('yyyy-MM-dd').format(today.subtract(const Duration(days: 1)))}'",
      "4": " and day ge '${DateFormat('yyyy-MM-dd').format(today)}'",
    });
  }

  Future<void> getEmployeesPresence() async {
    employeePresenceAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_empl_presence_v');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      employeePresence = EmployeePresenceJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in employeePresence.records!) {
        if (element.presente == 'ASSENTE') {
          employeeNonAttendances++;
        }
        if (element.presente == 'PRESENTE' && (element.qty ?? 0) < 8) {
          employeeLatenesses++;
        }
      }
      employeePresenceAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<List<Records>> getAllOrgs() async {
    List<Records> list = [];
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_org?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //_trx = LeadJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var json = OrganizationJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      list = json.records!;
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
    }
    return list;
  }

  Future<List<CRecords>> getAllEmployees() async {
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
      projectName: "Risorse Umane",
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

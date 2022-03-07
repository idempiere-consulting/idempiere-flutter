part of dashboard;

class SettingsController extends GetxController {
  var isBusinessPartnerSync = true.obs;
  var isProductSync = true.obs;
  var isjpTODOSync = true.obs;
  var isWorkOrderSync = true.obs;
  var isBusinessPartnerSyncing = false.obs;
  var isProductSyncing = false.obs;
  var isjpTODOSyncing = false.obs;
  var isWorkOrderSyncing = false.obs;
  var isWorkOrderSurveyLinesSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    isBusinessPartnerSync.value =
        GetStorage().read('isBusinessPartnerSync') ?? true;
    isProductSync.value = GetStorage().read('isProductSync') ?? true;
    isjpTODOSync.value = GetStorage().read('isjpTODOSync') ?? true;
    isWorkOrderSync.value = GetStorage().read('isWorkOrderSync') ?? true;
  }

  Future<void> reSyncAll() async {
    if (isjpTODOSync.value == true) {
      isjpTODOSyncing.value = true;
      syncJPTODO();
    }
    if (isBusinessPartnerSync.value == true) {
      isBusinessPartnerSyncing.value = true;
      syncBusinessPartner();
    }
    if (isProductSync.value == true) {
      isProductSyncing.value = true;
      syncProduct();
    }
    if (isWorkOrderSync.value == true) {
      isWorkOrderSyncing.value = true;
      syncWorkOrder();
    }
  }

  syncJPTODO() async {
    var now = DateTime.now();
    DateTime fiftyDaysAgo = now.subtract(const Duration(days: 60));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/jp_todo?\$filter= JP_ToDo_Type eq \'S\' and AD_User_ID eq ${GetStorage().read('userId')} and Created ge \'$formattedFiftyDaysAgo\' and Created le \'$formattedDate 23:59:59\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage().write('jpTODOSync', response.body);
      isjpTODOSyncing.value = false;
    }
  }

  Future<void> syncBusinessPartner() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('businessPartnerSync', response.body);
      isBusinessPartnerSyncing.value = false;
    }
  }

  Future<void> syncProduct() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('productSync', response.body);
      isProductSyncing.value = false;
    }
  }

  Future<void> syncWorkOrder() async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_mp_ot_v?\$filter= mp_ot_ad_user_id eq $userId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('workOrderSync', response.body);
      //isWorkOrderSyncing.value = false;
      syncWorkOrderResource();
    }
  }

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/lit_mp_maintain_resource_v');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('workOrderResourceSync', response.body);
      syncWorkOrderResourceSurveyLines();
    }
  }

  Future<void> syncWorkOrderResourceSurveyLines() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/LIT_SurveySheetsLine');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      GetStorage().write('workOrderResourceSurveyLinesSync', response.body);
      isWorkOrderSyncing.value = false;
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

class Provider extends GetConnect {
  Future<void> getLeads() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
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
    var url = Uri.parse('$protocol://' + ip + '/api/v1/windows/lead');
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

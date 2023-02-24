part of dashboard;

class PortalMpMaintenanceMpController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late LitMaintainJson _trx;
  late MPMaintainResourcesJson _trx1;
  var _hasCallSupport = false;
  //var _hasMailSupport = false;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;

  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  // ignore: prefer_final_fields
  var _dataAvailable1 = false.obs;
  // ignore: prefer_final_fields
  var _selectedMaintenanceCard = 10000.obs;
  // ignore: prefer_final_fields
  var _selectedResourceCard = 10000.obs;
  // ignore: prefer_final_fields
  var _showResourceDetails = false.obs;
  // ignore: prefer_final_fields
  var _selectedMaintainID = 0.obs;

  @override
  void onInit() {
    maintenanceDropDownList = getMaintenanceTypes()!;
    resourcesDropDownList = getResourcesTypes()!;
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });
  }

  bool get dataAvailable => _dataAvailable.value;
  bool get dataAvailable1 => _dataAvailable1.value;

  int get selectedMaintenanceCard => _selectedMaintenanceCard.value;
  set selectedMaintenanceCard(index) => _selectedMaintenanceCard.value = index;

  int get selectedResourceCard => _selectedResourceCard.value;
  set selectedResourceCard(index) => _selectedResourceCard.value = index;

  LitMaintainJson get trxMaintain => _trx;
  MPMaintainResourcesJson get trxResources => _trx1;

  bool get showResourceDetails => _showResourceDetails.value;
  set showResourceDetails(show) => _showResourceDetails.value = show;

  int get selectedMaintainID => _selectedMaintainID.value;
  set selectedMaintainID(id) => _selectedMaintainID.value = id;

  //maintenance filter
  late List<Types> maintenanceDropDownList;
  var maintenanceDropdownValue = "1".obs;
  var maintenanceSearchFieldController = TextEditingController();
  var maintenanceSearchFilterValue = "".obs;

  //resources filter
  //filter
  late List<Types> resourcesDropDownList;
  var resourcesDropdownValue = "1".obs;
  var resourcesSearchFieldController = TextEditingController();
  var resourcesSearchFilterValue = "".obs;

  final maintenanceJson = {
    "types": [
      {"id": "1", "name": "DocumentNo".tr},
      {"id": "2", "name": "Billing Partner".tr},
      {"id": "3", "name": "ContractNo".tr},
    ]
  };

  List<Types>? getMaintenanceTypes() {
    var dJson = TypeJson.fromJson(maintenanceJson);

    return dJson.types;
  }

  final resourcesJson = {
    "types": [
      {"id": "1", "name": "Product".tr},
      {"id": "2", "name": "Location".tr},
      {"id": "3", "name": "Code/Position".tr},
    ]
  };

  List<Types>? getResourcesTypes() {
    var dJson = TypeJson.fromJson(resourcesJson);

    return dJson.types;
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
  }

/*   Future<void> getMPMaintain() async {
    await getBusinessPartner();
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/MP_Maintain?\$filter= C_BPartner_ID eq $businessPartnerId ');//mp_ot_ad_user_id eq $userId 

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //_trx = MPMaintainJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } else {
      _dataAvailable1.value = false;
    }
  } */

  Future<void> getMPMaintain() async {
    _dataAvailable.value = false;
    await getBusinessPartner();
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_maintain_bploc_v?\$filter= C_BPartner_ID eq $businessPartnerId'); //?\$filter= C_BPartner_ID eq $businessPartnerId

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _trx =
          LitMaintainJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx.records!.isNotEmpty;
    } else {
      _dataAvailable.value = false;
    }
  }

  Future<void> getResources() async {
    _dataAvailable1.value = false;
    var maintainId = _selectedMaintainID;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/MP_Maintain_Resource?\$filter= MP_Maintain_ID eq $maintainId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _trx1 = MPMaintainResourcesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      _dataAvailable1.value = _trx1.records!.isNotEmpty;
    } else {
      _dataAvailable1.value = false;
      //print(response.body);
    }
  }

  Future<void> getBusinessPartner() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
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

      businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
      //getTickets();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
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

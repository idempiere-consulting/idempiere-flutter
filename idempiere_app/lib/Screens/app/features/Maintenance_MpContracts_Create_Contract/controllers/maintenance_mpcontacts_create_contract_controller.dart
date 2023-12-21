part of dashboard;

class MaintenanceMpContractsCreateContractController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  //late MPMaintainContractJSON _trx;
  //var _hasMailSupport = false;
  late ProductListJson _trx;

  List<ProductCheckout> productList = [];

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var filterCount = 0.obs;
  var counter = 0.obs;
  var total = 0.0.obs;
  int businessPartnerId = 0;
  int technicianId = 0;
  String date = DateTime.now().toString().substring(0, 10);
  var businessPartnerName = "".obs;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  var nameFieldController = TextEditingController();
  var ivaFieldController = TextEditingController();
  var addressFieldController = TextEditingController();
  var technicianFieldController =
      TextEditingController(text: GetStorage().read('user'));

  var filters = [
    "1. Business Partner",
    "2. Date and Technician",
    "3. Checkout",
    "4. Payment",
    "5. idk"
  ];

  final json = {
    "types": [
      {"id": "1", "name": "Business Partner"},
      {"id": "2", "name": "N° Doc"},
      {"id": "3", "name": "Phone N°"},
    ]
  };

  updateCounter() {
    counter.value = productList.length;
  }

  updateTotal() {
    num tot = 0;
    if (productList.isNotEmpty) {
      for (var i = 0; i < productList.length; i++) {
        tot = tot + (productList[i].cost * productList[i].qty);
      }
    }

    total.value = double.parse(tot.toString());
  }

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  Future<void> createMaintainContract() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    // ignore: unused_local_variable
    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_BPartner_ID": {"id": businessPartnerId},
      "DateNextRun": {"id": date},
      "AD_User_ID": {"id": technicianId},
    });

    var url =
        Uri.parse('$protocol://$ip/api/v1/windows/preventive-maintenance/');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      //print(response.body);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    super.onInit();
    getProductLists();

    //getContracts();
    //getADUserID();
    //adUserId = GetStorage().read('userId');
  }

  changeFilterPlus() {
    if (filterCount.value < 3) {
      switch (filterCount.value) {
        case 0:
          filterCount.value++;
          value.value = filters[filterCount.value];

          break;
        case 2:
          filterCount.value++;
          value.value = filters[filterCount.value];

          break;
        default:
          filterCount.value++;
          value.value = filters[filterCount.value];
          break;
      }

      /* filterCount.value++;
      value.value = filters[filterCount.value]; */
    }
    //print(object);

    //value.value = filters[filterCount];
  }

  changeFilterMinus() {
    if (filterCount.value > 0) {
      filterCount.value--;
      value.value = filters[filterCount.value];
    }

    //value.value = filters[filterCount];
  }

  get displayStringForOption => _displayStringForOption;
  get displayTechStringForOption => _displayTechStringForOption;

  static String _displayStringForOption(BPRecords option) => option.name!;
  static String _displayTechStringForOption(CRecords option) => option.name!;

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  getBusinessPartner() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      nameFieldController.text = json.records![0].name!;
      ivaFieldController.text = (json.records![0].litTaxID) ?? "";
      getBusinessPartnerLocation();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  getBusinessPartnerLocation() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner_location?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerLocationJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      addressFieldController.text =
          json.records![0].cLocationID?.identifier ?? "";
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<List<CRecords>> getAllTechnicians() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user');
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

  Future<void> getProductLists() async {
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list_v?\$filter= PriceStd neq null and IsSelfService eq Y and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      /* if (kDebugMode) {
        print(response.body);
      } */
      _trx =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  bool get dataAvailable => _dataAvailable.value;
  //String get value => _value.toString();

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

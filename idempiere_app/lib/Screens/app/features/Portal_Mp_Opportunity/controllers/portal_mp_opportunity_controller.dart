part of dashboard;

class PortalMpOpportunityController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late OpportunityJson _trx;

  late SalesStageJson _salesStage;

  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  // ignore: prefer_final_fields
  var _selectedCard = 0.obs;

  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerName;

  // ignore: prefer_final_fields
  var _showOpportunityDetails  = false.obs;

  // ignore: prefer_final_fields
  var _image64 = "".obs;
  // ignore: prefer_final_fields
  TextEditingController _imageName = TextEditingController();

  // ignore: prefer_final_fields
  var _newOpportunity = false.obs;

  // ignore: prefer_final_fields
  var _userNotListed = false.obs;

  // ignore: prefer_final_fields
  String _userDropDownValue = GetStorage().read('userId').toString();

  var opportunitySearchFieldController = TextEditingController();
  var opportunitySearchFilterValue = "".obs;
  late List<Types> opportunityDropDownList;
  var opportunityDropdownValue = "1".obs;
  final opportunityJson = {
    "types": [
      {"id": "1", "name": "DocumentNo".tr},
      {"id": "2", "name": "Request Date".tr},
    ]
  };

  // ignore: prefer_final_fields
  List<TextEditingController> _opportunityFields =  List.generate(10, (i) => TextEditingController());

  List<Types>? getTypes(json) {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  @override
  void onInit() {
    opportunityDropDownList = getTypes(opportunityJson)!;
    super.onInit();
    getOpportunities();
  }

  bool get dataAvailable => _dataAvailable.value;
  OpportunityJson get trxOpportunity => _trx;
  SalesStageJson get trxSalesStage => _salesStage;

  int get selectedCard => _selectedCard.value;
  set selectedCard(index) => _selectedCard.value = index;

  List<TextEditingController> get opportunityFields => _opportunityFields;

  bool get showOpportunityDetails => _showOpportunityDetails.value;
  set showOpportunityDetails(show) => _showOpportunityDetails.value = show;

  bool get newOpportunity => _newOpportunity.value;
  set newOpportunity(newOp) => _newOpportunity.value = newOp;

  bool get userNotListed => _userNotListed.value;
  set userNotListed(listed) => _userNotListed.value = listed;

  String get userDropDownValue => _userDropDownValue;
  set userDropDownValue(user) => _userDropDownValue = user;

  String get image64 => _image64.value;
  set image64(data) => _image64.value = data;
  TextEditingController get imageName => _imageName;
  set imageName(value) => _imageName.text = value;

  Future<void> getBusinessPartner() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/ad_user?\$filter= Name eq \'$name\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      GetStorage().write('BusinessPartnerName',
          json["records"][0]["C_BPartner_ID"]["identifier"]);
      GetStorage().write(
          'BusinessPartnerId', json["records"][0]["C_BPartner_ID"]["id"]);

      businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
      businessPartnerName = json["records"][0]["C_BPartner_ID"]["identifier"];
    } else {
      //print(response.body);
    }
  }

  Future<List<AdRecords>> getAdUsers() async {
    await getBusinessPartner();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/ad_user?\$filter= C_BPartner_ID eq $businessPartnerId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //_adUsers = PortalMPAdUserJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var json = PortalMPAdUserJson.fromJson(jsonDecode(response.body));
      return json.records!;
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<void> getOpportunities() async {
    await getBusinessPartner();
    _dataAvailable.value = false;
    _showOpportunityDetails.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/c_opportunity?\$filter= C_BPartner_ID eq $businessPartnerId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx =
          OpportunityJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      _dataAvailable.value = _trx.records!.isNotEmpty;
    }
  }

  Future<void> getSalesStage() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/c_salesstage?\$filter= Probability eq 0');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _salesStage = SalesStageJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      //print(response.body);
    }
  }

  getExpectedCloseDate(){
    DateTime now = DateTime.now();
    int currentMonth = int.parse(DateFormat('MM').format(now));
    int year = int.parse(DateFormat('yyyy').format(now));
    int closingMonth = (currentMonth + 1) % 12;

    if(closingMonth < currentMonth) {
      year = year + 1;
    }
    //get last day of month
    int day = int.parse(DateFormat('dd').format(DateTime(year, closingMonth +1, 0)));
    String expectedCloseDate = DateFormat('yyyy-MM-dd').format(DateTime(year, closingMonth, day));
    return expectedCloseDate;
  }

  attachImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    if (result != null) {
      _image64.value = base64.encode(result.files.first.bytes!);
      _imageName.text = result.files.first.name;
    }
  }

  initFieldsController(index, newOpportunity) async{
    if(businessPartnerId == null) await getBusinessPartner();
    await getSalesStage();

    var expectedCloseDate = getExpectedCloseDate();
    if(_opportunityFields.length != 9){
      for (int i = 1; i < 10; i++) {_opportunityFields.add(TextEditingController());}
    }

    getSalesStage();
    if(newOpportunity){
      _opportunityFields[0].text = businessPartnerName;
      _opportunityFields[1].text = _salesStage.records![0].name ?? "";
      _opportunityFields[2].text = expectedCloseDate;
      _opportunityFields[3].text = '';
      _opportunityFields[4].text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _opportunityFields[5].text = '';
      _opportunityFields[6].text = GetStorage().read('user') as String;
      _opportunityFields[7].text = '';
      _opportunityFields[8].text = '';
      _opportunityFields[9].text = '';
    } else{
      _opportunityFields[0].text = _trx.records![index].cBPartnerID?.identifier ?? '';
      _opportunityFields[1].text = _trx.records![index].cSalesStageID?.identifier ?? '';
      _opportunityFields[2].text = _trx.records![index].expectedCloseDate ?? '';
      _opportunityFields[3].text = _trx.records![index].comments ?? '';
      _opportunityFields[4].text = _trx.records![index].created!.split('T')[0];
      _opportunityFields[5].text = _trx.records![index].description ?? '';
      _opportunityFields[6].text = GetStorage().read('user');
      _opportunityFields[7].text = _trx.records![index].note ?? '';
      _opportunityFields[8].text = _trx.records![index].phone ?? '';
      _opportunityFields[9].text = _trx.records![index].email ?? '';
      _showOpportunityDetails.value = true;
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

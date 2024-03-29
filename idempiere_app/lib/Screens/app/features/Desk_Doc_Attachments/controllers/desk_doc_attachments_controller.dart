part of dashboard;

class DeskDocAttachmentsController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late DocAttachmentsJSON _trx;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  var businessPartnerFilter =
      GetStorage().read('DocAttachments_businessPartnerFilter') ?? "";
  var docNoFilter = GetStorage().read('DocAttachments_docNoFilter') ?? "";
  var docTypeFilter = GetStorage().read('DocAttachments_docTypeFilter') ?? "";

  var businessPartnerId = 0.obs;
  String businessPartnerName = "";
  var docNoValue = "".obs;
  var docTypeId = "0".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  //DESKTOP VIEW VARIABLES

  int selectedHeaderId = 0;
  int selectedHeaderIndex = 0;

  DocAttachmentsJSON _trxDesktop = DocAttachmentsJSON(records: []);

  AttachmentJSON _attachmentsDesktop = AttachmentJSON(attachments: []);

  ContractLineJSON _trxDesktopLines = ContractLineJSON(records: []);

  var desktopDocNosearchFieldController = TextEditingController();

  TextEditingController desktopDocNoFieldController = TextEditingController();
  TextEditingController desktopDocTypeFieldController = TextEditingController();
  TextEditingController desktopBusinessPartnerFieldController =
      TextEditingController();
  TextEditingController desktopNameFieldController = TextEditingController();
  TextEditingController desktopDescriptionFieldController =
      TextEditingController();
  TextEditingController desktopDateFromFieldController =
      TextEditingController();
  TextEditingController desktopDateToFieldController = TextEditingController();
  TextEditingController desktopFrequencyFieldController =
      TextEditingController();

  TextEditingController desktopParticipantNameFieldController =
      TextEditingController();
  TextEditingController desktopParticipantSurnameFieldController =
      TextEditingController();
  TextEditingController desktopParticipantBirthPlaceFieldController =
      TextEditingController();
  TextEditingController desktopParticipantBirthDateFieldController =
      TextEditingController();
  TextEditingController desktopParticipantEmailFieldController =
      TextEditingController();
  TextEditingController desktopParticipantRoleFieldController =
      TextEditingController();
  TextEditingController desktopParticipantNationalIDNumberFieldController =
      TextEditingController();
  var desktopIsConfirmedCheckBox = false.obs;

  var desktopSelectedMaintainID = 0.obs;

  List<DataRow> headerRows = [];

  List<DataRow> lineRows = [];
  // ignore: prefer_final_fields
  // ignore: prefer_final_fields
  var _desktopDataAvailable = false.obs;

  var desktopPagesCount = 1.obs;
  var desktopPagesTot = 1.obs;
  var desktopLinePagesCount = 1.obs;
  var desktopLinePagesTot = 1.obs;

  var showHeader = true.obs;
  var headerDataAvailable = false.obs;
  var participantsDataAvailable = false.obs;

  var showLines = false.obs;
  var linesDataAvailable = false.obs;

  var selectedDocumentId = 0.obs;
  var selectedDocumentTable = "".obs;

  var desktopDocTypeId = "0".obs;

  //END DESKTOP VIEW VARIABLES

  final json = {
    "types": [
      {"id": "0", "name": "All".tr},
      {"id": "MP_Maintain", "name": "MP_Maintain".tr},
      {"id": "MP_OT", "name": "MP_OT".tr},
      {"id": "C_Order", "name": "C_Order".tr},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    super.onInit();
    businessPartnerName =
        GetStorage().read('DocAttachments_businessPartnerName') ?? "";
    businessPartnerId.value =
        GetStorage().read('DocAttachments_businessPartnerId') ?? 0;
    docNoValue.value = GetStorage().read('DocAttachments_docNo') ?? "";
    docTypeId.value = GetStorage().read('DocAttachments_docTypeId') ?? "0";

    getDocs();
    getDocsDesktop();
  }

  bool get dataAvailable => _dataAvailable.value;
  DocAttachmentsJSON get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getDocs();
  }

  attachFile(int index) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    if (result != null) {
      //File file = File(result.files.first.bytes!);
      sendAttachedFile(result, index);
      //print(image64);
      //print(imageName);
    }
  }

  sendAttachedFile(FilePickerResult? result, int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final msg = jsonEncode({
      "name": result!.files.first.name,
      "data": base64.encode(result.files.first.bytes!)
    });

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/${_trx.records![index].name}/${_trx.records![index].recordID}/attachments');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      getDocs();
    } else {
      print(response.body);
    }
  }

  Future<void> getADUserID() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= Name eq \'$name\'');
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
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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

  Future<void> getDocs() async {
    _dataAvailable.value = false;

    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and C_Contract_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    // ignore: unused_local_variable
    var searchFilter = "";
    if (searchFieldController.text != "" && dropdownValue.value == "1") {
      searchFilter = "and DocumentNo contains ${searchFieldController.text}";
    }
    //var userFilters = [];

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_docdms_v?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}$notificationFilter$businessPartnerFilter$docNoFilter$docTypeFilter&\$skip=${(pagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      _trx = DocAttachmentsJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;
      //print(trx.records!.length);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  // DESKTOP FUNCTIONS

  Future<void> getDocsDesktop() async {
    _desktopDataAvailable.value = false;
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and MP_Maintain_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    // ignore: unused_local_variable
    var searchFilter = "";
    if (desktopDocNosearchFieldController.text != "") {
      searchFilter =
          " and contains(DocumentNo,'${desktopDocNosearchFieldController.text}')";
    }

    var dropDownFilter = "";
    if (desktopDocTypeId.value != "0") {
      searchFilter = " and Name eq '${desktopDocTypeId.value}'";
    }

    //var userFilters = [];

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_docdms_v?\$filter=  AD_Client_ID eq ${GetStorage().read("clientid")}$notificationFilter$searchFilter$dropDownFilter&\$skip=${(desktopPagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        //C_BPartner_ID eq $businessPartnerId and
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _trxDesktop = DocAttachmentsJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      desktopPagesTot.value = _trxDesktop.pagecount!;

      headerRows = [];

      for (var i = 0; i < _trxDesktop.records!.length; i++) {
        headerRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(Text(_trxDesktop.records![i].name ?? ''), onTap: () {}),
          DataCell(Text(_trxDesktop.records![i].documentNo ?? '??'), onTap: () {
            selectedDocumentId.value = _trxDesktop.records![i].recordID!;
            selectedDocumentTable.value = _trxDesktop.records![i].name!;
            getAttachmentsDesktop();
          }),
          DataCell(Text(_trxDesktop.records![i].cBPartnerID?.identifier ?? ''),
              onTap: () {}),
        ]));
      }
      //print(trx.records!.length);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _desktopDataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAttachmentsDesktop() async {
    participantsDataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/$selectedDocumentTable/$selectedDocumentId/attachments');
    var response = await http.get(
      url,
      headers: <String, String>{
        //C_BPartner_ID eq $businessPartnerId and
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      _attachmentsDesktop =
          AttachmentJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      participantsDataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  desktopAttachFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    if (result != null) {
      //File file = File(result.files.first.bytes!);
      desktopSendAttachedFile(result);
      //print(image64);
      //print(imageName);
    }
  }

  desktopSendAttachedFile(FilePickerResult? result) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final msg = jsonEncode({
      "name": result!.files.first.name,
      "data": base64.encode(result.files.first.bytes!)
    });

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/$selectedDocumentTable/$selectedDocumentId/attachments');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      getDocs();
    } else {
      print(response.body);
    }
  }

  desktopDeleteAttachedFile(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/$selectedDocumentTable/$selectedDocumentId/attachments/${_attachmentsDesktop.attachments![index].name}');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      getAttachmentsDesktop();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getContractLineDesktop() async {
    linesDataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_ContractLine?\$filter= C_Contract_ID eq $selectedHeaderId and  AD_Client_ID eq ${GetStorage().read("clientid")}&\$skip=${(desktopLinePagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trxDesktopLines = ContractLineJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      desktopLinePagesTot.value = _trxDesktopLines.pagecount!;

      lineRows = [];

      for (var i = 0; i < _trxDesktopLines.records!.length; i++) {
        lineRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Text(_trxDesktopLines.records![i].name ?? '??'),
          ),
          DataCell(Text(
              _trxDesktopLines.records![i].durationUnit?.identifier ?? '??')),
          DataCell(
            Text((_trxDesktopLines.records![i].qty ?? '??').toString()),
          ),
          DataCell(
            Text((_trxDesktopLines.records![i].amount ?? '??').toString()),
          ),
        ]));
      }

      linesDataAvailable.value = true;
    } else {
      //print(response.body);
    }
  }

  // END DESKTOP FUNCTIONS

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
      projectName: "Desk".tr,
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

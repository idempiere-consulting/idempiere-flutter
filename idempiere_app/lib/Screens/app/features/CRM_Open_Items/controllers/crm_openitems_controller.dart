// ignore_for_file: prefer_final_fields

part of dashboard;

class CRMOpenItemsController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  var _dataAvailable = false.obs;
  var _hasCallSupport = false;
  //var _hasMailSupport = false;
  var businessPartnerName = "".obs;
  var businessPartnerId = 0.obs;
  var orgName = "".obs;
  var orgId = 0.obs;
  var args = Get.arguments;
  var opentot = 0.0.obs;
  var tot = 0.0.obs;
  var currency = "".obs;

  OpenItemJson _trx = OpenItemJson();

  // ignore: prefer_typing_uninitialized_variables

  @override
  void onInit() {
    super.onInit();
    if (args != null) {
      businessPartnerId.value = args["bpId"] ?? 0;
      businessPartnerName.value = args["bpName"] ?? "";
    }
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });
    //getADUserID();
  }

  //String get value => _value.toString();

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

  Future<List<BPRecords>> getAllBPs() async {
    if (args != null) {
      businessPartnerId.value = args["bpId"] ?? 0;
      businessPartnerName.value = args["bpName"] ?? "";
    }

    final List<dynamic> list = GetStorage().read('permission');

    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    if (int.parse(list[14], radix: 16)
            .toRadixString(2)
            .padLeft(4, "0")
            .toString()[7] !=
        "1") {
      jsonbps.records!.removeWhere(
          (element) => element.salesRepID?.id != GetStorage().read('userId'));
    }

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
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

  static String _displayStringForOption(BPRecords option) => option.name!;
  get displayStringForOption => _displayStringForOption;

  static String _displayStringOrgForOption(Records option) => option.name!;
  get displayStringOrgForOption => _displayStringOrgForOption;

  getOpenItem() async {
    _dataAvailable.value = false;
    opentot.value = 0.0;
    tot.value = 0.0;
    var filter = "";
    filter = orgId.value != 0
        ? "C_BPartner_ID eq $businessPartnerId and AD_Org_ID eq $orgId and AD_Client_ID eq ${GetStorage().read('clientid')}"
        : "C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}";

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_openitem_v?\$filter= $filter');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      var json =
          OpenItemJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        getOpenItemPages(json, index, filter);
      } else {
        for (var record in json.records!) {
          opentot.value += record.openAmt!;
          tot.value = record.grandTotal!;
          currency.value = record.cCurrencyID!.identifier!;
        }
        _trx = json;
        _dataAvailable.value = true;
      }

      //print(json.records![0].chargeAmt);
      //_trx = LeadJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  getOpenItemPages(OpenItemJson json, int index, String filter) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_openitem_v?\$filter= $filter&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson =
          OpenItemJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        getOpenItemPages(json, index, filter);
      } else {
        for (var record in json.records!) {
          opentot.value += record.openAmt!;
          tot.value = record.grandTotal!;
          currency.value = record.cCurrencyID!.identifier!;
        }
        _trx = json;
        _dataAvailable.value = true;
        //checkSyncData();
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
      projectName: "CRM",
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

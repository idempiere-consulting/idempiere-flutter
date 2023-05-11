part of dashboard;

class PurchaseLeadController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late LeadJson _trx;
  SalesStageJson salestages = SalesStageJson(records: []);
  bool saleStagesAvailable = false;
  TextEditingController amtFieldController = TextEditingController(text: "0");
  var saleStageValue = 0;
  var _hasCallSupport = false;
  //var _hasMailSupport = false;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  var userFilter = "";
  var sectorFilter = "";
  var nameFilter = "";
  var mailFilter = "";
  var phoneFilter = "";
  var statusFilter = "";
  var sizeFilter = "";
  var campaignFilter = "";
  var sourceFilter = "";

  var sectorId = "0".obs;
  var selectedUserRadioTile = 0.obs;
  var nameValue = "".obs;
  var mailValue = "".obs;
  var phoneValue = "".obs;
  var statusId = "0".obs;
  var sizeId = "0".obs;
  var campaignId = "0".obs;
  var sourceId = "0".obs;

  final json = {
    "types": [
      {"id": "1", "name": "Name".tr},
      {"id": "2", "name": "Mail"},
      {"id": "3", "name": "Phone N°"},
      {"id": "4", "name": "Lead Status".tr},
      {"id": "5", "name": "Sector".tr},
      {"id": "6", "name": "Lead Size".tr},
      {"id": "7", "name": "Campaign".tr},
      {"id": "8", "name": "Lead Source".tr},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  getAllSaleStages() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/C_SalesStage');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      salestages = SalesStageJson.fromJson(jsonDecode(response.body));

      saleStagesAvailable = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load sale stages");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  static String _displayStringForOption(SSRecords option) => option.name!;

  convertLead(int index) {
    Get.defaultDialog(
        title: 'Create Opportunity'.tr,
        content: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sale Stage".tr,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.all(10),
              child: Autocomplete<SSRecords>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<SSRecords>.empty();
                  }
                  return salestages.records!.where((SSRecords option) {
                    return option.name!
                        .toString()
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (SSRecords selection) {
                  //debugPrint(
                  //'You just selected ${_displayStringForOption(selection)}');
                  saleStageValue = selection.id!;

                  //print(salesrepValue);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: amtFieldController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                  labelText: 'Opportunity Amount',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                ],
              ),
            ),
          ],
        ),
        onCancel: () {},
        onConfirm: () async {
          final ip = GetStorage().read('ip');
          String authorization = 'Bearer ${GetStorage().read('token')}';
          var msg = jsonEncode({
            "record-id": _trx.windowrecords![index].id,
            "CreateOpportunity": true,
            "C_SalesStage_ID": saleStageValue,
            "OpportunityAmt": double.parse(amtFieldController.text),
            "AD_User_ID": _trx.windowrecords![index].id,
            //"C_DocType_ID": _trx.records![index].litcDocTypeODVID?.id ?? 1000033,
          });

          //print(msg);
          final protocol = GetStorage().read('protocol');
          var url =
              Uri.parse('$protocol://$ip/api/v1/processes/aduserconvertlead');

          //print(url);

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
        });
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });

    getLeads();
    getAllSaleStages();
    //getADUserID();
    adUserId = GetStorage().read('userId');
  }

  bool get dataAvailable => _dataAvailable.value;
  LeadJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getLeads();
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

  Future<void> getLeads() async {
    _dataAvailable.value = false;
    /* var apiUrlFilter = ["", " and SalesRep_ID eq $adUserId"];
    var searchUrlFilter = "";

    switch (dropdownValue.value) {
      case "1":
        searchUrlFilter = " and contains(Name,'${searchFieldController.text}')";

        break;
      case "2":
        searchUrlFilter =
            " and contains(EMail,'${searchFieldController.text}')";
        break;
      case "3":
        searchUrlFilter =
            " and contains(Phone,'${searchFieldController.text}')";
        break;
      case "4":
        searchUrlFilter = " and LeadStatus eq '${leadStatusValue.value}'";
        break;
      case "5":
        searchUrlFilter =
            " and lit_IndustrySector_ID eq ${leadSectorValue.value}";
        break;
      case "6":
        searchUrlFilter = " and lit_LeadSize_ID eq ${leadSizeValue.value}";
        break;
      case "7":
        searchUrlFilter = " and C_Campaign_ID eq ${leadCampaignValue.value}";
        break;
      case "8":
        searchUrlFilter = " and LeadSource eq ${leadSourceValue.value}";
        break;
      default:
    } */

    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and AD_User_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_lead_v?\$filter= IsVendorLead eq Y and AD_Client_ID eq ${GetStorage().read('clientid')}$nameFilter$mailFilter$phoneFilter$userFilter$sectorFilter$statusFilter$sizeFilter$campaignFilter$sourceFilter&\$skip=${(pagesCount.value - 1) * 100}');
    //print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);

      _trx = LeadJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;
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

  createPhoneCallActivity(int id) async {
    var now = DateTime.now();

    var hourTime = "00";

    var minuteTime = "00";

    if (now.hour < 10) {
      hourTime = "0${now.hour}";
    } else {
      hourTime = "${now.hour}";
    }

    if (now.minute < 10) {
      minuteTime = "0${now.minute}";
    } else {
      minuteTime = "${now.minute}";
    }

    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(now);
    var startTime = '$hourTime:$minuteTime:00Z';
    /* var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "ContactActivityType": {"id": "PC"},
      "Description": 'phone call',
      "AD_User_ID": {"id": id},
      "StartDate": "${date}T$startTime",
    }; */

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"id": GetStorage().read('userId')},
      "Name": "Phone Call".tr,
      "Description": '$date $hourTime:$minuteTime - ${"Phone Call".tr}',
      "Qty": 0.5,
      //"C_BPartner_ID": {"id": businessPartnerId},
      "JP_ToDo_ScheduledStartDate": "${date}T$startTime",
      "JP_ToDo_ScheduledEndDate": "${date}T$startTime",
      "JP_ToDo_ScheduledStartTime": startTime,
      "JP_ToDo_ScheduledEndTime": startTime,
      "JP_ToDo_Status": {"id": 'CO'},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "T"},
      "LIT_Ad_User_Lead_ID": {"id": id},
      //"C_Project_ID": {"id": projectId}
    };

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo');
    /* var response = await */ http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    /* if (response.statusCode == 201) {
      print(response.body);
    } else {
      print(response.body);
    } */
  }

  createEmailActivity(int id) async {
    var now = DateTime.now();

    var hourTime = "00";

    var minuteTime = "00";

    if (now.hour < 10) {
      hourTime = "0${now.hour}";
    } else {
      hourTime = "${now.hour}";
    }

    if (now.minute < 10) {
      minuteTime = "0${now.minute}";
    } else {
      minuteTime = "${now.minute}";
    }

    var formatter = DateFormat('yyyy-MM-dd');
    var date = formatter.format(now);
    var startTime = '$hourTime:$minuteTime:00Z';
    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "AD_User_ID": {"id": GetStorage().read('userId')},
      "Name": "Email".tr,
      "Description": '$date $hourTime:$minuteTime - ${"Email".tr}',
      "Qty": 0.5,
      //"C_BPartner_ID": {"id": businessPartnerId},
      "JP_ToDo_ScheduledStartDate": "${date}T$startTime",
      "JP_ToDo_ScheduledEndDate": "${date}T$startTime",
      "JP_ToDo_ScheduledStartTime": startTime,
      "JP_ToDo_ScheduledEndTime": startTime,
      "JP_ToDo_Status": {"id": 'CO'},
      "IsOpenToDoJP": true,
      "JP_ToDo_Type": {"id": "T"},
      "LIT_Ad_User_Lead_ID": {"id": id},
      //"C_Project_ID": {"id": projectId}
    };

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/C_ContactActivity');
    /* var response = await */ http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    /* if (response.statusCode == 201) {
      print(response.body);
    } else {
      print(response.body);
    } */
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

part of dashboard;

class PortalMpHoursReviewController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  HoursReviewJSON _trx = HoursReviewJSON(records: []);
  var _hasCallSupport = false;
  //var _hasMailSupport = false;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  var businessPartnerId = 0.obs;

  var totalHours = 0.0.obs;
  var invoicedHours = 0.0.obs;

  //DESKTOP VARIABLES
  List<DataRow> headerRows = [];

  TextEditingController desktopsearchFieldController = TextEditingController();

  //END DESKTOP VARIABLES

  @override
  void onInit() {
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });

    getBusinessPartner();
    adUserId = GetStorage().read('userId');
  }

  bool get dataAvailable => _dataAvailable.value;
  HoursReviewJSON get trx => _trx;
  //String get value => _value.toString();

  Future<void> getBusinessPartner() async {
    final protocol = GetStorage().read('protocol');
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
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

      GetStorage().write('BusinessPartnerName',
          json["records"][0]["C_BPartner_ID"]["identifier"]);
      GetStorage().write(
          'BusinessPartnerId', json["records"][0]["C_BPartner_ID"]["id"]);

      businessPartnerId.value = json["records"][0]["C_BPartner_ID"]["id"];
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
    getHours();
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

  Future<void> getHours() async {
    _dataAvailable.value = false;
    DateTime today = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
    String formattedThirtyDaysAgo = formatter.format(thirtyDaysAgo);
    String formattedToday = formatter.format(today);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_customer_hours_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')} and AssignDateFrom ge \'$formattedThirtyDaysAgo 00:00:00\' and C_BPartner_ID eq ${businessPartnerId.value}&\$skip=${(pagesCount.value - 1) * 100}');
    //print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      _trx =
          HoursReviewJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;
      invoicedHours.value = 0.0;
      totalHours.value = 0.0;

      for (var element in _trx.records!) {
        if (!element.isDoNotInvoice!) {
          invoicedHours.value += (element.qty ?? 0).toDouble();
        }

        totalHours.value += (element.qty ?? 0).toDouble();
      }

      headerRows = [];

      for (var i = 0; i < _trx.records!.length; i++) {
        headerRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Tooltip(
                    message: (_trx.records![i].isDoNotInvoice ?? true)
                        ? 'Support'.tr
                        : 'Invoiced'.tr,
                    child: Icon(
                      Icons.info,
                      color: (_trx.records![i].isDoNotInvoice ?? true)
                          ? kNotifColor
                          : Colors.deepOrange,
                    ),
                  ),
                ),
                Visibility(
                  visible: _trx.records![i].documentNo != null,
                  child: Expanded(
                    child: Text(
                        "${_trx.records![i].documentNo} ${DateFormat('dd/MM/yyyy').format(DateTime.tryParse(_trx.records![i].dateticket ?? "") ?? DateTime.now())}"),
                  ),
                ),
              ],
            ),
          ),
          DataCell(Text(_trx.records![i].name ?? "N/A")),
          DataCell(Text(_trx.records![i].description ?? "N/A")),
          DataCell(Text((_trx.records![i].qty ?? 0.0).toString())),
        ]));
      }

      _dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> openRecordInfo(int index) async {}

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

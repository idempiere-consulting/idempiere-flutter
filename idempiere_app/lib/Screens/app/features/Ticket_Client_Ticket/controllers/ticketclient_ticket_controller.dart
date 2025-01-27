part of dashboard;

class TicketClientTicketController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late TicketsJson _trx;
  TicketTypeJson _tt = TicketTypeJson(records: []);
  var _hasCallSupport = false;

  String dropdownValue = "";
  //var _hasMailSupport = false;
  String ticketFilter = "";

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;
  // ignore: prefer_typing_uninitialized_variables
  var closedTicketId;

  var confirmCheckBoxValue = false.obs;

  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  //DESKTOP VIEW VARIABLES

  int selectedHeaderId = 0;
  int selectedHeaderIndex = 0;

  TicketsJson _trxDesktop = TicketsJson(records: []);

  EventJson _trxDesktopLines = EventJson(records: []);

  var desktopDocNosearchFieldController = TextEditingController();

  TextEditingController desktopDocNoFieldController = TextEditingController();
  TextEditingController desktopDocTypeFieldController = TextEditingController();
  TextEditingController desktopAssignedToFieldController =
      TextEditingController();
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

  List<DataRow> headerRows = [];

  List<DataRow> lineRows = [];
  var requestId = 0;
  // ignore: prefer_final_fields
  // ignore: prefer_final_fields
  var _desktopDataAvailable = false.obs;

  var desktopPagesCount = 1.obs;
  var desktopPagesTot = 1.obs;
  var desktopLinePagesCount = 1.obs;
  var desktopLinePagesTot = 1.obs;

  var showHeader = true.obs;
  var headerDataAvailable = false.obs;

  var showLines = false.obs;
  var linesDataAvailable = false.obs;

  //END DESKTOP VIEW VARIABLES

  @override
  void onInit() {
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });
    getTicketTypes();
    getClosedTicketsID();
    //getAllticketTypeID();
    //getBusinessPartner();
    //getTickets();
    //getADUserID();
    adUserId = GetStorage().read('userId');
    //getBusinessPartner();
  }

  bool get dataAvailable => _dataAvailable.value;
  TicketsJson get trx => _trx;
  TicketTypeJson get tt => _tt;
  //String get value => _value.toString();

  String quickFilterDropdownValue = "0";
  String quickFilterString = "";

  setQuickFilterValue(String value) {
    quickFilterDropdownValue = value;
    print(quickFilterDropdownValue);

    switch (quickFilterDropdownValue) {
      case "0":
        quickFilterString = "";
        break;
      case "1":
        quickFilterString =
            " and (R_Status_ID neq 1000024 or R_Status_ID neq 1000030)";
        break;
      default:
    }
    getTickets();
    getTicketsDesktop();
  }

  Future<void> confirmTicket(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "R_Status_ID": {"id": 1000042},
      "IsConfirmed": true,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/r_request/${_trx.records![index].id}');

    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      getTickets();
      getTicketsDesktop();
      //print("done!");
      //completeOrder(index);
    } else {
      //print(response.body);
      Get.snackbar(
        "Errore!",
        "Il Ticket non è stato confermato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  getAllticketTypeID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/R_RequestType?\$filter= Description eq \'TK\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          TicketTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < json.rowcount!; i++) {
        ticketFilter =
            ticketFilter + "R_RequestType_ID eq ${json.records![i].id}";

        if (i != json.rowcount! - 1) {
          ticketFilter = ticketFilter + " OR ";
        }
      }
      //print(ticketFilter);
      getTickets();
      getTicketsDesktop();
    }
  }

  getTicketAttachment(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/r_request/${trx.records![index].id}/attachments/ticketimage.jpg');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var image64 = base64.encode(response.bodyBytes);
      Get.to(const TicketInternalImage(), arguments: {"base64": image64});
    }
  }

  openTicketType() {
    Get.defaultDialog(
      title: "Ticket Type".tr,
      //middleText: "Choose the type of Ticket you want to create",
      //contentPadding: const EdgeInsets.all(2.0),
      content: DropdownButton(
        value: dropdownValue,
        style: const TextStyle(fontSize: 12.0),
        elevation: 16,
        onChanged: (String? newValue) {
          dropdownValue = newValue!;
          Get.back();
          Get.to(const CreateTicketClientTicket(),
              arguments: {"id": dropdownValue});
        },
        items: _tt.records!.map((list) {
          return DropdownMenuItem<String>(
            value: list.id.toString(),
            child: Text(
              list.name.toString(),
            ),
          );
        }).toList(),
      ),
      barrierDismissible: true,
      /* textCancel: "Cancel",
        textConfirm: "Confirm",
        onConfirm: () {
          Get.back();
          Get.to(const CreateTicketClientTicket(),
              arguments: {"id": dropdownValue});
        } */
    );
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getTickets();
  }

  Future<void> getBusinessPartner() async {
    final protocol = GetStorage().read('protocol');
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('$protocol://' +
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
      getAllticketTypeID();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<void> getClosedTicketsID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/R_Status?\$filter= Value eq \'CLOSE99\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      closedTicketId = json["records"][0]["id"];
      getBusinessPartner();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<void> getTicketTypes() async {
    //var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/R_RequestType?\$filter=startswith(LIT_RequestSubType,\'TK\') and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //var json = jsonDecode(response.body);
      _tt =
          TicketTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      dropdownValue = _tt.records![0].id.toString();

      //businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
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

  Future<void> getTickets() async {
    DateTime today = DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(Duration(days: 50));
    var apiUrlFilter = ["", " and AD_User_ID eq $adUserId"];
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and R_Request_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    /* print('$protocol://' +
        ip +
        '/api/v1/models/r_request?\$filter= R_Status_ID neq $closedTicketId and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}${apiUrlFilter[filterCount]}$notificationFilter and ($ticketFilter)'); */
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/r_request?\$filter= (R_Status_ID neq $closedTicketId or StartDate ge \'${DateFormat('yyyy-MM-dd').format(fiftyDaysAgo)}\') and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}${apiUrlFilter[filterCount]}$notificationFilter and ($ticketFilter)&\$skip=${(pagesCount.value - 1) * 100}&\$orderby= Created desc, DocumentNo desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx = TicketsJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
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

  Future<void> getTicketsDesktop() async {
    _desktopDataAvailable.value = false;
    DateTime today = DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(Duration(days: 50));
    var apiUrlFilter = ["", " and AD_User_ID eq $adUserId"];
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and R_Request_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    /* print('$protocol://' +
        ip +
        '/api/v1/models/r_request?\$filter= R_Status_ID neq $closedTicketId and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}${apiUrlFilter[filterCount]}$notificationFilter and ($ticketFilter)'); */
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/r_request?\$filter= (R_Status_ID neq $closedTicketId or StartDate ge \'${DateFormat('yyyy-MM-dd').format(fiftyDaysAgo)}\') and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}${apiUrlFilter[filterCount]}$notificationFilter and ($ticketFilter)&\$skip=${(desktopPagesCount.value - 1) * 100}&\$orderby= Created desc, DocumentNo desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trxDesktop =
          TicketsJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      desktopPagesTot.value = _trxDesktop.pagecount!;

      headerRows = [];

      for (var i = 0; i < _trxDesktop.records!.length; i++) {
        headerRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Row(
              children: [
                Visibility(
                  visible: _trxDesktop.records![i].rStatusID!.identifier!
                      .contains('CONF'),
                  child: IconButton(
                    tooltip: 'Pending Confirm'.tr,
                    icon: const Icon(
                      Icons.pending_actions,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      confirmCheckBoxValue.value = false;
                      Get.defaultDialog(
                        title: 'Pending Confirm'.tr,
                        textConfirm: 'Proceed'.tr,
                        onCancel: () {},
                        onConfirm: () {
                          if (confirmCheckBoxValue.value == true) {
                            confirmTicket(i);
                            Get.back();
                          }
                        },
                        content: Column(
                          children: [
                            Visibility(
                              visible: _trxDesktop.records![i].cOrderID != null,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 3,
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: _trx
                                          .records![i].cOrderID?.identifier),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.text_fields),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Sales Order'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  _trxDesktop.records![i].mProductID != null &&
                                      _trxDesktop.records![i].cOrderID == null,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 3,
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: _trxDesktop
                                          .records![i].mProductID?.identifier),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.text_fields),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Product'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  _trxDesktop.records![i].mProductID != null &&
                                      _trxDesktop.records![i].cOrderID == null,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 3,
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: _trxDesktop.records![i].requestAmt
                                          .toString()),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.text_fields),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Amount'.tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            Obx(
                              () => CheckboxListTile(
                                title: Text('Confirm Pending Action'.tr),
                                value: confirmCheckBoxValue.value,
                                activeColor: kPrimaryColor,
                                onChanged: (bool? value) {
                                  confirmCheckBoxValue.value = value!;
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    _trxDesktop.records![i].rStatusID?.identifier ?? '??',
                    style: TextStyle(
                        color: _trxDesktop.records![i].rStatusID?.id! == 1000024
                            ? kNotifColor
                            : _trxDesktop.records![i].rStatusID?.id! == 1000030
                                ? Colors.grey
                                : Colors.yellow),
                  ),
                ),
              ],
            ),
          ),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    requestId = _trxDesktop.records![i].id!;
                    selectedHeaderId = _trxDesktop.records![i].id!;
                    selectedHeaderIndex = i;

                    desktopDocNoFieldController.text =
                        _trxDesktop.records![i].documentNo ?? '??';

                    desktopNameFieldController.text =
                        _trxDesktop.records![i].name ?? '??';

                    desktopDocTypeFieldController.text =
                        _trxDesktop.records![i].rStatusID?.identifier ?? "";
                    desktopAssignedToFieldController.text =
                        _trxDesktop.records![i].salesRepID?.identifier ?? "N/A";

                    desktopDateFromFieldController.text =
                        DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(_trxDesktop.records![i].created!));

                    desktopDescriptionFieldController.text =
                        _trxDesktop.records![i].summary ?? "";

                    showHeader.value = false;
                    showLines.value = true;
                    getTicketLineDesktop();
                  },
                  icon: const Icon(EvaIcons.search)),
              Expanded(
                child: Text(
                    "${_trxDesktop.records![i].documentNo} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_trxDesktop.records![i].created!))}"),
              )
            ],
          )),
          DataCell(
            Text(_trxDesktop.records![i].summary ?? '??'),
          ),
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

  Future<void> getTicketLineDesktop() async {
    linesDataAvailable.value = false;
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/jp_todo?\$filter= R_Request_ID eq $requestId and AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= JP_ToDo_ScheduledStartDate desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      _trxDesktopLines =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      lineRows = [];

      desktopLinePagesTot.value = _trxDesktopLines.pagecount!;

      for (var i = 0; i < _trxDesktopLines.records!.length; i++) {
        lineRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Text(_trxDesktopLines.records![i].name ?? '??'),
          ),
          DataCell(Text(_trxDesktopLines.records![i].description ?? '??')),
          DataCell(
            Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(
                _trxDesktopLines.records![i].jPToDoScheduledStartDate!))),
          ),
        ]));
      }
    }

    linesDataAvailable.value = true;
  }

  checkcloseTicket(int id) {
    Get.defaultDialog(
        title: "Close Ticket".tr,
        middleText: "Are you sure you want to close the Ticket?".tr,
        //contentPadding: const EdgeInsets.all(2.0),
        barrierDismissible: true,
        textCancel: "Cancel",
        textConfirm: "Confirm",
        onConfirm: () {
          Get.back();
          closeTicket(id);
        });
  }

  Future<void> closeTicket(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "R_Status_ID": 1000030,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/r_request/$id');

    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      getTickets();
      //print("done!");
      //completeOrder(index);
    } else {
      //print(response.body);
      Get.snackbar(
        "Errore!",
        "Il Ticket non è stato chiuso",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

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

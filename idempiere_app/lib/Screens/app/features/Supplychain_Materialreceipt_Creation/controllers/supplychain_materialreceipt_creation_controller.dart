part of dashboard;

class SupplychainMaterialreceiptCreationController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  var currentStep = 1.obs;

  int documentTypeId = 0;

  late BusinessPartnerLocationJson bpLocation;

  var bpLocationAvailable = false.obs;

  var bpLocationId = '0'.obs;

  late SalesOrderDefaultsJson defValues;

  late int businessPartnerId;
  late TextEditingController bpSearchFieldController;
  late TextEditingController documentDateFieldController;
  late TextEditingController docNoFieldController;

  late TextEditingController pOrderdocNoSearchFieldController;
  var pOrderDocNoSearch = "".obs;

  var orderListAvailable = false.obs;

  MaterialReceiptPurchaseOrderJSON orderList =
      MaterialReceiptPurchaseOrderJSON(records: []);

  SalesOrderLineJson orderLineList = SalesOrderLineJson(records: []);

  @override
  void onInit() {
    super.onInit();
    bpSearchFieldController = TextEditingController();
    documentDateFieldController = TextEditingController();
    docNoFieldController = TextEditingController();
    pOrderdocNoSearchFieldController = TextEditingController();
    getMaterialReceiptDocType();
    //getPurchaseOrders();
  }

  Future<void> getLocationFromBP() async {
    bpLocationAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      bpLocation = BusinessPartnerLocationJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (bpLocation.rowcount! > 0) {
        if (bpLocation.records![0].id != null) {
          bpLocationId.value = bpLocation.records![0].id.toString();
        }
      }
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      bpLocationAvailable.value = true;
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getSalesOrderDefaultValues() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_order_defaults_v?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
    if (businessPartnerId != 0) {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //print(response.body);
        defValues = SalesOrderDefaultsJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        //getPriceListVersionID();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
  }

  Future<void> createMaterialReceipt() async {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var date = inputFormat.parse(documentDateFieldController.text);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/material-receipt');

    List<Map<String, Object>> list = [];

    for (var element in orderLineList.records!) {
      list.add({
        "C_OrderLine_ID": {"id": element.id},
        "QtyEntered": element.qtyRegistered!.toInt(),
        "C_ProjectPhase_ID": {"id": -1},
        "C_Activity_ID": {"id": -1},
        "C_Campaign_ID": {"id": -1},
        "User1_ID": {"id": -1},
        "User2_ID": {"id": -1},
        "C_Project_ID": {"id": -1},
        "Lot": element.lotNo ?? '',
      });
    }

    //print(url.toString());
    // physical-inventory/conteggio-inventario-if00/tabs/
    // physical-inventory/tabs/inventory-count/1000008/
    // inventory-count-line/
    // 1000008
    // 1000159
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_DocType_ID": {"id": documentTypeId},
      "DateDoc": DateFormat('yyyy-MM-dd').format(date),
      "MovementDate": DateFormat('yyyy-MM-dd').format(date),
      "DateAcct": DateFormat('yyyy-MM-dd').format(date),
      "C_BPartner_ID": businessPartnerId,
      "C_BPartner_Location_ID": {"id": int.parse(bpLocationId.value)},
      "PriorityRule": "5",
      "MovementType": {"id": 'V+'},
      "DocumentNo": docNoFieldController.text,
      "FreightCostRule": defValues.records![0].freightCostRule!.id,
      "receipt-line".tr: list,
    });
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      if (kDebugMode) {
        print(response.body);
      }
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      Get.snackbar(
        "${json["DocumentNo"]}",
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  getMaterialReceiptDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= LIT_DocType_DynamicVal eq null and IsSOTrx eq N and DocBaseType eq \'MMR\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);
      print(response.body);

      var json = DocumentTypeJSON.fromJson(jsondecoded);

      documentTypeId = json.records![0].id ?? 0;
    } else {
      throw Exception("Failed to load doc types");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBPs() async {
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;
  }

  getPurchaseOrders(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$expand=c_orderLine&\$filter= C_BPartner_ID eq $id and IsSoTrx eq N and AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby=DateOrdered desc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      orderList = MaterialReceiptPurchaseOrderJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      orderListAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
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

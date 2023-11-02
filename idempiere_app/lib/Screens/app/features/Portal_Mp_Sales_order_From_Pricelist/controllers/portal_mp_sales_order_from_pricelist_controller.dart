part of dashboard;

class PortalMpSalesOrderFromPriceListController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  var args = Get.arguments;
  int priceListID = 0;
  int bpLocationId = 0;
  int paymentTermId = 0;
  String paymentRuleId = "";
  int docTypeId = 0;
  PriceListJson _trx = PriceListJson(records: []);
  late SalesOrderDefaultsJson defValues;
  late BusinessPartnerLocationJson bpLocation;
  List<ProductCheckout2> productList = [];

  var allProdToggle = false.obs;

  var counter = 0.obs;
  var total = 0.0.obs;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  var searchFieldController = TextEditingController();
  var qtyFieldController = TextEditingController(text: '0');
  var qtyMinFieldController = TextEditingController(text: '0');
  var qtyMultiplierController = TextEditingController(text: '1');
  var descriptionFieldController = TextEditingController(text: '');

  var valueFilter = "";
  var nameFilter = "";
  var descriptionFilter = "";

  var value = "".obs;
  var name = "".obs;
  var description = "".obs;

  var isListShown = true.obs;
  var dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPriceListID();
    getLocationFromBP();
    getBPValues();
    getDocType();
  }

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

  Future<void> getPriceListID() async {
    final protocol = GetStorage().read('protocol');
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= C_BPartner_ID eq ${args["businessPartnerId"]} and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerJson.fromJson(jsonDecode(response.body));

      if (json.records![0].mPriceListID != null) {
        priceListID = json.records![0].mPriceListID!.id!;
        getPriceList();
      }

      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      print(response.body);
    }
  }

  Future<void> getPriceList() async {
    dataAvailable.value = false;
    if (searchFieldController.text != "") {
      pagesCount.value = 1;
      nameFilter =
          " and contains(tolower(Name),'${searchFieldController.text}')";
    } else {
      nameFilter = "";
    }
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_pricelist_v?\$filter= ((M_PriceList_ID eq $priceListID and C_BPartner_ID eq ${args["businessPartnerId"]} or Value eq \'.\') ${allProdToggle.value ? 'or pricelist_description eq \'Listino Generale\'' : ''}) and AD_Client_ID eq ${GetStorage().read("clientid")}$nameFilter&\$skip=${(pagesCount.value - 1) * 100}&\$orderby= Name');
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
      _trx =
          PriceListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPriceListByName() async {
    dataAvailable.value = false;

    if (searchFieldController.text != "") {
      pagesCount.value = 1;
      nameFilter =
          " and contains(tolower(Name),'${searchFieldController.text}')";
    } else {
      nameFilter = "";
    }
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_pricelist_v?\$filter= ((M_PriceList_ID eq $priceListID and C_BPartner_ID eq ${args["businessPartnerId"]} or Value eq \'.\') ${allProdToggle.value ? 'or pricelist_description eq \'Listino Generale\'' : ''}) and AD_Client_ID eq ${GetStorage().read("clientid")}$nameFilter&\$skip=${(pagesCount.value - 1) * 100}&\$orderby= Name');
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
      _trx =
          PriceListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pagesTot.value = _trx.pagecount!;
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> createSalesOrder() async {
    Get.back();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/sales-order');

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //print(formattedDate);
    List<Map<String, Object>> list = [];

    for (var element in productList) {
      var json = {
        "M_Product_ID": {"id": element.id},
        "qtyEntered": element.qty,
      };
      if (element.description != null) {
        json.addAll({"Description": element.description!});
      }
      list.add(json);
    }

    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_BPartner_ID": {"id": args["businessPartnerId"]},
      "C_BPartner_Location_ID": {"id": bpLocationId},
      "Bill_BPartner_ID": {"id": args["businessPartnerId"]},
      "Bill_Location_ID": {"id": defValues.records![0].cBPartnerLocationID!.id},
      "Revision": defValues.records![0].revision,
      "AD_User_ID": defValues.records![0].aDUserID!.id,
      "Bill_User_ID": defValues.records![0].billUserID!.id,
      "C_DocTypeTarget_ID": {"id": docTypeId},
      "DateOrdered": "${formattedDate}T00:00:00Z",
      "DatePromised": "${formattedDate}T00:00:00Z",
      "LIT_Revision_Date": "${formattedDate}T00:00:00Z",
      "DeliveryRule": defValues.records![0].deliveryRule!.id,
      "DeliveryViaRule": defValues.records![0].deliveryViaRule!.id,
      "FreightCostRule": defValues.records![0].freightCostRule!.id,
      "PriorityRule": defValues.records![0].priorityRule!.id,
      "InvoiceRule": defValues.records![0].invoiceRule!.id,
      "M_PriceList_ID": defValues.records![0].mPriceListID!.id,
      "SalesRep_ID": defValues.records![0].salesRepID!.id,
      "C_Currency_ID": defValues.records![0].cCurrencyID!.id,
      "C_PaymentTerm_ID": {"id": paymentTermId},
      "PaymentRule": {"id": paymentRuleId},
      "order-line".tr: list,
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
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      Get.back();
      //print("done!");
      Get.snackbar(
        "${json["DocumentNo"]}",
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );

      /* cOrderId = json["id"];
      if (cOrderId != 0) {
        createSalesOrderLine();
      } */
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.snackbar(
          "Error!".tr,
          "Record not updated".tr,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> getSalesOrderDefaultValues() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_order_defaults_v?\$filter= C_BPartner_ID eq ${args["businessPartnerId"]} and AD_Client_ID eq ${GetStorage().read("clientid")}');
    if (args["businessPartnerId"] != 0) {
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

  Future<void> getLocationFromBP() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location?\$filter= C_BPartner_ID eq ${args["businessPartnerId"]} and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
          bpLocationId = bpLocation.records![0].id!;
        }
      }
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getBPValues() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner?\$filter= C_BPartner_ID eq ${args["businessPartnerId"]} and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      var json2 = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      paymentTermId = json2.records![0].cPaymentTermID!.id!;
      paymentRuleId = json2.records![0].paymentRule!.id!;
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= Name eq \'Standard Order\' and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      var json2 = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      docTypeId = json2.records![0].id!;
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
    getSalesOrderDefaultValues();
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

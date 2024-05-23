part of dashboard;

class CRMPOSController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();

  late SalesOrderDefaultsJson defValues;

  TextEditingController fidelityFieldController =
      TextEditingController(text: "");

  int businessPartnerId = 0;
  var bpLocationId = "0".obs;
  var paymentTermId = "0".obs;
  var paymentRuleId = "K".obs;

  ProductListJson _trx = ProductListJson(records: []);

  ProductCategoryJSON prodCategoryList = ProductCategoryJSON(records: []);

  PosButtonLayoutJSON prodCategoryButtonList = PosButtonLayoutJSON(records: []);

  List<String> functionButtonNameList = ['RETURN'.tr, 'PURCH. PRICE'.tr];

  var isReturnButtonActive = false.obs;

  List<DataRow> rows = [];

  List<POSTableRowJSON> productList = [];

  int rowNumber = 0;
  var currentProductName = "".obs;
  var currentProductQuantity = "1".obs;
  var currentProductPrice = 0.0.obs;

  List<TextEditingController> rowQtyFieldController = [];

  List<TextEditingController> totalFieldController = [];

  String quantityCounted = "";

  var totalRows = 0.0.obs;

  var tableAvailable = true.obs;
  var dataAvailable = false.obs;
  var prodCategoryAvailable = false.obs;
  var prodCategoryButtonAvailable = false.obs;

  var cashPayment = false.obs;
  var creditCardPayment = false.obs;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
    getBusinessPartner();
    getDefaultPaymentTermsFromBP();
    getPOSProductCategories();
    getPOSProductCategoryButtonLayout();
  }

  Future<void> getProducts() async {
    dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= PriceStd neq null and AD_Client_ID eq ${GetStorage().read("clientid")}&\$skip=${(pagesCount.value - 1) * 100}');
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

      pagesTot.value = _trx.pagecount!;

      dataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getProductByBarcode(String barcode) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= (Value eq \'$barcode\' or UPC eq \'$barcode\') and PriceStd neq null and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        setCurrentProduct(json.records![0]);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getFidelityCard(String barcode) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= LIT_FidelityCard eq \'$barcode\' and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      print('fidelity');
      var json =
          ContactJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        fidelityFieldController.text = barcode;
        Get.snackbar(
          "Done!".tr,
          "Fidelity Card Added to the Order".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        Get.snackbar(
          "Error".tr,
          "Fidelity Card not found".tr,
          icon: const Icon(
            Icons.warning,
            color: Colors.yellow,
          ),
        );
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getProductByProductCategory(int categoryId) async {
    dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= M_Product_Category_ID eq $categoryId and PriceStd neq null and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      pagesTot.value = _trx.pagecount!;

      dataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getProductBySearchField(String search) async {
    dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        "$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= (contains(tolower(Name),'${search.toLowerCase()}') or contains(tolower(Value),'${search.toLowerCase()}')) and PriceStd neq null and AD_Client_ID eq ${GetStorage().read("clientid")}");
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
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      pagesTot.value = _trx.pagecount!;

      dataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<int> getSelectedProductPurchasePriceListPrice(int prodId) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        "$protocol://$ip/api/v1/models/lit_product_purchase_list_v?\$filter= M_Product_ID eq $prodId and AD_Client_ID eq ${GetStorage().read("clientid")}");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        return (json.records![0].price ?? 0).toInt();
      }
    } else {
      print(response.body);
    }

    return 0;
  }

  setCurrentProduct(PLRecords product) {
    tableAvailable.value = false;
    rowNumber++;

    var rowType = "";
    if (isReturnButtonActive.value) {
      rowType = "R";
    }
    productList.add(POSTableRowJSON.fromJson({
      "number": rowNumber,
      "rowType": rowType,
      "productCode": product.value,
      "productName": product.name,
      "productId": product.id,
      "qty": int.parse(rowType == "R" ? "-1" : "1"),
      "price": product.priceList!.toDouble(),
      "discount": product.discount!.toDouble(),
      "discountedPrice": product.price!.toDouble(),
      "tot":
          double.parse(rowType == "R" ? "-1" : "1") * product.price!.toDouble(),
    }));
    currentProductName.value = product.name!;

    rowQtyFieldController
        .add(TextEditingController(text: rowType == "R" ? "-1" : "1"));
    totalFieldController.add(TextEditingController(
        text: (double.parse(rowType == "R" ? "-1" : "1") *
                product.price!.toDouble())
            .toString()));
    currentProductPrice.value = product.price!.toDouble();
    updateTotal();
    currentProductName.value = product.name ?? "N/A";
    currentProductQuantity.value = "1";

    quantityCounted = "";
    tableAvailable.value = true;
  }

  setCurrentProductQty(String digit) {
    if (digit == "0" && quantityCounted == "") {
    } else {
      quantityCounted += digit;

      currentProductQuantity.value = quantityCounted;
      productList[rowNumber - 1].qty = int.parse(quantityCounted);
      rowQtyFieldController[rowNumber - 1].text =
          productList[rowNumber - 1].rowType == "R"
              ? "-$quantityCounted"
              : quantityCounted;
      totalFieldController[rowNumber - 1].text =
          (double.parse(quantityCounted) *
                  currentProductPrice.value *
                  (productList[rowNumber - 1].rowType == "R" ? -1 : 1))
              .toString();
      productList[rowNumber - 1].tot = double.parse(quantityCounted) *
          currentProductPrice.value *
          (productList[rowNumber - 1].rowType == "R" ? -1 : 1);

      updateTotal();
    }
  }

  deleteCurrentProductQtyDigit() {
    if (quantityCounted.isNotEmpty) {
      quantityCounted =
          quantityCounted.substring(0, quantityCounted.length - 1);

      if (quantityCounted.isNotEmpty) {
        currentProductQuantity.value = quantityCounted;
        productList[rowNumber - 1].qty = int.parse(quantityCounted);
        rowQtyFieldController[rowNumber - 1].text = quantityCounted;
        totalFieldController[rowNumber - 1].text =
            (double.parse(quantityCounted) * currentProductPrice.value)
                .toString();
        productList[rowNumber - 1].tot =
            double.parse(quantityCounted) * currentProductPrice.value;
      } else {
        currentProductQuantity.value = "1";
        rowQtyFieldController[rowNumber - 1].text = "1";
        totalFieldController[rowNumber - 1].text =
            (double.parse(rowQtyFieldController[rowNumber - 1].text) *
                    productList[rowNumber - 1].price!)
                .toString();
        productList[rowNumber - 1].tot =
            double.parse(rowQtyFieldController[rowNumber - 1].text) *
                productList[rowNumber - 1].price!;
      }
    }
    updateTotal();
  }

  updateTotal() {
    double tot = 0.0;
    for (var element in totalFieldController) {
      //print(element.text);
      tot = tot + double.parse(element.text);
    }

    totalRows.value = tot;
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
      list.add({
        "M_Product_ID": {"id": element.productId},
        "qtyEntered": element.qty!
      });
    }
    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_BPartner_ID": {"id": businessPartnerId},
      "C_BPartner_Location_ID": {"id": bpLocationId.value},
      "Bill_BPartner_ID": {"id": businessPartnerId},
      "Bill_Location_ID": {"id": defValues.records![0].cBPartnerLocationID!.id},
      "Revision": defValues.records![0].revision,
      //"AD_User_ID": defValues.records![0].aDUserID!.id,
      //"Bill_User_ID": defValues.records![0].billUserID!.id,
      "C_DocTypeTarget_ID": {"identifier": "Ordine Scontrino"},
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
      "C_PaymentTerm_ID": {"id": int.parse(paymentTermId.value)},
      "PaymentRule": {"id": paymentRuleId.value},
      "LIT_FidelityCard": fidelityFieldController.text,
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

      //Get.find<CRMSalesOrderController>().getSalesOrders();
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

  Future<void> getBusinessPartner() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= Value eq \'Scontrino\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
      try {
        businessPartnerId = json["records"][0]["id"];
      } catch (e) {
        if (kDebugMode) {
          print("no bp");
        }
      }

      getSalesOrderDefaultValues();

      /* try {
        businessPartnerName.value =
            json["records"][0]["C_BPartner_ID"]["identifier"];
      } catch (e) {
        if (kDebugMode) {
          print("no bp");
        }
      } */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getDefaultPaymentTermsFromBP() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.rowcount! > 0) {
        if (json.records![0].cPaymentTermID != null) {
          paymentTermId.value = json.records![0].cPaymentTermID!.id!.toString();
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

  Future<void> getPOSProductCategories() async {
    prodCategoryAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Product_Category?\$filter=  AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      prodCategoryList = ProductCategoryJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      prodCategoryAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPOSProductCategoryButtonLayout() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_POS?\$filter= AD_User_ID eq ${GetStorage().read('userId')} and LIT_POSType eq \'POSF\' and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      var json = PosJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.records![0].cposKeyLayoutID?.id != null) {
        getPOSProductCategoryButtons(json.records![0].cposKeyLayoutID!.id!);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPOSProductCategoryButtons(int id) async {
    prodCategoryButtonAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_POSKey?\$filter= C_POSKeyLayout_ID eq $id and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      prodCategoryButtonList = PosButtonLayoutJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      prodCategoryButtonAvailable.value = true;
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

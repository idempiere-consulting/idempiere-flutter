part of dashboard;

class PortalMpSalesOrderFromPriceListController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late PriceListJson _trx;
  late PaymentTermsJson pTerms;
  late PaymentRuleJson pRules;
  late BusinessPartnerLocationJson bpLocation;
  late SalesOrderDefaultsJson defValues;

  var allProdToggle = false.obs;

  var isWIP = false.obs;
  //var _hasMailSupport = false;
  var prodListAvailable = true.obs;

  var searchFieldController = TextEditingController();
  var qtyFieldController = TextEditingController(text: '0');
  var isQtyModule = true.obs;
  var qtyMinFieldController = TextEditingController(text: '0');
  var qtyMultiplierController = TextEditingController(text: '1');
  var descriptionFieldController = TextEditingController(text: '');
  var priceFieldController = TextEditingController(text: '0.0');
  var discountFieldController = TextEditingController(text: '0.0');
  var discountedPriceFieldController = TextEditingController(text: '0.0');
  var totalRowPriceFieldController = TextEditingController(text: '0.0');

  var addressFieldController = TextEditingController();

  var noteFieldController = TextEditingController();

  TextEditingController bpFieldController = TextEditingController();

  TextEditingController dateStartFieldController = TextEditingController(
      text: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 1))));

  var nameFilter = "";
  // ignore: prefer_typing_uninitialized_variables
  var adUserId;
  var docTypeFlag = false.obs;
  int businessPartnerId = 0;
  int priceListID = 0;
  var bpLocationId = "0".obs;
  var paymentTermId = "0".obs;
  var paymentRuleId = "K".obs;
  var businessPartnerName = "".obs;
  int cOrderId = 0;
  int priceListVersionID = 0;

  List<ProductCheckout2> productList = [];

  var prodCategoryFilterID = "0".obs;
  var litprodCategoryFilterID = "0".obs;

  var counter = 0.obs;

  var total = 0.0.obs;

  var value = "Tutti".obs;

  var filters = [
    "1. BP and Doc Type",
    "2. Products",
    "3. Checkout",
    "4. Payment"
  ];
  var filterCount = 0.obs;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var pTermAvailable = false.obs;

  var pRuleAvailable = false.obs;
  var bpLocationAvailable = false.obs;
  var searchFilterValue = "".obs;

  late List<DTRecords> dropDownList;
  var dropdownValue = "1".obs;

  final json = {
    "types": [
      {"id": "1", "name": "Name"},
      {"id": "2", "name": "Mail"},
      {"id": "3", "name": "Phone N°"},
    ]
  };

  get displayStringForOption => _displayStringForOption;

  updateCounter() {
    counter.value = productList.length;
  }

  updateTotal() {
    num tot = 0;
    if (productList.isNotEmpty) {
      for (var i = 0; i < productList.length; i++) {
        tot = tot +
            ((productList[i].discountedCost ?? productList[i].cost) *
                productList[i].qty);
      }
    }

    total.value = double.parse(tot.toString());
  }

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  changeFilterPlus() {
    if (filterCount.value < 3) {
      switch (filterCount.value) {
        case 0:
          if (businessPartnerId != 0) {
            filterCount.value++;
            value.value = filters[filterCount.value];
          }
          break;
        case 2:
          if (productList.isNotEmpty) {
            filterCount.value++;
            value.value = filters[filterCount.value];
          }
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

  @override
  void onInit() {
    //dropDownList = getTypes()!;
    super.onInit();
    getBusinessPartner();
    //getProductLists();

    //getTabs();
    //getLeads();
    //getADUserID();
    //adUserId = GetStorage().read('userId');
  }

  bool get dataAvailable => _dataAvailable.value;
  PriceListJson get trx => _trx;
  //String get value => _value.toString();

  static String _displayStringForOption(BPRecords option) => option.name!;

  Future<List<PCRecords>> getAllProdCategories() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Product_Category?\$filter= M_Product_Category_Parent_ID eq null and IsSelfService eq Y and AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonsectors = ProductCategoryJSON.fromJson(jsondecoded);

      jsonsectors.records!.insert(0, PCRecords(id: 0, name: 'All'.tr));

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load prod categories");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<PCRecords>> getAllLITProdCategories() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_M_Product_Category?\$filter= M_Product_Category_Parent_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonsectors = ProductCategoryJSON.fromJson(jsondecoded);

      jsonsectors.records!.insert(0, PCRecords(id: 0, name: 'All'.tr));

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load lit prod categories");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getBusinessPartner() async {
    var userId = GetStorage().read("userId");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= AD_User_ID eq $userId and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
        businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
        getSalesOrderDefaultValues();
        getLocationFromBP();
        getPaymentTerms();
        getPaymentRules();
        //getProductLists();
        getDocTypes();
        const filename = "businesspartner";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        var jsondecoded = jsonDecode(file.readAsStringSync());
        var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);
        for (var element in jsonbps.records!) {
          if (element.id == businessPartnerId) {
            priceListID = element.mPriceListID!.id!;
            getProductLists();
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("no bp");
        }
      }

      try {
        businessPartnerName.value =
            json["records"][0]["C_BPartner_ID"]["identifier"];
        bpFieldController.text =
            json["records"][0]["C_BPartner_ID"]["identifier"];
      } catch (e) {
        if (kDebugMode) {
          print("no bp");
        }
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    final List<dynamic> list = GetStorage().read('permission');

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getDocTypes() async {
    docTypeFlag.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= DocBaseType eq \'SOO\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
          DocTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var check = true;
      for (var element in json.records!) {
        //print(element.id);
        if (element.isDefault == true) {
          dropdownValue.value = element.id.toString();
          check = false;
          //print("Dropdown: ${dropdownValue.value}");
        }
      }

      if (check) {
        dropdownValue.value = json.records![0].id.toString();
      }

      dropDownList = json.records!;
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
      docTypeFlag.value = true;
    }
  }

  Future<void> getProductLists() async {
    _dataAvailable.value = false;

    if (searchFieldController.text != "") {
      nameFilter =
          " and (contains(tolower(Name),'${searchFieldController.text}') or contains(tolower(Value),'${searchFieldController.text}'))";
    } else {
      nameFilter = "";
    }
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_pricelist_v?\$filter=  ${allProdToggle.value ? 'pricelist_description eq \'Listino Generale\'' : '(M_PriceList_ID eq $priceListID and C_BPartner_ID eq $businessPartnerId)'} ${prodCategoryFilterID.value != "0" ? "and M_Product_Category_ID eq ${prodCategoryFilterID.value}" : ""} ${litprodCategoryFilterID.value != "0" ? "and LIT_M_Product_Category_ID eq ${litprodCategoryFilterID.value}" : ""} and AD_Client_ID eq ${GetStorage().read("clientid")}$nameFilter&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _trx =
          PriceListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
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

  Future<void> getPriceListByName() async {
    _dataAvailable.value = false;
    if (searchFieldController.text != "") {
      nameFilter =
          " and (contains(tolower(Name),'${searchFieldController.text}') or contains(tolower(Value),'${searchFieldController.text}'))";
    } else {
      nameFilter = "";
    }
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_pricelist_v?\$filter=  ${allProdToggle.value ? 'pricelist_description eq \'Listino Generale\'' : '(M_PriceList_ID eq $priceListID and C_BPartner_ID eq $businessPartnerId)'} ${prodCategoryFilterID.value != "0" ? "and M_Product_Category_ID eq ${prodCategoryFilterID.value}" : ""} ${litprodCategoryFilterID.value != "0" ? "and LIT_M_Product_Category_ID eq ${litprodCategoryFilterID.value}" : ""} and AD_Client_ID eq ${GetStorage().read("clientid")}$nameFilter&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      _trx =
          PriceListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
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

  Future<void> getPaymentTerms() async {
    pTermAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_PaymentTerm?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');
    if (businessPartnerId != 0) {
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
        //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        pTerms = PaymentTermsJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));

        for (var element in pTerms.records!) {
          if (element.isDefault == true) {
            paymentTermId.value = element.id!.toString();
          }
        }
        getDefaultPaymentTermsFromBP();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
  }

  Future<void> getLocationFromBP() async {
    bpLocationAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location?\$filter= IsShipTo eq Y and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
        /* if (bpLocation.records![0].id != null) {
          bpLocationId.value = bpLocation.records![0].id.toString();
          addressFieldController.text =
              bpLocation.records![0].cLocationID?.identifier ?? "N/A";
        } */

        for (var element in bpLocation.records!) {
          if (element.isShipTo == true) {
            bpLocationId.value = element.id.toString();
            addressFieldController.text =
                element.cLocationID?.identifier ?? "N/A";
          }
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
        if (json.records![0].cPaymentRuleID != null) {
          paymentRuleId.value = json.records![0].cPaymentRuleID!.id!;
        }

        if (json.records![0].cDocTypeTargetID != null) {
          dropdownValue.value =
              json.records![0].cDocTypeTargetID!.id!.toString();
        }
      }
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      pTermAvailable.value = true;
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPaymentRules() async {
    pTermAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 195');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pRules =
          PaymentRuleJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pRuleAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPriceListVersionID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_pricelist_version?\$select=M_PriceList_Version_ID&\$orderby=ValidFrom DESC&\$filter=M_PriceList_ID eq ${defValues.records![0].mPriceListID!.id} & ValidFrom le ${Get.arguments["dateOrdered"]}');

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

      priceListVersionID = json["records"][0]["id"];
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  /* Future<void> getTabs() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/windows/sales-order/tabs');

    var response = await http.get(
      url,
      //body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      //var json = jsonDecode(utf8.decode(response.bodyBytes));

      /* cOrderId = json["id"];
      if (cOrderId != 0) {
        createSalesOrderLine();
      } */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  } */

  Future<void> createSalesOrder(BuildContext context) async {
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
        "M_Product_ID": {"id": element.id},
        "qtyEntered": element.qty
      });
    }

    var inputFormat = DateFormat('dd/MM/yyyy');

    var dateMovement = "";

    if (dateStartFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateStartFieldController.text);

        dateMovement = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
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
      "AD_User_ID": defValues.records![0].aDUserID!.id,
      "Bill_User_ID": defValues.records![0].billUserID!.id,
      "C_DocTypeTarget_ID": {"id": int.parse(dropdownValue.value)},
      "DateOrdered": "${formattedDate}T00:00:00Z",
      "Note": noteFieldController.text,
      "DatePromised": "${dateStartFieldController.text}T00:00:00Z",
      "ShipDate": "${dateStartFieldController.text}T07:00:00Z",
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
      "IsSelfService": true,
      "IsLocked": isWIP.value,
      "order-line".tr: list,
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Creating record..".tr),
            ],
          ),
        );
      },
    );

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    Get.back();
    if (response.statusCode == 201) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      Get.find<PortalMpSalesOrderController>().getSalesOrders();
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

  /* Future<void> createSalesOrderLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/windows/sales-order/$cOrderId/tabs/order-line');

    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": productList[0].id},
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
      print(response.body);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
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

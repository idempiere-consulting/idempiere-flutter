part of dashboard;

class CRMPOSController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();

  late SalesOrderDefaultsJson defValues;

  DiscountSchemaBreakJSON discountSchemaBreakJSON =
      DiscountSchemaBreakJSON(records: []);

  int discountSchemaID = 0;

  TextEditingController fidelityFieldController =
      TextEditingController(text: "");

  int businessPartnerId = 0;
  var bpLocationId = "0".obs;
  var paymentTermId = "0".obs;
  var paymentRuleId = "K".obs;

  ProductListJson _trx = ProductListJson(records: []);

  ProductCategoryJSON prodCategoryList = ProductCategoryJSON(records: []);

  PosButtonLayoutJSON prodCategoryButtonList = PosButtonLayoutJSON(records: []);

  List<String> functionButtonNameList = [
    'EXIT'.tr,
    'RETURN'.tr,
    'PURCH. PRICE'.tr,
    'HISTORY'.tr,
    'CLOSING'.tr,
    'ROUNDING'.tr,
    'EDIT UNIT PRICE'.tr,
    "MIXED PAYMENT".tr
  ];

  List<int> roundingList = [1, 5, 10];

  var isReturnButtonActive = false.obs;

  ProductListJson mixedPaymentTypes = ProductListJson(records: []);

  List<TextEditingController> mixedPaymentControllerList = [];

  var isMixedPayment = false.obs;

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

  Future<void> nextCustomer() async {
    tableAvailable.value = false;

    fidelityFieldController.text = "";

    paymentRuleId.value = "K";

    isReturnButtonActive.value = false;

    rows = [];

    productList = [];

    rowNumber = 0;
    currentProductName.value = "";
    currentProductQuantity.value = "1";
    currentProductPrice.value = 0.0;

    discountSchemaBreakJSON = DiscountSchemaBreakJSON(records: []);

    rowQtyFieldController = [];

    totalFieldController = [];

    quantityCounted = "";

    totalRows.value = 0.0;
    discountSchemaID = 0;

    //dataAvailable.value = false;

    cashPayment.value = false;
    creditCardPayment.value = false;

    tableAvailable.value = true;
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
      //print('fidelity');
      var json =
          ContactJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        fidelityFieldController.text = barcode;

        if (json.records![0].mDiscountSchemaID != null) {
          discountSchemaID = json.records![0].mDiscountSchemaID!.id!;
          addDiscountSchema(json.records![0].mDiscountSchemaID!.id!);
        }
        Get.snackbar(
          "Done!".tr,
          "Fidelity Card Added to the Order".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        fidelityFieldController.text = "";
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

  Future<void> addDiscountSchema(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_DiscountSchemaBreak?\$filter= M_DiscountSchema_ID eq $id and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      discountSchemaBreakJSON = DiscountSchemaBreakJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
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

  Future<double> getSelectedProductPurchasePriceListPrice(int prodId) async {
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
        return (json.records![0].price ?? 0).toDouble();
      }
    } else {
      print(response.body);
    }

    return 0;
  }

  Future<void> getMixedPaymentTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        "$protocol://$ip/api/v1/models/C_POSTenderType?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      mixedPaymentTypes =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      mixedPaymentControllerList = List.generate(
          mixedPaymentTypes.records!.length,
          (index) => TextEditingController(text: "0.0"));
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> registerMixedPaymentOption() async {
    paymentRuleId.value = "M";
    cashPayment.value = false;
    creditCardPayment.value = false;
  }

  setCurrentProduct(PLRecords product) {
    tableAvailable.value = false;
    rowNumber++;

    var rowType = "";
    if (isReturnButtonActive.value) {
      rowType = "R";
    }

    double discount = discountSchemaBreakJSON.records!.isNotEmpty
        ? (discountSchemaBreakJSON.records!.where((element) =>
                element.lITDiscountPriceGroupID?.id ==
                product.litDiscountPriceGroupID?.id)).isNotEmpty
            ? (discountSchemaBreakJSON.records!.where((element) =>
                    element.lITDiscountPriceGroupID?.id ==
                    product.litDiscountPriceGroupID?.id))
                .first
                .breakDiscount!
                .toDouble()
            : product.discount!.toDouble()
        : product.discount!.toDouble();
    productList.add(POSTableRowJSON.fromJson({
      "number": rowNumber,
      "rowType": rowType,
      "productCode": product.value,
      "productName": product.name,
      "productId": product.id,
      "qty": int.parse(rowType == "R" ? "-1" : "1"),
      "price": product.priceList!.toDouble(),
      "discount": discount.toDouble(),
      "discountedPrice": product.price!.toDouble() -
          ((product.price!.toDouble() / 100.0) * discount.toDouble()),
      "tot": double.parse(rowType == "R" ? "-1" : "1") *
          (rowType != "R"
              ? product.price!.toDouble() -
                  ((product.price!.toDouble() / 100.0) * discount.toDouble())
              : product.price!.toDouble()),
    }));
    currentProductName.value = product.name!;

    rowQtyFieldController
        .add(TextEditingController(text: rowType == "R" ? "-1" : "1"));
    totalFieldController.add(TextEditingController(
        text: (double.parse(rowType == "R" ? "-1" : "1") *
                (rowType != "R"
                    ? product.price!.toDouble() -
                        ((product.price!.toDouble() / 100.0) *
                            discount.toDouble())
                    : product.price!.toDouble()))
            .toString()));
    currentProductPrice.value = product.price!.toDouble() -
        ((product.price!.toDouble() / 100.0) * discount.toDouble());
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

  Future<int> getpossc01() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Product?\$filter= Value eq \'possc01\' and AD_Client_ID eq ${GetStorage().read("clientid")}');
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

      return json.records![0].id!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      return 0;
    }
  }

  Future<void> roundingDownCaseOne(double roundedTot) async {
    tableAvailable.value = false;
    double tot = totalRows.value;

    double difference = tot - roundedTot;

    // print(difference);

    double qties = 0.0;

    int highestPriceProd = 0;

    double numToDistributeBetweenProds = double.parse(
        (difference / productList.length.toDouble()).toStringAsFixed(2));
    print(numToDistributeBetweenProds);

    for (var i = 0; i < productList.length; i++) {
      if (productList[i].discountedPrice! >=
          productList[highestPriceProd].discountedPrice!) {
        highestPriceProd = i;
      }
    }

    if (productList[highestPriceProd].qty! == 1) {
      productList[highestPriceProd].discountedPrice =
          productList[highestPriceProd].discountedPrice! - difference;
      productList[highestPriceProd].tot =
          productList[highestPriceProd].tot! - difference;
      totalFieldController[highestPriceProd].text =
          (productList[highestPriceProd].discountedPrice! *
                  productList[highestPriceProd].qty!.toDouble())
              .toStringAsFixed(2);
      productList[highestPriceProd].isRounded = true;
    }

    if (productList[highestPriceProd].qty! > 1) {
      productList[highestPriceProd].tot =
          productList[highestPriceProd].tot! - difference;
      productList[highestPriceProd].discountedPrice = double.parse(
          (productList[highestPriceProd].tot! /
                  productList[highestPriceProd].qty!.toDouble())
              .toStringAsFixed(2));
      totalFieldController[highestPriceProd].text =
          (productList[highestPriceProd].discountedPrice! *
                  productList[highestPriceProd].qty!.toDouble())
              .toStringAsFixed(2);

      productList[highestPriceProd].isRounded = true;
      if (productList[highestPriceProd].tot! -
              double.parse(totalFieldController[highestPriceProd].text) >
          0.0) {
        PLRecords rec = PLRecords(
            value: "possc01",
            name: "Arrotondamento",
            id: await getpossc01(),
            priceList: double.parse((productList[highestPriceProd].tot! -
                    double.parse(totalFieldController[highestPriceProd].text))
                .toStringAsFixed(2)),
            price: double.parse((productList[highestPriceProd].tot! -
                    double.parse(totalFieldController[highestPriceProd].text))
                .toStringAsFixed(2)),
            discount: 0.0);

        setCurrentProduct(rec);
      }
    }

    updateTotal();
    Get.back();

    tableAvailable.value = true;
  }

  Future<void> setUnitPrices(
      List<TextEditingController> unitPriceFieldController) async {
    tableAvailable.value = false;
    for (var i = 0; i < unitPriceFieldController.length; i++) {
      productList[i].discountedPrice =
          double.parse(unitPriceFieldController[i].text);
      productList[i].tot = double.parse(
          (productList[i].discountedPrice! * productList[i].qty!.toDouble())
              .toStringAsFixed(2));
      totalFieldController[i].text =
          (productList[i].discountedPrice! * productList[i].qty!.toDouble())
              .toStringAsFixed(2);
      productList[i].isRounded = true;
    }

    updateTotal();

    tableAvailable.value = true;
  }

  Future<void> createSalesOrder() async {
    Get.back();

    var total = 0.0;

    var msg2 =
        '<?xml version="1.0" encoding="utf-8"?><printerFiscalReceipt><beginFiscalReceipt></beginFiscalReceipt><displayText data="Message 1 On customer display "></displayText>';

    for (var element in productList) {
      if (element.qty! > 0) {
        msg2 =
            '$msg2<printRecItem description="${element.productName}" unitPrice="${(element.discountedPrice! * 100).toInt()}"  idVat="B" quantity="${element.qty! * 1000}" ></printRecItem>';
      } else {
        msg2 =
            '$msg2<printRecRefund  description="${element.productName}" unitPrice="${(element.price! * 100).toInt()}"  idVat="B" quantity="${element.qty! * -1000}" ></printRecRefund>';
      }
    }

    msg2 =
        '$msg2<printRecSubtotal></printRecSubtotal><endFiscalReceiptCut></endFiscalReceiptCut></printerFiscalReceipt>';

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/sales-order');

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //print(formattedDate);
    List<Map<String, Object>> list = [];

    List<Map<String, Object>> mixedPaymentList = [];

    for (var element in productList) {
      total = total + (element.qty! * element.discountedPrice!);

      if (element.productCode == "possc01" || element.isRounded == true) {
        list.add({
          "ProductName": element.productName!,
          "M_Product_ID": {"id": element.productId},
          "qtyEntered": element.qty!,
          "PriceList": element.price!,
          "PriceEntered": element.discountedPrice!
        });
      } else {
        list.add({
          "ProductName": element.productName!,
          "M_Product_ID": {"id": element.productId},
          "qtyEntered": element.qty!
        });
      }
    }

    if (paymentRuleId.value == "M") {
      for (var i = 0; i < mixedPaymentTypes.records!.length; i++) {
        if ((double.tryParse(mixedPaymentControllerList[i].text) ?? 0.0) >
            0.0) {
          mixedPaymentList.add({
            "C_POSTenderType_ID": {"id": mixedPaymentTypes.records![0].id},
            "PayAmt": double.parse(mixedPaymentControllerList[i].text),
          });
        }
      }
    }

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_BPartner_ID": {"id": businessPartnerId},
      "C_BPartner_Location_ID": {"id": bpLocationId.value},
      "Bill_BPartner_ID": {"id": businessPartnerId},
      "Bill_Location_ID": {"id": defValues.records![0].cBPartnerLocationID!.id},
      "Revision": defValues.records![0].revision,
      "TextDetails": msg2,
      "TOT": total,
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
      "datascontrino":
          "$formattedDate ${DateFormat('hh:mm:ss').format(DateTime.now())}",
    };

    if (paymentRuleId.value == 'M') {
      msg.addAll({
        "pos-payment".tr: mixedPaymentList,
      });
    }

    if (discountSchemaID != 0) {
      msg.addAll({
        "M_DiscountSchema_ID": {"id": discountSchemaID}
      });
    }

    List<dynamic> poslist = [];
    if (GetStorage().read('posList') == null) {
      poslist.add(jsonEncode(msg));
    } else {
      poslist = GetStorage().read('posList');
      poslist.add(jsonEncode(msg));
    }
    GetStorage().write('posList', poslist);

    GetStorage().write('postCallList', []);

    if (await checkConnection()) {
      var response = await http.post(
        url,
        body: jsonEncode(msg),
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

        nextCustomer();

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
    } else {
      List<dynamic> list = [];
      if (GetStorage().read('postCallList') == null) {
        var call = {
          "offlineid": GetStorage().read('postCallId'),
          "url": '$protocol://$ip/api/v1/windows/sales-order',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
          "C_BPartner_ID": {"id": businessPartnerId},
          "C_BPartner_Location_ID": {"id": bpLocationId.value},
          "Bill_BPartner_ID": {"id": businessPartnerId},
          "Bill_Location_ID": {
            "id": defValues.records![0].cBPartnerLocationID!.id
          },
          "Revision": defValues.records![0].revision,
          "TextDetails": msg2,
          "TOT": total,
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
        };

        if (discountSchemaID != 0) {
          call.addAll({
            "M_DiscountSchema_ID": {"id": discountSchemaID}
          });
        }

        list.add(jsonEncode(call));
      } else {
        list = GetStorage().read('postCallList');
        var call = {
          "offlineid": GetStorage().read('postCallId'),
          "url": '$protocol://$ip/api/v1/windows/sales-order',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
          "C_BPartner_ID": {"id": businessPartnerId},
          "C_BPartner_Location_ID": {"id": bpLocationId.value},
          "Bill_BPartner_ID": {"id": businessPartnerId},
          "Bill_Location_ID": {
            "id": defValues.records![0].cBPartnerLocationID!.id
          },
          "Revision": defValues.records![0].revision,
          "TextDetails": msg2,
          "TOT": total,
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
        };
        if (discountSchemaID != 0) {
          call.addAll({
            "M_DiscountSchema_ID": {"id": discountSchemaID}
          });
        }
        list.add(jsonEncode(call));
      }

      GetStorage().write('postCallId', GetStorage().read('postCallId') + 1);
      GetStorage().write('postCallList', list);
      Get.snackbar(
        "Saved!".tr,
        "The record has been saved locally waiting for internet connection".tr,
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
    }

    generateFiscalPrint(msg2);
  }

  Future<void> generateFiscalPrint(String msg2) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    var url = Uri.parse(
        'http://${GetStorage().read('fiscalPrinterIP')}/xml/printer.htm');

    var response = await http.post(
      url,
      body: msg2,
      headers: <String, String>{
        'Content-Type': 'application/xml',
        'authorization':
            'Basic ${stringToBase64.encode("${GetStorage().read('fiscalPrinterSerialNo')}:${GetStorage().read('fiscalPrinterSerialNo')}")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> generateCourtesyReceipt(
      List<dynamic> courtesyReceiptItemList) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    var msg2 =
        '<?xml version="1.0" encoding="utf-8"?><printerNotFiscal><beginNotFiscal></beginNotFiscal><printNormal font="5" data="SCONTRINO DI CORTESIA"></printNormal>';

    for (var element in courtesyReceiptItemList) {
      print(element);

      if (element["qtyEntered"] > 0) {
        msg2 =
            '$msg2<printNormal font="1" data="${element["ProductName"]}   x${element["qtyEntered"]}"></printNormal>';
      }
    }

    msg2 = '$msg2<endNotFiscal></endNotFiscal></printerNotFiscal>';

    var url = Uri.parse(
        'http://${GetStorage().read('fiscalPrinterIP')}/xml/printer.htm');

    var response = await http.post(
      url,
      body: msg2,
      headers: <String, String>{
        'Content-Type': 'application/xml',
        'authorization':
            'Basic ${stringToBase64.encode("${GetStorage().read('fiscalPrinterSerialNo')}:${GetStorage().read('fiscalPrinterSerialNo')}")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> generateDailyReport() async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    var msg =
        '<?xml version="1.0" encoding="utf-8"?><printerFiscalReport><printXReport description=""></printXReport></printerFiscalReport>';

    var url = Uri.parse(
        'http://${GetStorage().read('fiscalPrinterIP')}/xml/printer.htm');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/xml',
        'authorization':
            'Basic ${stringToBase64.encode("${GetStorage().read('fiscalPrinterSerialNo')}:${GetStorage().read('fiscalPrinterSerialNo')}")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> generateDailyFiscalClosing() async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    var msg =
        '<?xml version="1.0" encoding="utf-8"?><printerFiscalReport><printZReport description=""></printZReport></printerFiscalReport>';

    var url = Uri.parse(
        'http://${GetStorage().read('fiscalPrinterIP')}/xml/printer.htm');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/xml',
        'authorization':
            'Basic ${stringToBase64.encode("${GetStorage().read('fiscalPrinterSerialNo')}:${GetStorage().read('fiscalPrinterSerialNo')}")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
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

  Future<bool> getConfVariables() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_SysConfig?\$filter= Name eq \'LIT_POSShowDiscount\' and AD_Client_ID eq ${GetStorage().read("clientid")}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = ProductCategoryJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.records!.isNotEmpty) {
        if (json.records![0].value == 'Y') {
          return true;
        }
      } else {
        return false;
      }
      //getPriceListVersionID();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
    return false;
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

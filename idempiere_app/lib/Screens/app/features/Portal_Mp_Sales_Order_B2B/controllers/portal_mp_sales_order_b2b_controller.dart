// ignore_for_file: unused_field, prefer_final_fields

part of dashboard;

class PortalMpSalesOrderB2BController extends GetxController {
  var prodCategoriesAvailable = false.obs;
  var productsAvailable = false.obs;
  var productDetailAvailable = false.obs;
  var productFilterAvailable = false.obs;
  var shoppingCartAvailable = false.obs;
  var prodStockAvailable = false.obs;
  var bpLocationAvailable = false.obs;
  var docTypeFlag = false.obs;

  var pTermAvailable = false.obs;
  var pRuleAvailable = false.obs;

  int businessPartnerId = 0;
  var businessPartnerName = "".obs;
  var bpLocationId = "0".obs;
  var paymentTermId = "0".obs;
  var paymentRuleId = "B".obs;

  late List<DTRecords> dropDownList;
  var dropdownValue = "1".obs;

  TextEditingController searchFieldController = TextEditingController();

  B2BProductCategoryJson prodCategories = B2BProductCategoryJson(records: []);

  ProductListJson filteredProds = ProductListJson(records: []);

  List<PLRecords> skuProducts = [];

  ProductJson prodDetail = ProductJson(records: []);
  B2BProdStockJson prodStock = B2BProdStockJson(records: []);
  PSRecords currentStock = PSRecords(qtyOnHand: 0);
  PSRecords providerStock = PSRecords(qtyAvailable: 0);
  PSRecords futureStock = PSRecords(
    qtyOrdered: 0,
  );
  SalesOrderDefaultsJson defValues = SalesOrderDefaultsJson(records: []);
  BusinessPartnerLocationJson bpLocation =
      BusinessPartnerLocationJson(records: []);

  var detailIndex = 0;
  var detailImage = "";
  var detailImageType = "URL";
  var chosenDetailSize = "".obs;
  var chosenDetailSizeName = "";

  var chosenCategoryName = "".obs;
  var chosenProductName = "".obs;

  var cat = 0;

  var shoppingCartCounter = 0.obs;

  var colorUrlFilter = "";
  var sizeUrlFilter = "";

  List<FilterSize> detailDropDownSizes = [];

  TextEditingController qtyFieldController = TextEditingController(text: "1");

  List<ProductCheckout> productList = [];
  var total = 0.0.obs;

  static final List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();

  List<Animal> _selectedAnimals2 = [];

  // FILTER COLOR

  List<FilterColor> _colors = [];
  List<MultiSelectItem<dynamic>> _colorItems = [];

  List<dynamic> _selectedColors = [];

  //END FILTER COLOR
  // FILTER SIZE
  List<FilterSize> _sizes = [];
  List<MultiSelectItem<dynamic>> _sizeItems = [];

  List<dynamic> _selectedSizes = [];

  updateTotal() {
    num tot = 0;
    if (productList.isNotEmpty) {
      for (var i = 0; i < productList.length; i++) {
        tot = tot + (productList[i].cost * productList[i].qty);
      }
    }

    total.value = double.parse(tot.toString());
  }

  @override
  void onInit() {
    chosenDetailSize.value;
    super.onInit();
    getBusinessPartner();
    getProductCategories();
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
        getDefaultPaymentTermsFromBP();
        getSalesOrderDefaultValues();
        getDocTypes();
        getLocationFromBP();
      } catch (e) {
        if (kDebugMode) {
          print("no bp");
        }
      }

      try {
        businessPartnerName.value =
            json["records"][0]["C_BPartner_ID"]["identifier"];
      } catch (e) {
        if (kDebugMode) {
          print("no bp");
        }
      }
    } else {
      if (kDebugMode) {
        print('bp fallito');
        print(response.body);
      }
    }
  }

  getProductCategories() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_prod_category_v?\$filter= IsSummary eq Y and IsSelfService eq Y');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      prodCategories = B2BProductCategoryJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      prodCategoriesAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getFilteredProducts(int id) async {
    prodCategoriesAvailable.value = false;
    productFilterAvailable.value = false;
    productsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= M_Product_Category_ID eq $id');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      skuProducts = [];
      filteredProds.records!.removeWhere((element) => true);
      ProductListJson temp =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < temp.records!.length; i++) {
        var prodFound = filteredProds.records!
            .where((element) => element.sku == temp.records![i].sku);

        if (prodFound.isEmpty) {
          for (var element in temp.records!) {
            if (element.sku == temp.records![i].sku) {
              skuProducts.add(element);
            }
          }
          //print("added");
          filteredProds.records!.add(temp.records![i]);
        }
      }
      //print(skuProducts.length);
      //print(utf8.decode(response.bodyBytes));
      /* filteredProds =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes))); */
      for (var record in temp.records!) {
        //color filter
        if (_colors.isEmpty && record.adPrintColorID != null) {
          _colors.add(FilterColor(
              id: record.adPrintColorID!.id!,
              name: record.adPrintColorID!.identifier!));
        }
        if (_colors.isNotEmpty && record.adPrintColorID != null) {
          var found = _colors
              .where((element) => element.id == record.adPrintColorID!.id);
          if (found.isEmpty) {
            _colors.add(FilterColor(
                id: record.adPrintColorID!.id!,
                name: record.adPrintColorID!.identifier!));
          }
        }
        _colorItems = _colors
            .map((color) => MultiSelectItem<FilterColor>(color, color.name))
            .toList();

        //end color filter
        //size filter
        if (_sizes.isEmpty && record.litProductSizeID != null) {
          _sizes.add(FilterSize(
              id: record.litProductSizeID!.id!,
              name: record.litProductSizeID!.identifier!));
        }
        if (_sizes.isNotEmpty && record.litProductSizeID != null) {
          var found = _sizes
              .where((element) => element.id == record.litProductSizeID!.id);
          if (found.isEmpty) {
            _sizes.add(FilterSize(
                id: record.litProductSizeID!.id!,
                name: record.litProductSizeID!.identifier!));
          }
        }
        _sizeItems = _sizes
            .map((size) => MultiSelectItem<FilterSize>(size, size.name))
            .toList();

        //end size filter
      }
      //print(_sizeItems);
      productFilterAvailable.value = true;
      productsAvailable.value = true;
    } else {
      if (kDebugMode) {
        print('Error');
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getFilteredProducts2(int id) async {
    //print("kek");
    prodCategoriesAvailable.value = false;
    //productFilterAvailable.value = false;
    productsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= M_Product_Category_ID eq $id $colorUrlFilter');

    /* print('$protocol://$ip/api/v1/models/lit_product_list_v?\$filter= M_Product_Category_ID eq $id $colorUrlFilter $sizeUrlFilter'); */

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      filteredProds.records!.removeWhere((element) => true);
      skuProducts = [];
      ProductListJson temp =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < temp.records!.length; i++) {
        var prodFound = filteredProds.records!
            .where((element) => element.sku == temp.records![i].sku);

        if (prodFound.isEmpty) {
          for (var element in temp.records!) {
            if (element.sku == temp.records![i].sku) {
              skuProducts.add(element);
            }
          }
          //print("added");
          filteredProds.records!.add(temp.records![i]);
        }
      }

      _sizes.removeWhere((element) => true);

      for (var record in temp.records!) {
        if (_sizes.isEmpty && record.litProductSizeID != null) {
          _sizes.add(FilterSize(
              id: record.litProductSizeID!.id!,
              name: record.litProductSizeID!.identifier!));
        }
        if (_sizes.isNotEmpty && record.litProductSizeID != null) {
          var found = _sizes
              .where((element) => element.id == record.litProductSizeID!.id);
          if (found.isEmpty) {
            _sizes.add(FilterSize(
                id: record.litProductSizeID!.id!,
                name: record.litProductSizeID!.identifier!));
          }
        }
        _sizeItems = _sizes
            .map((size) => MultiSelectItem<FilterSize>(size, size.name))
            .toList();
      }
      //print(utf8.decode(response.bodyBytes));
      /* filteredProds =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes))); 
      */
      //productFilterAvailable.value = true;
      productsAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getFilteredProducts3() async {
    //print("kek");
    prodCategoriesAvailable.value = false;
    //productFilterAvailable.value = false;
    productsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization =
        'Bearer ${GetStorage().read('token')}'; //contains(tolower(Value),\'${searchFieldController.text}\')
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= contains(Value,\'${searchFieldController.text}\')');

    /*  print(
        '$protocol://$ip/api/v1/models/lit_product_list_v?\$filter= SKU eq \'${searchFieldController.text}\''); */

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));

      /* filteredProds =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes))); */
      filteredProds.records!.removeWhere((element) => true);

      skuProducts = [];
      ProductListJson temp =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < temp.records!.length; i++) {
        var prodFound = filteredProds.records!
            .where((element) => element.sku == temp.records![i].sku);

        if (prodFound.isEmpty) {
          for (var element in temp.records!) {
            if (element.sku == temp.records![i].sku) {
              skuProducts.add(element);
            }
          }
          //print("added");
          filteredProds.records!.add(temp.records![i]);
        }
      }

      _sizes.removeWhere((element) => true);

      for (var record in temp.records!) {
        if (_sizes.isEmpty && record.litProductSizeID != null) {
          _sizes.add(FilterSize(
              id: record.litProductSizeID!.id!,
              name: record.litProductSizeID!.identifier!));
        }
        if (_sizes.isNotEmpty && record.litProductSizeID != null) {
          var found = _sizes
              .where((element) => element.id == record.litProductSizeID!.id);
          if (found.isEmpty) {
            _sizes.add(FilterSize(
                id: record.litProductSizeID!.id!,
                name: record.litProductSizeID!.identifier!));
          }
        }
        _sizeItems = _sizes
            .map((size) => MultiSelectItem<FilterSize>(size, size.name))
            .toList();
      }

      if (filteredProds.records!.isNotEmpty) {
        chosenCategoryName.value =
            filteredProds.records![0].productCategoryName2!;
        prodCategoriesAvailable.value == true;
        productFilterAvailable.value = true;
      }
      //productFilterAvailable.value = true;
      productsAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  Future<void> getProduct(String sku, BuildContext context) async {
    //productFilterAvailable.value = false;
    //productDetailAvailable.value = false;
    rows.removeWhere((element) => true);
    columns.removeWhere((element) => true);

    gridSkuSelected = sku;

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_b2bdetailgrid_v?\$filter= SKU eq \'$sku\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);

      var gridDetail = B2BGridDetailJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      var columnList = gridDetail.records![0].stringAgg!.split(';');
      columns.add(PlutoColumn(
          title: 'Size',
          field: 'Size',
          type: PlutoColumnType.text(),
          readOnly: true));
      for (var element in columnList) {
        columns.add(PlutoColumn(
          title: element,
          field: element,
          type: PlutoColumnType.text(),
          checkReadOnly: (row, cell) {
            return row.sortIdx != rows.length - 1;
          },
        ));
      }

      /* columns.add(PlutoColumn(
        title: 'status',
        field: 'status',
        type: PlutoColumnType.text(),
        //readOnly: true,
        hide: true,
      )); */

      var rowPriceList = gridDetail.records![0].prices!.split(';');
      //print(rowList);

      /* PlutoRow(cells: {
        'id': PlutoCell(value: 'user1'),
        'name': PlutoCell(value: 'user name 1'),
        'status': PlutoCell(value: 'saved'),
      }), */
      Map<String, PlutoCell> priceRow = {};
      priceRow.addAll({
        'Size': PlutoCell(value: 'Price'),
      });
      for (var i = 0; i < columnList.length; i++) {
        priceRow.addAll({
          columnList[i]: PlutoCell(value: rowPriceList[i]),
        });
      }

      var rowqtyAvailableList = gridDetail.records![0].qtyAvailable!.split(';');

      Map<String, PlutoCell> qtyAvailableRow = {};
      qtyAvailableRow.addAll({
        'Size': PlutoCell(value: 'Available'),
      });
      for (var i = 0; i < columnList.length; i++) {
        qtyAvailableRow.addAll({
          columnList[i]: PlutoCell(value: rowqtyAvailableList[i]),
        });
      }

      var rowqtyOrderedList = gridDetail.records![0].qtyOrdered!.split(';');

      Map<String, PlutoCell> qtyOrderedRow = {};
      qtyOrderedRow.addAll({
        'Size': PlutoCell(value: 'Ordered'),
      });
      for (var i = 0; i < columnList.length; i++) {
        qtyOrderedRow.addAll({
          columnList[i]: PlutoCell(value: rowqtyOrderedList[i]),
        });
      }

      Map<String, PlutoCell> qtyInStockRow = {};
      qtyInStockRow.addAll({
        'Size': PlutoCell(value: 'BP Stock'),
      });
      for (var i = 0; i < columnList.length; i++) {
        qtyInStockRow.addAll({
          columnList[i]: PlutoCell(value: '0'),
        });
      }

      /* priceRow.addAll({
        columnList[columnList.length - 1]: PlutoCell(value: 'Added'),
      }); */
      rows.add(PlutoRow(cells: priceRow));
      rows.add(PlutoRow(cells: qtyAvailableRow));
      rows.add(PlutoRow(cells: qtyInStockRow));
      rows.add(PlutoRow(cells: qtyOrderedRow));

      //var currentStock = gridDetail.records![0].!.split(';');

      openGridPopUp(context, sku);

      //getProdB2BStock(id);

      //productDetailAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
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

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
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
          paymentRuleId.value = json.records![0].cPaymentRuleID?.id ?? "B";
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

  Future<void> getProdB2BStock(int id) async {
    prodStockAvailable.value = false;
    //print(id);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_b2bstock_v?\$filter= M_Product_ID eq $id and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));

      prodStock = B2BProdStockJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in prodStock.records!) {
        if (element.rowType!.id! == "m_product") {
          providerStock = element;
          futureStock = element;
        }
        if (element.rowType!.id! == "m_storageonhand") {
          currentStock = element;
        }
      }
      prodStockAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
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
        "M_Product_ID": {"id": element.id},
        "qtyEntered": element.qty
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
      "AD_User_ID": defValues.records![0].aDUserID!.id,
      "Bill_User_ID": defValues.records![0].billUserID!.id,
      "C_DocTypeTarget_ID": {"id": int.parse(dropdownValue.value)},
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
      //print(response.body);

      var json = jsonDecode(utf8.decode(response.bodyBytes));

      prodCategoriesAvailable.value = true;
      productsAvailable.value = false;
      productDetailAvailable.value = false;
      productFilterAvailable.value = false;
      shoppingCartAvailable.value = false;
      productList = [];
      shoppingCartCounter.value = 0;
      updateTotal();

      /* Get.find<CRMSalesOrderController>().getSalesOrders();
      Get.back(); */
      //Get.off('/PortalMpSalesOrderB2B');
      //print("done!");
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
        print(response.body);
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
  }

  //grid

  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  late PlutoGridStateManager stateManager;

  String gridSkuSelected = "";

  Map<String, String> gridProdValueList = {};

  openGridPopUp(BuildContext context, String sku) {
    PlutoGridPopupCustom(
      button: gridAddToCart,
      context: context,
      columns: columns,
      width: columns.length * 100,
      //height: 400,
      rows: rows,
      mode: PlutoGridMode.normal,
      createHeader: (stateManager) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sku,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
      configuration: const PlutoGridConfiguration(
        columnSize:
            PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
      ),
      onLoaded: (PlutoGridOnLoadedEvent event) {
        gridProdValueList = {};
        final newRows = event.stateManager.getNewRows(count: 1);

        /* for (var e in newRows) {
          e.cells['status']!.value = 'created';
        } */

        for (var i = 1; i < columns.length; i++) {
          newRows[0].cells[columns[i].field]!.value = '0';
        }

        event.stateManager.appendRows(newRows);

        event.stateManager.setCurrentCell(
          newRows.first.cells.entries.first.value,
          event.stateManager.refRows.length - 1,
        );

        event.stateManager.moveScrollByRow(
          PlutoMoveDirection.down,
          event.stateManager.refRows.length - 2,
        );

        event.stateManager.setKeepFocus(true);
        //stateManager = event.stateManager;
      },
      onSelected: (PlutoGridOnSelectedEvent event) {
        //event.
        /* controller.text = event.row!.cells[selectFieldName]!.value.toString(); */
      },
      onSorted: (PlutoGridOnSortedEvent event) {
        //print(event);
      },
      onChanged: (event) {
        //print('$gridSkuSelected.${columns[event.columnIdx].field}');
        gridProdValueList.addAll({
          '$gridSkuSelected.${columns[event.columnIdx].field}': event.value,
        });
        //print(event);
        //event.
        //print(event.row.sortIdx);
      },
    );
  }

  gridAddToCart() {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    gridProdValueList.forEach((key, value) async {
      if (0 < (int.tryParse(value) ?? 0)) {
        var url = Uri.parse(
            '$protocol://$ip/api/v1/models/lit_product_list2_v?\$filter= Value eq \'$key\'');

        var response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );

        if (response.statusCode == 200) {
          var data = ProductListJson.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));

          productList.add(ProductCheckout(
            id: data.records![0].id!,
            name: data.records![0].name!,
            qty: int.parse(
              value,
            ),
            cost: data.records![0].price ?? 0,
            adPrintColorID: data.records![0].adPrintColorID,
            litProductSizeID: data.records![0].litProductSizeID,
            imageData: data.records![0].imageData,
            imageUrl: data.records![0].imageUrl,
          ));

          shoppingCartCounter.value++;
          updateTotal();

          //print(data.records![0].id);
        } else {
          if (kDebugMode) {
            print(response.body);
          }
        }
      }
    });
    Get.back();
  }

  //end grid

  //print(list[0].eMail);

  //print(json.);

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
          Get.toNamed('/Maintenance');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Maintenance",
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
        seeAllFunction: () {
          Get.toNamed('/MaintenanceCalendar');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "MaintenanceCalendar",
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
        seeAllFunction: () {
          Get.toNamed('/TicketCustomerTicket');
        },
        addFunction: () {},
        title: "Ticket customer",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
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
      projectName: "Customer Portal".tr,
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

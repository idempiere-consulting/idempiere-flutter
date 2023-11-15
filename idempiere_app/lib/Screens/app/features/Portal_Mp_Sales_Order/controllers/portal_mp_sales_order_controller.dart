part of dashboard;

class PortalMpSalesOrderController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> list = GetStorage().read('permission');

  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late SalesOrderJson _trx;

  ContractArticleJSON articleList = ContractArticleJSON(records: []);

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  var userFilter = GetStorage().read('PortalMPSalesOrder_userFilter') ?? "";
  var businessPartnerFilter =
      GetStorage().read('PortalMPSalesOrder_businessPartnerFilter') ?? "";
  var docNoFilter = GetStorage().read('PortalMPSalesOrder_docNoFilter') ?? "";

  var businessPartnerId = 0.obs;
  String businessPartnerName = "";
  var selectedUserRadioTile = 0.obs;
  var salesRepId = 0;
  var salesRepName = "";
  var docNoValue = "".obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  var articleDropDownValue = "0".obs;

  //DESKTOP VIEW VARIABLES

  int selectedHeaderId = 0;
  int selectedHeaderIndex = 0;

  SalesOrderJson _trxDesktop = SalesOrderJson(records: []);

  SalesOrderLineJson _trxDesktopLines = SalesOrderLineJson(records: []);

  var desktopDocNosearchFieldController = TextEditingController();

  TextEditingController desktopDocNoFieldController = TextEditingController();
  TextEditingController desktopDocTypeFieldController = TextEditingController();
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

  final json = {
    "types": [
      {"id": "1", "name": "DocumentNo".tr},
      {"id": "2", "name": "Business Partner".tr},
      //{"id": "3", "name": "SalesRep".tr},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    super.onInit();
    selectedUserRadioTile.value =
        GetStorage().read('PortalMPSalesOrder_selectedUserRadioTile') ?? 0;
    businessPartnerName =
        GetStorage().read('PortalMPSalesOrder_businessPartnerName') ?? "";
    businessPartnerId.value =
        GetStorage().read('PortalMPSalesOrder_businessPartnerId') ?? 0;
    salesRepId = GetStorage().read('PortalMPSalesOrder_salesRepId') ?? 0;
    salesRepName = GetStorage().read('PortalMPSalesOrder_salesRepName') ?? "";
    docNoValue.value = GetStorage().read('PortalMPSalesOrder_docNo') ?? "";
    getBusinessPartnerDesktop();
    getADUserID();
    setConnect();
  }

  bool get dataAvailable => _dataAvailable.value;
  SalesOrderJson get trx => _trx;
  //String get value => _value.toString();

  Future<void> getBusinessPartnerDesktop() async {
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

      businessPartnerId.value = json["records"][0]["C_BPartner_ID"]["id"];
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
    getSalesOrders();
    getSalesOrdersDesktop();
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getSalesOrders();
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
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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

  Future<void> getSalesOrders() async {
    var apiUrlFilter = ["", " and SalesRep_ID eq $adUserId"];
    _dataAvailable.value = false;
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and C_Order_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$filter= C_BPartner_ID eq $businessPartnerId and IsSoTrx eq Y and (DocStatus eq \'CO\' or (DocStatus eq \'CO\' and IsSelfService eq Y)) and AD_Client_ID eq ${GetStorage().read("clientid")}${apiUrlFilter[filterCount]}$notificationFilter$userFilter$businessPartnerFilter$docNoFilter&\$orderby= DateOrdered desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx =
          SalesOrderJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      pagesTot.value = _trx.pagecount!;
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    }
  }

  Future<void> getSalesOrdersDesktop() async {
    _desktopDataAvailable.value = false;
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and C_Contract_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    // ignore: unused_local_variable
    var searchFilter = "";
    if (desktopDocNosearchFieldController.text != "") {
      searchFilter =
          " and contains(DocumentNo,'${desktopDocNosearchFieldController.text}')";
    }
    //var userFilters = [];

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$filter= C_BPartner_ID eq $businessPartnerId and DocStatus eq \'CO\' and IsSoTrx eq Y and AD_Client_ID eq ${GetStorage().read("clientid")}$notificationFilter$searchFilter&\$skip=${(desktopPagesCount.value - 1) * 100}&\$orderby= DateOrdered desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //C_BPartner_ID eq $businessPartnerId and
      //print(response.body);
      _trxDesktop =
          SalesOrderJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      desktopPagesTot.value = _trxDesktop.pagecount!;

      headerRows = [];

      for (var i = 0; i < _trxDesktop.records!.length; i++) {
        headerRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    selectedHeaderId = _trxDesktop.records![i].id!;
                    selectedHeaderIndex = i;

                    desktopDocNoFieldController.text =
                        _trxDesktop.records![i].documentNo ?? '??';
                    desktopDocTypeFieldController.text =
                        _trxDesktop.records![i].cDocTypeTargetID?.identifier ??
                            '??';
                    desktopBusinessPartnerFieldController.text =
                        _trxDesktop.records![i].cBPartnerID?.identifier ?? '??';

                    showHeader.value = false;
                    showLines.value = true;
                    getSalesOrderLinesDesktop();
                  },
                  icon: const Icon(EvaIcons.search)),
              Expanded(child: Text(_trxDesktop.records![i].documentNo ?? '??'))
            ],
          )),
          DataCell(
            Text(_trxDesktop.records![i].cDocTypeID?.identifier ?? 'N/A'),
          ),
          DataCell(
            Text(_trxDesktop.records![i].dateOrdered!.substring(0, 10)),
          ),
          DataCell(
            Text(_trxDesktop.records![i].paymentRule?.identifier ?? 'N/A'),
          ),
          DataCell(
            Text(_trxDesktop.records![i].cPaymentTermID?.identifier ?? 'N/A'),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((_trxDesktop.records![i].grandTotal ?? 'N/A').toString()),
              ],
            ),
          ),
          DataCell(
            IconButton(
                onPressed: () {
                  getDocument(i);
                },
                icon: const Icon(EvaIcons.printer)),
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

  Future<void> getSalesOrderLinesDesktop() async {
    linesDataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_orderline?\$filter= C_Order_ID eq $selectedHeaderId and  AD_Client_ID eq ${GetStorage().read("clientid")}&\$skip=${(desktopLinePagesCount.value - 1) * 100}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      _trxDesktopLines = SalesOrderLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      desktopLinePagesTot.value = _trxDesktopLines.pagecount!;

      lineRows = [];

      for (var i = 0; i < _trxDesktopLines.records!.length; i++) {
        lineRows.add(DataRow(selected: false, cells: <DataCell>[
          DataCell(
            Text(_trxDesktopLines.records![i].mProductID?.identifier ?? 'N/A'),
          ),
          DataCell(
            Text(_trxDesktopLines.records![i].cUOMID?.identifier ?? 'N/A'),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((_trxDesktopLines.records![i].qtyEntered ?? 'N/A')
                    .toString()),
              ],
            ),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((_trxDesktopLines.records![i].qtyEntered ?? 'N/A')
                    .toString()),
              ],
            ),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((_trxDesktopLines.records![i].priceList ?? 'N/A')
                    .toString()),
              ],
            ),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((_trxDesktopLines.records![i].priceEntered ?? 'N/A')
                    .toString()),
              ],
            ),
          ),
        ]));
      }

      linesDataAvailable.value = true;
    } else {
      print(response.body);
    }
  }

  Future<void> getDocument(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/sales-order/${_trx.records![index].id}/print');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      String pdfString = json["exportFile"];
      //print(pdfString);

      List<int> list = base64.decode(pdfString);
      Uint8List bytes = Uint8List.fromList(list);
      //print(bytes);

      //final pdf = await rootBundle.load('document.pdf');
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);

      //return json.records!;
    } else {
      //throw Exception("Failed to load PDF");
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> setConnect() async {
    try {
      final String? result = await BluetoothThermalPrinter.connect(
          GetStorage().read('posMacAddress'));
      //print("state conneected $result");
      if (result == "true") {}
    } catch (e) {
      if (kDebugMode) {
        print('nope');
      }
    }
    //printTicket();
  }

  Future<void> getBusinessPartner(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_orginfo?\$filter= AD_Org_ID eq ${_trx.records![index].aDOrgID!.id} and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //print('getbusinesspartner');

      //getBpData(index, json['records'][0]['C_BPartner_ID']['id']);
      var json =
          OrgInfoJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      printTicket(index, json);
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<void> printTicket(int index, OrgInfoJSON jsonBP) async {
    late SalesOrderLineJson json;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      final ip = GetStorage().read('ip');
      String authorization = 'Bearer ${GetStorage().read('token')}';
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse(
          '$protocol://$ip/api/v1/models/c_orderline?\$filter= C_Order_ID eq ${trx.records![index].id} and AD_Client_ID eq ${GetStorage().read("clientid")}');
      //print(Get.arguments["id"]);
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //print(response.body);
        json = SalesOrderLineJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        //print(trx.rowcount);
        //print(response.body);
        // ignore: unnecessary_null_comparison
        //_dataAvailable.value = _trx != null;
      }
      try {
        List<int> bytes = await getPOSSalesOrder(index, json, jsonBP);
        // ignore: unused_local_variable
        final result = await BluetoothThermalPrinter.writeBytes(bytes);
      } catch (e) {
        if (kDebugMode) {
          print('nope');
        }
      }
      //print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<void> getSalesOrderLines() async {
    _dataAvailable.value = false;
  }

  Future<List<int>> getPOSSalesOrder(
      int index, SalesOrderLineJson json, OrgInfoJSON jsonBP) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    var dateString = trx.records![index].dateOrdered;
    DateTime date = DateTime.parse(dateString!);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    bytes += generator.text("${_trx.records![index].aDOrgID!.identifier}",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(jsonBP.records![0].cLocationID!.identifier!,
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text("P. IVA ${jsonBP.records![0].taxID}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    bytes += generator.text(
        "${"Document Type: ".tr}${trx.records![index].cDocTypeID!.identifier}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        '${'Document: '.tr}${trx.records![index].documentNo} $formattedDate',
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Product',
          width: 8,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'IVA',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    // ignore: unnecessary_null_comparison
    if (json != null) {
      for (var line in json.records!) {
        bytes += generator.row([
          PosColumn(
              text: "${line.name}",
              width: 8,
              styles: const PosStyles(
                align: PosAlign.left,
              )),
          PosColumn(
              text: "${line.cTaxID!.identifier}",
              width: 2,
              styles: const PosStyles(align: PosAlign.center)),
          PosColumn(
              text:
                  (double.parse(line.lineNetAmt.toString())).toStringAsFixed(2),
              width: 2,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
        if (line.qtyEntered! > 1) {
          bytes += generator.text(
              "*  ${line.qtyEntered} X ${line.priceEntered!.toStringAsFixed(2)}",
              styles: const PosStyles(align: PosAlign.center));
        }
      }
    }

    /*  bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Tea",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "10", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]); */

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Totale',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: trx.records![index].grandTotal!.toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'di cui IVA',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: (double.parse(trx.records![index].grandTotal!.toString()) -
                  double.parse(trx.records![index].totalLines!.toString()))
              .toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    //DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    bytes += generator.text(dateFormat.format(DateTime.now()),
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text("Firma___________________",
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text("Demo Shop",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(
        "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +919591708470',
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'No',
          width: 1,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(text: "1", width: 1),
      PosColumn(
          text: "Tea",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "10",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "10", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "2", width: 1),
      PosColumn(
          text: "Sada Dosa",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "30",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "30", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "3", width: 1),
      PosColumn(
          text: "Masala Dosa",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "50",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "50", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: "4", width: 1),
      PosColumn(
          text: "Rova Dosa",
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "70",
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          )),
      PosColumn(
          text: "1", width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: "70", width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
      PosColumn(
          text: "160",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size4,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text("26-11-2020 15:22:45",
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: const PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }

  getContractArticles(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_ContractArticle?\$filter= C_Order_ID eq $id');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      articleList = ContractArticleJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      openArticleSelection();
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  openArticleSelection() {
    Get.defaultDialog(
        title: "Select which Article to Edit".tr,
        content: Obx(
          () => DropdownButton(
            hint: Text("No Article Selected".tr),
            value: articleDropDownValue.value == "0"
                ? null
                : articleDropDownValue.value,
            style: const TextStyle(fontSize: 12.0),
            elevation: 16,
            onChanged: (String? newValue) async {
              articleDropDownValue.value = newValue!;
              Get.back();
              //print(newValue);
              for (var element in articleList.records!) {
                if (element.help == articleDropDownValue.value) {
                  Get.to(const CRMEditHTMLSalesOrder(), arguments: {
                    "html": articleDropDownValue.value,
                    "id": element.id
                  });
                }
              }

              articleDropDownValue.value = "0";
            },
            items: articleList.records!.map((list) {
              return DropdownMenuItem<String>(
                value: list.help,
                child: Text(
                  list.rowType?.identifier ?? "NONE",
                ),
              );
            }).toList(),
          ),
        ));
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
      projectName: "Portale Cliente",
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

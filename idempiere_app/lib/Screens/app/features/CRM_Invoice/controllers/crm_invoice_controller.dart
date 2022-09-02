part of dashboard;

class CRMInvoiceController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late InvoiceJson _trx;

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

  final json = {
    "types": [
      {"id": "1", "name": "Doc N°"},
      {"id": "2", "name": "Date Invoiced"},
      {"id": "3", "name": "Business Partner"},
      {"id": "4", "name": "Description"}
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
    getInvoices();
    getADUserID();
    setConnect();
  }

  bool get dataAvailable => _dataAvailable.value;
  InvoiceJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getInvoices();
  }

  Future<void> getADUserID() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/ad_user?\$filter= Name eq \'$name\'');
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

  Future<void> getInvoices() async {
    var now = DateTime.now();
    DateTime ninetyDaysAgo = now.subtract(const Duration(days: 90));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String formattedNinetyDaysAgo = formatter.format(ninetyDaysAgo);
    var apiUrlFilter = ["", " and SalesRep_ID eq $adUserId"];
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_invoice?\$filter= IsSoTrx eq Y and DateInvoiced le \'$formattedDate 23:59:59\' and DateInvoiced ge \'$formattedNinetyDaysAgo 00:00:00\' and AD_Client_ID eq ${GetStorage().read("clientid")}${apiUrlFilter[filterCount]}&\$orderby= DateInvoiced desc');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx = InvoiceJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
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

  Future<void> printTicket(int index) async {
    late SalesOrderLineJson json;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      final ip = GetStorage().read('ip');
      String authorization = 'Bearer ' + GetStorage().read('token');
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse('$protocol://' +
          ip +
          '/api/v1/models/c_invoiceline?\$filter= C_Invoice_ID eq ${trx.records![index].id} and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
        List<int> bytes = await getPOSSalesOrder(index, json);
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

  Future<List<int>> getPOSSalesOrder(int index, SalesOrderLineJson json) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text("${GetStorage().read('clientname') ?? "???"}",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("VIA DEL MARANGON, 10",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("MESCOLINO-MINELLE (TV)",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("PARTITA IVA 43892049842",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    bytes += generator.text(
        "Document Type: ".tr + "${trx.records![index].cDocTypeID!.identifier}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        'Document: '.tr + '${trx.records![index].documentNo}',
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.hr();
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

    bytes += generator.cut();
    return bytes;
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

  Future<List<int>> getInvoiceTicket(int index, SalesOrderLineJson json,
      OrgInfoJSON frombpartner, RVbpartnerJSON tobpartner) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    var dateString = trx.records![index].dateInvoiced;
    DateTime date = DateTime.parse(dateString!);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    bytes += generator.text("${_trx.records![index].aDOrgID!.identifier}",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(frombpartner.records![0].cLocationID!.identifier!,
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.text("P. IVA ${frombpartner.records![0].taxID}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    bytes += generator.text(
        "Document Type: ".tr + "${trx.records![index].cDocTypeID!.identifier}",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(
        'Document: '.tr + '${trx.records![index].documentNo} $formattedDate',
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1);

    bytes += generator.row([
      PosColumn(
          text: 'Spett.',
          width: 2,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: tobpartner.records![0].name ?? "???",
          width: 10,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(
          text: ' ',
          width: 2,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: tobpartner.records![0].address1 ?? "???",
          width: 10,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: ' ',
          width: 2,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text:
              "${tobpartner.records![0].postal} ${tobpartner.records![0].city} (${tobpartner.records![0].regionName})",
          width: 10,
          styles: const PosStyles(align: PosAlign.left, bold: true)),
    ]);

    bytes += generator.hr();
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

    bytes += generator.cut();
    return bytes;
  }

  /* Future<void> getBpData(int index, int bpID) async {
    //late SalesOrderLineJson json;

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/rv_bpartner?\$filter= C_BPartner_ID eq $bpID and c_bp_location_isbillto eq \'Y\' and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      print('getbpdata');
      var json =
          RVbpartnerJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      getInvoiceData(index, json);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
    }

    //print("Print $result");
  } */

  Future<void> getToBPdata(int index, int bpID, OrgInfoJSON frombpartner,
      SalesOrderLineJson jsonLines) async {
    //late SalesOrderLineJson json;

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/rv_bpartner?\$filter= C_BPartner_ID eq $bpID and c_bp_location_isbillto eq Y and AD_Client_ID eq ${GetStorage().read("clientid")}');
    //print(Get.arguments["id"]);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      print('gettobpdata');
      var jsonTobpartner =
          RVbpartnerJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      try {
        List<int> bytes = await getInvoiceTicket(
            index, jsonLines, frombpartner, jsonTobpartner);
        // ignore: unused_local_variable
        final result = await BluetoothThermalPrinter.writeBytes(bytes);
      } catch (e) {
        if (kDebugMode) {
          print('nope1');
        }
      }

      //getInvoiceData(index, json);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
    }

    //print("Print $result");
  }

  Future<void> getInvoiceData(int index, OrgInfoJSON bpdata) async {
    late SalesOrderLineJson jsonLines;
    //String? isConnected = await BluetoothThermalPrinter.connectionStatus;

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_invoiceline?\$filter= C_Invoice_ID eq ${trx.records![index].id} and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
      print('getinvoicedata');
      jsonLines = SalesOrderLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      getToBPdata(
          index, _trx.records![index].cBPartnerID!.id!, bpdata, jsonLines);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
    } else {
      print(response.body);
    }

    //print("Print $result");
  }

  Future<void> getBusinessPartner(int index) async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/ad_orginfo?\$filter= AD_Org_ID eq ${_trx.records![index].aDOrgID!.id} and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      print('getbusinesspartner');

      //getBpData(index, json['records'][0]['C_BPartner_ID']['id']);
      var json =
          OrgInfoJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      getInvoiceData(index, json);
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

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
    String authorization = 'Bearer ' + GetStorage().read('token');
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

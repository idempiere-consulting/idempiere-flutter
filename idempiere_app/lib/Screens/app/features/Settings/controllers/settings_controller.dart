// ignore_for_file: use_build_context_synchronously

part of dashboard;

class SettingsController extends GetxController {
  var isBusinessPartnerSync = true.obs;
  var isProductSync = true.obs;
  var isjpTODOSync = true.obs;
  var isUserPreferencesSync = true.obs;
  var isWorkOrderSync = true.obs;
  var isBusinessPartnerSyncing = false.obs;
  var isUserPreferencesSyncing = false.obs;
  var isProductSyncing = false.obs;
  var isjpTODOSyncing = false.obs;
  var isWorkOrderSyncing = false.obs;
  var isWorkOrderSurveyLinesSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    isUserPreferencesSync.value =
        GetStorage().read('isUserPreferencesSync') ?? true;
    isBusinessPartnerSync.value =
        GetStorage().read('isBusinessPartnerSync') ?? true;
    isProductSync.value = GetStorage().read('isProductSync') ?? true;
    isjpTODOSync.value = GetStorage().read('isjpTODOSync') ?? true;
    isWorkOrderSync.value = GetStorage().read('isWorkOrderSync') ?? true;
    posPrinterName.value = GetStorage().read('posName') ?? 'None';
    fiscalPrinterIP.value = GetStorage().read('fiscalPrinterIP') ?? 'None';
    fiscalPrinterSerialNo.value =
        GetStorage().read('fiscalPrinterSerialNo') ?? 'None';
  }

  Future<void> reSyncAll() async {
    if (isUserPreferencesSync.value == true) {
      isUserPreferencesSyncing.value = true;
      syncUserPreferences();
    }
    if (isjpTODOSync.value == true) {
      isjpTODOSyncing.value = true;
      syncJPTODO();
    }
    if (isBusinessPartnerSync.value == true) {
      isBusinessPartnerSyncing.value = true;
      syncBusinessPartner();
    }
    if (isProductSync.value == true) {
      isProductSyncing.value = true;
      syncProduct();
    }
    if (isWorkOrderSync.value == true) {
      isWorkOrderSyncing.value = true;
      syncWorkOrder();
    }
  }

  syncJPTODO() async {
    var now = DateTime.now();
    DateTime fiftyDaysAgo = now.subtract(const Duration(days: 60));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/jp_todo?\$filter= JP_ToDo_Type eq \'S\' and AD_User_ID eq ${GetStorage().read('userId')} and Created ge \'$formattedFiftyDaysAgo\' and Created le \'$formattedDate 23:59:59\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      const filename = "calendar";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);
      isjpTODOSyncing.value = false;
    }
  }

  syncUserPreferences() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_UserPreference?\$filter= AD_User_ID eq ${GetStorage().read('userId')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      const filename = "userpreferences";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);
      isUserPreferencesSyncing.value = false;
    }
  }

  Future<void> syncBusinessPartner() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      //print(response.body);
      if (json.pagecount! > 1) {
        int index = 1;
        syncBusinessPartnerPages(json, index);
      } else {
        const filename = "businesspartner";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        isBusinessPartnerSyncing.value = false;
      }
      /* GetStorage()
          .write('businessPartnerSync', utf8.decode(response.bodyBytes)); */
    }
  }

  syncBusinessPartnerPages(BusinessPartnerJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncBusinessPartnerPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "businesspartner";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        isBusinessPartnerSyncing.value = false;
        if (kDebugMode) {
          print('BusinessPartner Checked');
        }
      }
    }
  }

  Future<void> syncProduct() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_product?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json =
          ProductJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncProductPages(json, index);
      } else {
        const filename = "products";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        isProductSyncing.value = false;
        if (kDebugMode) {
          print('Products Checked');
        }
      }
      //print(response.body);
      /* GetStorage().write('productSync', utf8.decode(response.bodyBytes));
      isProductSyncing.value = false; */
    }
  }

  syncProductPages(ProductJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_product?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson =
          ProductJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncProductPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "products";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        isProductSyncing.value = false;
        if (kDebugMode) {
          print('Products Checked');
        }
        //checkSyncData();
      }
    }
  }

  Future<void> syncWorkOrder() async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_v?\$filter= mp_ot_ad_user_id eq $userId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      const filename = "workorder";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);
      //isWorkOrderSyncing.value = false;
      syncWorkOrderResource();
      syncWorkOrderRefListResource();
      syncWorkOrderRefListResourceCategory();
    }
  }

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourcePages(json, index);
      } else {
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
      }
      //print(response.body);
      /* GetStorage()
          .write('workOrderResourceSync', utf8.decode(response.bodyBytes)); */
      syncWorkOrderResourceSurveyLines();
      syncWorkOrderResourceType();
    }
  }

  syncWorkOrderResourcePages(WorkOrderResourceLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderResourcePages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    }
  }

  Future<void> syncWorkOrderRefListResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'LIT_ResourceType\'');

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
      var id = json["records"][0]["id"];
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        const filename = "reflistresourcetype";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(response2.body);

        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body); &\$orderby=
    }
  }

  Future<void> syncWorkOrderRefListResourceCategory() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'C_BP_EDI EDI Type\'');

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
      var id = json["records"][0]["id"];
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        const filename = "reflistresourcetypecategory";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(response2.body);

        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body); &\$orderby=
    }
  }

  Future<void> syncWorkOrderResourceSurveyLines() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey_line?\$orderby= LineNo asc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourceSurveyLinesPages(json, index);
      } else {
        const filename = "workorderresourcesurveylines";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        isWorkOrderSyncing.value = false;
        if (kDebugMode) {
          print('workOrderResourceSurveyLinesSync Checked');
        }
        //checkSyncData();
      }
      //isWorkOrderSyncing.value = false;
    }
  }

  syncWorkOrderResourceSurveyLinesPages(
      WorkOrderResourceSurveyLinesJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_product?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderResourceSurveyLinesPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorderresourcesurveylines";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        isWorkOrderSyncing.value = false;
        if (kDebugMode) {
          print('workOrderResourceSurveyLinesSync Checked');
        }
        //checkSyncData();
      }
    }
  }

  Future<void> syncWorkOrderResourceType() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'LIT_ResourceType\'');

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
      var id = json["records"][0]["id"];
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        GetStorage()
            .write('refListResourceType', utf8.decode(response2.bodyBytes));

        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body); &\$orderby=
    }
  }

  var posPrinterName = "None".obs;
  List availableBluetoothDevices = [];

  Future<void> getBluetooth(BuildContext context) async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    //print("Print $bluetooths");

    availableBluetoothDevices = bluetooths!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: ListView.builder(
            itemCount: availableBluetoothDevices.isNotEmpty
                ? availableBluetoothDevices.length
                : 0,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  String select = availableBluetoothDevices[index];
                  List list = select.split("#");
                  posPrinterName.value = list[0];
                  String mac = list[1];
                  Get.back();
                  GetStorage().write('posMacAddress', mac);
                  GetStorage().write('posName', list[0]);

                  //setConnect(mac);
                },
                title: Text('${availableBluetoothDevices[index]}'),
                //subtitle: const Text("Click to connect"),
              );
            },
          ),
        );
      },
    );
  }

  TextEditingController fiscalPrinterIPFieldController =
      TextEditingController();

  var fiscalPrinterIP = "".obs;

  Future<void> writeFiscalPrinterIP() async {
    Get.defaultDialog(
      onConfirm: () {
        GetStorage()
            .write('fiscalPrinterIP', fiscalPrinterIPFieldController.text);
        fiscalPrinterIP.value = fiscalPrinterIPFieldController.text;
        Get.back();
      },
      title: '',
      content: Column(
        children: [
          TextField(
            autofocus: true,
            controller: fiscalPrinterIPFieldController,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
            ],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.print_rounded),
              border: const OutlineInputBorder(),
              labelText: 'Ip'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController fiscalPrinterSerialNoFieldController =
      TextEditingController();

  var fiscalPrinterSerialNo = "".obs;

  Future<void> writeFiscalPrinterSerialNo() async {
    Get.defaultDialog(
      onConfirm: () {
        GetStorage().write(
            'fiscalPrinterSerialNo', fiscalPrinterSerialNoFieldController.text);
        fiscalPrinterSerialNo.value = fiscalPrinterSerialNoFieldController.text;
        Get.back();
      },
      title: '',
      content: Column(
        children: [
          TextField(
            autofocus: true,
            controller: fiscalPrinterSerialNoFieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.print_rounded),
              border: const OutlineInputBorder(),
              labelText: 'Serial Number'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController fiscalPrinterHeader1FieldController =
      TextEditingController();
  TextEditingController fiscalPrinterHeader2FieldController =
      TextEditingController();
  TextEditingController fiscalPrinterHeader3FieldController =
      TextEditingController();
  TextEditingController fiscalPrinterHeader4FieldController =
      TextEditingController();
  TextEditingController fiscalPrinterHeader5FieldController =
      TextEditingController();
  TextEditingController fiscalPrinterHeader6FieldController =
      TextEditingController();

  Future<void> writeFiscalPrinterHeader() async {
    Get.defaultDialog(
      onConfirm: () {
        setFiscalPrintHeader();
        Get.back();
      },
      textConfirm: 'Set Header'.tr,
      title: '',
      content: Column(
        children: [
          TextField(
            //autofocus: true,
            controller: fiscalPrinterHeader1FieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_document),
              border: const OutlineInputBorder(),
              labelText: 'Row 1 (Name)'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            //autofocus: true,
            controller: fiscalPrinterHeader2FieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_document),
              border: const OutlineInputBorder(),
              labelText: 'Row 2 (Company Name)'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            //autofocus: true,
            controller: fiscalPrinterHeader3FieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_document),
              border: const OutlineInputBorder(),
              labelText: 'Row 3 (Address)'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            //autofocus: true,
            controller: fiscalPrinterHeader4FieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_document),
              border: const OutlineInputBorder(),
              labelText: 'Row 4 (Postal Code - City - Region)'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            //autofocus: true,
            controller: fiscalPrinterHeader5FieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_document),
              border: const OutlineInputBorder(),
              labelText: 'Row 5 (Phone - Email)'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            //autofocus: true,
            controller: fiscalPrinterHeader6FieldController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.edit_document),
              border: const OutlineInputBorder(),
              labelText: 'Row 6 (Tax Code)'.tr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                getHeaderOrgInfoFromIdempiere();
                getHeaderOrganizationFromIdempiere();
              },
              child: Text("Get Fields from Idempiere".tr)),
        ],
      ),
    );
  }

  Future<void> setFiscalPrintHeader() async {
    String msg =
        '<?xml version="1.0" encoding="utf-8"?><printerCommand><setHeaderLine  description="${fiscalPrinterHeader1FieldController.text}" rowNum="1" type="4"></setHeaderLine><setHeaderLine  description="${fiscalPrinterHeader2FieldController.text}" rowNum="2" type="1"></setHeaderLine><setHeaderLine  description="${fiscalPrinterHeader3FieldController.text}" rowNum="3" type="1"></setHeaderLine><setHeaderLine  description="${fiscalPrinterHeader4FieldController.text}" rowNum="4" type="1"></setHeaderLine><setHeaderLine  description="${fiscalPrinterHeader5FieldController.text}" rowNum="5" type="1"></setHeaderLine><setHeaderLine  description="${fiscalPrinterHeader6FieldController.text}" rowNum="6" type="1"></setHeaderLine></printerCommand>';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

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
  }

  Future<void> getHeaderOrgInfoFromIdempiere() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_OrgInfo?\$filter= AD_Org_ID eq ${GetStorage().read("organizationid")} and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json =
          OrgInfoJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      fiscalPrinterHeader5FieldController.text =
          "Tel ${json.records![0].phone ?? ""}  Email ${json.records![0].email ?? ""}";
      fiscalPrinterHeader6FieldController.text =
          "P. IVA ${json.records![0].taxID}";

      if (json.records![0].cLocationID != null) {
        getHeaderAddressFromIdempiere(json.records![0].cLocationID!.id!);
      }

      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> getHeaderAddressFromIdempiere(int locationId) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_Location?\$filter= C_Location_ID eq $locationId and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json =
          CLocationJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      fiscalPrinterHeader3FieldController.text = "${json.records![0].address1}";
      fiscalPrinterHeader4FieldController.text =
          "${json.records![0].postal}, ${json.records![0].city}, ${json.records![0].cRegionID?.identifier}";

      print(response.body);
    } else {
      print(response.body);
    }
  }

  Future<void> getHeaderOrganizationFromIdempiere() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Org?\$filter= AD_Org_ID eq ${GetStorage().read("organizationid")} and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = OrganizationJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      fiscalPrinterHeader1FieldController.text = json.records![0].name ?? "";
      fiscalPrinterHeader1FieldController.text =
          json.records![0].description ?? "";

      print(response.body);
    } else {
      print(response.body);
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

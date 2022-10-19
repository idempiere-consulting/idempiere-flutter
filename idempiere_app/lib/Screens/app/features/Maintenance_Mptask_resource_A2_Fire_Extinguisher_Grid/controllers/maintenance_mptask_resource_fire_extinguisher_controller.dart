part of dashboard;

class MaintenanceMpResourceFireExtinguisherController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderResourceLocalJson _trx;

  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderResourceLocalJson get trx => _trx;
  //String get value => _value.toString();
  MProductID lastProd = MProductID();
  int lastIndex = 0;

  @override
  void onInit() {
    getProds();

    super.onInit();

    //getADUserID();
  }

  getProds() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/products.json');

    prod = ProductJson.fromJson(jsonDecode(file.readAsStringSync()));
  }

  Future<void> getWorkOrders() async {
    _dataAvailable.value = false;
    final wk = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorder.json');
    final res = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
    int maintainId = GetStorage().read('selectedTaskDocNo');
    //print(GetStorage().read('workOrderResourceSync'));
    List<PlutoRow> newRows = [];
    int count = 0;
    // ignore: unnecessary_null_comparison
    if (wk.readAsStringSync() != null) {
      //print(wk.readAsStringSync());
      _trx = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(res.readAsStringSync()));

      for (var i = 0; i < _trx.records!.length; i++) {
        if (_trx.records![i].mpMaintainID?.id == maintainId &&
            _trx.records![i].eDIType?.id == 'A2') {
          count++;
          PlutoRow row = PlutoRow(cells: {
            'offlineid': PlutoCell(value: _trx.records![i].offlineId ?? -1),
            'index': PlutoCell(value: i),
            'id': PlutoCell(value: _trx.records![i].id),
            'V_Number': PlutoCell(value: _trx.records![i].number.toString()),
            'LocationComment':
                PlutoCell(value: _trx.records![i].locationComment ?? ''),
            'ProdCode': PlutoCell(value: _trx.records![i].prodCode ?? ''),
            'SerNo': PlutoCell(value: _trx.records![i].serNo ?? ''),
            'TextDetails': PlutoCell(value: _trx.records![i].textDetails ?? ''),
            'Manufacturer':
                PlutoCell(value: _trx.records![i].manufacturer ?? ''),
            'ManufacturedYear':
                PlutoCell(value: _trx.records![i].manufacturedYear),
            'LIT_Control1DateFrom':
                PlutoCell(value: _trx.records![i].lITControl1DateNext ?? ''),
            'LIT_Control2DateFrom':
                PlutoCell(value: _trx.records![i].lITControl2DateNext ?? ''),
            'LIT_Control3DateFrom':
                PlutoCell(value: _trx.records![i].lITControl3DateNext ?? ''),
            'Name': PlutoCell(value: _trx.records![i].name ?? ''),
            'M_Product_ID':
                PlutoCell(value: _trx.records![i].mProductID?.identifier ?? ''),
          });
          newRows.add(row);
          lastProd = MProductID(
              id: _trx.records![i].mProductID?.id,
              identifier: _trx.records![i].mProductID?.identifier);
        }
        lastIndex = i;
      }

      if (count > 0) {
        stateManager.appendRows(newRows);
      }

      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    }
  }

  //test grid

  //const filename = "products";

  //file.writeAsString(jsonEncode(json.toJson()));

  ProductJson prod = ProductJson();

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      readOnly: true,
      hide: true,
      title: 'offlineid',
      field: 'offlineid',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      readOnly: true,
      hide: true,
      title: 'index',
      field: 'index',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      readOnly: true,
      hide: true,
      title: 'id',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      //readOnly: true,
      title: 'N°',
      field: 'V_Number',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      //readOnly: true,
      title: 'Resource'.tr,
      field: 'M_Product_ID',
      type: PlutoColumnType.select(((ProductJson.fromJson(
                  jsonDecode((Get.arguments["products"]).readAsStringSync())))
              .records!
              .map((e) {
        return e.name!;
      }).toList())
          .where((element) => element.startsWith('EST.'))
          .toList()),
    ),
    PlutoColumn(
      title: 'Location'.tr,
      field: 'LocationComment',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Barcode'.tr,
      field: 'ProdCode',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Serial N°'.tr,
      field: 'SerNo',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Manufacturer'.tr,
      field: 'Manufacturer',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Year'.tr,
      field: 'ManufacturedYear',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Check'.tr,
      field: 'LIT_Control1DateFrom',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Revision'.tr,
      field: 'LIT_Control2DateFrom',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Testing'.tr,
      field: 'LIT_Control3DateFrom',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Observations'.tr,
      field: 'Name',
      type: PlutoColumnType.text(),
    ),
    /*PlutoColumn(
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Working time',
      field: 'working_time',
      type: PlutoColumnType.time(),
    ), */
  ];

  List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Identification'.tr, fields: [
      'V_Number',
      'M_Product_ID',
      'LocationComment',
      'ProdCode',
      'SerNo',
      'TextDetails',
      'Manufacturer',
      'ManufacturedYear'
    ]),
    PlutoColumnGroup(title: 'Activities'.tr, fields: [
      'LIT_Control1DateFrom',
      'LIT_Control2DateFrom',
      'LIT_Control3DateFrom'
    ]),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;
  var offline = -1;

  Future<void> handleEditTextRows(int? id, dynamic value, String field,
      int index, PlutoGridOnChangedEvent event) async {
    var isConnected = await checkConnection();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    var prodName = event.row?.cells['M_Product_ID']!.value;
    int? prodId = 0;

    for (var element in _trx.records!) {
      if (element.mProductID?.identifier == prodName) {
        prodId = element.mProductID?.id;
      }
    }

    offline = _trx.records![index].offlineId ?? -1;

    /* var msg = jsonEncode({"id": id, field: value}); */

    var msg = jsonEncode({
      //"AD_Org_ID": {"id": GetStorage().read("organizationid")},
      //"AD_Client_ID": {"id": GetStorage().read("clientid")},
      //"MP_Maintain_ID": {"id": GetStorage().read('selectedTaskDocNo')},
      "M_Product_ID": {"id": prodId},
      //"IsActive": true,
      "ResourceType": {"id": "BP"},
      // "LIT_ResourceType": {"id": dropDownValue},
      "ResourceQty": 1,
      "LIT_Control3DateFrom": event.row?.cells['LIT_Control3DateFrom']!.value,
      "LIT_Control2DateFrom": event.row?.cells['LIT_Control2DateFrom']!.value,
      "LIT_Control1DateFrom": event.row?.cells['LIT_Control1DateFrom']!.value,
      "V_Number": event.row?.cells['V_Number']!.value,
      "Name": event.row?.cells['Name']!.value,
      "SerNo": event.row?.cells['SerNo']!.value,
      "LocationComment": event.row?.cells['LocationComment']!.value,
      //"Value": locationCodeFieldController.text,
      "Manufacturer": event.row?.cells['Manufacturer']!.value,
      "ManufacturedYear": event.row?.cells['ManufacturedYear']!.value,
      //"UseLifeYears": int.parse(useLifeYearsFieldController.text),
      //"LIT_ProductModel": productModelFieldController.text,
      //"Lot": lotFieldController.text,
      //"DateOrdered": dateOrdered,
      //"ServiceDate": firstUseDate,
      //"UserName": userNameFieldController.text,
      "ProdCode": event.row?.cells['ProdCode']!.value,
      //"TextDetails": cartelFieldController.text
    });

    //print(msg);

    final res = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');

    /* WorkOrderResourceLocalJson trx =
        WorkOrderResourceLocalJson.fromJson(jsonDecode(res.readAsStringSync())); */
    switch (field) {
      case 'V_Number':
        _trx.records![index].number = value;
        break;
      case 'LocationComment':
        _trx.records![index].locationComment = value;
        break;
      case 'SerNo':
        _trx.records![index].serNo = value;
        break;
      case 'ManufacturedYear':
        _trx.records![index].manufacturedYear = value;
        break;
      case 'LIT_Control1DateFrom':
        _trx.records![index].lITControl1DateFrom = value;
        break;
      case 'LIT_Control2DateFrom':
        _trx.records![index].lITControl2DateFrom = value;
        break;
      case 'LIT_Control3DateFrom':
        _trx.records![index].lITControl3DateFrom = value;
        break;
      case 'Name':
        _trx.records![index].name = value;
        break;
      case 'ProdCode':
        _trx.records![index].prodCode = value;
        break;
      case 'TextDetails':
        _trx.records![index].textDetails = value;
        break;
      case 'M_Product_ID':
        for (var i = 0; i < prod.records!.length; i++) {
          if (prod.records![i].name == value) {
            msg = jsonEncode({
              "id": id,
              field: {"id": prod.records![i].id}
            });

            _trx.records![index].mProductID?.id = prod.records![i].id;
            _trx.records![index].mProductID?.identifier = prod.records![i].name;
          }
        }

        break;
      default:
    }
    // ignore: unnecessary_null_comparison
    if (id != null && offline == -1) {
      //trx.records![index]. = value;

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/$id');
      if (isConnected) {
        emptyAPICallStak();
        var response = await http.put(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          var data = jsonEncode(trx.toJson());

          final res = File(
              '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
          res.writeAsStringSync(data);
          //GetStorage().write('workOrderResourceSync', data);
          //getWorkOrders();
          // Get.find<MaintenanceMpResourceController>().getWorkOrders();
          //print("done!");
          //Get.back();
          Get.snackbar(
            "Fatto!",
            "Il record è stato modificato",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        } else {
          if (kDebugMode) {
            print(response.body);
          }
          //print(response.statusCode);
          Get.snackbar(
            "Errore!",
            "Il record non è stato modificato",
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      } else {
        var data = jsonEncode(_trx.toJson());
        final wk = File(
            '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
        wk.writeAsStringSync(data);
        //GetStorage().write('workOrderSync', data);
        //getWorkOrders();
        //Get.find<MaintenanceMpResourceController>().getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/$id'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/$id'] =
              msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.red,
          ),
        );
      }
    }

    if (offline != -1) {
      List<dynamic> list = GetStorage().read('postCallList');

      for (var i = 0; i < list.length; i++) {
        var json = jsonDecode(list[i]);
        if (json["offlineid"] == _trx.records![index].offlineId) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];
          // ignore: prefer_typing_uninitialized_variables

          // ignore: unused_local_variable
          /*  var call = jsonEncode(
                {"offlineid": offlineid2, "url": url2, field: value}); */
          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "AD_Org_ID": {"id": GetStorage().read("organizationid")},
            "AD_Client_ID": {"id": GetStorage().read("clientid")},
            "MP_Maintain_ID": {"id": GetStorage().read('selectedTaskDocNo')},
            "M_Product_ID": {"id": prodId},
            "IsActive": true,
            "ResourceType": {"id": "BP"},
            // "LIT_ResourceType": {"id": dropDownValue},
            "ResourceQty": 1,
            "LIT_Control3DateFrom":
                event.row?.cells['LIT_Control3DateFrom']!.value,
            "LIT_Control2DateFrom":
                event.row?.cells['LIT_Control2DateFrom']!.value,
            "LIT_Control1DateFrom":
                event.row?.cells['LIT_Control1DateFrom']!.value,
            "V_Number": event.row?.cells['V_Number']!.value,
            "Name": event.row?.cells['Name']!.value,
            "SerNo": event.row?.cells['SerNo']!.value,
            "LocationComment": event.row?.cells['LocationComment']!.value,
            //"Value": locationCodeFieldController.text,
            "Manufacturer": event.row?.cells['Manufacturer']!.value,
            "ManufacturedYear": event.row?.cells['ManufacturedYear']!.value,
            //"UseLifeYears": int.parse(useLifeYearsFieldController.text),
            //"LIT_ProductModel": productModelFieldController.text,
            //"Lot": lotFieldController.text,
            //"DateOrdered": dateOrdered,
            //"ServiceDate": firstUseDate,
            //"UserName": userNameFieldController.text,
            "ProdCode": event.row?.cells['ProdCode']!.value,
            //"TextDetails": cartelFieldController.text
          });

          res.writeAsStringSync(jsonEncode(_trx.toJson()));

          list.removeAt(i);
          list.add(call);
          GetStorage().write('postCallList', list);
          Get.snackbar(
            "Salvato!",
            "Il record è stato salvato localmente in attesa di connessione internet.",
            icon: const Icon(
              Icons.save,
              color: Colors.red,
            ),
          );
        }
      }
    }

    //print(msg);
  }

  Future<void> handleRemoveCurrentRowButton() async {
    int id = stateManager.currentRow!.cells['id']!.value;
    int index = stateManager.currentRow!.cells['index']!.value;
    stateManager.removeCurrentRow();

    var isConnected = await checkConnection();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final res = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');

    WorkOrderResourceLocalJson trx =
        WorkOrderResourceLocalJson.fromJson(jsonDecode(res.readAsStringSync()));

    var url =
        Uri.parse('http://' + ip + '/api/v1/models/MP_Maintain_Resource/$id');

    if (isConnected) {
      emptyAPICallStak();
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //print("done!");
        Get.snackbar(
          "Fatto!",
          "Il record è stato eliminato",
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        Get.snackbar(
          "Errore!",
          "Record non eliminato",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      List<dynamic> list = [];
      if (GetStorage().read('deleteCallList') == null) {
        var call = jsonEncode({
          "url": 'http://' + ip + '/api/v1/models/MP_Maintain_Resource/$id',
        });

        list.add(call);
      } else {
        list = GetStorage().read('deleteCallList');
        var call = jsonEncode({
          "url": 'http://' + ip + '/api/v1/models/MP_Maintain_Resource/$id',
        });
        list.add(call);
      }
      GetStorage().write('deleteCallList', list);
      Get.snackbar(
        "Salvato!",
        "Il record è stato salvato localmente in attesa di connessione internet.",
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
    }
    if (GetStorage().read('postCallList') != null &&
        (GetStorage().read('postCallList')).isEmpty == false) {
      List<dynamic> list2 = GetStorage().read('postCallList');

      for (var element in list2) {
        var json = jsonDecode(element);
        if (json["offlineid"] == trx.records![index].offlineId) {
          list2.remove(element);
        }
        //print(element);
        //print(json["url"]);
      }
      GetStorage().write('postCallList', list2);
    }
    lastIndex -= 1;
    _trx.records!.removeAt(index);
    _trx.rowcount = trx.rowcount! - 1;
    var data = jsonEncode(_trx.toJson());
    res.writeAsStringSync(data);
    //GetStorage().write('workOrderResourceSync', data);
    //Get.find<MaintenanceMpResourceController>().getWorkOrders();
  }

  void handleAddRows() {
    final newRows = stateManager.getNewRows(count: 1);

    /* for (var e in newRows) {
      e.cells['status']!.value = 'created';
    } */

    stateManager.appendRows(newRows);

    stateManager.setCurrentCell(
      newRows.first.cells.entries.first.value,
      stateManager.refRows.length - 1,
    );

    stateManager.moveScrollByRow(
      PlutoMoveDirection.down,
      stateManager.refRows.length - 2,
    );

    stateManager.setKeepFocus(true);
  }

  createWorkOrderResource(bool isConnected) async {
    //print(now);
    DateTime dateToday = DateTime.now();
    //String date = dateToday.toString().substring(0,10);
    const filename = "reflistresourcetype";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    //print(GetStorage().read('selectedTaskId'));

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "MP_Maintain_ID": {"id": GetStorage().read('selectedTaskDocNo')},
      "M_Product_ID": {"id": lastProd.id},
      "IsActive": true,
      "ResourceType": {"id": "BP"},
      // "LIT_ResourceType": {"id": dropDownValue},
      "ResourceQty": 1,
      "LIT_Control3DateFrom": dateToday.toString().substring(0, 10),
      "LIT_Control2DateFrom": dateToday.toString().substring(0, 10),
      "LIT_Control1DateFrom": dateToday.toString().substring(0, 10),
      "V_Number": "0",
      /*  "Name": noteFieldController.text,
      "SerNo": sernoFieldController.text,
      "LocationComment": locationFieldController.text,
      "Value": locationCodeFieldController.text,
      "Manufacturer": manufacturerFieldController.text,
      "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
      "UseLifeYears": int.parse(useLifeYearsFieldController.text),
      "LIT_ProductModel": productModelFieldController.text,
      "Lot": lotFieldController.text,
      "DateOrdered": dateOrdered,
      "ServiceDate": firstUseDate,
      "UserName": userNameFieldController.text,
      "ProdCode": barcodeFieldController.text,
      "TextDetails": cartelFieldController.text */
    });

    WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));
    MProductID prod = lastProd;
    ResourceType res =
        ResourceType(id: "BP", identifier: "Parti Scheda Prodotto");

    EDIType edt = EDIType(id: "A2");
    RRecords record = RRecords(
        mProductID: prod,
        mpMaintainID: MPMaintainID(id: GetStorage().read('selectedTaskDocNo')),
        //mpOtDocumentno: GetStorage().read('selectedTaskDocNo'),
        resourceType: res,
        resourceQty: 1,
        eDIType: edt,
        lITControl3DateFrom: dateToday.toString().substring(0, 10),
        lITControl2DateFrom: dateToday.toString().substring(0, 10),
        lITControl1DateFrom: dateToday.toString().substring(0, 10),
        number: "0"
        /* name: noteFieldController.text,
        serNo: sernoFieldController.text,
        locationComment: locationFieldController.text,
        value: locationCodeFieldController.text,
        manufacturer: manufacturerFieldController.text,
        manufacturedYear: int.parse(manufacturedYearFieldController.text),
        useLifeYears: int.parse(useLifeYearsFieldController.text),
        lITProductModel: productModelFieldController.text,
        lot: lotFieldController.text,
        dateOrdered: dateOrdered,
        serviceDate: firstUseDate,
        userName: userNameFieldController.text,
        prodCode: barcodeFieldController.text,
        textDetails: cartelFieldController.text */
        );

    var url = Uri.parse('http://' +
        ip +
        '/api/v1/windows/maintenance-item/tabs/${"maintenance".tr}/${GetStorage().read('selectedTaskDocNo')}/${"mp-resources".tr}');
    if (isConnected) {
      if (kDebugMode) {
        print(msg);
      }
      emptyAPICallStak();
      var response = await http.post(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 201) {
        var record = RRecords.fromJson(jsonDecode(response.body));
        //lastIndex += 1;
        //var edi = EDIType(id: "A2");
        record.eDIType = EDIType(id: "A2");
        _trx.records!.add(record);
        final res = File(
            '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
        res.writeAsStringSync(jsonEncode(_trx.toJson()));
        //print("done!");
        if (kDebugMode) {
          print(response.body);
        }
        PlutoRow row = PlutoRow(cells: {
          'offlineid': PlutoCell(value: -1),
          'index': PlutoCell(value: lastIndex + 1),
          'id': PlutoCell(value: record.id),
          'V_Number': PlutoCell(value: "0"),
          'LocationComment': PlutoCell(value: ''),
          'ProdCode': PlutoCell(value: ''),
          'SerNo': PlutoCell(value: ''),
          'TextDetails': PlutoCell(value: ''),
          'Manufacturer': PlutoCell(value: ''),
          'ManufacturedYear': PlutoCell(value: 0),
          'LIT_Control1DateFrom': PlutoCell(value: ''),
          'LIT_Control2DateFrom': PlutoCell(value: ''),
          'LIT_Control3DateFrom': PlutoCell(value: ''),
          'Name': PlutoCell(value: ''),
          'M_Product_ID': PlutoCell(value: lastProd.identifier),
        });
        lastIndex += 1;
        List<PlutoRow> newRows = [];
        newRows.add(row);
        stateManager.appendRows(newRows);
        stateManager.setCurrentCell(
          newRows.first.cells.entries.first.value,
          stateManager.refRows.length - 1,
        );

        stateManager.moveScrollByRow(
          PlutoMoveDirection.down,
          stateManager.refRows.length - 2,
        );

        stateManager.setKeepFocus(true);
        //syncWorkOrder();
        Get.snackbar(
          "Done!".tr,
          "The record has been created".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        if (kDebugMode) {
          print(response.body);
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
    } else {
      record.offlineId = GetStorage().read('postCallId');
      List<dynamic> list = [];
      if (GetStorage().read('postCallList') == null) {
        var call = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": 'http://' +
              ip +
              '/api/v1/windows/maintenance-item/tabs/maintenance/${GetStorage().read('selectedTaskDocNo')}/${"mp-resources".tr}',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "MP_Maintain_ID": {"id": GetStorage().read('selectedTaskDocNo')},
          "M_Product_ID": {"id": lastProd.id},
          "IsActive": true,
          "ResourceType": {"id": "BP"},
          //"LIT_ResourceType": {"id": dropDownValue},
          "ResourceQty": 1,
          "LIT_Control3DateFrom": dateToday.toString().substring(0, 10),
          "LIT_Control2DateFrom": dateToday.toString().substring(0, 10),
          "LIT_Control1DateFrom": dateToday.toString().substring(0, 10),
          "V_Number": "0",
          /* "Name": noteFieldController.text,
          "SerNo": sernoFieldController.text,
          "LocationComment": locationFieldController.text,
          "Value": locationCodeFieldController.text,
          "Manufacturer": manufacturerFieldController.text,
          "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
          "UseLifeYears": int.parse(useLifeYearsFieldController.text),
          "LIT_ProductModel": productModelFieldController.text,
          "Lot": lotFieldController.text,
          "DateOrdered": dateOrdered,
          "ServiceDate": firstUseDate,
          "UserName": userNameFieldController.text,
          "ProdCode": barcodeFieldController.text,
          "TextDetails": cartelFieldController.text */
        });

        list.add(call);
      } else {
        list = GetStorage().read('postCallList');
        var call = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": 'http://' +
              ip +
              '/api/v1/windows/maintenance-item/tabs/maintenance/${GetStorage().read('selectedTaskDocNo')}/${"mp-resources".tr}',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "MP_Maintain_ID": {"id": GetStorage().read('selectedTaskDocNo')},
          "M_Product_ID": {"id": lastProd.id},
          "IsActive": true,
          "ResourceType": {"id": "BP"},
          //"LIT_ResourceType": {"id": dropDownValue},
          "ResourceQty": 1,
          "LIT_Control3DateFrom": dateToday.toString().substring(0, 10),
          "LIT_Control2DateFrom": dateToday.toString().substring(0, 10),
          "LIT_Control1DateFrom": dateToday.toString().substring(0, 10),
          "V_Number": "0",
          /* "Name": noteFieldController.text,
          "SerNo": sernoFieldController.text,
          "LocationComment": locationFieldController.text,
          "Value": locationCodeFieldController.text,
          "Manufacturer": manufacturerFieldController.text,
          "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
          "UseLifeYears": int.parse(useLifeYearsFieldController.text),
          "LIT_ProductModel": productModelFieldController.text,
          "Lot": lotFieldController.text,
          "DateOrdered": dateOrdered,
          "ServiceDate": firstUseDate,
          "ProdCode": barcodeFieldController.text,
          "TextDetails": cartelFieldController.text */
        });
        list.add(call);
      }
      PlutoRow row = PlutoRow(cells: {
        'offlineid': PlutoCell(value: GetStorage().read('postCallId')),
        'index': PlutoCell(value: lastIndex + 1),
        'id': PlutoCell(value: record.id),
        'V_Number': PlutoCell(value: "0"),
        'LocationComment': PlutoCell(value: ''),
        'ProdCode': PlutoCell(value: ''),
        'SerNo': PlutoCell(value: ''),
        'TextDetails': PlutoCell(value: ''),
        'Manufacturer': PlutoCell(value: ''),
        'ManufacturedYear': PlutoCell(value: 0),
        'LIT_Control1DateFrom':
            PlutoCell(value: dateToday.toString().substring(0, 10)),
        'LIT_Control2DateFrom':
            PlutoCell(value: dateToday.toString().substring(0, 10)),
        'LIT_Control3DateFrom':
            PlutoCell(value: dateToday.toString().substring(0, 10)),
        'Name': PlutoCell(value: ''),
        'M_Product_ID': PlutoCell(value: lastProd.identifier),
      });
      lastIndex += 1;
      List<PlutoRow> newRows = [];
      newRows.add(row);
      stateManager.appendRows(newRows);
      stateManager.setCurrentCell(
        newRows.first.cells.entries.first.value,
        stateManager.refRows.length - 1,
      );

      stateManager.moveScrollByRow(
        PlutoMoveDirection.down,
        stateManager.refRows.length - 2,
      );

      stateManager.setKeepFocus(true);
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
      final res = File(
          '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
      record.eDIType = EDIType(id: "A2");
      _trx.records!.add(record);
      //_trx.rowcount = trx.rowcount! + 1;
      var data = jsonEncode(trx.toJson());
      res.writeAsStringSync(data);
      /*  _trx = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(res.readAsStringSync())); */
      //Get.find<MaintenanceMpResourceController>().getWorkOrders();
    }
  }

  //end test grid
}

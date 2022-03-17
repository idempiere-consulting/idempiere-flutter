part of dashboard;

class MaintenanceMpResourceFireExtinguisherController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderResourceLocalJson _trx;

  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    //getADUserID();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderResourceLocalJson get trx => _trx;
  //String get value => _value.toString();

  Future<void> getWorkOrders() async {
    _dataAvailable.value = false;

    String docNo = GetStorage().read('selectedTaskDocNo');
    //print(GetStorage().read('workOrderResourceSync'));
    List<PlutoRow> newRows = [];
    int count = 0;
    if (GetStorage().read('workOrderSync') != null) {
      _trx = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(GetStorage().read('workOrderResourceSync')));

      for (var i = 0; i < _trx.records!.length; i++) {
        if (_trx.records![i].mpOtDocumentno == docNo &&
            _trx.records![i].eDIType?.id == 'A2') {
          count++;
          PlutoRow row = PlutoRow(cells: {
            'offlineid': PlutoCell(value: _trx.records![i].offlineId ?? -1),
            'index': PlutoCell(value: i),
            'id': PlutoCell(value: _trx.records![i].id),
            'N°': PlutoCell(value: count.toString()),
            'LocationComment':
                PlutoCell(value: _trx.records![i].locationComment ?? ''),
            'ProdCode': PlutoCell(value: _trx.records![i].prodCode ?? ''),
            'SerNo': PlutoCell(value: _trx.records![i].serNo ?? ''),
            'TextDetails': PlutoCell(value: _trx.records![i].textDetails ?? ''),
            'Manufacturer':
                PlutoCell(value: _trx.records![i].manufacturer ?? ''),
            'ManufacturedYear':
                PlutoCell(value: _trx.records![i].manufacturedYear),
            'ShutDownType': PlutoCell(value: ''),
            'Type': PlutoCell(value: ''),
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
        }
      }

      if (count > 0) {
        stateManager.appendRows(newRows);
      }

      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    }
  }

  //test grid

  ProductJson prod =
      ProductJson.fromJson(jsonDecode(GetStorage().read('productSync')));

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
      readOnly: true,
      title: 'N°',
      field: 'N°',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      //readOnly: true,
      title: 'Resource',
      field: 'M_Product_ID',
      type: PlutoColumnType.select(
          ((ProductJson.fromJson(jsonDecode(GetStorage().read('productSync'))))
                  .records!
                  .map((e) {
        return e.name!;
      }).toList())
              .where((element) => element.startsWith('EST.'))
              .toList()),
    ),
    PlutoColumn(
      title: 'Location',
      field: 'LocationComment',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Barcode',
      field: 'ProdCode',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Serial N°',
      field: 'SerNo',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Cartel',
      field: 'TextDetails',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Manufacturer',
      field: 'Manufacturer',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Year',
      field: 'ManufacturedYear',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'ShutDown Type',
      field: 'ShutDownType',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Type',
      field: 'Type',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Check',
      field: 'LIT_Control1DateFrom',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Revision',
      field: 'LIT_Control2DateFrom',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Testing',
      field: 'LIT_Control3DateFrom',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Observations',
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
    PlutoColumnGroup(title: 'Identification', fields: [
      'N°',
      'M_Product_ID'
          'LocationComment',
      'ProdCode',
      'SerNo',
      'TextDetails',
      'Manufacturer',
      'ManufacturedYear'
    ]),
    PlutoColumnGroup(title: 'Activities', fields: [
      'ShutDownType',
      'Type',
      'LIT_Control1DateFrom',
      'LIT_Control2DateFrom',
      'LIT_Control3DateFrom'
    ]),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;
  var offline = -1;

  Future<void> handleEditTextRows(
      int id, dynamic value, String field, int index) async {
    var isConnected = await checkConnection();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    var msg = jsonEncode({"id": id, field: value});

    WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync')));

    if (id != null && offline == -1) {
      //trx.records![index]. = value;

      switch (field) {
        case 'LocationComment':
          trx.records![index].locationComment = value;
          break;
        case 'SerNo':
          trx.records![index].serNo = value;
          break;
        case 'ManufacturedYear':
          trx.records![index].manufacturedYear = value;
          break;
        case 'LIT_Control1DateFrom':
          trx.records![index].lITControl1DateFrom = value;
          break;
        case 'LIT_Control2DateFrom':
          trx.records![index].lITControl2DateFrom = value;
          break;
        case 'LIT_Control3DateFrom':
          trx.records![index].lITControl3DateFrom = value;
          break;
        case 'Name':
          trx.records![index].name = value;
          break;
        case 'ProdCode':
          trx.records![index].prodCode = value;
          break;
        case 'TextDetails':
          trx.records![index].textDetails = value;
          break;
        case 'M_Product_ID':
          for (var i = 0; i < prod.records!.length; i++) {
            if (prod.records![i].name == value) {
              msg = jsonEncode({
                "id": id,
                field: {"id": prod.records![i].id}
              });

              trx.records![index].mProductID?.id = prod.records![i].id;
              trx.records![index].mProductID?.identifier =
                  prod.records![i].name;
            }
          }

          break;
        default:
      }

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/preventive-maintenance/tabs/resources/$id');
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
          GetStorage().write('workOrderResourceSync', data);
          //getWorkOrders();
          Get.find<MaintenanceMpResourceController>().getWorkOrders();
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
          //print(response.body);
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
        var data = jsonEncode(trx.toJson());
        GetStorage().write('workOrderSync', data);
        //getWorkOrders();
        Get.find<MaintenanceMpResourceController>().getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/$id'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/preventive-maintenance/tabs/resources/$id'] =
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

    /* if (offline != -1) {
      List<dynamic> list = GetStorage().read('postCallList');

      for (var i = 0; i < list.length; i++) {
        var json = jsonDecode(list[i]);
        if (json["offlineid"] == _trx.records![index].offlineId) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            field: value
          });

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
    } */

    //print(msg);
  }

  //end test grid
}

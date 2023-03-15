// ignore_for_file: library_private_types_in_public_api

part of dashboard;

class MaintenanceMpResourceController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderResourceLocalJson _trx;
  late WorkOrderResourceLocalJson _trx2;
  late RefListResourceTypeJson
      _tt /* = RefListResourceTypeJson.fromJson(
      jsonDecode(GetStorage().read('refListResourceTypeCategory'))) */
      ;
  late RefListResourceTypeJson
      _tt2 /* = RefListResourceTypeJson.fromJson(
      jsonDecode(GetStorage().read('refListResourceTypeCategory'))) */
      ;
  late RefListResourceTypeJson
      _tt3 /* = RefListResourceTypeJson.fromJson(
      jsonDecode(GetStorage().read('refListResourceTypeCategory'))) */
      ;
  //var _hasMailSupport = false;
  var args = Get.arguments;
  var offline = -1;

  var sell = false.obs;

  var dropDownValue = "A01";
  var dropDownValue2 = "0".obs;
  var dropDownValue3 = "0".obs;

  // ignore: prefer_typing_uninitialized_variables
  //var adUserId;
  DateTime now = DateTime.now();

  var value = "All".tr.obs;

  var filters = [
    "All".tr,
    "Installed".tr,
    "Unchecked".tr,
    "Checked".tr,
    'Retired'.tr,
  ];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  var filter1Available = false.obs;
  var filter2Available = false.obs;
  var filter3Available = false.obs;

  bool init = true;

  TextEditingController passwordFieldController = TextEditingController();
  TextEditingController newLocationCommentFieldController =
      TextEditingController();
  TextEditingController numberFieldController = TextEditingController();
  TextEditingController lineFieldController = TextEditingController();

  final json = {
    "types": [
      {"id": "IRV", "name": "IRV".tr},
      {"id": "IRR", "name": "IRR".tr},
      {"id": "IRX", "name": "IRX".tr},
      {"id": "REV", "name": "REV".tr},
      {"id": "INS", "name": "INS".tr},
      {"id": "DEL", "name": "DEL".tr},
      {"id": "RNR", "name": "RNR".tr},
      {"id": "OUT", "name": "OUT".tr},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  final json2 = {
    "types": [
      {"id": "1", "name": "Barcode".tr},
      {"id": "2", "name": "Serial N°".tr},
      {"id": "3", "name": "Location".tr},
      {"id": "4", "name": "N°".tr},
    ]
  };

  List<Types>? getFilterTypes() {
    var dJson = TypeJson.fromJson(json2);

    return dJson.types;
  }

  @override
  void onInit() {
    dropDownList = getFilterTypes()!;
    initializeFilters();

    super.onInit();

    //getADUserID();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderResourceLocalJson get trx => _trx;
  RefListResourceTypeJson get tt => _tt;
  RefListResourceTypeJson get tt2 => _tt2;
  //String get value => _value.toString();

  Future<void> initializeFilters() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/reflistresourcetypecategory.json');
    const filename = "listresourcegroup";
    final file2 = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    _tt3 =
        RefListResourceTypeJson.fromJson(jsonDecode(file2.readAsStringSync()));

    _tt3.records!.retainWhere((element) =>
        element.mpMaintain3ID?.id == GetStorage().read('selectedTaskDocNo'));

    _tt2 =
        RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));

    _tt = RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));

    _tt2.records?.insert(0, RefRecords(value: "0", name: "All Types".tr));

    _tt3.records?.insert(0, RefRecords(id: 0, name: "All Group Locations".tr));

    filter1Available.value = true;
    filter2Available.value = true;
    filter3Available.value = true;
    getWorkOrders();
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 5) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getWorkOrders();
  }

  String getPerm(String type) {
    for (var i = 0; i < _tt.records!.length; i++) {
      if (_tt.records![i].value == type) {
        return _tt.records![i].parameterValue!;
      }
    }
    return "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
  }

  reviewResourceButton(int index) {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    Get.defaultDialog(
      title: "${"Resource Code".tr}:",
      content: RoundedCodeField(
        controller: passwordFieldController,
        onChanged: (value) {},
      ),
      barrierDismissible: true,
      textConfirm: 'Replace'.tr,
      textCancel: 'Revision'.tr,
      onCancel: () async {
        var isConnected = await checkConnection();
        editWorkOrderResourceDateRevision(isConnected, index);
        //Get.back();
      },
      buttonColor: kNotifColor,
      onConfirm: () async {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");

        String date = dateFormat.format(DateTime.now());

        var isConnected = await checkConnection();
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

        // ignore: unused_local_variable
        var res = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(file.readAsStringSync()));
        var count = 0;
        for (var i = 0; i < _trx2.records!.length; i++) {
          //print(res.records![i].prodCode);
          if (_trx2.records![i].prodCode == passwordFieldController.text) {
            count++;
            var msg = jsonEncode({
              "MP_Maintain_ID": {
                "id": _trx.records![index].mpMaintainID?.id,
              },
              "LIT_Control1DateFrom": date,
              "LocationComment": _trx.records![index].locationComment,
              "V_Number": _trx.records![index].number,
              "LineNo": _trx.records![index].lineNo,
              "LIT_ResourceStatus": {"id": "INS"},
              "AD_User_ID": {"id": GetStorage().read('userId')},
              "LIT_ResourceActivity": {"id": "CHK"}
            });

            if (_trx.records![index].litResourceGroupID != null) {
              msg = jsonEncode({
                "MP_Maintain_ID": {
                  "id": _trx.records![index].mpMaintainID?.id,
                },
                "LIT_Control1DateFrom": date,
                "LocationComment": _trx.records![index].locationComment,
                "V_Number": _trx.records![index].number,
                "LineNo": _trx.records![index].lineNo,
                "LIT_ResourceStatus": {"id": "INS"},
                "AD_User_ID": {"id": GetStorage().read('userId')},
                "LIT_ResourceActivity": {"id": "CHK"},
                "lit_ResourceGroup_ID": {
                  "id": _trx.records![index].litResourceGroupID?.id
                }
              });
              _trx2.records![i].litResourceGroupID =
                  _trx.records![index].litResourceGroupID;
            }

            _trx2.records![i].mpMaintainID = _trx.records![index].mpMaintainID;
            _trx2.records![i].lITControl1DateFrom = date;
            _trx2.records![i].number = _trx.records![index].number;
            _trx2.records![i].lineNo = _trx.records![index].lineNo;
            _trx2.records![i].locationComment =
                _trx.records![index].locationComment;
            _trx2.records![i].resourceStatus =
                ResourceStatus(id: "INS", identifier: "INS".tr);
            _trx2.records![i].doneAction = "Checked";
            _trx2.records![i].toDoAction = "OK";

            //print(_trx.records![index].mpMaintainID?.id);
            /*  print('http://' +
                ip +
                '/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'); */
            var url = Uri.parse(
                '$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}');
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
                //print(response.body);
                var data = jsonEncode(_trx2.toJson());
                file.writeAsStringSync(data);
                //getWorkOrders();
                //print("done!");
                //Get.back();
                Get.back();
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
              var data = jsonEncode(_trx2.toJson());
              //GetStorage().write('workOrderSync', data);
              file.writeAsStringSync(data);
              //getWorkOrders();
              Map calls = {};
              if (GetStorage().read('storedEditAPICalls') == null) {
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              } else {
                calls = GetStorage().read('storedEditAPICalls');
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              }
              GetStorage().write('storedEditAPICalls', calls);
              Get.snackbar(
                "Salvato!",
                "Il record è stato salvato localmente in attesa di connessione internet.",
                icon: const Icon(
                  Icons.save,
                  color: Colors.yellow,
                ),
              );
            }

            for (var i2 = 0; i2 < _trx2.records!.length; i2++) {
              if (_trx.records![index].id == _trx2.records![i2].id) {
                _trx2.records![i2].resourceStatus =
                    ResourceStatus(id: "IRV", identifier: "IRV".tr);
                var msg = jsonEncode({
                  "LIT_ResourceStatus": {"id": "IRV"},
                });
                var url = Uri.parse(
                    '$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}');
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
                    if (kDebugMode) {
                      print(response.body);
                    }
                    var data = jsonEncode(_trx2.toJson());
                    file.writeAsStringSync(data);
                    //getWorkOrders();
                    //print("done!");
                    //Get.back();
                    /* Get.snackbar(
                      "Fatto!",
                      "Il record è stato modificato",
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ); */
                  } else {
                    //print(response.body);
                    //print(response.statusCode);
                    /* Get.snackbar(
                      "Errore!",
                      "Il record non è stato modificato",
                      icon: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ); */
                  }
                } else {
                  var data = jsonEncode(_trx2.toJson());
                  //GetStorage().write('workOrderSync', data);
                  file.writeAsStringSync(data);
                  //getWorkOrders();
                  Map calls = {};
                  if (GetStorage().read('storedEditAPICalls') == null) {
                    calls['$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}'] =
                        msg;
                  } else {
                    calls = GetStorage().read('storedEditAPICalls');
                    calls['$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}'] =
                        msg;
                  }
                  GetStorage().write('storedEditAPICalls', calls);
                  /* Get.snackbar(
                    "Salvato!",
                    "Il record è stato salvato localmente in attesa di connessione internet.",
                    icon: const Icon(
                      Icons.save,
                      color: Colors.red,
                    ),
                  ); */
                }
              }
            }
            getWorkOrders();
          }
        }
        if (count == 0) {
          Get.snackbar(
            "Error!".tr,
            "Barcode not found!",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        }
      },
    );
  }

  testingResourceButton(int index) {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    Get.defaultDialog(
      title: "${"Resource Code".tr}:",
      content: RoundedCodeField(
        controller: passwordFieldController,
        onChanged: (value) {},
      ),
      barrierDismissible: true,
      textConfirm: 'Replace'.tr,
      textCancel: 'Testing'.tr,
      onCancel: () async {
        var isConnected = await checkConnection();
        editWorkOrderResourceDateTesting(isConnected, index);
        //Get.back();
      },
      buttonColor: kNotifColor,
      onConfirm: () async {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");

        String date = dateFormat.format(DateTime.now());

        var isConnected = await checkConnection();
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

        // ignore: unused_local_variable
        var res = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(file.readAsStringSync()));
        var count = 0;
        for (var i = 0; i < _trx2.records!.length; i++) {
          //print(res.records![i].prodCode);
          if (_trx2.records![i].prodCode == passwordFieldController.text) {
            count++;
            var msg = jsonEncode({
              "MP_Maintain_ID": {
                "id": _trx.records![index].mpMaintainID?.id,
              },
              "LIT_Control1DateFrom": date,
              "LocationComment": _trx.records![index].locationComment,
              "V_Number": _trx.records![index].number,
              "LineNo": _trx.records![index].lineNo,
              "LIT_ResourceStatus": {"id": "INS"},
              "AD_User_ID": {"id": GetStorage().read('userId')},
              "LIT_ResourceActivity": {"id": "CHK"}
            });

            if (_trx.records![index].litResourceGroupID != null) {
              msg = jsonEncode({
                "MP_Maintain_ID": {
                  "id": _trx.records![index].mpMaintainID?.id,
                },
                "LIT_Control1DateFrom": date,
                "LocationComment": _trx.records![index].locationComment,
                "V_Number": _trx.records![index].number,
                "LineNo": _trx.records![index].lineNo,
                "LIT_ResourceStatus": {"id": "INS"},
                "AD_User_ID": {"id": GetStorage().read('userId')},
                "LIT_ResourceActivity": {"id": "CHK"},
                "lit_ResourceGroup_ID": {
                  "id": _trx.records![index].litResourceGroupID?.id
                }
              });
              _trx2.records![i].litResourceGroupID =
                  _trx.records![index].litResourceGroupID;
            }

            _trx2.records![i].mpMaintainID = _trx.records![index].mpMaintainID;
            _trx2.records![i].lITControl1DateFrom = date;
            _trx2.records![i].number = _trx.records![index].number;
            _trx2.records![i].lineNo = _trx.records![index].lineNo;
            _trx2.records![i].locationComment =
                _trx.records![index].locationComment;
            _trx2.records![i].resourceStatus =
                ResourceStatus(id: "INS", identifier: "INS".tr);
            _trx2.records![i].doneAction = "Checked";
            _trx2.records![i].toDoAction = "OK";

            //print(_trx.records![index].mpMaintainID?.id);
            /*  print('http://' +
                ip +
                '/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'); */
            var url = Uri.parse(
                '$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}');
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
                //print(response.body);
                var data = jsonEncode(_trx2.toJson());
                file.writeAsStringSync(data);
                //getWorkOrders();
                //print("done!");
                //Get.back();
                Get.back();
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
              var data = jsonEncode(_trx2.toJson());
              //GetStorage().write('workOrderSync', data);
              file.writeAsStringSync(data);
              //getWorkOrders();
              Map calls = {};
              if (GetStorage().read('storedEditAPICalls') == null) {
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              } else {
                calls = GetStorage().read('storedEditAPICalls');
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              }
              GetStorage().write('storedEditAPICalls', calls);
              Get.snackbar(
                "Salvato!",
                "Il record è stato salvato localmente in attesa di connessione internet.",
                icon: const Icon(
                  Icons.save,
                  color: Colors.yellow,
                ),
              );
            }

            for (var i2 = 0; i2 < _trx2.records!.length; i2++) {
              if (_trx.records![index].id == _trx2.records![i2].id) {
                _trx2.records![i2].resourceStatus =
                    ResourceStatus(id: "IRV", identifier: "IRV".tr);
                var msg = jsonEncode({
                  "LIT_ResourceStatus": {"id": "IRV"},
                });
                var url = Uri.parse(
                    '$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}');
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
                    if (kDebugMode) {
                      print(response.body);
                    }
                    var data = jsonEncode(_trx2.toJson());
                    file.writeAsStringSync(data);
                    //getWorkOrders();
                    //print("done!");
                    //Get.back();
                    /* Get.snackbar(
                      "Fatto!",
                      "Il record è stato modificato",
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ); */
                  } else {
                    //print(response.body);
                    //print(response.statusCode);
                    /* Get.snackbar(
                      "Errore!",
                      "Il record non è stato modificato",
                      icon: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ); */
                  }
                } else {
                  var data = jsonEncode(_trx2.toJson());
                  //GetStorage().write('workOrderSync', data);
                  file.writeAsStringSync(data);
                  //getWorkOrders();
                  Map calls = {};
                  if (GetStorage().read('storedEditAPICalls') == null) {
                    calls['$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}'] =
                        msg;
                  } else {
                    calls = GetStorage().read('storedEditAPICalls');
                    calls['$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}'] =
                        msg;
                  }
                  GetStorage().write('storedEditAPICalls', calls);
                  /* Get.snackbar(
                    "Salvato!",
                    "Il record è stato salvato localmente in attesa di connessione internet.",
                    icon: const Icon(
                      Icons.save,
                      color: Colors.red,
                    ),
                  ); */
                }
              }
            }
            getWorkOrders();
          }
        }
        if (count == 0) {
          Get.snackbar(
            "Error!".tr,
            "Barcode not found!",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        }
      },
    );
  }

  sellResource() {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    Get.defaultDialog(
      title: "${"Resource Code".tr}:",
      content: Column(
        children: [
          RoundedCodeField(
            controller: passwordFieldController,
            onChanged: (value) {},
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: numberFieldController,
              onChanged: (value) {
                lineFieldController.text =
                    (int.parse(numberFieldController.text) * 10).toString();
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_pin_outlined),
                border: const OutlineInputBorder(),
                labelText: 'N°'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: lineFieldController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_pin_outlined),
                border: const OutlineInputBorder(),
                labelText: 'Line N°'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: newLocationCommentFieldController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_pin_outlined),
                border: const OutlineInputBorder(),
                labelText: 'Location'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
      textConfirm: 'Add'.tr,
      buttonColor: kNotifColor,
      onConfirm: () async {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");

        String date = dateFormat.format(DateTime.now());

        var isConnected = await checkConnection();
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

        // ignore: unused_local_variable
        var res = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(file.readAsStringSync()));

        for (var i = 0; i < _trx2.records!.length; i++) {
          if (_trx2.records![i].prodCode == passwordFieldController.text) {
            //print('trovato');
            var msg = jsonEncode({
              "MP_Maintain_ID": {
                "id": GetStorage().read('selectedTaskDocNo'),
              },
              "LIT_Control1DateFrom": date,
              "LocationComment": newLocationCommentFieldController.text,
              "V_Number": numberFieldController.text,
              "LineNo": int.parse(lineFieldController.text == ""
                  ? "0"
                  : lineFieldController.text),
              "LIT_ResourceStatus": {"id": "INS"},
            });

            _trx2.records![i].mpMaintainID?.id =
                GetStorage().read('selectedTaskDocNo');
            _trx2.records![i].lITControl1DateFrom = date;
            _trx2.records![i].number = numberFieldController.text;
            _trx2.records![i].lineNo = int.parse(lineFieldController.text == ""
                ? "0"
                : lineFieldController.text);
            _trx2.records![i].locationComment =
                newLocationCommentFieldController.text;
            _trx2.records![i].resourceStatus =
                ResourceStatus(id: "INS", identifier: "INS".tr);

            //print(_trx.records![index].mpMaintainID?.id);
            /*  print('http://' +
                ip +
                '/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'); */
            var url = Uri.parse(
                '$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}');
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
                var data = jsonEncode(_trx2.toJson());
                file.writeAsStringSync(data);
                //getWorkOrders();
                //print("done!");
                //Get.back();
                Get.back();
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
              var data = jsonEncode(_trx2.toJson());
              //GetStorage().write('workOrderSync', data);
              file.writeAsStringSync(data);
              //getWorkOrders();
              Map calls = {};
              if (GetStorage().read('storedEditAPICalls') == null) {
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              } else {
                calls = GetStorage().read('storedEditAPICalls');
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              }
              GetStorage().write('storedEditAPICalls', calls);
              Get.snackbar(
                "Salvato!",
                "Il record è stato salvato localmente in attesa di connessione internet.",
                icon: const Icon(
                  Icons.save,
                  color: Colors.yellow,
                ),
              );
            }

            getWorkOrders();
          }
        }
      },
    );
  }

  replaceResourceButton(int index) {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    Get.defaultDialog(
      title: "${"Resource Code".tr}:",
      content: Column(
        children: [
          RoundedCodeField(
            controller: passwordFieldController,
            onChanged: (value) {},
          ),
          Obx(
            () => CheckboxListTile(
              title: Text('Sold'.tr),
              value: sell.value,
              activeColor: kPrimaryColor,
              onChanged: (bool? value) {
                sell.value = value!;
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          )
        ],
      ),
      barrierDismissible: true,
      onCustom: () {},
      textConfirm: 'Replace'.tr,
      buttonColor: kNotifColor,
      textCancel: 'Cancel'.tr,
      onConfirm: () async {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");

        String date = dateFormat.format(DateTime.now());

        var isConnected = await checkConnection();
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

        // ignore: unused_local_variable
        var res = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(file.readAsStringSync()));
        var count = 0;
        for (var i = 0; i < _trx2.records!.length; i++) {
          //print(res.records![i].prodCode);
          if (_trx2.records![i].prodCode == passwordFieldController.text) {
            count++;
            var msg = jsonEncode({
              "MP_Maintain_ID": {
                "id": _trx.records![index].mpMaintainID?.id,
              },
              "LIT_Control1DateFrom": date,
              "LocationComment": _trx.records![index].locationComment,
              "V_Number": _trx.records![index].number,
              "LineNo": _trx.records![index].lineNo,
              "LIT_ResourceStatus": {"id": "INS"},
              "AD_User_ID": {"id": GetStorage().read('userId')},
              "LIT_ResourceActivity": {"id": "CHK"},
              "IsSold": sell.value,
            });

            if (_trx.records![index].litResourceGroupID != null) {
              msg = jsonEncode({
                "MP_Maintain_ID": {
                  "id": _trx.records![index].mpMaintainID?.id,
                },
                "LIT_Control1DateFrom": date,
                "LocationComment": _trx.records![index].locationComment,
                "V_Number": _trx.records![index].number,
                "LineNo": _trx.records![index].lineNo,
                "LIT_ResourceStatus": {"id": "INS"},
                "AD_User_ID": {"id": GetStorage().read('userId')},
                "LIT_ResourceActivity": {"id": "CHK"},
                "lit_ResourceGroup_ID": {
                  "id": _trx.records![index].litResourceGroupID?.id
                },
                "IsSold": sell.value,
              });
              _trx2.records![i].litResourceGroupID =
                  _trx.records![index].litResourceGroupID;
            }

            _trx2.records![i].mpMaintainID = _trx.records![index].mpMaintainID;
            _trx2.records![i].lITControl1DateFrom = date;
            _trx2.records![i].number = _trx.records![index].number;
            _trx2.records![i].lineNo = _trx.records![index].lineNo;
            _trx2.records![i].locationComment =
                _trx.records![index].locationComment;
            _trx2.records![i].resourceStatus =
                ResourceStatus(id: "INS", identifier: "INS".tr);
            _trx2.records![i].doneAction = "Checked";
            _trx2.records![i].toDoAction = "OK";
            _trx2.records![i].isSold = sell.value;

            //print(_trx.records![index].mpMaintainID?.id);
            /*  print('http://' +
                ip +
                '/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'); */
            var url = Uri.parse(
                '$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}');
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
                //print(response.body);
                var data = jsonEncode(_trx2.toJson());
                file.writeAsStringSync(data);
                //getWorkOrders();
                //print("done!");
                Get.back();
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
              var data = jsonEncode(_trx2.toJson());
              //GetStorage().write('workOrderSync', data);
              file.writeAsStringSync(data);
              //getWorkOrders();
              Map calls = {};
              if (GetStorage().read('storedEditAPICalls') == null) {
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              } else {
                calls = GetStorage().read('storedEditAPICalls');
                calls['$protocol://$ip/api/v1/windows/maintenance-resource/${_trx2.records![i].id}'] =
                    msg;
              }
              GetStorage().write('storedEditAPICalls', calls);
              Get.snackbar(
                "Salvato!",
                "Il record è stato salvato localmente in attesa di connessione internet.",
                icon: const Icon(
                  Icons.save,
                  color: Colors.yellow,
                ),
              );
            }

            for (var i2 = 0; i2 < _trx2.records!.length; i2++) {
              if (_trx.records![index].id == _trx2.records![i2].id) {
                _trx2.records![i2].resourceStatus =
                    ResourceStatus(id: "IRX", identifier: "IRX".tr);
                var msg = jsonEncode({
                  "LIT_ResourceStatus": {"id": "IRX"},
                });
                var url = Uri.parse(
                    '$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}');
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
                    //print(response.body);
                    var data = jsonEncode(_trx2.toJson());
                    file.writeAsStringSync(data);
                    //getWorkOrders();
                    //print("done!");
                    //Get.back();
                    /* Get.snackbar(
                      "Fatto!",
                      "Il record è stato modificato",
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ); */
                  } else {
                    //print(response.body);
                    //print(response.statusCode);
                    /* Get.snackbar(
                      "Errore!",
                      "Il record non è stato modificato",
                      icon: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ); */
                  }
                } else {
                  var data = jsonEncode(_trx2.toJson());
                  //GetStorage().write('workOrderSync', data);
                  file.writeAsStringSync(data);
                  //getWorkOrders();
                  Map calls = {};
                  if (GetStorage().read('storedEditAPICalls') == null) {
                    calls['$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}'] =
                        msg;
                  } else {
                    calls = GetStorage().read('storedEditAPICalls');
                    calls['$protocol://$ip/api/v1/windows/maintenance-resource/${trx.records![index].id}'] =
                        msg;
                  }
                  GetStorage().write('storedEditAPICalls', calls);
                  /* Get.snackbar(
                    "Salvato!",
                    "Il record è stato salvato localmente in attesa di connessione internet.",
                    icon: const Icon(
                      Icons.save,
                      color: Colors.red,
                    ),
                  ); */
                }
              }
            }
            getWorkOrders();
            Get.back();
          }
        }
        if (count == 0) {
          Get.snackbar(
            "Error!".tr,
            "Barcode not found!",
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
        }
      },
    );
  }

  openResourceType() {
    Get.defaultDialog(
      title: "Resource Type".tr,
      //middleText: "Choose the type of Ticket you want to create",
      //contentPadding: const EdgeInsets.all(2.0),
      content: DropdownButton(
        value: dropDownValue,
        style: const TextStyle(fontSize: 12.0),
        elevation: 16,
        onChanged: (String? newValue) async {
          dropDownValue = newValue!;
          //print(newValue);
          Get.back();
          const filename = "reflistresourcetype";
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
          switch (newValue) {
            case "A02NEW":
              sellResource();
              break;
            case "A02SEDE":
              for (var i = 0; i < _tt.records!.length; i++) {
                if (_tt.records![i].value == newValue) {
                  Get.to(const CreateMaintenanceMpResource(), arguments: {
                    "id": dropDownValue,
                    "reflistresourcetype": file,
                    "perm": _tt.records![i].parameterValue,
                    "property": true,
                  });
                }
              }
              break;
            default:
              for (var i = 0; i < _tt.records!.length; i++) {
                if (_tt.records![i].value == newValue) {
                  Get.to(const CreateMaintenanceMpResource(), arguments: {
                    "id": dropDownValue,
                    "reflistresourcetype": file,
                    "perm": _tt.records![i].parameterValue,
                    "property": false,
                  });
                }
              }
          }
        },
        items: _tt.records!.map((list) {
          return DropdownMenuItem<String>(
            value: list.value,
            child: Text(
              list.name.toString(),
            ),
          );
        }).toList(),
      ),
      barrierDismissible: true,
      /* textCancel: "Cancel",
        textConfirm: "Confirm",
        onConfirm: () {
          Get.back();
          Get.to(const CreateTicketClientTicket(),
              arguments: {"id": dropdownValue});
        } */
    );
  }

  editWorkOrderResourceDateCheck(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String date = dateFormat.format(DateTime.now());

    final protocol = GetStorage().read('protocol');

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "LIT_Control1DateFrom": date,
      "AD_User_ID": {"id": GetStorage().read("userId")},
      "LIT_ResourceActivity": {"id": "CHK"}
    });

    /*  WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].lITControl1DateFrom = date;
          _trx2.records![i].doneAction = "Checked";
          _trx2.records![i].toDoAction = "OK";
        }
      }

      var url = Uri.parse(
          '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}');
      //print(msg);
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
          _dataAvailable.value = false;
          var data = jsonEncode(_trx2.toJson());
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
          file.writeAsStringSync(data);
          //GetStorage().write('workOrderResourceSync', data);
          getWorkOrders();
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
        var data = jsonEncode(_trx2.toJson());
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
        file.writeAsStringSync(data);
        //GetStorage().write('workOrderResourceSync', data);
        getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
              msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.yellow,
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

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "LIT_Control1DateFrom": date,
            "AD_User_ID": {"id": GetStorage().read("userId")},
            "LIT_ResourceActivity": {"id": "CHK"}
          });

          list.removeAt(i);
          list.add(call);
          GetStorage().write('postCallList', list);
          Get.snackbar(
            "Salvato!",
            "Il record è stato salvato localmente in attesa di connessione internet.",
            icon: const Icon(
              Icons.save,
              color: Colors.yellow,
            ),
          );
        }
      }
    }
  }

  editWorkOrderResourceDateRevision(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String date = dateFormat.format(DateTime.now());

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "LIT_Control1DateFrom": date,
      "LIT_Control2DateFrom": date,
      "AD_User_ID": {"id": GetStorage().read("userId")},
      "LIT_ResourceActivity": {"id": "REV"}
    });

    /* WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].lITControl1DateFrom = date;
          _trx2.records![i].lITControl2DateFrom = date;
          _trx2.records![i].doneAction = "Revisioned";
          _trx2.records![i].toDoAction = "OK";
        }
      }
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse(
          '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}');
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
          var data = jsonEncode(_trx2.toJson());
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
          file.writeAsStringSync(data);
          //GetStorage().write('workOrderResourceSync', data);
          getWorkOrders();
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
        var data = jsonEncode(_trx2.toJson());
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
        file.writeAsStringSync(data);
        //GetStorage().write('workOrderResourceSync', data);
        getWorkOrders();
        //GetStorage().write('workOrderSync', data);
        getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
              msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.yellow,
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

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "LIT_Control1DateFrom": date,
            "LIT_Control2DateFrom": date,
            "AD_User_ID": {"id": GetStorage().read("userId")},
            "LIT_ResourceActivity": {"id": "REV"}
          });

          list.removeAt(i);
          list.add(call);
          GetStorage().write('postCallList', list);
          Get.snackbar(
            "Salvato!",
            "Il record è stato salvato localmente in attesa di connessione internet.",
            icon: const Icon(
              Icons.save,
              color: Colors.yellow,
            ),
          );
        }
      }
    }
  }

  editWorkOrderResourceDateTesting(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    final protocol = GetStorage().read('protocol');
    String date = dateFormat.format(DateTime.now());

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "LIT_Control1DateFrom": date,
      "LIT_Control2DateFrom": date,
      "LIT_Control3DateFrom": date,
      "AD_User_ID": {"id": GetStorage().read("userId")},
      "LIT_ResourceActivity": {"id": "TST"}
    });

    /*  WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].lITControl1DateFrom = date;
          _trx2.records![i].lITControl2DateFrom = date;
          _trx2.records![i].lITControl3DateFrom = date;
          _trx2.records![i].doneAction = "Tested";
          _trx2.records![i].toDoAction = "OK";
        }
      }

      var url = Uri.parse(
          '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}');
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
          var data = jsonEncode(_trx2.toJson());
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
          file.writeAsStringSync(data);
          //GetStorage().write('workOrderResourceSync', data);
          getWorkOrders();
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
        var data = jsonEncode(_trx2.toJson());
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');
        file.writeAsStringSync(data);
        //GetStorage().write('workOrderResourceSync', data);
        getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
              msg;
        }
        GetStorage().write('storedEditAPICalls', calls);
        Get.snackbar(
          "Salvato!",
          "Il record è stato salvato localmente in attesa di connessione internet.",
          icon: const Icon(
            Icons.save,
            color: Colors.yellow,
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

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "LIT_Control1DateFrom": date,
            "LIT_Control2DateFrom": date,
            "LIT_Control3DateFrom": date,
            "AD_User_ID": {"id": GetStorage().read("userId")},
            "LIT_ResourceActivity": {"id": "TST"}
          });

          list.removeAt(i);
          list.add(call);
          GetStorage().write('postCallList', list);
          Get.snackbar(
            "Salvato!",
            "Il record è stato salvato localmente in attesa di connessione internet.",
            icon: const Icon(
              Icons.save,
              color: Colors.yellow,
            ),
          );
        }
      }
    }
  }

  undoLastChanges(int id, String modelname) {
    //print("halo");
    Get.defaultDialog(
      title: 'Undo changes'.tr,
      content: Text("Are you sure you want to Undo?".tr),
      onCancel: () {},
      onConfirm: () async {
        final ip = GetStorage().read('ip');
        String authorization = 'Bearer ${GetStorage().read('token')}';
        final msg = jsonEncode({
          "record-id": id,
          "model-name": modelname,
        });
        //print(msg);
        final protocol = GetStorage().read('protocol');
        var url = Uri.parse(
            '$protocol://$ip/api/v1/processes/undompmaintainresource');

        var response = await http.post(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          //print("done!");
          Get.back();
          //print(response.body);
          syncSingleResource(id);
          Get.snackbar(
            "Done!".tr,
            "Record rollback successfull".tr,
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
            "Record rollback failed".tr,
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} or AD_User_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
    if (await checkConnection()) {
      _dataAvailable.value = false;
      emptyAPICallStak();
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          //print(response.body);
        }
        var json = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        if (json.pagecount! > 1) {
          int index = 1;
          syncWorkOrderResourcePages(json, index);
        } else {
          const filename = "workorderresource";
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
          file.writeAsStringSync(utf8.decode(response.bodyBytes));
          //productSync = false;
          getWorkOrders();
          if (kDebugMode) {
            print('WorkOrderResource Checked');
          }
          //checkSyncData();
        }
        //syncWorkOrderResourceSurveyLines();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } else {
      Get.snackbar(
        "Connessione Internet assente!",
        "Impossibile aggiornare i record.",
        icon: const Icon(
          Icons.signal_wifi_connected_no_internet_4,
          color: Colors.red,
        ),
      );
    }
  }

  syncWorkOrderResourcePages(WorkOrderResourceLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} or AD_User_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
        file.writeAsStringSync(jsonEncode(json.toJson()));
        //workOrderSync = false;
        getWorkOrders();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  syncSingleResource(int id) async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= lit_mp_maintain_resource_v_ID eq $id AND AD_User_ID eq ${GetStorage().read('userId')}');
    if (await checkConnection()) {
      _dataAvailable.value = false;
      emptyAPICallStak();
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
        var json = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        //print(json.records!.length);
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

        var temp = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(file.readAsStringSync()));

        //temp.records!.replaceRange(start, end, replacements)

        for (var i = 0; i < temp.records!.length; i++) {
          for (var j = 0; j < json.records!.length; j++) {
            if (temp.records![i].id == json.records![j].id) {
              temp.records!.removeAt(i);
              temp.records!.insert(i, json.records![j]);
            }
          }
        }

        /* for (var tempRecord in temp.records!) {
          for (var jsonRecord in json.records!) {
            if (jsonRecord.id == tempRecord.id) {
              print('Prima');
              print(tempRecord.lITControl1DateFrom);

              tempRecord.lITControl1DateFrom = jsonRecord.lITControl1DateFrom;
              print('Dopo');
              print(tempRecord.lITControl1DateFrom);
            }
          }
        } */
        file.writeAsStringSync(jsonEncode(temp.toJson()));
        //productSync = false;
        getWorkOrders();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();

        //syncWorkOrderResourceSurveyLines();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
  }

  Future<void> syncThisWorkOrderResource(int id) async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= MP_Maintain_ID eq $id AND (AD_User_ID eq ${GetStorage().read('userId')} OR AD_User_ID eq null)');
    if (await checkConnection()) {
      _dataAvailable.value = false;
      emptyAPICallStak();
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          //print(response.body);
        }
        var json = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        //print(json.records!.length);
        if (json.pagecount! > 1) {
          int index = 1;
          syncThisWorkOrderResourcePages(json, index, id);
        } else {
          const filename = "workorderresource";
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

          var temp = WorkOrderResourceLocalJson.fromJson(
              jsonDecode(file.readAsStringSync()));

          for (var i = 0; i < temp.records!.length; i++) {
            for (var j = 0; j < json.records!.length; j++) {
              if (temp.records![i].id == json.records![j].id) {
                temp.records!.removeAt(i);
                temp.records!.insert(i, json.records![j]);
              }
            }
          }
          file.writeAsStringSync(jsonEncode(temp.toJson()));
          //productSync = false;
          getWorkOrders();
          if (kDebugMode) {
            print('WorkOrderResource Checked');
          }
          //checkSyncData();
        }
        //syncWorkOrderResourceSurveyLines();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } else {
      Get.snackbar(
        "Connessione Internet assente!",
        "Impossibile aggiornare i record.",
        icon: const Icon(
          Icons.signal_wifi_connected_no_internet_4,
          color: Colors.red,
        ),
      );
    }
  }

  syncThisWorkOrderResourcePages(
      WorkOrderResourceLocalJson json, int index, int id) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter=MP_Maintain_ID eq $id AND (AD_User_ID eq ${GetStorage().read('userId')} OR AD_User_ID eq null)&\$skip=${(index * 100)}');

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
        syncThisWorkOrderResourcePages(json, index, id);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }

        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

        var temp = WorkOrderResourceLocalJson.fromJson(
            jsonDecode(file.readAsStringSync()));

        for (var i = 0; i < temp.records!.length; i++) {
          for (var j = 0; j < json.records!.length; j++) {
            if (temp.records![i].id == json.records![j].id) {
              temp.records!.removeAt(i);
              temp.records!.insert(i, json.records![j]);
            }
          }
        }

        file.writeAsStringSync(jsonEncode(temp.toJson()));
        //workOrderSync = false;
        getWorkOrders();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getWorkOrders() async {
    //print('hallo');
    //print(GetStorage().read('selectedTaskDocNo'));
    _dataAvailable.value = false;
    late List<RRecords> temp;
    var flag = true;
    var now = DateTime.now();
    var twentyDaysAgoDate = now.add(const Duration(days: -20));
    var twentyDaysLater = now.add(const Duration(days: 20));
    //var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    //print(GetStorage().read('workOrderResourceSync'));

    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');

    //print(file.readAsStringSync());
    //print(GetStorage().read('selectedTaskDocNo'));
    _trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    //print(_trx.records!.length);

    //print(_trx.records!.length);
    _trx2 = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    if (dropDownValue2.value != "0") {
      temp = (_trx.records!.where((element) =>
          element.eDIType?.id == dropDownValue2.value &&
          element.mpMaintainID?.id ==
              GetStorage().read('selectedTaskDocNo'))).toList();
      //print(temp);
      _trx.records = temp;
      _trx.rowcount = _trx.records?.length;
      flag = false;
    }
    if (filterCount != 0) {
      switch (filterCount) {
        case 1:
          temp = (_trx.records!.where((element) =>
              element.resourceStatus!.id == "INS" &&
              element.mpMaintainID?.id ==
                  GetStorage().read('selectedTaskDocNo'))).toList();
          //print(temp);
          _trx.records = temp;
          _trx.rowcount = _trx.records?.length;
          flag = false;
          break;
        case 2:
          temp = (_trx.records!.where((element) =>
              (DateTime.parse(element.lITControl1DateFrom!)
                      .isAfter(twentyDaysLater) ||
                  DateTime.parse(element.lITControl1DateFrom!)
                      .isBefore(twentyDaysAgoDate)) &&
              element.mpMaintainID?.id ==
                  GetStorage().read('selectedTaskDocNo') &&
              element.resourceStatus!.id == "INS")).toList();
          //print(temp);
          _trx.records = temp;
          _trx.rowcount = _trx.records?.length;
          flag = false;
          break;
        case 3:
          temp = (_trx.records!.where((element) =>
              (DateTime.parse(element.lITControl1DateFrom!)
                      .isBefore(twentyDaysLater) &&
                  DateTime.parse(element.lITControl1DateFrom!)
                      .isAfter(twentyDaysAgoDate)) &&
              element.mpMaintainID?.id ==
                  GetStorage().read('selectedTaskDocNo') &&
              element.resourceStatus!.id == "INS")).toList();
          //print(temp);
          _trx.records = temp;
          _trx.rowcount = _trx.records?.length;
          flag = false;
          break;
        case 4:
          temp = (_trx.records!.where((element) =>
              (element.resourceStatus!.id == "IRV" ||
                  element.resourceStatus!.id == "IRX") &&
              element.mpMaintainID?.id ==
                  GetStorage().read('selectedTaskDocNo'))).toList();
          //print(temp);
          _trx.records = temp;
          _trx.rowcount = _trx.records?.length;
          flag = false;
          break;
        default:
      }
    }
    if (init) {
      //filter3Available.value = false;
      var found = _trx.records!.where((element) =>
          element.litResourceGroupID != null &&
          element.mpMaintainID?.id == GetStorage().read('selectedTaskDocNo'));
      if (found.isNotEmpty) {
        dropDownValue3.value = found.first.litResourceGroupID!.id.toString();
      }
      init = false;
    }
    //FILTRO DESTINAZIONE
    if (dropDownValue3.value != "0") {
      var temp = (_trx.records!.where((element) =>
          element.litResourceGroupID?.id == int.parse(dropDownValue3.value) &&
          element.mpMaintainID?.id ==
              GetStorage().read('selectedTaskDocNo'))).toList();
      _trx.records = temp;
    }
    if (flag) {
      temp = (_trx.records!.where((element) =>
          element.mpMaintainID?.id ==
          GetStorage().read('selectedTaskDocNo'))).toList();
      //print(temp);
      _trx.records = temp;
      _trx.rowcount = _trx.records?.length;
    }

    for (var element in _trx.records!) {
      if (kDebugMode) {
        print(element.anomaliesCount);
      }
    }

    //print(_trx.records!.length);

    // ignore: unnecessary_null_comparison
    _dataAvailable.value = _trx != null;
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

// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';
import 'package:data_table_2/data_table_2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/infocount_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_edit_mptask_surveillance_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_resource/models/reflist_resource_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_create_resource_anomaly.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';

class MaintenanceMptaskSurveillanceOrder extends StatefulWidget {
  const MaintenanceMptaskSurveillanceOrder({Key? key}) : super(key: key);

  @override
  State<MaintenanceMptaskSurveillanceOrder> createState() =>
      _MaintenanceMptaskSurveillanceOrderState();
}

class _MaintenanceMptaskSurveillanceOrderState
    extends State<MaintenanceMptaskSurveillanceOrder> {
  editSurveillance(bool isConnected, int index) async {
    offline = _trx.records![index].offlineId ?? -1;
    //print(now);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    String date = dateFormat.format(DateTime.now());

    final protocol = GetStorage().read('protocol');

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "id": _trx.records![index].id,
      "DecisionDate": date,
      'LIT_IsField17': _trx.records![index].isPositive ?? false,
      'LIT_IsField16': _trx.records![index].isNegative ?? false,
    });

    /*  WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync'))); */

    if (_trx.records![index].id != null && offline == -1) {
      for (var i = 0; i < _trx2.records!.length; i++) {
        if (_trx.records![index].id == _trx2.records![i].id) {
          _trx2.records![i].surveilDate = date;
          _trx2.records![i].isPositive =
              _trx.records![index].isPositive ?? false;
          _trx2.records![i].isNegative =
              _trx.records![index].isNegative ?? false;
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
          setState(() {
            dataAvailable = false;
          });
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

          if (calls[
                  '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] ==
              null) {
            calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
                msg;
          } else {
            Map<String, dynamic> json = jsonDecode(calls[
                '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}']);
            json.addAll({
              "DecisionDate": date,
              'LIT_IsField17': _trx.records![index].isPositive ?? false,
              'LIT_IsField16': _trx.records![index].isNegative ?? false,
            });

            calls['$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${_trx.records![index].id}'] =
                jsonEncode(json);
          }
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
            "DecisionDate": date,
            'LIT_IsField17': _trx.records![index].isPositive ?? false,
            'LIT_IsField16': _trx.records![index].isNegative ?? false,
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

  String getPerm(String type) {
    for (var i = 0; i < _tt.records!.length; i++) {
      if (_tt.records![i].value == type) {
        return _tt.records![i].parameterValue!;
      }
    }
    return "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
  }

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

  changeFilter() {
    setState(() {
      filterCount++;
      if (filterCount == 3) {
        filterCount = 0;
      }

      value = filters[filterCount];
    });
    print(filterCount);
    getWorkOrders();
  }

  Future<void> getWorkOrders() async {
    var now = DateTime.now();
    var twentyDaysAgoDate = now.add(const Duration(days: -20));
    var twentyDaysLater = now.add(const Duration(days: 20));
    setState(() {
      dataAvailable = false;
    });
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/workorderresource.json');

    print(jsonDecode(file.readAsStringSync()));

    setState(() {
      _trx = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(file.readAsStringSync()));
    });

    _trx2 = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    print(Get.arguments['superiorCategoryList']);

    var temp = (_trx.records!.where((element) =>
        element.resourceStatus?.id == "INS" &&
        element.mpMaintainID?.id == GetStorage().read('selectedTaskDocNo') &&
        (args['superiorCategoryList']).contains(
            (element.litmProductCategParent2ID?.id ?? 0).toString()))).toList();
    //print(temp);
    _trx.records = temp;

    for (var i = 0; i < _trx.records!.length; i++) {
      if (_trx.records![i].surveilDate != null) {
        if ((DateTime.parse(_trx.records![i].surveilDate!)
            .isBefore(twentyDaysAgoDate))) {
          setState(() {
            _trx.records![i].isPositive = false;
            _trx.records![i].isNegative = false;
          });
        }
      }
    }

    if (filterCount != 0) {
      switch (filterCount) {
        case 1:
          temp = (_trx.records!.where((element) =>
                  element.isPositive == true || element.isNegative == true))
              .toList();
          //print(temp);
          _trx.records = temp;

          break;
        case 2:
          temp = (_trx.records!.where((element) =>
                  element.isPositive == false && element.isNegative == false))
              .toList();
          //print(temp);
          _trx.records = temp;

          break;
        default:
      }
    }

    //print(_trx.records);

    setState(() {
      totalDevices = _trx.records?.length ?? 0;
      dataAvailable = true;
    });
  }

  Future<void> initializeFilters() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/reflistresourcetypecategory.json');

    _tt = RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));

    getWorkOrders();
  }

  late WorkOrderResourceLocalJson _trx;
  late WorkOrderResourceLocalJson _trx2;
  ScrollController listscrollController = ScrollController();
  bool dataAvailable = false;
  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  int totalDevices = 0;

  var value = "All".tr;

  var filters = [
    "All".tr,
    "Done".tr,
    "Remaining".tr,
  ];

  var filterCount = 0;

  var offline = -1;

  RefListResourceTypeJson _tt = RefListResourceTypeJson(records: []);
  var args = Get.arguments;

  @override
  void initState() {
    super.initState();
    _trx = WorkOrderResourceLocalJson(records: []);
    value = "All".tr;
    filterCount = 0;
    totalDevices = 0;
    dropDownList = getFilterTypes()!;
    listscrollController = ScrollController();
    dataAvailable = false;
    initializeFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.arrow_upward),
          onPressed: () {
            setState(() {
              listscrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            });
          }),
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(args["docN"]),
              Text('Surveillance'.tr),
            ],
          ),
        ),
      ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 55,
                margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: kSpacing,
                          right: kSpacing,
                          top: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${"Total Devices".tr}: $totalDevices".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                TextButton(
                                  onPressed: () {
                                    changeFilter();
                                    //print("hello");
                                  },
                                  child: Text(value),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    //padding: const EdgeInsets.all(10),
                    //width: 20,
                    /* decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ), */
                    child: DropdownButton(
                      underline: const SizedBox(),
                      icon: const Icon(Icons.filter_alt_sharp),
                      value: dropdownValue.value,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        dropdownValue.value = newValue!;

                        //print(dropdownValue);
                      },
                      items: dropDownList.map((list) {
                        return DropdownMenuItem<String>(
                          value: list.id,
                          child: Text(
                            list.name.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        autofocus: true,
                        onTap: () {
                          setState(() {
                            searchFieldController.text = "";
                          });
                        },
                        controller: searchFieldController,
                        onSubmitted: (String? value) {
                          setState(() {
                            searchFilterValue.value =
                                searchFieldController.text;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(EvaIcons.search),
                          hintText: "search..".tr,
                          isDense: true,
                          fillColor: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              dataAvailable
                  ? Expanded(
                      child: ListView.builder(
                        key: const PageStorageKey<String>(
                            'surveillanceresource'),

                        controller: listscrollController,
                        //primary: true,
                        //reverse: true,
                        // scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _trx.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: searchFilterValue.value == ""
                                ? true
                                : dropdownValue.value == "1"
                                    ? _trx.records![index].prodCode
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchFilterValue.value
                                            .toLowerCase())
                                    : dropdownValue.value == "2"
                                        ? _trx.records![index].serNo
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchFilterValue.value
                                                .toLowerCase())
                                        : dropdownValue.value == "3"
                                            ? _trx
                                                .records![index].locationComment
                                                .toString()
                                                .toLowerCase()
                                                .contains(searchFilterValue
                                                    .value
                                                    .toLowerCase())
                                            : dropdownValue.value == "4"
                                                ? _trx.records![index].number
                                                        .toString()
                                                        .toLowerCase() ==
                                                    searchFilterValue.value
                                                        .toLowerCase()
                                                : true,
                            child: Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  key: PageStorageKey(
                                      'surveillanceresource$index'),
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: kNotifColor,
                                      ),
                                      tooltip: 'Edit Resource'.tr,
                                      onPressed: () {
                                        var index2 = 0;
                                        for (var i = 0;
                                            i < _trx2.records!.length;
                                            i++) {
                                          if (_trx2.records![i].id ==
                                              _trx.records![index].id) {
                                            index2 = i;
                                          }
                                        }
                                        Get.to(
                                            MaintenanceEditMptaskSurveillanceOrder(
                                              getWorkorderResources:
                                                  getWorkOrders,
                                            ),
                                            arguments: {
                                              "perm": getPerm(_trx
                                                  .records![index]
                                                  .eDIType!
                                                  .id!),
                                              "id": _trx.records![index].id,
                                              "number":
                                                  _trx.records![index].number,
                                              "lineNo": _trx
                                                  .records![index].lineNo
                                                  .toString(),
                                              "cartel": _trx
                                                  .records![index].textDetails,
                                              "model": _trx.records![index]
                                                  .lITProductModel,
                                              "dateOrder": _trx
                                                  .records![index].dateOrdered,
                                              "years": _trx.records![index]
                                                          .useLifeYears !=
                                                      null
                                                  ? _trx.records![index]
                                                      .useLifeYears
                                                      .toString()
                                                  : "0",
                                              "user":
                                                  _trx.records![index].userName,
                                              "serviceDate": _trx
                                                  .records![index].serviceDate,
                                              "productName": _trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": _trx.records![index]
                                                  .mProductID!.id,
                                              "cartelFormatId": _trx
                                                  .records![index]
                                                  .litCartelFormID
                                                  ?.id,
                                              "subCategoryId": _trx
                                                  .records![index]
                                                  .litmProductSubCategoryID
                                                  ?.id,
                                              "cartelFormatName": _trx
                                                  .records![index]
                                                  .litCartelFormID
                                                  ?.identifier,
                                              "location": _trx.records![index]
                                                  .locationComment,
                                              "observation":
                                                  _trx.records![index].name,
                                              "SerNo":
                                                  _trx.records![index].serNo,
                                              "barcode":
                                                  _trx.records![index].prodCode,
                                              "manufacturer": _trx
                                                  .records![index].manufacturer,
                                              "year": _trx.records![index]
                                                          .manufacturedYear !=
                                                      null
                                                  ? _trx.records![index]
                                                      .manufacturedYear
                                                      .toString()
                                                  : "0",
                                              "Description": _trx
                                                  .records![index].description,
                                              "date3": _trx.records![index]
                                                  .lITControl3DateFrom,
                                              "date2": _trx.records![index]
                                                  .lITControl2DateFrom,
                                              "date1": _trx.records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": _trx
                                                  .records![index].offlineId,
                                              "index": index2,
                                              "length":
                                                  _trx.records![index].length,
                                              "width":
                                                  _trx.records![index].width,
                                              "weightAmt": _trx
                                                  .records![index].weightAmt,
                                              "height":
                                                  _trx.records![index].height,
                                              "color":
                                                  _trx.records![index].color,
                                              "resourceStatus": _trx
                                                      .records![index]
                                                      .resourceStatus
                                                      ?.id ??
                                                  "OUT",
                                              "resourceGroup": _trx
                                                  .records![index]
                                                  .litResourceGroupID
                                                  ?.id,
                                              "note": _trx.records![index].note,
                                              "name": _trx.records![index].name,
                                              "lot": _trx.records![index].lot,
                                            });
                                      },
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "NR. ${_trx.records![index].number} L. ${_trx.records![index].lineNo} b. ${_trx.records![index].prodCode} M. ${_trx.records![index].serNo}",
                                              style: const TextStyle(
                                                color:
                                                    kNotifColor, /* fontWeight: FontWeight.bold */
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _trx.records![index].mProductID
                                                      ?.identifier ??
                                                  "???",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          const Icon(
                                            Icons.location_city,
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                            child: Text(
                                              _trx.records![index]
                                                      .locationComment ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Text(
                                          'Quantity: '.tr,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "${_trx.records![index].resourceQty}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ]),
                                      Row(children: [
                                        Text(
                                          'Manufactured Year: '.tr,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          _trx.records![index].manufacturedYear
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ]),
                                      Visibility(
                                        visible: _trx.records![index].isOwned ??
                                            false,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                              child: Text(
                                                "Is Property".tr,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: _trx.records![index]
                                                .anomaliesCount !=
                                            "0",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                              child: Text(
                                                "Has Anomaly".tr,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            _trx.records![index].doneAction !=
                                                "Nothing",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: kNotifColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                              child: Text(
                                                (_trx.records![index]
                                                            .doneAction ??
                                                        "")
                                                    .tr,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: _trx.records![index]
                                                    .toDoAction !=
                                                "OK" &&
                                            _trx.records![index].doneAction ==
                                                "Nothing",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: _trx.records![index]
                                                                .toDoAction ==
                                                            "OK" ||
                                                        _trx.records![index]
                                                                .toDoAction ==
                                                            "NEW"
                                                    ? kNotifColor
                                                    : _trx.records![index].toDoAction == "PR" ||
                                                            _trx.records![index]
                                                                    .toDoAction ==
                                                                "PC" ||
                                                            _trx.records![index]
                                                                    .toDoAction ==
                                                                "PRnow" ||
                                                            _trx.records![index]
                                                                    .toDoAction ==
                                                                "PCnow"
                                                        ? const Color.fromARGB(
                                                            255, 209, 189, 4)
                                                        : _trx.records![index].toDoAction == "PT" ||
                                                                _trx.records![index]
                                                                        .toDoAction ==
                                                                    "PTnow"
                                                            ? Colors.orange
                                                            : _trx.records![index].toDoAction == "PSG"
                                                                ? Colors.red
                                                                : _trx.records![index].toDoAction == "PX"
                                                                    ? Colors.black
                                                                    : kNotifColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2.5),
                                              child: Text(
                                                (_trx.records![index]
                                                            .toDoAction ??
                                                        "")
                                                    .tr,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  /* trailing: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white,
                                      size: 30.0,
                                    ), */
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(children: [
                                          Text('Note: '.tr),
                                          Expanded(
                                            child: Text(
                                                _trx.records![index].note ??
                                                    ""),
                                          ),
                                        ]),
                                        Row(children: [
                                          Text('Status: '.tr),
                                          Text(_trx.records![index]
                                                  .resourceStatus?.identifier ??
                                              ""),
                                        ]),
                                        /* Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]), */
                                        Row(children: [
                                          Text('Description: '.tr),
                                          Text(_trx.records![index]
                                                  .description ??
                                              ""),
                                        ]),
                                        /* Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]), */
                                        /* Row(children: [
                                          const Text('Check Date: '),
                                          Text(_trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]), */
                                        Row(children: [
                                          Text('Check Date: '.tr),
                                          Text(
                                              "${DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].lITControl1DateNext!))}"),
                                        ]),
                                        /* Row(children: [
                                          const Text('Revision Date: '),
                                          Text(_trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]), */
                                        Row(children: [
                                          Text('Revision Date: '.tr),
                                          Text(
                                              "${DateTime.tryParse(_trx.records![index].lITControl2DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].lITControl2DateFrom!)) : ""} - ${_trx.records![index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].lITControl2DateNext!)) : ""}"),
                                        ]),
                                        /*  Row(children: [
                                          const Text('Testing Date: '),
                                          Text(_trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]), */ //DateFormat('dd-MM-yyyy').format(
                                        //DateTime.parse(_trx
                                        //   .records![index].jpToDoStartDate!))
                                        Row(children: [
                                          Text('Testing Date: '.tr),
                                          Text(
                                              "${DateTime.tryParse(_trx.records![index].lITControl3DateFrom ?? "") != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].lITControl3DateFrom!)) : ""} - ${_trx.records![index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_trx.records![index].lITControl3DateNext!)) : ""}"),
                                        ]),

                                        Row(children: [
                                          Text('Manufacturer: '.tr),
                                          Text(_trx.records![index]
                                                  .manufacturer ??
                                              ""),
                                        ]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.center,
                                              overflowDirection:
                                                  VerticalDirection.down,
                                              overflowButtonSpacing: 5,
                                              /* buttonPadding:
                                                const EdgeInsets.symmetric(horizontal: 30, vertical: 20), */
                                              children: [
                                                Visibility(
                                                  visible: true,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all((_trx
                                                                      .records![
                                                                          index]
                                                                      .isPositive ??
                                                                  false)
                                                              ? Colors.green
                                                              : Colors.grey),
                                                    ),
                                                    child:
                                                        const Text("Positive"),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _trx.records![index]
                                                            .isPositive = true;
                                                        _trx.records![index]
                                                            .isNegative = false;
                                                      });
                                                      var isConnected =
                                                          await checkConnection();
                                                      editSurveillance(
                                                          isConnected, index);
                                                    },
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all((_trx
                                                                      .records![
                                                                          index]
                                                                      .isNegative ??
                                                                  false)
                                                              ? Colors.orange
                                                              : Colors.grey),
                                                    ),
                                                    child:
                                                        const Text("Negative"),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _trx.records![index]
                                                            .isNegative = true;
                                                        _trx.records![index]
                                                            .isPositive = false;
                                                      });

                                                      var isConnected =
                                                          await checkConnection();
                                                      editSurveillance(
                                                          isConnected, index);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                var isConnected =
                                                    await checkConnection();
                                                if (isConnected) {
                                                  await emptyPostCallStack();
                                                  await emptyEditAPICallStack();
                                                  await emptyDeleteCallStack();
                                                }
                                                Get.to(const CreateResAnomaly(),
                                                    arguments: {
                                                      "id": _trx
                                                          .records![index].id,
                                                      "docNo": _trx
                                                              .records![index]
                                                              .mpOtDocumentno ??
                                                          "",
                                                      "productId": _trx
                                                              .records![index]
                                                              .mProductID
                                                              ?.id ??
                                                          0,
                                                      "productName": _trx
                                                              .records![index]
                                                              .mProductID
                                                              ?.identifier ??
                                                          "",
                                                      "isConnected":
                                                          isConnected,
                                                    });
                                              },
                                              icon: Stack(
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.warning,
                                                    color: Colors.red,
                                                  ),
                                                  Visibility(
                                                    visible: _trx
                                                            .records![index]
                                                            .anomaliesCount !=
                                                        "0",
                                                    child: Positioned(
                                                      right: 1,
                                                      top: 1,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 12,
                                                          minHeight: 12,
                                                        ),
                                                        child: Text(
                                                          '${_trx.records![index].anomaliesCount}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          );
        },
        tabletBuilder: (context, constraints) {
          return Column(
            children: [],
          );
        },
        desktopBuilder: (context, constraints) {
          return Column(
            children: [],
          );
        },
      ),
    );
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';

class EditMaintenanceMpResource extends StatefulWidget {
  const EditMaintenanceMpResource({Key? key}) : super(key: key);

  @override
  State<EditMaintenanceMpResource> createState() =>
      _EditMaintenanceMpResourceState();
}

class _EditMaintenanceMpResourceState extends State<EditMaintenanceMpResource> {
  editWorkOrderResource(bool isConnected) async {
    //print(now);

    const filename = "workorderresource";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "id": Get.arguments["id"],
      "M_Product_ID": {"id": productId},
      "LIT_Control3DateFrom": date3,
      "LIT_Control2DateFrom": date2,
      "LIT_Control1DateFrom": date1,
      "Name": nameFieldController.text,
      "SerNo": sernoFieldController.text,
      "Description": descriptionFieldController.text,
      "V_Number": numberFieldController.text,
      "lineNo": int.parse(
          lineFieldController.text == "" ? "0" : lineFieldController.text),
      "LocationComment": locationFieldController.text,
      "Manufacturer": manufacturerFieldController.text,
      "ManufacturedYear": int.parse(yearFieldController.text),
      "ProdCode": barcodeFieldController.text,
      "TextDetails": cartelFieldController.text,
      "LIT_ProductModel": productModelFieldController.text,
      "DateOrdered": dateOrdered,
      "ServiceDate": firstUseDate,
      "UserName": userNameFieldController.text,
      "UseLifeYears": int.parse(
        useLifeYearsFieldController.text == ""
            ? "0"
            : useLifeYearsFieldController.text,
      ),
      "IsActive": isActive,
      "LIT_ResourceStatus": {"id": dropdownValue},
    });

    WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    if (Get.arguments["id"] != null && offline == -1) {
      trx.records![Get.arguments["index"]].mProductID!.id = productId;
      trx.records![Get.arguments["index"]].mProductID!.identifier = productName;
      trx.records![Get.arguments["index"]].lITControl3DateFrom = date3;
      trx.records![Get.arguments["index"]].lITControl2DateFrom = date2;
      trx.records![Get.arguments["index"]].lITControl1DateFrom = date1;
      trx.records![Get.arguments["index"]].name =
          observationFieldController.text;
      trx.records![Get.arguments["index"]].serNo = sernoFieldController.text;
      trx.records![Get.arguments["index"]].description =
          descriptionFieldController.text;
      trx.records![Get.arguments["index"]].number = numberFieldController.text;
      trx.records![Get.arguments["index"]].lineNo = int.parse(
          lineFieldController.text == "" ? "0" : lineFieldController.text);
      trx.records![Get.arguments["index"]].locationComment =
          locationFieldController.text;
      trx.records![Get.arguments["index"]].manufacturer =
          manufacturerFieldController.text;
      trx.records![Get.arguments["index"]].manufacturedYear =
          int.parse(yearFieldController.text);
      trx.records![Get.arguments["index"]].prodCode =
          barcodeFieldController.text;
      trx.records![Get.arguments["index"]].textDetails =
          cartelFieldController.text;
      trx.records![Get.arguments["index"]].lITProductModel =
          productModelFieldController.text;
      trx.records![Get.arguments["index"]].dateOrdered = dateOrdered;
      trx.records![Get.arguments["index"]].serviceDate = firstUseDate;
      trx.records![Get.arguments["index"]].userName =
          userNameFieldController.text;
      trx.records![Get.arguments["index"]].useLifeYears = int.parse(
          useLifeYearsFieldController.text == ""
              ? "0"
              : useLifeYearsFieldController.text);
      trx.records![Get.arguments["index"]].isActive = isActive;
      trx.records![Get.arguments["index"]].resourceStatus =
          ResourceStatus(id: dropdownValue, identifier: dropdownValue.tr);

      var url = Uri.parse('http://' +
          ip +
          '/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${Get.arguments["id"]}');
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
          //var data = jsonEncode(trx.toJson());
          file.writeAsStringSync(jsonEncode(trx.toJson()));
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
          print(response.body);
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
        //GetStorage().write('workOrderSync', data);
        file.writeAsStringSync(data);
        Get.find<MaintenanceMpResourceController>().getWorkOrders();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
                  ip +
                  '/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${Get.arguments["id"]}'] =
              msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
                  ip +
                  '/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${Get.arguments["id"]}'] =
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
        if (json["offlineid"] == Get.arguments?["offlineid"]) {
          var url2 = json["url"];
          var offlineid2 = json["offlineid"];
          var adorg = json["AD_Org_ID"];
          var adclient = json["AD_Client_ID"];

          var call = jsonEncode({
            "offlineid": offlineid2,
            "url": url2,
            "AD_Org_ID": adorg,
            "AD_Client_ID": adclient,
            "Mp_Maintain_ID": {"id": GetStorage().read('selectedTaskDocNo')},
            "M_Product_ID": {"id": productId},
            "IsActive": isActive,
            "ResourceType": {"id": "BP"},
            "ResourceQty": 1,
            "CostAmt": 0,
            "Discount": 0,
            "UseLifeMonths": 0,
            "LIT_Control3DateFrom": date3,
            "LIT_Control2DateFrom": date2,
            "LIT_Control1DateFrom": date1,
            "Name": observationFieldController.text,
            "SerNo": sernoFieldController.text,
            "Description": descriptionFieldController.text,
            "V_Number": numberFieldController.text,
            "lineNo": int.parse(lineFieldController.text == ""
                ? "0"
                : lineFieldController.text),
            "LocationComment": locationFieldController.text,
            "Manufacturer": manufacturerFieldController.text,
            "ManufacturedYear": int.parse(yearFieldController.text),
            "ProdCode": barcodeFieldController.text,
            "TextDetails": cartelFieldController.text,
            "LIT_ProductModel": productModelFieldController.text,
            "DateOrdered": dateOrdered,
            "ServiceDate": firstUseDate,
            "UserName": userNameFieldController.text,
            "UseLifeYears": int.parse(useLifeYearsFieldController.text == ""
                ? "0"
                : useLifeYearsFieldController.text),
            "LIT_ResourceStatus": {"id": dropdownValue},
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
    }
  }

  Future<List<Records>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonResources = ProductJson.fromJson(jsondecoded);

    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

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

  Future<List<Types>> getTypes() async {
    var dJson = TypeJson.fromJson(json);

    return dJson.types!;
  }

  /* void fillFields() {
    nameFieldController.text = args["name"];
    bPartnerFieldController.text = args["bpName"];
    phoneFieldController.text = args["Tel"];
    mailFieldController.text = args["eMail"];
    //dropdownValue = args["leadStatus"];
    salesrepValue = args["salesRep"];
    //salesRepFieldController.text = args["salesRep"];
  } */

  //dynamic args = Get.arguments;
  var numberFieldController;
  var lineFieldController;
  var nameFieldController;
  var valueFieldController;
  var descriptionFieldController;
  var barcodeFieldController;
  var sernoFieldController;
  var locationFieldController;
  var manufacturerFieldController;
  var yearFieldController;
  var observationFieldController;
  var cartelFieldController;
  var productModelFieldController;
  var userNameFieldController;
  var useLifeYearsFieldController;
  String date3 = "";
  int dateCalc3 = 0;
  String date2 = "";
  int dateCalc2 = 0;
  String date1 = "";
  int dateCalc1 = 0;
  var productId;
  var productName;
  var offline = -1;
  String dateOrdered = Get.arguments["dateOrder"] ?? "";
  String firstUseDate = Get.arguments["serviceDate"] ?? "";
  bool isActive = true;
  String dropdownValue = "OUT";

  @override
  void initState() {
    dropdownValue = Get.arguments["resourceStatus"] ?? "OUT";
    productId = Get.arguments["productId"] ?? 0;
    productName = Get.arguments["productName"] ?? "";
    super.initState();
    numberFieldController = TextEditingController();
    numberFieldController.text = Get.arguments["number"] ?? "0";
    lineFieldController = TextEditingController();
    lineFieldController.text = Get.arguments["lineNo"] ?? "0";
    cartelFieldController = TextEditingController();
    cartelFieldController.text = Get.arguments["cartel"] ?? "";
    productModelFieldController = TextEditingController();
    productModelFieldController.text = Get.arguments["model"] ?? "";
    userNameFieldController = TextEditingController();
    userNameFieldController.text = Get.arguments["user"] ?? "";
    useLifeYearsFieldController = TextEditingController();
    useLifeYearsFieldController.text = Get.arguments["years"] ?? "0";
    nameFieldController = TextEditingController();
    nameFieldController.text = Get.arguments["name"] ?? "";
    valueFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    descriptionFieldController.text = Get.arguments["Description"] ?? "";
    sernoFieldController = TextEditingController();
    sernoFieldController.text = Get.arguments["SerNo"] ?? "";
    barcodeFieldController = TextEditingController();
    barcodeFieldController.text = Get.arguments["barcode"] ?? "";
    locationFieldController = TextEditingController();
    locationFieldController.text = Get.arguments["location"] ?? "";
    manufacturerFieldController = TextEditingController();
    manufacturerFieldController.text = Get.arguments["manufacturer"] ?? "";
    yearFieldController = TextEditingController();
    yearFieldController.text = Get.arguments["year"] ?? "0";
    observationFieldController = TextEditingController();
    observationFieldController.text = Get.arguments["observation"] ?? "";
    date3 = Get.arguments["date3"] ?? "";
    dateCalc3 = 0;
    date2 = Get.arguments["date2"] ?? "";
    dateCalc3 = 0;
    date1 = Get.arguments["date1"] ?? "";
    dateCalc3 = 0;
    offline = Get.arguments["offlineid"] ?? -1;
    dateOrdered = "";
    firstUseDate = "";
    isActive = true;
    //print(Get.arguments["offlineid"]);

    //getAllProducts();
  }

  static String _displayStringForOption(Records option) => option.name!;

  static int _setIdForOption(Records option) => option.id!;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit Resource'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                editWorkOrderResource(isConnected);
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[0] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: numberFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "N°".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[1] == "Y",
                  child: Container(
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
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Prodotto",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue:
                                    TextEditingValue(text: productName),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Visibility(
                  visible: (Get.arguments["perm"])[3] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      minLines: 3,
                      maxLines: 3,
                      controller: observationFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[4] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: barcodeFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Barcode'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: sernoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Serial N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[6] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: cartelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Cartel'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[7] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: productModelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Product Model'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[8] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date Ordered'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateOrdered = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[9] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'First Use Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          firstUseDate = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: userNameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'User Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[12] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: locationFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Location'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[13] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: manufacturerFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufacturer'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: yearFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Manufactured Year".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: date1,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Check'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date1 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: date2,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Revision'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date2 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (Get.arguments["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      initialValue: date3,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Testing'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date3 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getTypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Types>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                value: dropdownValue,
                                //icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                //style: const TextStyle(color: Colors.deepPurple),
                                /* underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ), */
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: /* <String>[
                                  'Chiuso',
                                  'Convertito',
                                  'In Lavoro',
                                  'Nuovo'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()*/
                                    snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.id.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Active'.tr),
                  value: isActive,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isActive = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Prodotto",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue:
                                    TextEditingValue(text: productName),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: sernoFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'SerNo',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: date3,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Control3DateFrom',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date3 = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: date2,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Control2DateFrom',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date2 = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: date1,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Control1DateFrom',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date1 = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Prodotto",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue:
                                    TextEditingValue(text: productName),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: sernoFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'SerNo',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: date3,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Control3DateFrom',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date3 = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: date2,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Control2DateFrom',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date2 = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: date1,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Control1DateFrom',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date1 = val.substring(0, 10);
                      });
                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    // ignore: avoid_print
                    onSaved: (val) => print(val),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

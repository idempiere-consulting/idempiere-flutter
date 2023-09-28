// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/reflist_resource_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_barcode/views/screens/maintenance_mptask_resource_barcode_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Maintenance_Switch_Resource/views/screens/supplychain_maintenance_switch_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';

class EditSupplychainSwitchMpResource extends StatefulWidget {
  const EditSupplychainSwitchMpResource({Key? key}) : super(key: key);

  @override
  State<EditSupplychainSwitchMpResource> createState() =>
      _EditSupplychainSwitchMpResourceState();
}

class _EditSupplychainSwitchMpResourceState
    extends State<EditSupplychainSwitchMpResource> {
  editWorkOrderResource(bool isConnected) async {
    //print(now);

    const filename = "workorderresource";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var msg = jsonEncode({
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
      "ManufacturedYear": int.parse(
          yearFieldController.text == "null" ? "0" : yearFieldController.text),
      "ProdCode": barcodeFieldController.text,
      "TextDetails": cartelFieldController.text,
      "LIT_ProductModel": productModelFieldController.text,
      "Lot": lotFieldController.text,
      "DateOrdered": dateOrdered,
      "ServiceDate": firstUseDate,
      "Note": observationFieldController.text,
      "UserName": userNameFieldController.text,
      "UseLifeYears": int.parse(
        useLifeYearsFieldController.text == ""
            ? "0"
            : useLifeYearsFieldController.text,
      ),
      "IsActive": isActive,
      "LIT_ResourceStatus": {"id": dropdownValue},
      "Length": double.parse(
          lengthFieldController.text != "" ? lengthFieldController.text : "0"),
      "Width": double.parse(
          widthFieldController.text != "" ? widthFieldController.text : "0"),
      "WeightedAmt": double.parse(weightAmtFieldController.text != ""
          ? weightAmtFieldController.text
          : "0"),
      "Height": double.parse(
          heightFieldController.text != "" ? heightFieldController.text : "0"),
      "Color": colorFieldController.text,

      "lit_cartel_format_ID": {
        "id": cartelDropDownValue != "" ? int.parse(cartelDropDownValue) : -1
      }
      /* "lit_ResourceGroup_ID": {
        "id": dropdownValue3 == "" ? 1000000 : int.parse(dropdownValue3)
      } */
      //"IsPrinted": sendWorkOrder,
    });

    if (dropdownValue3 != "") {
      msg = jsonEncode({
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
        "ManufacturedYear": int.parse(yearFieldController.text == "null"
            ? "0"
            : yearFieldController.text),
        "ProdCode": barcodeFieldController.text,
        "TextDetails": cartelFieldController.text,
        "LIT_ProductModel": productModelFieldController.text,
        "DateOrdered": dateOrdered,
        "ServiceDate": firstUseDate,
        "Note": observationFieldController.text,
        "UserName": userNameFieldController.text,
        "UseLifeYears": int.parse(
          useLifeYearsFieldController.text == ""
              ? "0"
              : useLifeYearsFieldController.text,
        ),
        "IsActive": isActive,
        "LIT_ResourceStatus": {"id": dropdownValue},
        "Lot": lotFieldController.text,
        "Length": int.parse(lengthFieldController.text != ""
            ? lengthFieldController.text
            : "0"),
        "Width": int.parse(
            widthFieldController.text != "" ? widthFieldController.text : "0"),
        "WeightedAmt": int.parse(weightAmtFieldController.text != ""
            ? weightAmtFieldController.text
            : "0"),
        "Height": int.parse(heightFieldController.text != ""
            ? heightFieldController.text
            : "0"),
        "Color": colorFieldController.text,
        "lit_ResourceGroup_ID": {"id": dropdownValue3},
        "lit_cartel_format_ID": {
          "id": cartelDropDownValue != "" ? int.parse(cartelDropDownValue) : -1
        },

        "LIT_M_Product_SubCategory_ID": {
          "id": subCategoryDropDownValue != ""
              ? int.parse(subCategoryDropDownValue)
              : -1
        }

        //"IsPrinted": sendWorkOrder,
      });
    }

    //trx.records![Get.arguments["index"]].isPrinted = sendWorkOrder;

    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"mp-resources".tr}/${Get.arguments["id"]}');
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

        try {
          Get.find<SupplychainMaintenanceSwitchResourceController>()
              .searchMaintainResource(Get.arguments["barcode"]);
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        //print("done!");
        //Get.back();
        Get.snackbar(
          "Fatto!",
          "Il record è stato modificato",
          duration: const Duration(milliseconds: 800),
          isDismissible: true,
          snackPosition: SnackPosition.TOP,
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
          duration: const Duration(milliseconds: 800),
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      //GetStorage().write('workOrderSync', data);
      //MaintenanceMpResourceBarcodeController
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
      {"id": "NEW", "name": "NEW".tr},
    ]
  };

  Future<List<Types>> getTypes() async {
    var dJson = TypeJson.fromJson(json);

    return dJson.types!;
  }

  Future<List<Records>> getAllCartelFormats() async {
    const filename = "cartelformat";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    return jsonResources.records!;
  }

  Future<List<Records>> getAllSubCategories() async {
    const filename = "resourcesubcategory";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    return jsonResources.records!;
  }

  Future<List<RefRecords>> getResourceGroup() async {
    const filename = "listresourcegroup";
    final file2 = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var dJson =
        RefListResourceTypeJson.fromJson(jsonDecode(file2.readAsStringSync()));

    dJson.records!.retainWhere((element) =>
        element.mpMaintain3ID?.id == GetStorage().read('selectedTaskDocNo'));

    return dJson.records!;
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

  dynamic args = Get.arguments;
  var numberFieldController;
  var lineFieldController;
  var nameFieldController;
  var valueFieldController;
  var descriptionFieldController;
  var barcodeFieldController;
  var sernoFieldController;
  var locationFieldController;
  var lotFieldController;
  var manufacturerFieldController;
  var yearFieldController;
  var observationFieldController;
  var cartelFieldController;
  var productModelFieldController;
  var userNameFieldController;
  var useLifeYearsFieldController;
  var lengthFieldController;
  var widthFieldController;
  var weightAmtFieldController;
  var heightFieldController;
  var colorFieldController;
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
  //bool sendWorkOrder = false;
  String dropdownValue = "OUT";
  String dropdownValue3 = "";
  String cartelDropDownValue = "";
  String subCategoryDropDownValue = "";

  @override
  void initState() {
    dropdownValue3 = ((Get.arguments["resourceGroup"]) ?? "").toString();
    //print(Get.arguments["resourceGroup"]);
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
    lotFieldController =
        TextEditingController(text: Get.arguments["lot"] ?? "");
    manufacturerFieldController = TextEditingController();
    manufacturerFieldController.text = Get.arguments["manufacturer"] ?? "";
    yearFieldController = TextEditingController();
    yearFieldController.text = Get.arguments["year"] ?? "0";
    observationFieldController = TextEditingController();
    observationFieldController.text = Get.arguments["note"] ?? "";
    lengthFieldController =
        TextEditingController(text: (Get.arguments["length"] ?? 0).toString());
    widthFieldController =
        TextEditingController(text: (Get.arguments["width"] ?? 0).toString());
    weightAmtFieldController = TextEditingController(
        text: (Get.arguments["weightAmt"] ?? 0).toString());
    heightFieldController =
        TextEditingController(text: (Get.arguments["height"] ?? 0).toString());
    colorFieldController =
        TextEditingController(text: Get.arguments["color"] ?? "");

    date3 = Get.arguments["date3"] ?? "";
    dateCalc3 = 0;
    date2 = Get.arguments["date2"] ?? "";
    dateCalc3 = 0;
    date1 = Get.arguments["date1"] ?? "";
    dateCalc3 = 0;
    offline = Get.arguments["offlineid"] ?? -1;
    dateOrdered = Get.arguments["dateOrder"] ?? "";
    firstUseDate = Get.arguments["serviceDate"] ?? "";

    cartelDropDownValue = (Get.arguments["cartelFormatId"] ?? "").toString();
    subCategoryDropDownValue =
        (Get.arguments["subCategoryId"] ?? "").toString();
    //sendWorkOrder = Get.arguments["isPrinted"] ?? false;
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
        title: Center(
          child: Text('Edit Resource'.tr),
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
                  visible: (args["perm"])[0] == "Y",
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
                  visible: (args["perm"])[1] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lineFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            lineFieldController.text == "" ? Colors.red : null,
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                                    return "${option.value}_${option.name}"
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
                  visible: (args["perm"])[3] == "Y",
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
                  visible: (args["perm"])[4] == "Y",
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
                  visible: (args["perm"])[6] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Cartel".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[24] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Typology".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[24] == "Y",
                  child: Container(
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
                      future: getAllSubCategories(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Records>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a typology".tr),
                                  value: subCategoryDropDownValue == ""
                                      ? null
                                      : subCategoryDropDownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      subCategoryDropDownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[6] == "Y",
                  child: Container(
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
                      future: getAllCartelFormats(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Records>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Cartel".tr),
                                  value: cartelDropDownValue == ""
                                      ? null
                                      : cartelDropDownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      cartelDropDownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[7] == "Y",
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
                  visible: (args["perm"])[8] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: dateOrdered,
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
                  visible: (args["perm"])[9] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: firstUseDate,
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
                  visible: (args["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: useLifeYearsFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resource Group".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
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
                      future: getResourceGroup(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RefRecords>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Destination".tr),
                                  value: dropdownValue3 == ""
                                      ? null
                                      : dropdownValue3,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[12] == "Y",
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
                  visible: (args["perm"])[26] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: lotFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Lot'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[13] == "Y",
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
                  visible: (args["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: yearFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            yearFieldController.text == "" ? Colors.red : null,
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
                  visible: (args["perm"])[15] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                  visible: (args["perm"])[16] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                  visible: (args["perm"])[17] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                Visibility(
                  visible: (args["perm"])[18] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lengthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: lengthFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Length".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[19] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: widthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            widthFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Width".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[20] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: weightAmtFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: weightAmtFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Supported Weight".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[21] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: heightFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: heightFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Height".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[22] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: colorFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Color".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
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
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                Visibility(
                  visible: (args["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Switch'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
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
                Visibility(
                  visible: (args["perm"])[0] == "Y",
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
                  visible: (args["perm"])[1] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lineFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            lineFieldController.text == "" ? Colors.red : null,
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                  visible: (args["perm"])[3] == "Y",
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
                  visible: (args["perm"])[4] == "Y",
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
                  visible: (args["perm"])[6] == "Y",
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
                  visible: (args["perm"])[7] == "Y",
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
                  visible: (args["perm"])[8] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: dateOrdered,
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
                  visible: (args["perm"])[9] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: firstUseDate,
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
                  visible: (args["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: useLifeYearsFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resource Group".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
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
                      future: getResourceGroup(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RefRecords>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Destination".tr),
                                  value: dropdownValue3 == ""
                                      ? null
                                      : dropdownValue3,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[12] == "Y",
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
                  visible: (args["perm"])[13] == "Y",
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
                  visible: (args["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: yearFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            yearFieldController.text == "" ? Colors.red : null,
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
                  visible: (args["perm"])[15] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                  visible: (args["perm"])[16] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                  visible: (args["perm"])[17] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                Visibility(
                  visible: (args["perm"])[18] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lengthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: lengthFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Length".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[19] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: widthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            widthFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Width".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[20] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: weightAmtFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: weightAmtFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Supported Weight".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[21] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: heightFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: heightFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Height".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[22] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: colorFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Color".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
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
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                Visibility(
                  visible: (args["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Switch'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
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
                Visibility(
                  visible: (args["perm"])[0] == "Y",
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
                  visible: (args["perm"])[1] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lineFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            lineFieldController.text == "" ? Colors.red : null,
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
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
                  visible: (args["perm"])[3] == "Y",
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
                  visible: (args["perm"])[4] == "Y",
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
                  visible: (args["perm"])[6] == "Y",
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
                  visible: (args["perm"])[7] == "Y",
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
                  visible: (args["perm"])[8] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: dateOrdered,
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
                  visible: (args["perm"])[9] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: firstUseDate,
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
                  visible: (args["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: useLifeYearsFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resource Group".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
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
                      future: getResourceGroup(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RefRecords>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Destination".tr),
                                  value: dropdownValue3 == ""
                                      ? null
                                      : dropdownValue3,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[12] == "Y",
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
                  visible: (args["perm"])[13] == "Y",
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
                  visible: (args["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: yearFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            yearFieldController.text == "" ? Colors.red : null,
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
                  visible: (args["perm"])[15] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                  visible: (args["perm"])[16] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                  visible: (args["perm"])[17] == "Y",
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
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
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
                Visibility(
                  visible: (args["perm"])[18] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lengthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: lengthFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Length".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[19] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: widthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            widthFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Width".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[20] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: weightAmtFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: weightAmtFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Supported Weight".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[21] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: heightFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: heightFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Height".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[22] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: colorFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Color".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
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
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                  //print(dropdownValue);
                                },
                                items: snapshot.data!.map((list) {
                                  return DropdownMenuItem<String>(
                                    value: list.id.toString(),
                                    child: Text(
                                      list.name.toString(),
                                    ),
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
                Visibility(
                  visible: (args["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: nameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Switch'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
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

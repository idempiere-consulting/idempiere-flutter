import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/storageonhand_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Line/views/screens/crm_sales_order_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class CreateSalesOrderLine extends StatefulWidget {
  const CreateSalesOrderLine({Key? key}) : super(key: key);

  @override
  State<CreateSalesOrderLine> createState() => _CreateSalesOrderLineState();
}

class _CreateSalesOrderLineState extends State<CreateSalesOrderLine> {
  createSalesOrderLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_Order_ID": {"id": Get.arguments["id"]},
      "M_Product_ID": {"id": productId},
      "Name": nameFieldController.text,
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "QtyEntered": double.parse(qtyFieldController.text),
      "QtyOrdered": double.parse(qtyFieldController.text),
      "PriceEntered": double.parse(priceFieldController.text),
      "PriceList": productPriceList,
      "PriceActual": double.parse(priceFieldController.text),
      "C_UOM_ID": {"id": uomID},
      "C_Tax_ID": {"id": 1000319},
      "M_AttributeSetInstance_ID": {"id": instAttrId},
      "LIT_StockInTrade": "test",
      "DatePromised": date,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/c_orderline/');
    //print(msg);
    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      Get.find<CRMSalesOrderLineController>().getSalesOrderLines();
      //print("done!");
      Get.snackbar(
        "Fatto!",
        "Il record è stato creato",
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
        "Record non creato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> getPriceListVersionID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_pricelist_version?\$select=M_PriceList_Version_ID&\$orderby=ValidFrom DESC&\$filter=M_PriceList_ID eq ${Get.arguments["priceListId"]} & ValidFrom le ${Get.arguments["dateOrdered"]}');

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

      priceListVersionID = json["records"][0]["id"];
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getProductPrice() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_productprice?\$select=PriceStd,PriceList&\$filter=M_Product_ID eq $productId and M_PriceList_Version_ID eq $priceListVersionID');
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
      if (json["row-count"] > 0) {
        priceFieldController.text = json["records"][0]["PriceStd"].toString();
        productPriceList = json["records"][0]["PriceList"];
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAdditionalProductInfo() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter=M_Product_ID eq $productId and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = ProductJson.fromJson(jsonDecode(response.body));
      uomID = json.records![0].cUOMID?.id;
      cattaxID = json.records![0].cTaxCategoryID?.id;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getInstAttr(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_storageonhand?\$filter=M_Product_ID eq $id and DateLastInventory neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      attrList = StorageOnHandJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (attrList.rowcount! > 0) {
        attrList.records!
            .removeWhere((element) => element.mAttributeSetInstanceID?.id == 0);
        SOORecords record = SOORecords(
            mAttributeSetInstanceID:
                MAttributeSetInstance2ID(id: 0, identifier: ""));
        attrList.records!.add(record);

        setState(() {
          attrValue = "0";
          attrFieldAvailable = true;
          attrFieldVisible = true;
        });
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> searchByCode(dynamic value) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter=Value eq \'$value\' and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = ProductJson.fromJson(jsonDecode(response.body));
      if (json.rowcount! > 0) {
        setState(() {
          attrValue = "0";
          attrFieldAvailable = false;
          attrFieldVisible = false;
          productId = json.records![0].id;
          productName = json.records![0].name;
          nameFieldController.text = json.records![0].name;
          valueFieldController.text = json.records![0].value;
          getProductPrice();
          getAdditionalProductInfo();
          if (json.records![0].mAttributeSetID?.id != null) {
            getInstAttr(json.records![0].id!);
          }
        });
      } else {
        searchByInstAttr(value);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> searchByInstAttr(dynamic id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_storageonhand?\$filter=M_AttributeSetInstance_ID eq $id and DateLastInventory neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        attrFieldAvailable = false;
        attrFieldVisible = false;
      });
      attrList = StorageOnHandJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (attrList.rowcount! > 0) {
        instAttrId = attrList.records![0].mAttributeSetInstanceID!.id!;
        getProductByInstAttr(attrList.records![0].mProductID!.id!);
        setState(() {
          attrValue =
              attrList.records![0].mAttributeSetInstanceID!.id.toString();
          attrFieldAvailable = true;
          attrFieldVisible = true;
        });
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getProductByInstAttr(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter=M_Product_ID eq $id and AD_Client_ID eq ${GetStorage().read('clientid')}');

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

      productId = json.records![0].id;
      productName = json.records![0].name;
      nameFieldController.text = json.records![0].name;
      valueFieldController.text = json.records![0].value;
      getProductPrice();
      getAdditionalProductInfo();
    }
  }

  Future<List<Records>> getAllProducts() async {
    //print(response.body);
    var jsondecoded = jsonDecode(GetStorage().read('productSync'));
    var jsonResources = ProductJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  //dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var bycodeFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var activityFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var valueFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var priceFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var productId;
  // ignore: prefer_typing_uninitialized_variables
  var productName;
  // ignore: prefer_typing_uninitialized_variables
  var productPriceList;
  // ignore: prefer_typing_uninitialized_variables
  var uomID;
  // ignore: prefer_typing_uninitialized_variables
  var cattaxID;

  var instAttrId = 0;
  //var productPriceStd;
  // ignore: prefer_typing_uninitialized_variables
  var initialValue;

  var priceListVersionID = 0;

  var attrFieldVisible = false;

  var attrFieldAvailable = false;

  // ignore: prefer_typing_uninitialized_variables
  var attrValue;

  late StorageOnHandJson attrList;

  String date = Get.arguments["dateOrdered"];

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  static int _setIdForOption(Records option) => option.id!;

  @override
  void initState() {
    super.initState();
    getPriceListVersionID();
    activityFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    valueFieldController = TextEditingController();
    nameFieldController = TextEditingController();
    qtyFieldController = TextEditingController();
    priceFieldController = TextEditingController();
    bycodeFieldController = TextEditingController();
    qtyFieldController.text = "1";
    priceFieldController.text = "0";
    initialValue = const TextEditingValue(text: '');
    attrFieldVisible = false;
    attrFieldAvailable = false;
    attrValue = "0";
    //fillFields();
  }

  //static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Sales Order Line'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createSalesOrderLine();
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Search by code",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (String? text) {
                      searchByCode(text!);
                    },
                    controller: bycodeFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Search by product",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    instAttrId = 0;
                                    attrFieldAvailable = false;
                                    attrFieldVisible = false;
                                    productId = _setIdForOption(selection);
                                    productName = selection.name;
                                    nameFieldController.text = selection.name;
                                    valueFieldController.text = selection.value;
                                    getProductPrice();
                                    getAdditionalProductInfo();
                                    if (selection.mAttributeSetID?.id != null) {
                                      getInstAttr(selection.id!);
                                    }
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.wallet_travel),
                      border: OutlineInputBorder(),
                      labelText: 'Product Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.wallet_travel),
                      border: OutlineInputBorder(),
                      labelText: 'Product Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: const Align(
                      child: Text(
                        "Attribute Instance",
                        style: TextStyle(fontSize: 12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
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
                    child: attrFieldAvailable
                        ? DropdownButton(
                            value: attrValue as String,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              instAttrId = int.parse(newValue!);
                              setState(() {
                                attrValue = newValue;
                              });
                              print(newValue);
                            },
                            items: attrList.records!
                                .map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.mAttributeSetInstanceID
                                              ?.identifier ??
                                          "???",
                                    ),
                                    value: list.mAttributeSetInstanceID?.id
                                        .toString(),
                                  );
                                })
                                .toSet()
                                .toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
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
                    initialValue: Get.arguments["dateOrdered"],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Promised Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date = val.substring(0, 10);
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
                      "Search by code",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (String? text) {
                      searchByCode(text!);
                    },
                    controller: bycodeFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Search by product",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    instAttrId = 0;
                                    attrFieldAvailable = false;
                                    attrFieldVisible = false;
                                    productId = _setIdForOption(selection);
                                    productName = selection.name;
                                    nameFieldController.text = selection.name;
                                    valueFieldController.text = selection.value;
                                    getProductPrice();
                                    getAdditionalProductInfo();
                                    if (selection.mAttributeSetID?.id != null) {
                                      getInstAttr(selection.id!);
                                    }
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.wallet_travel),
                      border: OutlineInputBorder(),
                      labelText: 'Product Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.wallet_travel),
                      border: OutlineInputBorder(),
                      labelText: 'Product Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: const Align(
                      child: Text(
                        "Attribute Instance",
                        style: TextStyle(fontSize: 12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
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
                    child: attrFieldAvailable
                        ? DropdownButton(
                            value: attrValue as String,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              instAttrId = int.parse(newValue!);
                              setState(() {
                                attrValue = newValue;
                              });
                              print(newValue);
                            },
                            items: attrList.records!
                                .map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.mAttributeSetInstanceID
                                              ?.identifier ??
                                          "???",
                                    ),
                                    value: list.mAttributeSetInstanceID?.id
                                        .toString(),
                                  );
                                })
                                .toSet()
                                .toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
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
                    initialValue: Get.arguments["dateOrdered"],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Promised Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date = val.substring(0, 10);
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
                      "Search by code",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (String? text) {
                      searchByCode(text!);
                    },
                    controller: bycodeFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Search by product",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                                initialValue: initialValue,
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return ("${option.value}_${option.name}")
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    instAttrId = 0;
                                    attrFieldAvailable = false;
                                    attrFieldVisible = false;
                                    productId = _setIdForOption(selection);
                                    productName = selection.name;
                                    nameFieldController.text = selection.name;
                                    valueFieldController.text = selection.value;
                                    getProductPrice();
                                    getAdditionalProductInfo();
                                    if (selection.mAttributeSetID?.id != null) {
                                      getInstAttr(selection.id!);
                                    }
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.wallet_travel),
                      border: OutlineInputBorder(),
                      labelText: 'Product Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.wallet_travel),
                      border: OutlineInputBorder(),
                      labelText: 'Product Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: priceFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: const Align(
                      child: Text(
                        "Attribute Instance",
                        style: TextStyle(fontSize: 12),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
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
                    child: attrFieldAvailable
                        ? DropdownButton(
                            value: attrValue as String,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              instAttrId = int.parse(newValue!);
                              setState(() {
                                attrValue = newValue;
                              });
                              print(newValue);
                            },
                            items: attrList.records!
                                .map((list) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      list.mAttributeSetInstanceID
                                              ?.identifier ??
                                          "???",
                                    ),
                                    value: list.mAttributeSetInstanceID?.id
                                        .toString(),
                                  );
                                })
                                .toSet()
                                .toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
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
                    initialValue: Get.arguments["dateOrdered"],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Promised Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date = val.substring(0, 10);
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

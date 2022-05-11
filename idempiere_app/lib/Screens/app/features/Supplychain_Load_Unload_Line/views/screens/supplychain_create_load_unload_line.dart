import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/models/storageonhand_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload_Line/views/screens/supplychain_load_unload_line_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class CreateSupplychainLoadUnloadLine extends StatefulWidget {
  const CreateSupplychainLoadUnloadLine({Key? key}) : super(key: key);

  @override
  State<CreateSupplychainLoadUnloadLine> createState() =>
      _CreateSupplychainLoadUnloadLineState();
}

class _CreateSupplychainLoadUnloadLineState
    extends State<CreateSupplychainLoadUnloadLine> {
  createLoadUnloadLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "M_Inventory_ID": {"id": Get.arguments["id"]},
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": productId},
      "M_Locator_ID": {"id": locatorId},
      "Description": descriptionFieldController.text,
      "QtyInternalUse": int.parse(qtyFieldController.text) * -1,
      "C_Charge_ID": {"id": chargeId},
      "M_AttributeSetInstance_ID": {"id": instAttrId},
    });
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/M_InventoryLine/');
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
      Get.find<SupplychainLoadUnloadLineController>().getLoadUnloadsLine();
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

  Future<void> getCharge() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_UserPreference?\$filter= AD_User_ID eq ${GetStorage().read('userId')} and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      chargeId =
          json["records"][0]["M_InventoryLine_C_Charge_ID"]["id"] ?? 1000000;
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

  Future<List<Records>> getLocators() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/M_Locator?\$filter= M_Warehouse_ID eq ${GetStorage().read('warehouseid')}  and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsonResources = ProductJson.fromJson(jsonDecode(response.body));
      return jsonResources.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load lead statuses");
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

  Future<void> searchByCode(String value) async {
    setState(() {
      productId = null;
    });
    instAttrId = 0;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= Value eq \'$value\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = ProductJson.fromJson(jsonDecode(response.body));
      if (json.rowcount! > 0) {
        nameFieldController.text = json.records![0].name;
        valueFieldController.text = json.records![0].value;
        productId = json.records![0].id;
        if (json.records![0].mLocatorID != null) {
          locatorId = json.records![0].mLocatorID?.id;
          isready = false;
          initialValue =
              TextEditingValue(text: json.records![0].mLocatorID!.identifier!);
          isready = true;
        }
        if (json.records![0].mAttributeSetID?.id != null) {
          setState(() {
            buttonVisible = true;
          });
          getInstAttr(json.records![0].id!);
        }
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
          buttonVisible = true;
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
      if (json.records![0].mLocatorID != null) {
        locatorId = json.records![0].mLocatorID?.id;
        locatorName = json.records![0].mLocatorID?.identifier;
        isready = false;
        initialValue =
            TextEditingValue(text: json.records![0].mLocatorID!.identifier!);
        isready = true;
      }
    }
  }

  Future<void> nextLotIncrease() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    final msg = jsonEncode({
      "CurrentNext": nextLot + 1,
    });

    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/M_LotCtl/1000001');

    // ignore: unused_local_variable
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
  }

  Future<void> createAttribute() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/M_LotCtl?\$filter= M_LotCtl_ID eq 1000001 and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      nextLot = json["records"][0]["CurrentNext"];
      nextLotIncrease();
      createLot();
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.defaultDialog(
          title: "Oops!",
          content: const Text("createAttribute Error"),
        );
      }
    }
  }

  Future<void> createLot() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/M_Lot/');

    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": productId},
      "Name": nextLot,
      "M_LotCtl_ID": {"id": 1000001}
    });

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      idLot = json["id"];
      createAttributeSetInstance();
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.defaultDialog(
          title: "Oops!",
          content: const Text("createLot Error"),
        );
      }
    }
  }

  Future<void> createAttributeSetInstance() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/m_attributesetinstance/');

    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_AttributeSet_ID": {"id": 1000001},
      "Lot": nextLot,
      "Description": seriesNr.toString() + '«' + nextLot.toString() + '»',
      "M_Lot_ID": {"id": idLot},
    });

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      //print(utf8.decode(response.bodyBytes));
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      instAttrId = json["id"];
      setState(() {
        attrFieldAvailable = false;
        attrFieldVisible = false;
      });

      var mattrsetid = MAttributeSetInstance2ID(
          id: json["id"], identifier: seriesNr.toString());

      var record = SOORecords(mAttributeSetInstanceID: mattrsetid);

      attrList.records!.add(record);
      attrValue = json["id"].toString();

      setState(() {
        attrFieldAvailable = true;
        attrFieldVisible = true;
      });
      createAttributeInstance();
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.defaultDialog(
          title: "Oops!",
          content: const Text("createAttributeSetInstance Error"),
        );
      }
    }
  }

  Future<void> createAttributeInstance() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/m_attributesetinstance/');

    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_AttributeSetInstance_ID": {"id": instAttrId},
      "M_Attribute_ID": {"id": 1000000},
      "Value": seriesNr
    });

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      if (instAttrId != 0) {
        Get.defaultDialog(
          title: "Done!",
          content: const Text("Instance Attribute Created!"),
        );
      }
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.defaultDialog(
          title: "Oops!",
          content: const Text("createAttributeInstance Error"),
        );
      }
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var nextLot;

  // ignore: prefer_typing_uninitialized_variables
  var seriesNr;

  // ignore: prefer_typing_uninitialized_variables
  var idLot;

  // ignore: prefer_typing_uninitialized_variables
  var idAttributeInstance;

  //dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var valueFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bycodeFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var seriesNrFieldController;
  String salesrepValue = "";

  bool isready = true;

  bool buttonVisible = false;

  // ignore: prefer_typing_uninitialized_variables
  var productId;
  // ignore: prefer_typing_uninitialized_variables
  var productName;
  // ignore: prefer_typing_uninitialized_variables
  var locatorId;
  // ignore: prefer_typing_uninitialized_variables
  var locatorName;

  // ignore: prefer_typing_uninitialized_variables
  var dropdownValue;

  // ignore: prefer_typing_uninitialized_variables
  var initialValue;

  late StorageOnHandJson attrList;

  var instAttrId = 0;

  // ignore: prefer_typing_uninitialized_variables
  var attrValue;

  var attrFieldVisible = false;

  var attrFieldAvailable = false;

  var chargeId = 1000000;

  late FocusNode focusNode;

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  static String _displayStringvalueForOption(Records option) => option.value!;

  static int _setIdForOption(Records option) => option.id!;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    dropdownValue = null;
    //getLocators();
    valueFieldController = TextEditingController();
    nameFieldController = TextEditingController();
    qtyFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    qtyFieldController.text = "1";
    bycodeFieldController = TextEditingController();
    seriesNrFieldController = TextEditingController();
    initialValue = const TextEditingValue(text: '');
    attrFieldVisible = false;
    attrFieldAvailable = false;
    attrValue = "0";
    buttonVisible = false;
    getCharge();
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
        title: Center(
          child: Text('Add Line'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createLoadUnloadLine();
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
                  child: Align(
                    child: Text(
                      "Search by code".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                      focusNode.requestFocus();
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
                  child: Align(
                    child: Text(
                      "Search by product".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
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
                                  instAttrId = 0;
                                  locatorId = selection.mLocatorID?.id;

                                  setState(() {
                                    if (selection.mAttributeSetID?.id != null) {
                                      buttonVisible = true;
                                    } else {
                                      buttonVisible = false;
                                    }
                                    initialValue = TextEditingValue(
                                        text:
                                            selection.mLocatorID?.identifier ??
                                                "");
                                    productId = _setIdForOption(selection);
                                    productName = selection.name;
                                    nameFieldController.text = selection.name;
                                    valueFieldController.text = selection.value;
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "Locator".tr,
                      style: const TextStyle(fontSize: 12),
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
                    future: getLocators(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData && isready
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption:
                                    _displayStringvalueForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.value!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    locatorId = _setIdForOption(selection);
                                    locatorName = selection.value;
                                    //nameFieldController.text = selection.name;
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
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.wallet_travel),
                      border: const OutlineInputBorder(),
                      labelText: 'Product Value'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.wallet_travel),
                      border: const OutlineInputBorder(),
                      labelText: 'Product Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    focusNode: focusNode,
                    controller: qtyFieldController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields_rounded),
                      border: const OutlineInputBorder(),
                      labelText: 'Quantity'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onSubmitted: (String? text) {
                      createLoadUnloadLine();
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields_rounded),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: attrFieldVisible,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      child: Text(
                        "Attribute Instance".tr,
                        style: const TextStyle(fontSize: 12),
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
                              if (kDebugMode) {
                                print(newValue);
                              }
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
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  overflowDirection: VerticalDirection.down,
                  overflowButtonSpacing: 8,
                  children: [
                    Visibility(
                      visible: productId != null && buttonVisible,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        child: Text("Create Instance Attribute".tr),
                        onPressed: () async {
                          //declareFinishedProduct();
                          Get.defaultDialog(
                              title: 'Series Number'.tr,
                              content: Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: seriesNrFieldController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]"))
                                  ],
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin_outlined),
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              onConfirm: () {
                                Get.back();
                                seriesNr = seriesNrFieldController.text;
                                createAttribute();
                              },
                              onCancel: () {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return const Text("desktop visual WIP");
          },
          desktopBuilder: (context, constraints) {
            return const Text("tablet visual WIP");
          },
        ),
      ),
    );
  }
}

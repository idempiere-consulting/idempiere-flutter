import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
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
      "C_Charge_ID": {"id": 1000000},
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
      print(response.body);
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

  Future<void> searchByCode(String value) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= M_Product_ID eq $value and AD_Client_ID eq ${GetStorage().read('clientid')}');
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
    } else {
      print(response.body);
    }
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
  String salesrepValue = "";

  bool isready = true;

  var productId;
  var productName;
  var locatorId;
  var locatorName;

  var dropdownValue;

  var initialValue;

  static String _displayStringForOption(Records option) => option.name!;

  static String _displayStringvalueForOption(Records option) => option.value!;

  static int _setIdForOption(Records option) => option.id!;

  @override
  void initState() {
    super.initState();
    dropdownValue = null;
    //getLocators();
    valueFieldController = TextEditingController();
    nameFieldController = TextEditingController();
    qtyFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    qtyFieldController.text = "1";
    bycodeFieldController = TextEditingController();
    initialValue = TextEditingValue(text: '');
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
          child: Text('Add Load/Unload Line'),
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
                                    nameFieldController.text = selection.name;
                                    valueFieldController.text = selection.value;
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
                      labelText: 'Value',
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
                      labelText: 'Nome',
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
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Locator",
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

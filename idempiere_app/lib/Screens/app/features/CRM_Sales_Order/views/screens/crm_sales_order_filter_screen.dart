import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class CRMFilterSalesOrder extends StatefulWidget {
  const CRMFilterSalesOrder({Key? key}) : super(key: key);

  @override
  State<CRMFilterSalesOrder> createState() => _CRMFilterSalesOrderState();
}

class _CRMFilterSalesOrderState extends State<CRMFilterSalesOrder> {
  final List<dynamic> list = GetStorage().read('permission');
  applyFilters() {
    if (selectedUserRadioTile > 0) {
      if (selectedUserRadioTile == 2 && salesRepId > 0) {
        Get.find<CRMSalesOrderController>().userFilter =
            " and SalesRep_ID eq $salesRepId";
      } else {
        Get.find<CRMSalesOrderController>().userFilter =
            " and SalesRep_ID eq ${GetStorage().read('userId')}";
      }
    } else {
      Get.find<CRMSalesOrderController>().userFilter = "";
    }

    if (businessPartnerId > 0) {
      Get.find<CRMSalesOrderController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<CRMSalesOrderController>().businessPartnerFilter = "";
    }

    if (docNoFieldController.text != "") {
      Get.find<CRMSalesOrderController>().docNoFilter =
          " and contains(DocumentNo,'${docNoFieldController.text}')";
    } else {
      Get.find<CRMSalesOrderController>().docNoFilter = "";
    }

    Get.find<CRMSalesOrderController>().selectedUserRadioTile.value =
        selectedUserRadioTile;

    Get.find<CRMSalesOrderController>().salesRepId = salesRepId;
    Get.find<CRMSalesOrderController>().salesRepName =
        salesRepFieldController.text;

    Get.find<CRMSalesOrderController>().businessPartnerId.value =
        businessPartnerId;

    if (businessPartnerId > 0) {
      Get.find<CRMSalesOrderController>().businessPartnerName =
          bpSearchFieldController.text;
    } else {
      Get.find<CRMSalesOrderController>().businessPartnerName = "";
    }
    Get.find<CRMSalesOrderController>().docNoValue.value =
        docNoFieldController.text;

    Get.find<CRMSalesOrderController>().getSalesOrders();
    Get.back();
  }

  saveFilters() {
    if (selectedUserRadioTile > 0) {
      if (selectedUserRadioTile == 2 && salesRepId > 0) {
        GetStorage()
            .write('SalesOrder_userFilter', " and SalesRep_ID eq $salesRepId");
      } else {
        GetStorage().write('SalesOrder_userFilter',
            " and SalesRep_ID eq ${GetStorage().read('userId')}");
      }
    } else {
      GetStorage().write('SalesOrder_userFilter', "");
    }

    if (businessPartnerId > 0) {
      GetStorage().write('SalesOrder_businessPartnerFilter',
          " and C_BPartner_ID eq $businessPartnerId");
    } else {
      GetStorage().write('SalesOrder_businessPartnerFilter', "");
    }

    if (docNoFieldController.text != "") {
      GetStorage().write('SalesOrder_docNoFilter',
          " and contains(DocumentNo,'${docNoFieldController.text}')");
    } else {
      GetStorage().write('SalesOrder_docNoFilter', "");
    }

    GetStorage()
        .write('SalesOrder_selectedUserRadioTile', selectedUserRadioTile);
    GetStorage().write('SalesOrder_salesRepId', salesRepId);
    GetStorage().write('SalesOrder_salesRepName', salesRepFieldController.text);
    GetStorage().write('SalesOrder_businessPartnerId', businessPartnerId);
    GetStorage()
        .write('SalesOrder_businessPartnerName', bpSearchFieldController.text);
    GetStorage().write('SalesOrder_docNo', docNoFieldController.text);
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    if (int.parse(list[14], radix: 16)
            .toRadixString(2)
            .padLeft(8, "0")
            .toString()[7] !=
        "1") {
      jsonbps.records!.removeWhere(
          (element) => element.salesRepID?.id != GetStorage().read('userId'));
    }

    jsonbps.records!.removeWhere((element) => element.isCustomer == false);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<CRecords>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= DateLastLogin neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  setSelectedUserRadioTile(int val) {
    setState(() {
      selectedUserRadioTile = val;
    });
  }

  dynamic args = Get.arguments;
  int selectedUserRadioTile = 1;
  late TextEditingController salesRepFieldController;
  int salesRepId = 0;

  int businessPartnerId = 0;
  late TextEditingController bpSearchFieldController;
  late TextEditingController docNoFieldController;

  @override
  void initState() {
    super.initState();
    bpSearchFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    salesRepFieldController =
        TextEditingController(text: args['salesRepName'] ?? "");
    salesRepId = args['salesRepId'] ?? 0;
    selectedUserRadioTile = args['selectedUserRadioTile'] ?? 1;
    businessPartnerId = args['businessPartnerId'] ?? 0;
    docNoFieldController = TextEditingController(text: args['docNo'] ?? "");
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: applyFilters, child: Text('Apply Filters'.tr)),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              tooltip: 'reset filters',
              onPressed: () {
                setState(() {
                  selectedUserRadioTile = 1;
                  salesRepId = 0;
                  salesRepFieldController.text = "";
                  businessPartnerId = 0;
                  bpSearchFieldController.text = "";
                  docNoFieldController.text = "";
                });
              },
              icon: const Icon(
                Symbols.filter_alt_off,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              tooltip: 'save filters',
              onPressed: saveFilters,
              icon: const Icon(
                Symbols.bookmark,
              ),
            ),
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Text('Filters'.tr),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[7] ==
                          "1"
                      ? true
                      : false,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      'SalesRep Filter'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    childrenPadding:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    children: [
                      RadioListTile(
                        value: 0,
                        groupValue: selectedUserRadioTile,
                        title: Text("All".tr),
                        //subtitle: Text("Radio 1 Subtitle"),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        activeColor: Theme.of(context).primaryColor,

                        //selected: true,
                      ),
                      RadioListTile(
                        value: 1,
                        groupValue: selectedUserRadioTile,
                        title: Text("Mine Only".tr),
                        subtitle: Text(GetStorage().read('user')),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        //activeColor: Colors.red,
                        activeColor: Theme.of(context).primaryColor,

                        selected: false,
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: selectedUserRadioTile,
                        title: FutureBuilder(
                          future: getAllSalesRep(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<CRecords>> snapshot) =>
                              snapshot.hasData
                                  ? TypeAheadField<CRecords>(
                                      direction: AxisDirection.up,
                                      //getImmediateSuggestions: true,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        onChanged: (value) {
                                          if (value == "") {
                                            setState(() {
                                              salesRepId = 0;
                                            });
                                          }
                                        },
                                        controller: salesRepFieldController,
                                        //autofocus: true,

                                        decoration: InputDecoration(
                                          labelText: 'SalesRep'.tr,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon:
                                              const Icon(EvaIcons.search),
                                          hintText: "search..",
                                          isDense: true,
                                          fillColor:
                                              Theme.of(context).cardColor,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return snapshot.data!.where((element) =>
                                            (element.name ?? "")
                                                .toLowerCase()
                                                .contains(
                                                    pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          //leading: Icon(Icons.shopping_cart),
                                          title: Text(suggestion.name ?? ""),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        salesRepFieldController.text =
                                            suggestion.name!;
                                        salesRepId = suggestion.id!;
                                      },
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                        //subtitle: Text(GetStorage().read('user')),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        //activeColor: Colors.red,
                        activeColor: Theme.of(context).primaryColor,

                        selected: false,
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller: bpSearchFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Business Partner'.tr,
                                        //filled: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        //hintText: "search..",
                                        isDense: true,
                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return snapshot.data!.where((element) =>
                                          (element.name ?? "")
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        //leading: Icon(Icons.shopping_cart),
                                        title: Text(suggestion.name ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      bpSearchFieldController.text =
                                          suggestion.name!;
                                      businessPartnerId = suggestion.id!;
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
                        controller: docNoFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'DocumentNo'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
                /* Visibility(
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[7] !=
                          "1"
                      ? true
                      : false,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Non hai il permesso per modificare il filtro'),
                      ],
                    ),
                  ),
                ), */
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[7] ==
                          "1"
                      ? true
                      : false,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      'SalesRep Filter'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    childrenPadding:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    children: [
                      RadioListTile(
                        value: 0,
                        groupValue: selectedUserRadioTile,
                        title: Text("All".tr),
                        //subtitle: Text("Radio 1 Subtitle"),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        activeColor: Theme.of(context).primaryColor,

                        //selected: true,
                      ),
                      RadioListTile(
                        value: 1,
                        groupValue: selectedUserRadioTile,
                        title: Text("Mine Only".tr),
                        subtitle: Text(GetStorage().read('user')),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        //activeColor: Colors.red,
                        activeColor: Theme.of(context).primaryColor,

                        selected: false,
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: selectedUserRadioTile,
                        title: FutureBuilder(
                          future: getAllSalesRep(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<CRecords>> snapshot) =>
                              snapshot.hasData
                                  ? TypeAheadField<CRecords>(
                                      direction: AxisDirection.up,
                                      //getImmediateSuggestions: true,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        onChanged: (value) {
                                          if (value == "") {
                                            setState(() {
                                              salesRepId = 0;
                                            });
                                          }
                                        },
                                        controller: salesRepFieldController,
                                        //autofocus: true,

                                        decoration: InputDecoration(
                                          labelText: 'SalesRep'.tr,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon:
                                              const Icon(EvaIcons.search),
                                          hintText: "search..",
                                          isDense: true,
                                          fillColor:
                                              Theme.of(context).cardColor,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return snapshot.data!.where((element) =>
                                            (element.name ?? "")
                                                .toLowerCase()
                                                .contains(
                                                    pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          //leading: Icon(Icons.shopping_cart),
                                          title: Text(suggestion.name ?? ""),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        salesRepFieldController.text =
                                            suggestion.name!;
                                        salesRepId = suggestion.id!;
                                      },
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                        //subtitle: Text(GetStorage().read('user')),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        //activeColor: Colors.red,
                        activeColor: Theme.of(context).primaryColor,

                        selected: false,
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller: bpSearchFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Business Partner'.tr,
                                        //filled: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        //hintText: "search..",
                                        isDense: true,
                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return snapshot.data!.where((element) =>
                                          (element.name ?? "")
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        //leading: Icon(Icons.shopping_cart),
                                        title: Text(suggestion.name ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      bpSearchFieldController.text =
                                          suggestion.name!;
                                      businessPartnerId = suggestion.id!;
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
                        controller: docNoFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'DocumentNo'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
                /* Visibility(
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[7] !=
                          "1"
                      ? true
                      : false,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Non hai il permesso per modificare il filtro'),
                      ],
                    ),
                  ),
                ), */
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[7] ==
                          "1"
                      ? true
                      : false,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      'SalesRep Filter'.tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    childrenPadding:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    children: [
                      RadioListTile(
                        value: 0,
                        groupValue: selectedUserRadioTile,
                        title: Text("All".tr),
                        //subtitle: Text("Radio 1 Subtitle"),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        activeColor: Theme.of(context).primaryColor,

                        //selected: true,
                      ),
                      RadioListTile(
                        value: 1,
                        groupValue: selectedUserRadioTile,
                        title: Text("Mine Only".tr),
                        subtitle: Text(GetStorage().read('user')),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        //activeColor: Colors.red,
                        activeColor: Theme.of(context).primaryColor,

                        selected: false,
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: selectedUserRadioTile,
                        title: FutureBuilder(
                          future: getAllSalesRep(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<CRecords>> snapshot) =>
                              snapshot.hasData
                                  ? TypeAheadField<CRecords>(
                                      direction: AxisDirection.up,
                                      //getImmediateSuggestions: true,
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        onChanged: (value) {
                                          if (value == "") {
                                            setState(() {
                                              salesRepId = 0;
                                            });
                                          }
                                        },
                                        controller: salesRepFieldController,
                                        //autofocus: true,

                                        decoration: InputDecoration(
                                          labelText: 'SalesRep'.tr,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon:
                                              const Icon(EvaIcons.search),
                                          hintText: "search..",
                                          isDense: true,
                                          fillColor:
                                              Theme.of(context).cardColor,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return snapshot.data!.where((element) =>
                                            (element.name ?? "")
                                                .toLowerCase()
                                                .contains(
                                                    pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          //leading: Icon(Icons.shopping_cart),
                                          title: Text(suggestion.name ?? ""),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        salesRepFieldController.text =
                                            suggestion.name!;
                                        salesRepId = suggestion.id!;
                                      },
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                        //subtitle: Text(GetStorage().read('user')),
                        onChanged: (val) {
                          //print("Radio Tile pressed $val");
                          setSelectedUserRadioTile(val as int);
                        },
                        //activeColor: Colors.red,
                        activeColor: Theme.of(context).primaryColor,

                        selected: false,
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBPs(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPRecords>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<BPRecords>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            businessPartnerId = 0;
                                          });
                                        }
                                      },
                                      controller: bpSearchFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Business Partner'.tr,
                                        //filled: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        //hintText: "search..",
                                        isDense: true,
                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return snapshot.data!.where((element) =>
                                          (element.name ?? "")
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        //leading: Icon(Icons.shopping_cart),
                                        title: Text(suggestion.name ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      bpSearchFieldController.text =
                                          suggestion.name!;
                                      businessPartnerId = suggestion.id!;
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
                        controller: docNoFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'DocumentNo'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
                /* Visibility(
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[7] !=
                          "1"
                      ? true
                      : false,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Non hai il permesso per modificare il filtro'),
                      ],
                    ),
                  ),
                ), */
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

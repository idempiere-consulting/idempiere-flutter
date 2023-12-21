import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/views/screens/crm_invoice_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class CRMFilterInvoice extends StatefulWidget {
  const CRMFilterInvoice({Key? key}) : super(key: key);

  @override
  State<CRMFilterInvoice> createState() => _CRMFilterInvoiceState();
}

class _CRMFilterInvoiceState extends State<CRMFilterInvoice> {
  applyFilters() {
    var inputFormat = DateFormat('dd/MM/yyyy');
    if (selectedUserRadioTile > 0) {
      if (selectedUserRadioTile == 2 && salesRepId > 0) {
        Get.find<CRMInvoiceController>().userFilter =
            " and SalesRep_ID eq $salesRepId";
      } else {
        Get.find<CRMInvoiceController>().userFilter =
            " and SalesRep_ID eq ${GetStorage().read('userId')}";
      }
    } else {
      Get.find<CRMInvoiceController>().userFilter = "";
    }

    if (businessPartnerId > 0) {
      Get.find<CRMInvoiceController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<CRMInvoiceController>().businessPartnerFilter = "";
    }

    if (docNoFieldController.text != "") {
      Get.find<CRMInvoiceController>().docNoFilter =
          " and contains(DocumentNo,'${docNoFieldController.text}')";
    } else {
      Get.find<CRMInvoiceController>().docNoFilter = "";
    }

    if (descriptionFieldController.text != "") {
      Get.find<CRMInvoiceController>().descriptionFilter =
          " and contains(tolower(Description),'${descriptionFieldController.text}')";
    } else {
      Get.find<CRMInvoiceController>().descriptionFilter = "";
    }

    if (dateStartFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateStartFieldController.text);

        Get.find<CRMInvoiceController>().dateStartFilter =
            " and DateInvoiced ge '${DateFormat('yyyy-MM-dd').format(date)} 00:00:00'";
        Get.find<CRMInvoiceController>().dateStartValue.value =
            dateStartFieldController.text;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      Get.find<CRMInvoiceController>().dateStartFilter = "";
      Get.find<CRMInvoiceController>().dateStartValue.value = '';
    }

    if (dateEndFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateEndFieldController.text);

        Get.find<CRMInvoiceController>().dateEndFilter =
            " and DateInvoiced le '${DateFormat('yyyy-MM-dd').format(date)} 23:59:59'";
        Get.find<CRMInvoiceController>().dateEndValue.value =
            dateEndFieldController.text;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      Get.find<CRMInvoiceController>().dateEndFilter = "";
      Get.find<CRMInvoiceController>().dateEndValue.value = '';
    }

    Get.find<CRMInvoiceController>().selectedUserRadioTile.value =
        selectedUserRadioTile;

    Get.find<CRMInvoiceController>().salesRepId = salesRepId;
    Get.find<CRMInvoiceController>().salesRepName =
        salesRepFieldController.text;

    Get.find<CRMInvoiceController>().businessPartnerId.value =
        businessPartnerId;

    if (businessPartnerId > 0) {
      Get.find<CRMInvoiceController>().businessPartnerName =
          bpSearchFieldController.text;
    } else {
      Get.find<CRMInvoiceController>().businessPartnerName = "";
    }
    Get.find<CRMInvoiceController>().docNoValue.value =
        docNoFieldController.text;
    Get.find<CRMInvoiceController>().description.value =
        descriptionFieldController.text;

    Get.find<CRMInvoiceController>().getInvoices();
    Get.back();
  }

  saveFilters() {
    var inputFormat = DateFormat('dd/MM/yyyy');
    if (selectedUserRadioTile > 0) {
      if (selectedUserRadioTile == 2 && salesRepId > 0) {
        GetStorage()
            .write('Invoice_userFilter', " and SalesRep_ID eq $salesRepId");
      } else {
        GetStorage().write('Invoice_userFilter',
            " and SalesRep_ID eq ${GetStorage().read('userId')}");
      }
    } else {
      GetStorage().write('Invoice_userFilter', "");
    }

    if (businessPartnerId > 0) {
      GetStorage().write('Invoice_businessPartnerFilter',
          " and C_BPartner_ID eq $businessPartnerId");
    } else {
      GetStorage().write('Invoice_businessPartnerFilter', "");
    }

    if (docNoFieldController.text != "") {
      GetStorage().write('Invoice_docNoFilter',
          " and contains(DocumentNo,'${docNoFieldController.text}')");
    } else {
      GetStorage().write('Invoice_docNoFilter', "");
    }

    if (descriptionFieldController.text != "") {
      GetStorage().write('Invoice_descriptionFilter',
          " and contains(tolower(Description),'${descriptionFieldController.text}')");
    } else {
      GetStorage().write('Invoice_descriptionFilter', "");
    }

    if (dateStartFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateStartFieldController.text);
        GetStorage().write('Invoice_dateStartFilter',
            " and DateInvoiced ge '${DateFormat('yyyy-MM-dd').format(date)} 00:00:00'");
        GetStorage().write('Invoice_dateStart', dateStartFieldController.text);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      GetStorage().write('Invoice_dateStartFilter', "");
      GetStorage().write('Invoice_dateStart', "");
    }

    if (dateEndFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateEndFieldController.text);

        GetStorage().write('Invoice_dateEndFilter',
            " and DateInvoiced le '${DateFormat('yyyy-MM-dd').format(date)} 23:59:59'");
        GetStorage().write('Invoice_dateEnd', dateEndFieldController.text);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      GetStorage().write('Invoice_dateEndFilter', "");
      GetStorage().write('Invoice_dateEnd', "");
    }

    GetStorage().write('Invoice_selectedUserRadioTile', selectedUserRadioTile);
    GetStorage().write('Invoice_salesRepId', salesRepId);
    GetStorage().write('Invoice_salesRepName', salesRepFieldController.text);
    GetStorage().write('Invoice_businessPartnerId', businessPartnerId);
    GetStorage()
        .write('Invoice_businessPartnerName', bpSearchFieldController.text);
    GetStorage().write('Invoice_docNo', docNoFieldController.text);
    GetStorage().write('Invoice_description', descriptionFieldController.text);
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

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
  int selectedUserRadioTile = 0;
  late TextEditingController salesRepFieldController;
  int salesRepId = 0;

  int businessPartnerId = 0;
  late TextEditingController bpSearchFieldController;
  late TextEditingController docNoFieldController;
  late TextEditingController descriptionFieldController;
  late TextEditingController dateStartFieldController;
  late TextEditingController dateEndFieldController;

  @override
  void initState() {
    super.initState();
    bpSearchFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    salesRepFieldController =
        TextEditingController(text: args['salesRepName'] ?? "");
    salesRepId = args['salesRepId'] ?? 0;
    selectedUserRadioTile = args['selectedUserRadioTile'] ?? 0;
    businessPartnerId = args['businessPartnerId'] ?? 0;
    docNoFieldController = TextEditingController(text: args['docNo'] ?? "");
    descriptionFieldController =
        TextEditingController(text: args['description'] ?? "");
    dateStartFieldController =
        TextEditingController(text: args['dateStart'] ?? "");
    dateEndFieldController = TextEditingController(text: args['dateEnd'] ?? "");
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
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
                  selectedUserRadioTile = 0;
                  salesRepId = 0;
                  salesRepFieldController.text = "";
                  businessPartnerId = 0;
                  bpSearchFieldController.text = "";
                  docNoFieldController.text = "";
                  descriptionFieldController.text = "";
                  dateStartFieldController.text = "";
                  dateEndFieldController.text = "";
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
                ExpansionTile(
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
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
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
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: descriptionFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Description'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateStartFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date From'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateEndFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date To'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                  ],
                ),
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
                ExpansionTile(
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
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
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
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: descriptionFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Description'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateStartFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date From'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateEndFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date To'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                  ],
                ),
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
                ExpansionTile(
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
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
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
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: descriptionFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Description'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateStartFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date From'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        // maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        controller: dateEndFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(EvaIcons.calendarOutline),
                          border: const OutlineInputBorder(),
                          labelText: 'Date To'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'DD/MM/YYYY',
                          counterText: '',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                          LengthLimitingTextInputFormatter(10),
                          _DateFormatterCustom(),
                        ],
                      ),
                    ),
                  ],
                ),
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

class _DateFormatterCustom extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = '${cText.substring(0, 2)}/';
      } else {
        // Insert / char
        cText =
            '${cText.substring(0, pLen)}/${cText.substring(pLen, pLen + 1)}';
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = '${cText.substring(0, 5)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, 5)}/${cText.substring(5, 6)}';
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

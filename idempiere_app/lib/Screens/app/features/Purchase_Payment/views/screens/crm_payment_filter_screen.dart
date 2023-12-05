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
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/CRM_Payment/views/screens/crm_payment_screen.dart';
import 'package:intl/intl.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

//models

//screens

class PurchaseFilterPayment extends StatefulWidget {
  const PurchaseFilterPayment({Key? key}) : super(key: key);

  @override
  State<PurchaseFilterPayment> createState() => _PurchaseFilterPaymentState();
}

class _PurchaseFilterPaymentState extends State<PurchaseFilterPayment> {
  applyFilters() {
    var inputFormat = DateFormat('dd/MM/yyyy');
    if (businessPartnerId > 0) {
      Get.find<CRMPaymentController>().businessPartnerFilter =
          " and C_BPartner_ID eq $businessPartnerId";
    } else {
      Get.find<CRMPaymentController>().businessPartnerFilter = "";
    }

    if (dateStartFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateStartFieldController.text);

        Get.find<CRMPaymentController>().dateStartFilter =
            " and DateInvoiced ge '${DateFormat('yyyy-MM-dd').format(date)} 00:00:00'";
        Get.find<CRMPaymentController>().dateStartValue.value =
            dateStartFieldController.text;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      Get.find<CRMPaymentController>().dateStartFilter = "";
      Get.find<CRMPaymentController>().dateStartValue.value = '';
    }

    if (dateEndFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateEndFieldController.text);

        Get.find<CRMPaymentController>().dateEndFilter =
            " and DateInvoiced le '${DateFormat('yyyy-MM-dd').format(date)} 23:59:59'";
        Get.find<CRMPaymentController>().dateEndValue.value =
            dateEndFieldController.text;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      Get.find<CRMPaymentController>().dateEndFilter = "";
      Get.find<CRMPaymentController>().dateEndValue.value = '';
    }

    if (bankAccountId > 0) {
      Get.find<CRMPaymentController>().bankAccountFilter =
          " and C_BankAccount_ID eq $bankAccountId";
    } else {
      Get.find<CRMPaymentController>().bankAccountFilter = "";
    }

    Get.find<CRMPaymentController>().businessPartnerId.value =
        businessPartnerId;

    if (businessPartnerId > 0) {
      Get.find<CRMPaymentController>().businessPartnerName =
          bpSearchFieldController.text;
    } else {
      Get.find<CRMPaymentController>().businessPartnerName = "";
    }

    Get.find<CRMPaymentController>().bankAccountId.value = bankAccountId;

    if (bankAccountId > 0) {
      Get.find<CRMPaymentController>().bankAccountName =
          bankSearchFieldController.text;
    } else {
      Get.find<CRMPaymentController>().bankAccountName = "";
    }

    Get.find<CRMPaymentController>().getPayments();
    Get.back();
  }

  saveFilters() {
    var inputFormat = DateFormat('dd/MM/yyyy');
    if (businessPartnerId > 0) {
      GetStorage().write('PurchasePayment_businessPartnerFilter',
          " and C_BPartner_ID eq $businessPartnerId");
    } else {
      GetStorage().write('PurchasePayment_businessPartnerFilter', "");
    }

    GetStorage().write('PurchasePayment_businessPartnerId', businessPartnerId);
    GetStorage().write(
        'PurchasePayment_businessPartnerName', bpSearchFieldController.text);
    if (dateStartFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateStartFieldController.text);
        GetStorage().write('PurchasePayment_dateStartFilter',
            " and DateTrx ge '${DateFormat('yyyy-MM-dd').format(date)} 00:00:00'");
        GetStorage()
            .write('PurchasePayment_dateStart', dateStartFieldController.text);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      GetStorage().write('PurchasePayment_dateStartFilter', "");
      GetStorage().write('PurchasePayment_dateStart', "");
    }

    if (dateEndFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateEndFieldController.text);

        GetStorage().write('PurchasePayment_dateEndFilter',
            " and DateTrx le '${DateFormat('yyyy-MM-dd').format(date)} 23:59:59'");
        GetStorage()
            .write('PurchasePayment_dateEnd', dateEndFieldController.text);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      GetStorage().write('PurchasePayment_dateEndFilter', "");
      GetStorage().write('PurchasePayment_dateEnd', "");
    }

    if (bankAccountId > 0) {
      GetStorage().write('PurchasePayment_bankAccountFilter',
          " and C_BankAccount_ID eq $bankAccountId");
    } else {
      GetStorage().write('PurchasePayment_bankAccountFilter', "");
    }

    GetStorage().write('PurchasePayment_bankAccountId', bankAccountId);
    GetStorage().write(
        'PurchasePayment_bankAccountName', bankSearchFieldController.text);
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

  Future<List<Records>> getAllBankAccounts() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BankAccount?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
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

  dynamic args = Get.arguments;

  int businessPartnerId = 0;
  late TextEditingController bpSearchFieldController;
  late TextEditingController dateStartFieldController;
  late TextEditingController dateEndFieldController;
  int bankAccountId = 0;
  late TextEditingController bankSearchFieldController;

  @override
  void initState() {
    super.initState();
    bpSearchFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? "");
    businessPartnerId = args['businessPartnerId'] ?? 0;
    dateStartFieldController =
        TextEditingController(text: args['dateStart'] ?? "");
    dateEndFieldController = TextEditingController(text: args['dateEnd'] ?? "");
    bankAccountId = args['bankAccountId'] ?? 0;
    bankSearchFieldController =
        TextEditingController(text: args['bankAccountName'] ?? "");
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
                  businessPartnerId = 0;
                  bpSearchFieldController.text = "";
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
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBankAccounts(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            bankAccountId = 0;
                                          });
                                        }
                                      },
                                      controller: bankSearchFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Bank Account'.tr,
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
                                      bankSearchFieldController.text =
                                          suggestion.name!;
                                      bankAccountId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
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
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBankAccounts(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            bankAccountId = 0;
                                          });
                                        }
                                      },
                                      controller: bankSearchFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Bank Account'.tr,
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
                                      bankSearchFieldController.text =
                                          suggestion.name!;
                                      bankAccountId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
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
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: FutureBuilder(
                        future: getAllBankAccounts(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            bankAccountId = 0;
                                          });
                                        }
                                      },
                                      controller: bankSearchFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'Bank Account'.tr,
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
                                      bankSearchFieldController.text =
                                          suggestion.name!;
                                      bankAccountId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
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

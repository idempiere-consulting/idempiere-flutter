import 'dart:convert';
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_Contract/models/documenttype_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/models/materialreceipt_purchaseorder_json.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CreateSupplychainMaterialReceipt extends StatefulWidget {
  const CreateSupplychainMaterialReceipt({Key? key}) : super(key: key);

  @override
  State<CreateSupplychainMaterialReceipt> createState() =>
      _CreateSupplychainMaterialReceiptState();
}

class _CreateSupplychainMaterialReceiptState
    extends State<CreateSupplychainMaterialReceipt> {
  Future<void> createMaterialReceipt() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/M_InOut/');
    //print(url.toString());
    // physical-inventory/conteggio-inventario-if00/tabs/
    // physical-inventory/tabs/inventory-count/1000008/
    // inventory-count-line/
    // 1000008
    // 1000159
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
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
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
      Get.snackbar(
        "Error!".tr,
        "Record not created".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  getMaterialReceiptDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= DocBaseType eq \'MMR\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);
      //print(response.body);

      var json = DocumentTypeJSON.fromJson(jsondecoded);

      documentTypeId = json.records![0].id ?? 0;
    } else {
      throw Exception("Failed to load doc types");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBPs() async {
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;
  }

  getPurchaseOrders() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$expand=c_orderLine&\$filter= IsSoTrx eq N and AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby=DateOrdered desc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      orderList = MaterialReceiptPurchaseOrderJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        orderListAvailable = true;
      });
    } else {
      print(response.body);
    }
  }

  /* late WarehouseJson trx; */
  int currentStep = 1;

  int documentTypeId = 0;

  late int businessPartnerId;
  late TextEditingController bpSearchFieldController;
  late TextEditingController documentDateFieldController;
  late TextEditingController docNoFieldController;

  late TextEditingController pOrderdocNoSearchFieldController;
  bool orderListAvailable = false;

  MaterialReceiptPurchaseOrderJSON orderList =
      MaterialReceiptPurchaseOrderJSON(records: []);

  @override
  void initState() {
    super.initState();
    currentStep = 1;
    businessPartnerId = 0;
    bpSearchFieldController = TextEditingController();
    documentDateFieldController = TextEditingController();
    docNoFieldController = TextEditingController();
    pOrderdocNoSearchFieldController = TextEditingController();
    orderListAvailable = false;
    getPurchaseOrders();
    //getWarehouses();
    //fillFields();
    //createInventoryLine();
    //getAllProducts();
  }

  //static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    ScrollController orderListController = ScrollController();
    Size size = MediaQuery.of(context).size;
    //getSalesRepAutoComplete();
/*     Size size = MediaQuery.of(context).size; */
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Material Receipt'.tr),
      ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              StepProgressIndicator(
                roundedEdges: const Radius.circular(10),
                totalSteps: 3,
                currentStep: currentStep,
                size: 36,
                onTap: (index) {
                  return () {
                    switch (index) {
                      case 0:
                        setState(() {
                          currentStep = index + 1;
                        });
                        break;
                      case 1:
                        setState(() {
                          currentStep = index + 1;
                        });
                        break;
                      case 2:
                        setState(() {
                          currentStep = index + 1;
                        });
                        break;
                      default:
                    }
                  };
                },
                selectedColor: kNotifColor,
                unselectedColor: Colors.grey,
                customStep: (index, color, _) => color == kNotifColor
                    ? index == 0
                        ? Container(
                            color: color,
                            child: const Icon(
                              Icons.handshake,
                              color: Colors.white,
                            ),
                          )
                        : index == 1
                            ? Container(
                                color: color,
                                child: const Icon(
                                  MaterialSymbols.playlist_add,
                                  color: Colors.white,
                                ),
                              )
                            : index == 2
                                ? Container(
                                    color: color,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: const <Widget>[
                                            Icon(Icons.shopping_cart_checkout),
                                          ],
                                        ),
                                      ],
                                    ))
                                : index == 3
                                    ? Container(
                                        color: color,
                                        child: const Icon(
                                          Icons.payment,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        color: color,
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      )
                    : index == 0
                        ? Container(
                            color: color,
                            child: const Icon(
                              Icons.handshake,
                              color: Colors.white,
                            ),
                          )
                        : index == 1
                            ? Container(
                                color: color,
                                child: const Icon(
                                  MaterialSymbols.playlist_add,
                                  color: Colors.white,
                                ),
                              )
                            : index == 2
                                ? Container(
                                    color: color,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: const <Widget>[
                                            Icon(Icons.shopping_cart_checkout),
                                          ],
                                        ),
                                      ],
                                    ))
                                : index == 3
                                    ? Container(
                                        color: color,
                                        child: const Icon(
                                          Icons.payment,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        color: color,
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
              ),
              Visibility(
                visible: currentStep == 1,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 20),
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<BPRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: true,
                                textFieldConfiguration: TextFieldConfiguration(
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
                                    //filled: true,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.handshake),
                                    //hintText: "Business Partner",
                                    labelText: 'Business Partner',
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
              ),
              Visibility(
                visible: currentStep == 1,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    // maxLength: 10,
                    keyboardType: TextInputType.datetime,
                    controller: documentDateFieldController,
                    decoration: InputDecoration(
                      //filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      labelText: 'Document Date'.tr,
                      hintText: "DD/MM/YYYY",
                      isDense: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                      LengthLimitingTextInputFormatter(10),
                      _DateFormatterCustom(),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: currentStep == 1,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      //filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.text_fields),
                      //hintText: "Business Partner",
                      labelText: 'DocumentNo'.tr,
                      isDense: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
              ),
              Visibility(
                visible: currentStep == 2,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(EvaIcons.search),
                      hintText: "Search Order...",
                      isDense: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: orderListAvailable == true && currentStep == 2,
                child: SizedBox(
                  height: size.height * 0.65,
                  child: ListView.builder(
                      //primary: true,
                      controller: orderListController,
                      //scrollDirection: Axis.vertical,
                      //shrinkWrap: true,
                      itemCount: orderList.records!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),

                              leading: Container(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: Checkbox(
                                      value: false, onChanged: (newvalue) {})),
                              title: Text(
                                orderList.records![index].documentNo ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Column(children: [
                                Row(
                                  children: [
                                    Text(
                                      orderList.records![index].dateOrdered ??
                                          '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ]),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.manage_search_outlined)),
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              children: [
                                Column(
                                  children: [
                                    /* ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: orderList
                                            .records![index].cOrderLine?.length,
                                        itemBuilder: (BuildContext context,
                                            int indexRows) {
                                          return Row(
                                            children: [],
                                          );
                                        }), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          );
        },
        tabletBuilder: (context, constraints) {
          return Column(
            children: const [],
          );
        },
        desktopBuilder: (context, constraints) {
          return Column(
            children: const [],
          );
        },
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

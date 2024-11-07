import 'dart:convert';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_BP_PriceList/models/businesspartner_location_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/deliveryviarule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/movementtype_json.dart';

import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/models/shipmentline_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import '../../../CRM_Sales_Order_Line/models/salesorderline_json.dart';

//models

//screens

class CRMCreateRetunByBarcodeShipment extends StatefulWidget {
  const CRMCreateRetunByBarcodeShipment({Key? key}) : super(key: key);

  @override
  State<CRMCreateRetunByBarcodeShipment> createState() =>
      _CRMCreateRetunByBarcodeShipmentState();
}

class _CRMCreateRetunByBarcodeShipmentState
    extends State<CRMCreateRetunByBarcodeShipment> {
  Future<void> createShipment() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/customer-return');

    var inputFormat = DateFormat('dd/MM/yyyy');

    var date = inputFormat.parse(dateFieldController.text);

    List<Map<String, Object>> list = [];

    for (var element in shipmentLines.records!) {
      list.add({
        "M_Product_ID": {"id": element.mProductID?.id},
        "QtyEntered": element.movementQty!,
      });
    }

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_DocType_ID": {"id": 1000015},
      "C_BPartner_ID": {"id": shipmentLines.records![0].cBPartnerID?.id},
      "C_BPartner_Location_ID": {"id": bpLocationId},
      "MovementDate": DateFormat('yyyy-MM-dd').format(date),
      "DateAcct": DateFormat('yyyy-MM-dd').format(date),
      "customer-return-line".tr: list,
    };

    print(msg);

    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      Get.back();
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getShipmentAddress() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location?\$filter= IsShipTo eq true and C_BPartner_ID eq ${shipmentLines.records![0].cBPartnerID!.id!}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = BusinessPartnerLocationJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      bpLocationId = json.records![0].id ?? 0;
      //print(response.body);
    } else {
      //print(response.body);
    }
  }

  Future<List<MTRecords>> getAllMovementTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_M_MovementType?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = MovementTypeJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load movement types");
    }

    //print(response.body);
  }

  Future<List<DVRRecords>> getAllFOB() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 200030');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = DeliveryViaRuleJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      //print(response.body);
      throw Exception("Failed to load FOB");
    }

    //print(response.body);
  }

  Future<List<DVRRecords>> getAllDeliveryViaRules() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 152');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = DeliveryViaRuleJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      //print(response.body);
      throw Exception("Failed to load deliveryviarules");
    }

    //print(response.body);
  }

  Future<List<MTRecords>> getAllShippers() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Shipper?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = MovementTypeJSON.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load shippers");
    }

    //print(response.body);
  }

  Future<void> getScannedOrderLine(String barcode) async {
    setState(() {
      linesAvailable = false;
    });
    List<String> barcodeList = barcode.split(' ');
    print(barcodeList);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_OrderLine?\$filter= C_OrderLine_ID eq ${barcodeList[0]}');
    print(
        '$protocol://$ip/api/v1/models/C_OrderLine?\$filter= C_OrderLine_ID eq ${barcodeList[0]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      SalesOrderLineJson orderLine = SalesOrderLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (orderLine.records!.isNotEmpty) {
        if (shipmentLines.records!.isEmpty) {
          shipmentLines.records!.add(SLRecords(
              cOrderLineID: SLCOrderLineID(id: orderLine.records![0].id),
              plannedQty: orderLine.records![0].qtyEntered! -
                  orderLine.records![0].qtyReserved!,
              cBPartnerID: SLCBPartnerID(
                  id: orderLine.records![0].cBPartnerID!.id!,
                  identifier: orderLine.records![0].cBPartnerID!.identifier!),
              mProductID: SLMProductID(
                  id: orderLine.records![0].mProductID!.id!,
                  identifier: orderLine.records![0].mProductID!.identifier!),
              movementQty: num.parse(barcodeList[1])));

          businessPartnerFieldController.text =
              orderLine.records![0].cBPartnerID!.identifier!;
          getShipmentAddress();
        } else if (orderLine.records![0].cBPartnerID!.id! ==
            shipmentLines.records![0].cBPartnerID!.id!) {
          bool notFound = true;
          for (var i = 0; i < shipmentLines.records!.length; i++) {
            if (shipmentLines.records![i].cOrderLineID?.id ==
                    orderLine.records![0].id &&
                shipmentLines.records![i].mProductID?.id ==
                    orderLine.records![0].mProductID?.id) {
              shipmentLines.records![i].movementQty =
                  shipmentLines.records![i].movementQty! +
                      num.parse(barcodeList[1]);

              notFound = false;
            }
          }
          if (notFound) {
            shipmentLines.records!.add(SLRecords(
                cOrderLineID: SLCOrderLineID(id: orderLine.records![0].id),
                plannedQty: orderLine.records![0].qtyEntered! -
                    orderLine.records![0].qtyReserved!,
                cBPartnerID: SLCBPartnerID(
                    id: orderLine.records![0].cBPartnerID!.id!,
                    identifier: orderLine.records![0].cBPartnerID!.identifier!),
                mProductID: SLMProductID(
                    id: orderLine.records![0].mProductID!.id!,
                    identifier: orderLine.records![0].mProductID!.identifier!),
                movementQty: num.parse(barcodeList[1])));
          }
        }
      }

      linesAvailable = true;
      setState(() {});

      print(response.body);
    } else {
      print(response.body);
    }
  }

  ShipmentLineJson shipmentLines = ShipmentLineJson(records: []);

  bool linesAvailable = false;
  late TextEditingController businessPartnerFieldController;
  late TextEditingController dateFieldController;
  late TextEditingController timeFieldController;
  late TextEditingController noPackagesFieldController;
  late TextEditingController weightFieldController;
  late TextEditingController grossWeightFieldController;
  late TextEditingController externalAspectFieldController;
  String movementTypeId = "0";

  int bpLocationId = 0;

  String deliveryViaRule = "0";
  String shipperId = "0";
  String fobId = "0";

  @override
  void initState() {
    super.initState();
    shipmentLines = ShipmentLineJson(records: []);
    linesAvailable = false;
    businessPartnerFieldController = TextEditingController(text: '');
    dateFieldController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
    timeFieldController = TextEditingController(
        text: DateFormat('HH:mm:ss').format(DateTime.now()));
    noPackagesFieldController = TextEditingController(text: '1');
    weightFieldController = TextEditingController(text: '0');
    grossWeightFieldController = TextEditingController(text: '0');
    externalAspectFieldController = TextEditingController(text: '');
    deliveryViaRule = "P";
    shipperId = "0";
    fobId = "0";
    movementTypeId = "0";
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Text('Create Return Customer'.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createShipment();
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: BarcodeKeyboardListener(
        onBarcodeScanned: (barcode) {
          print(barcode);
          getScannedOrderLine(barcode);
        },
        child: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ExpansionTile(
                    title: Text('Header Fields'.tr),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: TextField(
                          readOnly: true,
                          controller: businessPartnerFieldController,
                          decoration: InputDecoration(
                            isDense: true,
                            //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Business Partner'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          minLines: 1,
                          maxLines: 4,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: TextField(
                          // maxLength: 10,
                          keyboardType: TextInputType.datetime,
                          controller: dateFieldController,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(EvaIcons.calendarOutline),
                            border: const OutlineInputBorder(),
                            labelText: 'Date'.tr,
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
                  Visibility(
                    visible: linesAvailable,
                    child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: shipmentLines.records!.length,
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
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.article,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'Article'.tr,
                                  onPressed: () {
                                    //log("info button pressed");
                                  },
                                ),
                              ),
                              title: Text(
                                shipmentLines.records![index].mProductID
                                        ?.identifier ??
                                    'N/A',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Column(children: [
                                Row(
                                  children: <Widget>[
                                    const Icon(Icons.handshake,
                                        color: Colors.white),
                                    Expanded(
                                      child: Text(
                                        shipmentLines.records![index]
                                                .cBPartnerID?.identifier ??
                                            "N/A",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "${"Added Qty".tr}: ${shipmentLines.records![index].movementQty ?? 0}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ]),
                              /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              children: [],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
            tabletBuilder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[],
              );
            },
            desktopBuilder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[],
              );
            },
          ),
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

class TimeTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = value.substring(6, 7) + ":" + value.substring(7);
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk = value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk = value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7, 8) +
              value.substring(8);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk = value.substring(0, 1) +
              ":" +
              value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}

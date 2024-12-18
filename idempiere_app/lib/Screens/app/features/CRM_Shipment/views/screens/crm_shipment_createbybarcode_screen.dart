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
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/mstoragereservation_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_screen.dart';

import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/models/shipmentline_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_barcode/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Offer/models/sales_order_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import '../../../CRM_Sales_Order_Line/models/salesorderline_json.dart';

//models

//screens

class CRMCreateByBarcodeShipment extends StatefulWidget {
  const CRMCreateByBarcodeShipment({Key? key}) : super(key: key);

  @override
  State<CRMCreateByBarcodeShipment> createState() => _CRMFilterShipmentState();
}

class _CRMFilterShipmentState extends State<CRMCreateByBarcodeShipment> {
  Future<void> createShipment() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/shipment-customer');

    var inputFormat = DateFormat('dd/MM/yyyy');

    var date = inputFormat.parse(dateFieldController.text);

    List<Map<String, Object>> list = [];

    for (var element in shipmentLines.records!) {
      if (element.cOrderLineID != null) {
        list.add({
          "M_Product_ID": {"id": element.mProductID?.id},
          "QtyEntered": element.movementQty!,
          "C_OrderLine_ID": {"id": element.cOrderLineID?.id},
          "Name": element.name ?? '',
          "Description": element.description ?? '',
          "Help": element.help ?? '',
        });
      } else {
        list.add({
          "M_Product_ID": {"id": element.mProductID?.id},
          "QtyEntered": element.movementQty!,
          "IsInvoiced": element.isInvoiced ?? false,
        });
      }
    }

    var msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_DocType_ID": {"id": 1000011},
      "C_BPartner_ID": {"id": shipmentLines.records![0].cBPartnerID?.id},
      "C_BPartner_Location_ID": {"id": bpLocationId},
      "NoPackages": int.parse(noPackagesFieldController.text),
      "Weight": double.tryParse(weightFieldController.text) ?? 0.0,
      "LIT_GrossWeight":
          double.tryParse(grossWeightFieldController.text) ?? 0.0,
      "LIT_ExternalAspect": externalAspectFieldController.text,
      "ShipDate":
          '${DateFormat('yyyy-MM-dd').format(date)}T${timeFieldController.text}Z',
      "shipment-line".tr: list,
    };

    if (movementTypeId != "0") {
      msg.addAll({
        'LIT_M_MovementType_ID': {"id": int.parse(movementTypeId)}
      });
    }
    if (deliveryViaRule != "0") {
      msg.addAll({
        "DeliveryViaRule": {"id": deliveryViaRule}
      });
    }

    if (shipperId != "0") {
      msg.addAll({
        "M_Shipper_ID": {"id": int.parse(shipperId)}
      });
    }

    if (fobId != "0") {
      msg.addAll({
        "FOB": {"id": fobId}
      });
    }

    //print(msg);

    save = true;

    var response = await http.post(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      save = false;
      GetStorage().write('DDT_SavedBarcodeCreation', null);
      Get.back();
      Get.find<CRMShipmentController>().getShipments();
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> restoreCreationFromJson() async {
    setState(() {
      linesAvailable = false;
    });
    shipmentLines = ShipmentLineJson.fromJson(
        GetStorage().read('DDT_SavedBarcodeCreation'));
    getRestoredLine(shipmentLines.records![0].cOrderLineID?.id ?? 0);
    //getShipmentAddress(shipmentLines.records![0].cOrderID!.id!);
    setState(() {
      linesAvailable = true;
    });
  }

  Future<void> getRestoredLine(int orderLineId) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_OrderLine?\$filter= C_OrderLine_ID eq $orderLineId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      SalesOrderLineJson orderLineJSON = SalesOrderLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (orderLineJSON.records!.isNotEmpty) {
        getRestoredHeaderData(orderLineJSON.records![0].cOrderID?.id ?? 0);
      }
    }
  }

  Future<void> getRestoredHeaderData(int orderId) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$filter= C_Order_ID eq $orderId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json =
          SalesOrderJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      bpLocationId = json.records![0].cBPartnerLocationID?.id ?? 0;
      businessPartnerFieldController.text =
          json.records![0].cBPartnerID!.identifier!;
      businessPartnerID = json.records![0].cBPartnerID!.id!;
      getShipmentAddress(json.records![0].id!);
      //print(response.body);
    } else {
      //print(response.body);
    }
  }

  Future<void> getShipmentAddress(int orderId) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$filter= C_Order_ID eq $orderId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json =
          SalesOrderJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      bpLocationId = json.records![0].cBPartnerLocationID?.id ?? 0;

      setState(() {
        fobId = json.records![0].fob?.id ?? "0";
        deliveryViaRule = json.records![0].deliveryViaRule?.id ?? "P";
        shipperId = (json.records![0].mShipperID?.id ?? 0).toString();
      });

      //print(response.body);
    } else {
      //print(response.body);
    }
  }

  Future<int> checkShipmentAddress(int orderId) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$filter= C_Order_ID eq $orderId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json =
          SalesOrderJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return json.records![0].cBPartnerLocationID?.id ?? 0;
      //print(response.body);
    } else {
      return 0;
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

  Future<num> getProdQtyReserved(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_storagereservation?\$filter= M_product_ID eq $id');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      MStorageReservationJSON storageReservation =
          MStorageReservationJSON.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));

      if (storageReservation.records!.isNotEmpty) {
        return storageReservation.records![0].qty ?? 0;
      } else {
        return 0;
      }
    }

    return 0;
  }

  Future<bool> isOrderCompleted(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_order?\$filter= C_Order_ID eq $id and DocStatus eq \'CO\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(id);
      SalesOrderJson orderJSON =
          SalesOrderJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (orderJSON.records!.isNotEmpty) {
        //print(orderJSON.records!);
        //print(orderJSON.records![0].docStatus?.id);
        //print('-----------');
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  Future<SalesOrderLineJson> getAllOrderLines(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_OrderLine?\$filter= C_Order_ID eq $id');
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

      print(orderLine.pagecount!);

      if (orderLine.pagecount! > 1) {
        int index = 1;
        var json2 = await getAllOrderLinesPages(orderLine, index, id);
        return json2;
      } else {
        return orderLine;
      }
    }

    return SalesOrderLineJson(records: []);
  }

  Future<SalesOrderLineJson> getAllOrderLinesPages(
      SalesOrderLineJson json, int index, int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_OrderLine?\$filter= C_Order_ID eq $id&\$skip=${(index * 100)}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      index += 1;
      SalesOrderLineJson pagejson = SalesOrderLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pagejson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        await getAllOrderLinesPages(json, index, id);
      } else {
        print('AAAAA');
        return json;
      }
    } else {
      print(response.body);
    }

    return SalesOrderLineJson(records: []);
  }

  Future<void> getScannedOrderLine(String barcode) async {
    setState(() {
      linesAvailable = false;
    });
    List<String> barcodeList = barcode.split(' ');
    //print(barcodeList);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_OrderLine?\$filter= C_OrderLine_ID eq ${barcodeList[1]}');

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

      //getProdQtyReserved(orderLine.records![0].mProductID!.id!);

      if (orderLine.records!.isNotEmpty && !(barcodeList[0].contains('pr'))) {
        var olscanned = false;
        if (shipmentLines.records!.isEmpty) {
          orderLine.records![0].qtyReserved =
              await getProdQtyReserved(orderLine.records![0].mProductID!.id!);
          if (barcodeList[0].contains('pr')) {
            /* TextEditingController qtyController =
                TextEditingController(text: '');
            Get.defaultDialog(
                title: 'Insert Qty'.tr,
                onConfirm: () {
                  Get.back();
                  shipmentLines.records!.add(SLRecords(
                      cOrderLineID:
                          SLCOrderLineID(id: orderLine.records![0].id),
                      plannedQty: orderLine.records![0].qtyReserved!,
                      cBPartnerID: SLCBPartnerID(
                          id: orderLine.records![0].cBPartnerID!.id!,
                          identifier:
                              orderLine.records![0].cBPartnerID!.identifier!),
                      mProductID: SLMProductID(
                          id: orderLine.records![0].mProductID!.id!,
                          identifier:
                              orderLine.records![0].mProductID!.identifier!),
                      movementQty: num.parse(qtyController.text)));

                  businessPartnerFieldController.text =
                      orderLine.records![0].cBPartnerID!.identifier!;
                  getShipmentAddress();
                  linesAvailable = true;
                  setState(() {});
                },
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        autofocus: true,
                        controller: qtyController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.timelapse),
                          border: const OutlineInputBorder(),
                          labelText: 'Qty'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                )); */
          } else {
            if ((orderLine.records![0].qtyOrdered! -
                        orderLine.records![0].qtyDelivered!) -
                    (num.parse(barcodeList[2])) <
                0) {
              Get.defaultDialog(
                title: 'Error!'.tr,
                content: Text(
                    'The Missing Quantity of this Order Line would be below 0 as a result of adding this Shipment Line'
                        .tr),
              );
            } else {
              olscanned = true;
              shipmentLines.records!.add(
                SLRecords(
                  cOrderLineID: SLCOrderLineID(id: orderLine.records![0].id),
                  plannedQty: orderLine.records![0].qtyOrdered! -
                      orderLine.records![0].qtyDelivered!,
                  cBPartnerID: SLCBPartnerID(
                      id: orderLine.records![0].cBPartnerID!.id!,
                      identifier:
                          orderLine.records![0].cBPartnerID!.identifier!),
                  mProductID: SLMProductID(
                      id: orderLine.records![0].mProductID!.id!,
                      identifier:
                          orderLine.records![0].mProductID!.identifier!),
                  name: orderLine.records![0].name,
                  description: orderLine.records![0].description,
                  help: orderLine.records![0].help,
                  movementQty: num.parse(barcodeList[2]),
                  mobileBarcodeType: barcodeList[0],
                ),
              );

              businessPartnerFieldController.text =
                  orderLine.records![0].cBPartnerID!.identifier!;
              businessPartnerID = orderLine.records![0].cBPartnerID!.id!;
              getShipmentAddress(orderLine.records![0].cOrderID!.id!);
            }
          }
        } else if (orderLine.records![0].cBPartnerID!.id! ==
            shipmentLines.records![0].cBPartnerID!.id!) {
          if (barcodeList[0].contains('pr')) {
            /* TextEditingController qtyController =
                TextEditingController(text: '');
            Get.defaultDialog(
                title: 'Insert Qty'.tr,
                onConfirm: () async {
                  Get.back();
                  bool notFound = true;
                  for (var i = 0; i < shipmentLines.records!.length; i++) {
                    if (shipmentLines.records![i].cOrderLineID?.id ==
                            orderLine.records![0].id &&
                        shipmentLines.records![i].mProductID?.id ==
                            orderLine.records![0].mProductID?.id) {
                      shipmentLines.records![i].movementQty =
                          shipmentLines.records![i].movementQty! +
                              num.parse(qtyController.text);

                      notFound = false;
                    }
                  }
                  if (notFound) {
                    orderLine.records![0].qtyReserved =
                        await getProdQtyReserved(
                            orderLine.records![0].mProductID!.id!);
                    shipmentLines.records!.add(SLRecords(
                        cOrderLineID:
                            SLCOrderLineID(id: orderLine.records![0].id),
                        plannedQty: orderLine.records![0].qtyReserved!,
                        cBPartnerID: SLCBPartnerID(
                            id: orderLine.records![0].cBPartnerID!.id!,
                            identifier:
                                orderLine.records![0].cBPartnerID!.identifier!),
                        mProductID: SLMProductID(
                            id: orderLine.records![0].mProductID!.id!,
                            identifier:
                                orderLine.records![0].mProductID!.identifier!),
                        movementQty: num.parse(qtyController.text)));
                  }

                  linesAvailable = true;
                  setState(() {});
                },
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        autofocus: true,
                        controller: qtyController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.timelapse),
                          border: const OutlineInputBorder(),
                          labelText: 'Qty'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                )); */
          } else {
            bool notFound = true;
            for (var i = 0; i < shipmentLines.records!.length; i++) {
              if (shipmentLines.records![i].cOrderLineID?.id ==
                      orderLine.records![0].id &&
                  shipmentLines.records![i].mProductID?.id ==
                      orderLine.records![0].mProductID?.id) {
                if (shipmentLines.records![i].plannedQty! -
                        (shipmentLines.records![i].movementQty! +
                            num.parse(barcodeList[2])) <
                    0) {
                  Get.defaultDialog(
                    title: 'Error!'.tr,
                    content: Text(
                        'The Missing Quantity of this Order Line would be below 0 as a result of adding this Shipment Line'
                            .tr),
                  );
                } else {
                  olscanned = true;
                  shipmentLines.records![i].movementQty =
                      shipmentLines.records![i].movementQty! +
                          num.parse(barcodeList[2]);
                }

                notFound = false;
              }
            }
            if (notFound) {
              if ((orderLine.records![0].qtyOrdered! -
                          orderLine.records![0].qtyDelivered!) -
                      (num.parse(barcodeList[2])) <
                  0) {
                Get.defaultDialog(
                  title: 'Error!'.tr,
                  content: Text(
                      'The Missing Quantity of this Order Line would be below 0 as a result of adding this Shipment Line'
                          .tr),
                );
              } else {
                if (await checkShipmentAddress(
                        orderLine.records![0].cOrderID?.id ?? 0) !=
                    bpLocationId) {
                  Get.defaultDialog(
                    title: 'Different Address!'.tr,
                    content: Text(
                        'This barcode has a different address from the header, do you still want to add this shipment line?'
                            .tr),
                    textCancel: 'back'.tr,
                    onConfirm: () async {
                      olscanned = true;
                      Navigator.of(Get.overlayContext!, rootNavigator: true)
                          .pop();

                      orderLine.records![0].qtyReserved =
                          await getProdQtyReserved(
                              orderLine.records![0].mProductID!.id!);
                      shipmentLines.records!.add(SLRecords(
                        cOrderLineID:
                            SLCOrderLineID(id: orderLine.records![0].id),
                        plannedQty: orderLine.records![0].qtyOrdered! -
                            orderLine.records![0].qtyDelivered!,
                        cBPartnerID: SLCBPartnerID(
                            id: orderLine.records![0].cBPartnerID!.id!,
                            identifier:
                                orderLine.records![0].cBPartnerID!.identifier!),
                        mProductID: SLMProductID(
                            id: orderLine.records![0].mProductID!.id!,
                            identifier:
                                orderLine.records![0].mProductID!.identifier!),
                        name: orderLine.records![0].name,
                        description: orderLine.records![0].description,
                        help: orderLine.records![0].help,
                        movementQty: num.parse(barcodeList[2]),
                        mobileBarcodeType: barcodeList[0],
                      ));
                    },
                  );
                } else {
                  olscanned = true;
                  orderLine.records![0].qtyReserved = await getProdQtyReserved(
                      orderLine.records![0].mProductID!.id!);
                  shipmentLines.records!.add(SLRecords(
                    cOrderLineID: SLCOrderLineID(id: orderLine.records![0].id),
                    plannedQty: orderLine.records![0].qtyOrdered! -
                        orderLine.records![0].qtyDelivered!,
                    cBPartnerID: SLCBPartnerID(
                        id: orderLine.records![0].cBPartnerID!.id!,
                        identifier:
                            orderLine.records![0].cBPartnerID!.identifier!),
                    mProductID: SLMProductID(
                        id: orderLine.records![0].mProductID!.id!,
                        identifier:
                            orderLine.records![0].mProductID!.identifier!),
                    name: orderLine.records![0].name,
                    description: orderLine.records![0].description,
                    help: orderLine.records![0].help,
                    movementQty: num.parse(barcodeList[2]),
                    mobileBarcodeType: barcodeList[0],
                  ));
                }
              }
            }
          }

          /* bool notFound = true;
          for (var i = 0; i < shipmentLines.records!.length; i++) {
            if (shipmentLines.records![i].cOrderLineID?.id ==
                    orderLine.records![0].id &&
                shipmentLines.records![i].mProductID?.id ==
                    orderLine.records![0].mProductID?.id) {
              shipmentLines.records![i].movementQty =
                  shipmentLines.records![i].movementQty! +
                      num.parse(barcodeList[2]);

              notFound = false;
            }
          }
          if (notFound) {
            shipmentLines.records!.add(SLRecords(
                cOrderLineID: SLCOrderLineID(id: orderLine.records![0].id),
                plannedQty: orderLine.records![0].qtyReserved!,
                cBPartnerID: SLCBPartnerID(
                    id: orderLine.records![0].cBPartnerID!.id!,
                    identifier: orderLine.records![0].cBPartnerID!.identifier!),
                mProductID: SLMProductID(
                    id: orderLine.records![0].mProductID!.id!,
                    identifier: orderLine.records![0].mProductID!.identifier!),
                movementQty: num.parse(barcodeList[2])));
          } */
        }
        /* switch (barcodeList[0]) {
          case 'OLRF':
            SalesOrderLineJson allLines =
                await getAllOrderLines(orderLine.records![0].cOrderID!.id!);
            for (var i = 0; i < allLines.records!.length; i++) {
              if (allLines.records![i].bayMasterOrderLineID?.id ==
                  int.parse(barcodeList[1])) {
                await getScannedOrderLine(
                    'N/A ${allLines.records![i].id} ${allLines.records![i].qtyEntered}');
              }
            }
            break;

          default:
        } */

        if (barcodeList[0].contains('ol') && olscanned) {
          noPackagesFieldController.text =
              (int.parse(noPackagesFieldController.text) + 1).toString();
          SalesOrderLineJson allLines =
              await getAllOrderLines(orderLine.records![0].cOrderID!.id!);
          for (var i = 0; i < allLines.records!.length; i++) {
            if (allLines.records![i].bayMasterOrderLineID?.id ==
                int.parse(barcodeList[1])) {
              await getScannedOrderLine(
                  'N/A ${allLines.records![i].id} ${barcodeList[2]}');
            }
          }
        }
      } else {
        bool noOrderlineFound = true;

        if (businessPartnerID > 0) {
          var url = Uri.parse(
              '$protocol://$ip/api/v1/models/c_orderline?\$filter= M_Product_ID eq ${barcodeList[1]} and C_BPartner_ID eq $businessPartnerID and C_BPartner_Location_ID eq $bpLocationId and QtyReserved neq 0&\$orderby= Created asc');

          var response3 = await http.get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': authorization,
            },
          );
          if (response3.statusCode == 200) {
            SalesOrderLineJson orderLinePR = SalesOrderLineJson.fromJson(
                jsonDecode(utf8.decode(response3.bodyBytes)));

            SalesOrderLineJson orderLinePRCOPY = orderLinePR;
            for (var i = 0; i < orderLinePR.records!.length; i++) {
              if (!(await isOrderCompleted(
                  orderLinePR.records![i].cOrderID?.id ?? 0))) {
                orderLinePRCOPY.records!.removeWhere((element) =>
                    element.cOrderID?.id ==
                    orderLinePR.records![i].cOrderID?.id);
              }
            }

            orderLinePR = orderLinePRCOPY;

            if (orderLinePR.records!.isNotEmpty) {
              noOrderlineFound = false;
              TextEditingController qtyController =
                  TextEditingController(text: '');
              Get.defaultDialog(
                  title: 'Insert Qty'.tr,
                  onConfirm: () {
                    Navigator.of(Get.overlayContext!, rootNavigator: true)
                        .pop();

                    int qtyToAdd = int.parse(qtyController.text);
                    int totResidueQty = 0;
                    for (var element in orderLinePR.records!) {
                      totResidueQty =
                          (totResidueQty + element.qtyReserved!).toInt();
                    }

                    if (totResidueQty < qtyToAdd) {
                      Get.defaultDialog(
                        title: 'Error!'.tr,
                        content: Text(
                            'The Missing Quantity of this Order Line would be below 0 as a result of adding this Shipment Line'
                                .tr),
                      );
                    } else {
                      for (var i = 0; i < orderLinePR.records!.length; i++) {
                        if (qtyToAdd > 0 &&
                            (orderLinePR.records![i].qtyOrdered ??
                                    0 -
                                        (orderLinePR.records![i].qtyDelivered ??
                                            0)) >
                                0) {
                          orderLinePR.records![i].qtyReserved;

                          if (qtyToAdd <=
                              orderLinePR.records![i].qtyReserved!) {
                            shipmentLines.records!.add(SLRecords(
                              cOrderLineID: SLCOrderLineID(
                                  id: orderLinePR.records![i].id),
                              plannedQty: orderLinePR.records![i].qtyReserved,
                              cBPartnerID: SLCBPartnerID(
                                  id: orderLinePR.records![i].cBPartnerID!.id!,
                                  identifier: orderLinePR
                                      .records![i].cBPartnerID!.identifier!),
                              mProductID: SLMProductID(
                                  id: orderLinePR.records![i].mProductID!.id!,
                                  identifier: orderLinePR
                                      .records![i].mProductID!.identifier!),
                              name: orderLinePR.records![i].name,
                              description: orderLinePR.records![i].description,
                              help: orderLinePR.records![i].help,
                              movementQty: qtyToAdd,
                              mobileBarcodeType: barcodeList[0],
                            ));

                            qtyToAdd = 0;
                          }

                          if (qtyToAdd > orderLinePR.records![i].qtyReserved!) {
                            shipmentLines.records!.add(SLRecords(
                              cOrderLineID: SLCOrderLineID(
                                  id: orderLinePR.records![i].id),
                              plannedQty: orderLinePR.records![i].qtyReserved!,
                              cBPartnerID: SLCBPartnerID(
                                  id: orderLinePR.records![i].cBPartnerID!.id!,
                                  identifier: orderLinePR
                                      .records![i].cBPartnerID!.identifier!),
                              mProductID: SLMProductID(
                                  id: orderLinePR.records![i].mProductID!.id!,
                                  identifier: orderLinePR
                                      .records![i].mProductID!.identifier!),
                              name: orderLinePR.records![i].name,
                              description: orderLinePR.records![i].description,
                              help: orderLinePR.records![i].help,
                              movementQty: orderLinePR.records![i].qtyReserved!,
                              mobileBarcodeType: barcodeList[0],
                            ));

                            qtyToAdd = qtyToAdd -
                                orderLinePR.records![i].qtyReserved!.toInt();
                          }
                        }
                      }
                    }

                    linesAvailable = true;
                    setState(() {});
                  },
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: orderLinePR
                                  .records![0].mProductID?.identifier),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Product'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          autofocus: true,
                          controller: qtyController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.timelapse),
                            border: const OutlineInputBorder(),
                            labelText: 'Qty'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {}
          } else {}
        }

        if (noOrderlineFound) {
          var url = Uri.parse(
              '$protocol://$ip/api/v1/models/M_Product?\$filter= M_Product_ID eq ${barcodeList[1]}');

          var response2 = await http.get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': authorization,
            },
          );

          if (response2.statusCode == 200) {
            ProductJson prod = ProductJson.fromJson(
                jsonDecode(utf8.decode(response2.bodyBytes)));

            if (prod.records!.isNotEmpty &&
                barcodeList[0].contains('pr') &&
                prod.records![0].litAutomationRule?.id == "XODV") {
              var resQty = await getProdQtyReserved(prod.records![0].id!);
              TextEditingController qtyController =
                  TextEditingController(text: '');
              Get.defaultDialog(
                  title: 'Insert Qty'.tr,
                  onConfirm: () {
                    Navigator.of(Get.overlayContext!, rootNavigator: true)
                        .pop();

                    /* orderLine.records![0].qtyReserved =
                        await getProdQtyReserved(
                            orderLine.records![0].mProductID!.id!); */
                    shipmentLines.records!.add(SLRecords(
                      plannedQty: resQty,
                      mProductID: SLMProductID(
                          id: prod.records![0].id!,
                          identifier:
                              "${prod.records![0].value}_${prod.records![0].name}"),
                      movementQty: num.parse(qtyController.text),
                      mobileBarcodeType: barcodeList[0],
                      isInvoiced: true,
                    ));

                    linesAvailable = true;
                    setState(() {});
                  },
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: prod.records![0].value),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Code'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: prod.records![0].name),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Product'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          autofocus: true,
                          controller: qtyController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.timelapse),
                            border: const OutlineInputBorder(),
                            labelText: 'Qty'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {
              Get.defaultDialog(
                title: 'Error!'.tr,
                content: Text(
                    'No Linked Order was found for this Product and It\'s NOT Extra ODV'
                        .tr),
              );
            }
          }
        }
      }

      linesAvailable = true;
      setState(() {});

      //print(response.body);
    } else {
      print(response.body);
    }
  }

  ShipmentLineJson shipmentLines = ShipmentLineJson(records: []);

  bool linesAvailable = false;
  late TextEditingController businessPartnerFieldController;
  int businessPartnerID = 0;
  late TextEditingController dateFieldController;
  late TextEditingController timeFieldController;
  late TextEditingController noPackagesFieldController;
  late TextEditingController weightFieldController;
  late TextEditingController grossWeightFieldController;
  late TextEditingController externalAspectFieldController;
  String movementTypeId = "0";

  int bpLocationId = 0;

  String deliveryViaRule = "P";
  String shipperId = "0";
  String fobId = "0";

  bool save = false;

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
    noPackagesFieldController = TextEditingController(text: '0');
    weightFieldController = TextEditingController(text: '0');
    grossWeightFieldController = TextEditingController(text: '0');
    externalAspectFieldController = TextEditingController(text: '');
    deliveryViaRule = "P";
    shipperId = "0";
    fobId = "0";
    movementTypeId = "0";
    save = false;

    if (GetStorage().read('DDT_SavedBarcodeCreation') != null) {
      restoreCreationFromJson();
    }
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (shipmentLines.records!.isNotEmpty) {
                Get.defaultDialog(
                  title: 'Unfinished Shipment'.tr,
                  content: Text('Do you want to save it?'.tr),
                  onCancel: () {
                    if (GetStorage().read('DDT_SavedBarcodeCreation') != null) {
                      GetStorage().write('DDT_SavedBarcodeCreation', null);
                    }
                    Get.back();
                    Get.back();
                  },
                  onConfirm: () {
                    Get.back();
                    //print(shipmentLines.toJson());
                    GetStorage().write(
                        'DDT_SavedBarcodeCreation', shipmentLines.toJson());
                    Get.back();
                  },
                );
              } else {
                Get.back();
              }
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Text('Create Shipment'.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                if (!save) {
                  createShipment();
                }
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      /* floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.arrow_upward),
          onPressed: () {
            //print('hello');
            getScannedOrderLine('PRXX 1000029 1');
          }), */
      body: BarcodeKeyboardListener(
        onBarcodeScanned: (barcode) {
          print(barcode);
          Get.snackbar(
            "barcode".tr,
            barcode,
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          );
          getScannedOrderLine(barcode);
        },
        child: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                        '${'Scanned Packages'.tr}: ${noPackagesFieldController.text}'),
                  ),
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
                  ExpansionTile(
                    title: Text('Header Fields'.tr),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: FutureBuilder(
                          future: getAllMovementTypes(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<MTRecords>> snapshot) =>
                              snapshot.hasData
                                  ? InputDecorator(
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Movement Type'.tr,
                                        //filled: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.list),
                                        //hintText: "search..",

                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                      child: DropdownButton(
                                        isDense: true,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        value: movementTypeId == "0"
                                            ? null
                                            : movementTypeId,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            movementTypeId = newValue!;
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
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: FutureBuilder(
                          future: getAllDeliveryViaRules(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<DVRRecords>> snapshot) =>
                              snapshot.hasData
                                  ? InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Delivery Via Rule'.tr,
                                        //filled: true,
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.list),
                                        //hintText: "search..",

                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                      child: DropdownButton(
                                        isDense: true,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        value: deliveryViaRule == "0"
                                            ? null
                                            : deliveryViaRule,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            deliveryViaRule = newValue!;
                                          });
                                          //print(dropdownValue);
                                        },
                                        items: snapshot.data!.map((list) {
                                          return DropdownMenuItem<String>(
                                            value: list.value,
                                            child: Text(
                                              list.name.toString(),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: FutureBuilder(
                          future: getAllShippers(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<MTRecords>> snapshot) =>
                              snapshot.hasData
                                  ? InputDecorator(
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Shipper'.tr,
                                        //filled: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.list),
                                        //hintText: "search..",

                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                      child: DropdownButton(
                                        isDense: true,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        value:
                                            shipperId == "0" ? null : shipperId,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            shipperId = newValue!;
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
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: FutureBuilder(
                          future: getAllFOB(),
                          builder: (BuildContext ctx,
                                  AsyncSnapshot<List<DVRRecords>> snapshot) =>
                              snapshot.hasData
                                  ? InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Freight Terms'.tr,
                                        //filled: true,
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                            ),
                                        prefixIcon: const Icon(EvaIcons.list),
                                        //hintText: "search..",

                                        //fillColor: Theme.of(context).cardColor,
                                      ),
                                      child: DropdownButton(
                                        isDense: true,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        value: fobId == "0" ? null : fobId,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            fobId = newValue!;
                                          });
                                          //print(dropdownValue);
                                        },
                                        items: snapshot.data!.map((list) {
                                          return DropdownMenuItem<String>(
                                            value: list.value,
                                            child: Text(
                                              list.name.toString(),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: TextField(
                          controller: externalAspectFieldController,
                          decoration: InputDecoration(
                            isDense: true,
                            //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'External Aspect'.tr,
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
                          controller: noPackagesFieldController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'NoPackages'.tr,
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
                          controller: weightFieldController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Weight'.tr,
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
                          controller: grossWeightFieldController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Gross Weight'.tr,
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
                            labelText: 'Date Start Shipment'.tr,
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
                        child: TextField(
                          // maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: timeFieldController,

                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(EvaIcons.calendarOutline),
                            border: const OutlineInputBorder(),
                            labelText: 'Time'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '00:00:00',
                            counterText: '',
                          ),
                          inputFormatters: [TimeTextInputFormatter()],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: linesAvailable,
                    child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      reverse: true,
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
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Delete'.tr,
                                  onPressed: () {
                                    setState(() {
                                      linesAvailable = false;
                                    });
                                    if ((shipmentLines.records![index]
                                                .mobileBarcodeType ??
                                            '')
                                        .contains('ol')) {
                                      noPackagesFieldController.text =
                                          (int.parse(noPackagesFieldController
                                                      .text) -
                                                  1)
                                              .toString();
                                    }
                                    shipmentLines.records!.removeAt(index);

                                    setState(() {
                                      linesAvailable = true;
                                    });
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
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "${"Missing Qty".tr}: ${shipmentLines.records![index].plannedQty! - shipmentLines.records![index].movementQty!}",
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

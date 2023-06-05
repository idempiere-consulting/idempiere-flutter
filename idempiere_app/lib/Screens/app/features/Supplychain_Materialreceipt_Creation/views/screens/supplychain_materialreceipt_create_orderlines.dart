import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Line/models/salesorderline_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/deliveryviarule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/models/movementtype_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/views/screens/supplychain_materialreceipt_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt_Creation/views/screens/supplychain_materialreceipt_creation_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';

class SupplychainCreateMaterialReceiptOrderLine extends StatefulWidget {
  const SupplychainCreateMaterialReceiptOrderLine({Key? key}) : super(key: key);

  @override
  State<SupplychainCreateMaterialReceiptOrderLine> createState() =>
      _SupplychainCreateMaterialReceiptOrderLineState();
}

class _SupplychainCreateMaterialReceiptOrderLineState
    extends State<SupplychainCreateMaterialReceiptOrderLine> {
  Future<void> getSalesOrderLines() async {
    setState(() {
      orderLineListAvailable = false;
    });
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_orderline?\$filter= C_Order_ID eq ${args["id"]} and AD_Client_ID eq ${GetStorage().read("clientid")}');
    //print(Get.arguments["id"]);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      orderLineList = SalesOrderLineJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      qtyArrivedFieldControllerList = List.generate(
          orderLineList.records!.length, (i) => TextEditingController());
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      setState(() {
        orderLineListAvailable = true;
      });
    }
  }

  allShipped() {
    if (allShippedcheckboxState) {
      for (var i = 0; i < orderLineList.records!.length; i++) {
        qtyArrivedFieldControllerList[i].text =
            orderLineList.records![i].qtyReserved!.toInt().toString();
      }
    } else {
      for (var i = 0; i < orderLineList.records!.length; i++) {
        qtyArrivedFieldControllerList[i].text = '';
      }
    }
  }

  saveRows() {
    for (var i = 0; i < orderLineList.records!.length; i++) {
      if (orderLineList.records![i].qtyReserved!.toInt() > 0 &&
          qtyArrivedFieldControllerList[i].text != '') {
        Records rec = orderLineList.records![i];
        rec.qtyRegistered = int.parse(
            qtyArrivedFieldControllerList[i].text == ''
                ? '0'
                : qtyArrivedFieldControllerList[i].text);

        Get.find<SupplychainMaterialreceiptCreationController>()
            .orderLineList
            .records!
            .add(rec);
        Get.back();
      }
    }
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables

  late TextEditingController docNoFieldController;
  late TextEditingController businessPartnerFieldController;

  bool allShippedcheckboxState = false;
  bool viewReservedOnlycheckboxState = false;

  bool orderLineListAvailable = false;
  SalesOrderLineJson orderLineList = SalesOrderLineJson(records: []);
  List<TextEditingController> qtyArrivedFieldControllerList = [];

  @override
  void initState() {
    super.initState();
    docNoFieldController = TextEditingController(text: args['docNo'] ?? '');
    businessPartnerFieldController =
        TextEditingController(text: args['businessPartnerName'] ?? '');
    orderLineListAvailable = false;
    viewReservedOnlycheckboxState = false;
    getSalesOrderLines();

    //getAllMovementTypes();
  }

  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Order Lines'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                saveRows();
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
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: businessPartnerFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Business Partner'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: CheckboxListTile(
                        title: Text('All Received'.tr),
                        value: allShippedcheckboxState,
                        activeColor: kPrimaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            allShippedcheckboxState = value!;
                          });
                          allShipped();
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Flexible(
                      child: CheckboxListTile(
                        title: Text('View Reserved Only'.tr),
                        value: viewReservedOnlycheckboxState,
                        activeColor: kPrimaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            viewReservedOnlycheckboxState = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                orderLineListAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: orderLineList.rowcount,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: viewReservedOnlycheckboxState
                                ? orderLineList.records![index].qtyReserved! > 0
                                : true,
                            child: Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ListTile(
                                  /*  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0), */
                                  /* leading: Container(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: ''.tr,
                                      onPressed: () {},
                                    ),
                                  ), */

                                  title: Text(
                                    orderLineList.records![index].mProductID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Vendor Code: ".tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            orderLineList.records![index]
                                                    .vendorProductNo ??
                                                'N/A',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.all(1),
                                                child: TextField(
                                                  textAlign: TextAlign.end,
                                                  readOnly: true,
                                                  controller:
                                                      TextEditingController(
                                                          text: orderLineList
                                                              .records![index]
                                                              .qtyOrdered!
                                                              .toInt()
                                                              .toString()),
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Ordered'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.all(1),
                                                child: TextField(
                                                  textAlign: TextAlign.end,
                                                  readOnly: true,
                                                  controller:
                                                      TextEditingController(
                                                          text: orderLineList
                                                              .records![index]
                                                              .qtyReserved!
                                                              .toInt()
                                                              .toString()),
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Reserved'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.all(1),
                                                child: TextField(
                                                  textAlign: TextAlign.end,
                                                  controller:
                                                      qtyArrivedFieldControllerList[
                                                          index],
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: 'Quantity'.tr,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
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
              ],
            );
          },
        ),
      ),
    );
  }
}

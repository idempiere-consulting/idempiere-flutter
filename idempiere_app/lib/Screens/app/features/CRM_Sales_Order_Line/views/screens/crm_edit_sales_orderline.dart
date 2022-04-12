import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Line/views/screens/crm_sales_order_line_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditSalesOrderLine extends StatefulWidget {
  const EditSalesOrderLine({Key? key}) : super(key: key);

  @override
  State<EditSalesOrderLine> createState() => _EditSalesOrderLineState();
}

class _EditSalesOrderLineState extends State<EditSalesOrderLine> {
  editSalesOrderLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final msg = jsonEncode({
      "QtyEntered": double.parse(qtyFieldController.text),
      "QtyOrdered": double.parse(qtyFieldController.text),
      "PriceEntered": double.parse(priceFieldController.text),
      "PriceActual": double.parse(priceFieldController.text),
      "DatePromised": date,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/c_orderline/$id');
    //print(msg);
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMSalesOrderLineController>().getSalesOrderLines();
      //print("done!");
      Get.snackbar(
        "Fatto!",
        "Il record è stato modificato",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      print(response.body);
      Get.snackbar(
        "Errore!",
        "Record non modificato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  deleteSalesOrderLine() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/c_orderline/$id');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMSalesOrderLineController>().getSalesOrderLines();
      Get.back();
      Get.back();
      //print("done!");
      Get.snackbar(
        "Fatto!",
        "Il record è stato eliminato",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      print(response.body);
      Get.snackbar(
        "Errore!",
        "Record non eliminato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
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
  // ignore: prefer_typing_uninitialized_variables
  var valueFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var priceFieldController;
  //var productPriceStd;

  var id;

  var priceListVersionID = 0;

  String date = Get.arguments["date"];

  @override
  void initState() {
    super.initState();
    id = Get.arguments["ID"];
    valueFieldController = TextEditingController();
    nameFieldController = TextEditingController();
    qtyFieldController = TextEditingController();
    priceFieldController = TextEditingController();
    qtyFieldController.text = (Get.arguments["qty"] ?? 1).toString();
    priceFieldController.text = (Get.arguments["price"] ?? 0).toString();
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
          child: Text('Edit Sales Order Line'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //deleteSalesOrderLine();
                Get.defaultDialog(
                    title: "Delete",
                    content: const Text(
                        "Are you sure you want to delete the record?"),
                    onConfirm: () {
                      deleteSalesOrderLine();
                    },
                    onCancel: () {});
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                editSalesOrderLine();
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
                    initialValue: Get.arguments["date"],
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

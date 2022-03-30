import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/views/screens/crm_shipmentline_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';

class EditShipmentline extends StatefulWidget {
  const EditShipmentline({Key? key}) : super(key: key);

  @override
  State<EditShipmentline> createState() => _EditShipmentlineState();
}

class _EditShipmentlineState extends State<EditShipmentline> {
  editShipment() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "PlannedQty": int.parse(qtyFieldController.text),
      "Description": descriptionFieldController.text,
      "IsSelected": checkboxState,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/m_inoutline/${args["id"]}');
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
      //print(response.body);
      Get.back();
      Get.find<CRMShipmentlineController>().getShipmentlines();
      //print("done!");
      Get.snackbar(
        "Fatto!",
        "Il record è stato aggiornato",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Errore!",
        "Record non aggiornato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var qtyFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;

  var checkboxState;

  @override
  void initState() {
    super.initState();
    qtyFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    qtyFieldController.text = (args["qtyPlanned"]).toString();
    descriptionFieldController.text = args["description"] ?? "";
    checkboxState = args["isSelected"] ?? false;
  }

  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit ShipmentLine'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                editShipment();
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
                    //maxLines: 5,
                    controller: qtyFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields),
                      border: OutlineInputBorder(),
                      labelText: 'Quantity Planned',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_fields),
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CheckboxListTile(
                    title: const Text('Selected'),
                    value: checkboxState,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        checkboxState = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
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
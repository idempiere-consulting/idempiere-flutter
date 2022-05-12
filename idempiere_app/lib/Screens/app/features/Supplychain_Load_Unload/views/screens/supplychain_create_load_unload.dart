import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload/models/warehouse_json.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload/views/screens/supplychain_load_unload_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateSupplychainLoadUnload extends StatefulWidget {
  const CreateSupplychainLoadUnload({Key? key}) : super(key: key);

  @override
  State<CreateSupplychainLoadUnload> createState() =>
      _CreateSupplychainLoadUnloadState();
}

class _CreateSupplychainLoadUnloadState
    extends State<CreateSupplychainLoadUnload> {
  createLoadUnload() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var formatter = DateFormat('yyyy-MM-dd');
    // ignore: prefer_typing_uninitialized_variables
    var msg;
    if (activityFieldController.text == "") {
      msg = jsonEncode({
        "AD_Org_ID": {"id": GetStorage().read("organizationid")},
        "AD_Client_ID": {"id": GetStorage().read("clientid")},
        "C_DocType_ID": {"id": Get.arguments["idDoc"]},
        "M_Warehouse_ID": {"id": int.parse(warehouseId)},
        "MovementDate": formatter.format(DateTime.now()),
        "Description": descriptionFieldController.text,
        "DocAction": "CO",
      });
    } else {
      msg = jsonEncode({
        "AD_Org_ID": {"id": GetStorage().read("organizationid")},
        "AD_Client_ID": {"id": GetStorage().read("clientid")},
        "C_Activity_ID": {"id": int.parse(activityFieldController.text)},
        "C_DocType_ID": {"id": Get.arguments["idDoc"]},
        "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
        "MovementDate": formatter.format(DateTime.now()),
        "Description": descriptionFieldController.text,
        "DocAction": "CO",
      });
    }

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/M_Inventory/');
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
      if (kDebugMode) {
        print(response.body);
      }
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      Get.find<SupplychainLoadUnloadController>().getLoadUnloads();
      Get.offNamed('/SupplychainLoadUnloadLine', arguments: {
        "id": json["id"],
        "docNo": json["DocumentNo"],
        "warehouseId": warehouseId
      });
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
      if (kDebugMode) {
        print(response.body);
      }
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

  Future<void> getWarehouses() async {
    setState(() {
      warehouseAvailable = false;
    });

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/M_warehouse?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(utf8.decode(response.bodyBytes));

      trx = WarehouseJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        warehouseAvailable = true;
      });
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
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
  var activityFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;

  bool warehouseAvailable = false;

  var warehouseId = "1000000";

  late WarehouseJson trx;

  @override
  void initState() {
    super.initState();
    warehouseId = Get.arguments["warehouseId"].toString();
    warehouseAvailable = false;
    activityFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    getWarehouses();
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
        title: Center(
          child: Text('Add Load/Unload'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                createLoadUnload();
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
                    controller: activityFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity (Barcode)'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: warehouseAvailable
                      ? DropdownButton(
                          value: warehouseId,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              warehouseId = newValue!;
                            });
                            if (kDebugMode) {
                              print(newValue);
                            }
                          },
                          items: trx.records!
                              .map((list) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    list.name ?? "???",
                                  ),
                                  value: list.id.toString(),
                                );
                              })
                              .toSet()
                              .toList(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: "Description".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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

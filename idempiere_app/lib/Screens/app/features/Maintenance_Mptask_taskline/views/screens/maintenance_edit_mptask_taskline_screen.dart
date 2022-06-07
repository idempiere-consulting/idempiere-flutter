import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_mptask_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';

class EditMaintenanceMptaskLine extends StatefulWidget {
  const EditMaintenanceMptaskLine({Key? key}) : super(key: key);

  @override
  State<EditMaintenanceMptaskLine> createState() =>
      _EditMaintenanceMptaskLineState();
}

class _EditMaintenanceMptaskLineState extends State<EditMaintenanceMptaskLine> {
  deleteWorkOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' + ip + '/api/v1/models/mp_ot/${args["id"]}');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //Get.find<MaintenanceMptaskController>().getWorkOrders();
      //print("done!");
      Get.back();
      Get.back();
      Get.snackbar(
        "Fatto!",
        "Il record è stato cancellato",
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
      //print(response.body);
      Get.snackbar(
        "Errore!",
        "Il record non è stato cancellato",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  editWorkOrder(bool isConnected) async {
    //print(now);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "Status": {"id": dropdownValue},
    });
    var url =
        Uri.parse('http://' + ip + '/api/v1/models/MP_OT_Task/${args["id"]}');
    //print(msg);

    WorkOrderLocalJson trx = WorkOrderLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderSync')));

    trx.records![args["index"]].mpOtTaskStatus = dropdownValue;

    //print(trx.records![args["index"]].mpOtTaskStatus = dropdownValue);
    var data = jsonEncode(trx.toJson());

    GetStorage().write('workOrderSync', data);

    Get.find<MaintenanceMptaskLineController>().getWorkOrders();
    Get.find<MaintenanceMptaskController>().getWorkOrders();

    //print(qwe);
    if (isConnected) {
      emptyAPICallStak();
      var response = await http.put(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //Get.find<MaintenanceMptaskController>().getWorkOrders();
        //print("done!");
        //Get.back();
        Get.snackbar(
          "Fatto!",
          "Il record è stato modificato",
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        //print(response.body);
        Get.snackbar(
          "Errore!",
          "Il record non è stato modificato",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      Map calls = {};
      if (GetStorage().read('storedEditAPICalls') == null) {
        calls['http://' + ip + '/api/v1/models/MP_OT_Task/${args["id"]}'] = msg;
      } else {
        calls = GetStorage().read('storedEditAPICalls');
        calls['http://' + ip + '/api/v1/models/MP_OT_Task/${args["id"]}'] = msg;
      }
      GetStorage().write('storedEditAPICalls', calls);
      Get.snackbar(
        "Salvato!",
        "Il record è stato salvato localmente in attesa di connessione internet.",
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
    }
  }

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  final json = {
    "types": [
      {"id": "NS", "name": "NS".tr},
      {"id": "IP", "name": "IP".tr},
      {"id": "ST", "name": "ST".tr},
      {"id": "CO", "name": "CO".tr},
    ]
  };

  late List<Types> dropDownList;
  String dropdownValue = "";

  dynamic args = Get.arguments;

  @override
  void initState() {
    dropdownValue = args["completed"] ?? "NS";
    dropDownList = getTypes()!;
    super.initState();

    //getDocType();
    //getResourceName();
    //getAllResources();
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit WorkOrder'),
        ),
        actions: [
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Eliminazione record",
                  middleText: "Sicuro di voler eliminare il record?",
                  backgroundColor: const Color.fromRGBO(38, 40, 55, 1),
                  //titleStyle: TextStyle(color: Colors.white),
                  //middleTextStyle: TextStyle(color: Colors.white),
                  textConfirm: "Elimina",
                  textCancel: "Annulla",
                  cancelTextColor: Colors.white,
                  confirmTextColor: Colors.white,
                  buttonColor: const Color.fromRGBO(31, 29, 44, 1),
                  barrierDismissible: false,
                  onConfirm: () {
                    //deleteWorkOrder();
                  },
                  //radius: 50,
                );
                //editLead();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ), */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                editWorkOrder(isConnected);
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
                const Text("Stato Completamento"),
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
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      //print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text("Stato Completamento"),
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
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      //print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
                  ),
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
                const Text("Stato Completamento"),
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
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      //print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

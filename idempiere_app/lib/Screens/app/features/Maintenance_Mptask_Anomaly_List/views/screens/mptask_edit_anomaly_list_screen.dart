// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_List/models/anomaly_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_List/views/screens/mptask_anomaly_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';

class EditAnomalyList extends StatefulWidget {
  const EditAnomalyList({Key? key}) : super(key: key);

  @override
  State<EditAnomalyList> createState() => _EditAnomalyListState();
}

class _EditAnomalyListState extends State<EditAnomalyList> {
  editAnomaly(bool isConnected) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');

    const filename = "anomalies";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var msg = jsonEncode({
      //"LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
      //"AD_User_ID": {"id": GetStorage().read("userId")},
      //"Name": "anomaly",
      "Description": noteFieldController.text,
      "IsInvoiced": isCharged,
      "LIT_IsReplaced": isReplacedNow,
      //"M_Product_ID": {"id": replacementId},
      //"DateDoc": "${formattedDate}T00:00:00Z",
      "LIT_IsManagedByCustomer": manByCustomer,
      "IsClosed": isClosed,
    });

    var json = AnomalyJson.fromJson(jsonDecode(file.readAsStringSync()));

    if (Get.arguments["id"] != null && offline == -1) {
      json.records![Get.arguments["index"]].description =
          noteFieldController.text;
      json.records![Get.arguments["index"]].isInvoiced = isCharged;
      json.records![Get.arguments["index"]].lITIsReplaced = isReplacedNow;
      json.records![Get.arguments["index"]].lITIsManagedByCustomer =
          manByCustomer;
      json.records![Get.arguments["index"]].isClosed = isClosed;

      var url = Uri.parse(
          'http://' + ip + '/api/v1/models/LIT_NC/${Get.arguments["id"]}');
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
          var data = jsonEncode(json.toJson());
          file.writeAsStringSync(data);
          Get.find<MaintenanceMpResourceController>().getWorkOrders();
          Get.find<AnomalyListController>().getAnomalies();
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
          //print(response.statusCode);
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
        var data = jsonEncode(json.toJson());
        //GetStorage().write('workOrderSync', data);
        file.writeAsStringSync(data);
        Get.find<MaintenanceMpResourceController>().getWorkOrders();
        Get.find<AnomalyListController>().getAnomalies();
        Map calls = {};
        if (GetStorage().read('storedEditAPICalls') == null) {
          calls['http://' +
              ip +
              '/api/v1/models/LIT_NC/${Get.arguments["id"]}'] = msg;
        } else {
          calls = GetStorage().read('storedEditAPICalls');
          calls['http://' +
              ip +
              '/api/v1/models/LIT_NC/${Get.arguments["id"]}'] = msg;
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
      if (offline != -1) {
        List<dynamic> list = GetStorage().read('postCallList');

        for (var i = 0; i < list.length; i++) {
          var json = jsonDecode(list[i]);
          if (json["offlineid"] == Get.arguments?["offlineid"]) {
            var url2 = json["url"];
            var offlineid2 = json["offlineid"];
            var adorg = json["AD_Org_ID"];
            var adclient = json["AD_Client_ID"];
            var faultType = json["LIT_NCFaultType_ID"];
            var aduser = json["AD_User_ID"];
            var product = json["M_Product_ID"];
            var date = json["DateDoc"];
            var workorder = json["MP_OT_ID"];
            var resource = json["MP_Maintain_Resource_ID"];

            var call = jsonEncode({
              "offlineid": offlineid2,
              "url": url2,
              "AD_Org_ID": adorg,
              "MP_OT_ID": workorder,
              "MP_Maintain_Resource_ID": resource,
              "AD_Client_ID": adclient,
              "LIT_NCFaultType_ID": faultType,
              "AD_User_ID": aduser,
              "Name": "anomaly",
              "Description": noteFieldController.text,
              "IsInvoiced": isCharged,
              "LIT_IsReplaced": isReplacedNow,
              "M_Product_ID": product,
              "DateDoc": date,
              "LIT_IsManagedByCustomer": manByCustomer,
              "IsClosed": isClosed,
            });

            list.removeAt(i);
            list.add(call);
            GetStorage().write('postCallList', list);
            var data = jsonEncode(json.toJson());
            //GetStorage().write('workOrderSync', data);
            file.writeAsStringSync(data);
            Get.find<MaintenanceMpResourceController>().getWorkOrders();
            Get.find<AnomalyListController>().getAnomalies();
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
      }
    }
  }

  var offline = -1;
  var anomalyTypeFieldController;
  var resourceFieldController;
  bool manByCustomer = false;
  bool isCharged = false;
  bool isReplacedNow = false;
  var noteFieldController;
  bool isClosed = false;
  @override
  void initState() {
    super.initState();
    anomalyTypeFieldController =
        TextEditingController(text: Get.arguments["fault"]);
    resourceFieldController =
        TextEditingController(text: Get.arguments["resource"]);
    manByCustomer = Get.arguments["manByCustomer"];
    isCharged = Get.arguments["invoiced"];
    isReplacedNow = Get.arguments["replaced"];
    noteFieldController = TextEditingController(text: Get.arguments["note"]);
    isClosed = Get.arguments["closed"];
    offline = Get.arguments["offlineid"] ?? -1;
  }

  static String _displayStringForOption(Records option) => option.name!;

  static int _setIdForOption(Records option) => option.id!;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Edit Anomaly'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                editAnomaly(isConnected);
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: anomalyTypeFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Anomaly Type'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: resourceFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Resource'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Managed by the Customer'.tr),
                  value: manByCustomer,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      manByCustomer = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Visibility(
                  visible: manByCustomer != true,
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    title: Text('Is Charged'.tr),
                    value: isCharged,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        isCharged = value!;
                        //GetStorage().write('checkboxLogin', checkboxState);
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Visibility(
                  visible: manByCustomer != true,
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    title: Text('Is being Replaced Now'.tr),
                    value: isReplacedNow,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        isReplacedNow = value!;
                        //GetStorage().write('checkboxLogin', checkboxState);
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //readOnly: true,
                    controller: noteFieldController,
                    minLines: 2,
                    maxLines: 2,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Closed'.tr),
                  value: isClosed,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isClosed = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: const [
                SizedBox(
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

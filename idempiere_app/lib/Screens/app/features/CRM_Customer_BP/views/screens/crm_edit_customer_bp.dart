import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/models/customer_bp_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/views/screens/crm_customer_bp_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

class EditCRMCustomerBP extends StatefulWidget {
  const EditCRMCustomerBP({Key? key}) : super(key: key);

  @override
  State<EditCRMCustomerBP> createState() => _EditCRMCustomerBP();
}

class _EditCRMCustomerBP extends State<EditCRMCustomerBP> {
  editCustomer() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Name": nameFieldController.text,
      "Value": valueController.text,
      "C_BP_Group_ID": int.parse(dropdownValue),
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/C_BPartner/${args["id"]}');
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
      Get.find<CRMCustomerBPController>().getCustomers();
      //print("done!");
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Error!".tr,
        "Record not updated".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  deleteCustomer() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/ad_user/${args["id"]}');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMCustomerBPController>().getCustomers();
      //print("done!");
      Get.back();
      Get.back();
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.delete,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Error!".tr,
        "Record not updated".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  Future<List<Records>> getAllBPGroups() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/C_BP_Group?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = CustomerBpJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load BP Groups");
    }

    //print(response.body);
  }

  void fillFields() {
    nameFieldController.text = args["Name"] ?? "";
    valueController.text = args["Value"] ?? "";
    //salesRepFieldController.text = args["salesRep"];
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var valueController;
  // ignore: prefer_typing_uninitialized_variables
  //var bPGroupController;
  String dropdownValue = "";

  @override
  void initState() {
    dropdownValue = (args["C_BP_Group_ID"]).toString();
    super.initState();
    nameFieldController = TextEditingController();
    valueController = TextEditingController();
    //bPGroupController = TextEditingController();
    fillFields();
    getAllBPGroups();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Edit Customer'.tr),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Record deletion".tr,
                    middleText: "Are you sure to delete the record?".tr,
                    backgroundColor: const Color.fromRGBO(38, 40, 55, 1),
                    //titleStyle: TextStyle(color: Colors.white),
                    //middleTextStyle: TextStyle(color: Colors.white),
                    textConfirm: "Delete".tr,
                    textCancel: "Cancel".tr,
                    cancelTextColor: Colors.white,
                    confirmTextColor: Colors.white,
                    buttonColor: const Color.fromRGBO(31, 29, 44, 1),
                    barrierDismissible: false,
                    onConfirm: () {
                      deleteCustomer();
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () {
                  editCustomer();
                },
                icon: const Icon(
                  Icons.save,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'Name'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: const OutlineInputBorder(),
                    labelText: 'Value'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gruppo Business Partner'.tr,
                    style: const TextStyle(fontSize: 12),
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
                child: FutureBuilder(
                  future: getAllBPGroups(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<Records>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              value: dropdownValue,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
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
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                ),
              ),
            ],
          );
        }, tabletBuilder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'Name'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: const OutlineInputBorder(),
                    labelText: 'Value'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gruppo Business Partner'.tr,
                    style: const TextStyle(fontSize: 12),
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
                child: FutureBuilder(
                  future: getAllBPGroups(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<Records>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              value: dropdownValue,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
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
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                ),
              ),
            ],
          );
        }, desktopBuilder: (context, cons) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'Name'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: const OutlineInputBorder(),
                    labelText: 'Value'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gruppo Business Partner'.tr,
                    style: const TextStyle(fontSize: 12),
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
                child: FutureBuilder(
                  future: getAllBPGroups(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<Records>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              value: dropdownValue,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
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
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                ),
              ),
            ],
          );
        })));
  }
}

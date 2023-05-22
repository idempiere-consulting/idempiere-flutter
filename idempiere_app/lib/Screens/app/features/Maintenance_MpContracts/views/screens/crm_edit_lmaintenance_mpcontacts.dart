import 'dart:convert';
import 'dart:io';
//import 'dart:developer';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/models/mpmaintaincontractjson.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/businesspartner_location_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/views/screens/crm_maintenance_mpcontacts_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_edit_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class EditMaintenanceMpContracts extends StatefulWidget {
  const EditMaintenanceMpContracts({Key? key}) : super(key: key);

  @override
  State<EditMaintenanceMpContracts> createState() =>
      _EditMaintenanceMpContractsState();
}

class _EditMaintenanceMpContractsState
    extends State<EditMaintenanceMpContracts> {
  edit() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var msg = jsonEncode({
      "DateNextRun": "${date}T00:00:00Z",
      "AD_User_ID": {"id": technicianId},
      "C_BPartner_ID": {"id": businesspartnerId},
    });
    if (technicianId == 0) {
      msg = jsonEncode({
        "DateNextRun": "${date}T00:00:00Z",
        "C_BPartner_ID": {"id": businesspartnerId},
        "Help": helpFieldController.text,
      });
    }
    //print(msg);
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/MP_Maintain/${args["maintainId"]}');
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
      const filename = "maintain";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

      var trx =
          MPMaintainContractJSON.fromJson(jsonDecode(file.readAsStringSync()));

      for (var element in trx.records!) {
        if (element.id == args["maintainId"]) {
          element.dateNextRun = date;
          element.cBPartnerID?.id = businesspartnerId;
          element.cBPartnerID?.identifier = businesspartnerName;
          element.litMpMaintainHelp = helpFieldController.text;
        }
      }
      file.writeAsStringSync(jsonEncode(trx.toJson()));
      Get.find<MaintenanceMpContractsController>().getContracts();
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

  deleteLead() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/MP_Maintain/${args["maintainId"]}');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<MaintenanceMpContractsController>().getContracts();
      Get.back();
      //print("done!");
      Get.back();
      Get.back();
      Get.snackbar(
        "Done!".tr,
        "The record has been erased".tr,
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

  Future<List<LSRecords>> getAllLeadStatuses() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 53416 ');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = LeadStatusJson.fromJson(jsonDecode(response.body));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead statuses");
    }

    //print(response.body);
  }

  Future<List<CRecords>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<BPRecords>> getAllBPs() async {
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    //await getBusinessPartner();
    //print(response.body);
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  void fillFields() {
    /* nameFieldController.text = args["name"] ?? "";
    bPartnerFieldController.text = args["bpName"] ?? "";
    phoneFieldController.text = args["Tel"] ?? "";
    mailFieldController.text = args["eMail"] ?? ""; */
    //dropdownValue = args["leadStatus"];
    //salesrepValue = args["salesRep"] ?? "";
    //salesRepFieldController.text = args["salesRep"];
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var phoneFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var mailFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var helpFieldController;
  String dropdownValue = "";
  String salesrepValue = "";
  String date = (Get.arguments["date"]).substring(0, 10);
  // ignore: prefer_typing_uninitialized_variables
  var taskFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var ivaFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var addressFieldController;
  //var cityFieldController;
  var businesspartnerId = 0;
  var businesspartnerName = "";
  var technicianId = 0;
  DateTime now = DateTime.now();

  List<RRecords> productList = [];

  var flagResources = false;

  @override
  void initState() {
    super.initState();
    flagResources = false;
    businesspartnerId = Get.arguments['businesspartnerId'];
    technicianId = Get.arguments["technicianId"] ?? 0;
    businesspartnerName = Get.arguments['businesspartnerName'];
    nameFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    mailFieldController = TextEditingController();
    taskFieldController = TextEditingController();
    ivaFieldController = TextEditingController();
    addressFieldController = TextEditingController();
    helpFieldController =
        TextEditingController(text: Get.arguments["help"] ?? "");
    //cityFieldController = TextEditingController();
    getContractResource();
    getBusinessPartner();

    //dropdownValue = Get.arguments["leadStatus"];
    fillFields();
    getAllLeadStatuses();
  }

  getContractResource() async {
    /* final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/mp_maintain_resource?\$filter= MP_Maintain_ID eq ${Get.arguments['maintainId']} and MP_Maintain_Resource_ID neq null and M_Product_ID neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200)  */

    const filename = "workorderresource";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    //print(response.body);
    var json = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));

    json.records!.retainWhere(
        (element) => element.mpMaintainID?.id == Get.arguments['maintainId']);
    productList = json.records!;
    setState(() {
      flagResources = true;
    });
    /*  } else {
      if (kDebugMode) {
        print(response.body);
      }
    } */
  }

  getBusinessPartner() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= C_BPartner_ID eq $businesspartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      nameFieldController.text = json.records![0].name;
      ivaFieldController.text = (json.records![0].litTaxID) ?? "";
      getBusinessPartnerLocation();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  /* String getPerm(String type) {
    for (var i = 0; i < _tt.records!.length; i++) {
      if (_tt.records![i].value == type) {
        return _tt.records![i].parameterValue!;
      }
    }
    return "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
  } */

  getBusinessPartnerLocation() async {
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner_location?\$filter= C_BPartner_ID eq $businesspartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerLocationJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      addressFieldController.text =
          json.records![0].cLocationID?.identifier ?? "";
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  static String _displayStringForOption(CRecords option) => option.name!;
  static String _displayBPStringForOption(BPRecords option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Contract'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Record deletion".tr,
                  middleText: "Are you sure you want to delete the record?".tr,
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
                    deleteLead();
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
                edit();
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
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Business Partner".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption:
                                    _displayBPStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<BPRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((BPRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (BPRecords selection) {
                                  businesspartnerId = selection.id!;
                                  getBusinessPartner();
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    readOnly: true,
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
                    //maxLines: 5,
                    readOnly: true,
                    controller: ivaFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payments),
                      border: const OutlineInputBorder(),
                      labelText: 'P. IVA'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    readOnly: true,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.home),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const Divider(),
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
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: Get.arguments['date'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Contract Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);

                      date = val.substring(0, 10);

                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Technician".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<CRecords>(
                                initialValue: TextEditingValue(
                                    text: (Get.arguments["technicianName"]) ??
                                        ""),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((CRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    technicianId = selection.id!;
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    //readOnly: true,
                    controller: helpFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.badge),
                      border: const OutlineInputBorder(),
                      labelText: 'WO Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: taskFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Task'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Visibility(
                  visible: flagResources,
                  child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ExpansionTile(
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.timer_outlined,
                                  color: (productList[index]
                                                  .lITControl2DateNext)
                                              ?.substring(0, 4) ==
                                          now.year.toString()
                                      ? Colors.yellow
                                      : (productList[index].lITControl3DateNext)
                                                  ?.substring(0, 4) ==
                                              now.year.toString()
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
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
                                  icon: Icon(
                                    productList[index].eDIType?.id == 'A02'
                                        ? Icons.grid_4x4_outlined
                                        : Icons.edit,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Edit Resource',
                                  onPressed: () async {
                                    switch (productList[index].eDIType?.id) {
                                      case "A01":
                                        if (productList[index].offlineId ==
                                            null) {
                                          Get.toNamed(
                                              '/MaintenanceMpResourceSheet',
                                              arguments: {
                                                "surveyId": productList[index]
                                                    .lITSurveySheetsID
                                                    ?.id,
                                                "id": productList[index].id,
                                                "serNo":
                                                    productList[index].serNo ??
                                                        "",
                                                "prodId": productList[index]
                                                    .mProductID
                                                    ?.id,
                                                "prodName": productList[index]
                                                    .mProductID
                                                    ?.identifier,
                                                "lot": productList[index].lot,
                                                "location": productList[index]
                                                    .locationComment,
                                                "locationCode":
                                                    productList[index].value,
                                                "manYear": productList[index]
                                                    .manufacturedYear,
                                                "userName":
                                                    productList[index].userName,
                                                "serviceDate":
                                                    productList[index]
                                                        .serviceDate,
                                                "endDate":
                                                    productList[index].endDate,
                                                "manufacturer":
                                                    productList[index]
                                                        .manufacturer,
                                                "model": productList[index]
                                                    .lITProductModel,
                                                "manufacturedYear":
                                                    productList[index]
                                                        .manufacturedYear,
                                                "purchaseDate":
                                                    productList[index]
                                                        .dateOrdered,
                                                "note": productList[index].name,
                                                "resTypeId": productList[index]
                                                    .lITResourceType
                                                    ?.id,
                                                "valid":
                                                    productList[index].isValid,
                                                "offlineid": productList[index]
                                                    .offlineId,
                                                "index": index,
                                              });
                                        }

                                        break;
                                      case 'A02':
                                        Get.toNamed(
                                            '/MaintenanceMpResourceFireExtinguisherGrid',
                                            arguments: {
                                              "products": File(
                                                  '${(await getApplicationDocumentsDirectory()).path}/products.json')
                                            });
                                        break;
                                      default:
                                    }
                                    /* Get.to(
                                            const EditMaintenanceMpResource(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "productName": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "SerNo": controller
                                                  .trx.records![index].serNo,
                                              "Description": controller.trx
                                                  .records![index].description,
                                              "date3": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl3DateFrom,
                                              "date2": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl2DateFrom,
                                              "date1": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": controller.trx
                                                  .records![index].offlineId,
                                              "index": index,
                                            }); */
                                  },
                                ),
                              ),
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "NR. ${productList[index].number} L. ${productList[index].lineNo} b. ${productList[index].prodCode} M. ${productList[index].serNo}",
                                          style: const TextStyle(
                                            color:
                                                kNotifColor, /* fontWeight: FontWeight.bold */
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          productList[index]
                                                  .mProductID
                                                  ?.identifier ??
                                              "???",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          productList[index].locationComment ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      'Quantity: '.tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${productList[index].resourceQty}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ]),
                                  Visibility(
                                    visible:
                                        productList[index].toDoAction! != "OK",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: productList[index]
                                                        .toDoAction! ==
                                                    "OK"
                                                ? kNotifColor
                                                : productList[index]
                                                            .toDoAction! ==
                                                        "PR"
                                                    ? const Color.fromARGB(
                                                        255, 209, 189, 4)
                                                    : productList[index]
                                                                .toDoAction! ==
                                                            "PT"
                                                        ? Colors.orange
                                                        : productList[index]
                                                                    .toDoAction! ==
                                                                "PSG"
                                                            ? Colors.red
                                                            : productList[index]
                                                                        .toDoAction! ==
                                                                    "PX"
                                                                ? Colors.black
                                                                : kNotifColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2.5),
                                          child: Text(
                                            productList[index].toDoAction!.tr,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              children: [
                                Column(
                                  children: [
                                    Row(children: [
                                      Text('Note: '.tr),
                                      Text(productList[index].name ?? ""),
                                    ]),
                                    Row(children: [
                                      Text('Status: '.tr),
                                      Text(productList[index]
                                              .resourceStatus
                                              ?.identifier ??
                                          ""),
                                    ]),
                                    /* Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Description: '.tr),
                                      Text(
                                          productList[index].description ?? ""),
                                    ]),
                                    /* Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]), */
                                    /* Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Check Date: '.tr),
                                      Text(
                                          "${DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl1DateNext!))}"),
                                    ]),
                                    /* Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Revision Date: '.tr),
                                      Text(
                                          "${productList[index].lITControl2DateFrom != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl2DateFrom!)) : ""} - ${productList[index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl2DateNext!)) : ""}"),
                                    ]),
                                    /*  Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]), */ //DateFormat('dd-MM-yyyy').format(
                                    //DateTime.parse(controller.trx
                                    //   .records![index].jpToDoStartDate!))
                                    Row(children: [
                                      Text('Testing Date: '.tr),
                                      Text(
                                          "${productList[index].lITControl3DateFrom != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl3DateFrom!)) : ""} - ${productList[index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl3DateNext!)) : ""}"),
                                    ]),
                                    Row(children: [
                                      Text('Manufactured Year: '.tr),
                                      Text(productList[index]
                                          .manufacturedYear
                                          .toString()),
                                    ]),
                                    Row(children: [
                                      Text('Manufacturer: '.tr),
                                      Text(productList[index].manufacturer ??
                                          ""),
                                    ]),
                                    Visibility(
                                      visible: productList[index].eDIType?.id ==
                                          "A02",
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              tooltip: 'Edit',
                                              onPressed: () async {
                                                Get.to(
                                                    const EditMaintenanceMpResource(),
                                                    arguments: {
                                                      "perm":
                                                          "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",
                                                      "id":
                                                          productList[index].id,
                                                      "number":
                                                          productList[index]
                                                              .number,
                                                      "lineNo":
                                                          productList[index]
                                                              .lineNo
                                                              .toString(),
                                                      "cartel":
                                                          productList[index]
                                                              .textDetails,
                                                      "model":
                                                          productList[index]
                                                              .lITProductModel,
                                                      "dateOrder":
                                                          productList[index]
                                                              .dateOrdered,
                                                      "years":
                                                          productList[index]
                                                              .useLifeYears
                                                              .toString(),
                                                      "user": productList[index]
                                                          .userName,
                                                      "serviceDate":
                                                          productList[index]
                                                              .serviceDate,
                                                      "productName":
                                                          productList[index]
                                                              .mProductID!
                                                              .identifier,
                                                      "productId":
                                                          productList[index]
                                                              .mProductID!
                                                              .id,
                                                      "location":
                                                          productList[index]
                                                              .locationComment,
                                                      "observation":
                                                          productList[index]
                                                              .name,
                                                      "SerNo":
                                                          productList[index]
                                                              .serNo,
                                                      "barcode":
                                                          productList[index]
                                                              .prodCode,
                                                      "manufacturer":
                                                          productList[index]
                                                              .manufacturer,
                                                      "year": productList[index]
                                                          .manufacturedYear
                                                          .toString(),
                                                      "Description":
                                                          productList[index]
                                                              .description,
                                                      "date3": productList[
                                                              index]
                                                          .lITControl3DateFrom,
                                                      "date2": productList[
                                                              index]
                                                          .lITControl2DateFrom,
                                                      "date1": productList[
                                                              index]
                                                          .lITControl1DateFrom,
                                                      "offlineid":
                                                          productList[index]
                                                              .offlineId,
                                                      "index": index,
                                                    });
                                                /* controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index); */
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            /* IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Revision',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .replaceResource(index);
                                                    /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                  },
                                                  icon: const Icon(
                                                      Icons.handyman_outlined),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Testing',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateTesting(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.gavel_outlined),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Anomaly',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    if (isConnected) {
                                                      await emptyPostCallStack();
                                                      await emptyEditAPICallStack();
                                                      await emptyDeleteCallStack();
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "docNo": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mpOtDocumentno ??
                                                              "",
                                                          "productId": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID
                                                                  ?.id ??
                                                              0,
                                                          "productName": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID
                                                                  ?.identifier ??
                                                              "",
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .anomaliesCount!) !=
                                                                0
                                                            ? true
                                                            : false,
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Replace',
                                                  onPressed: () async {
                                                    controller
                                                        .replaceResourceButton(
                                                            index);
                                                    /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                  },
                                                  icon: const Icon(
                                                      Icons.find_replace),
                                                ), */
                                          ]),
                                    ),
                                    /* Visibility(
                                          visible: productList[index]
                                                  .eDIType
                                                  ?.id !=
                                              "A02",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                tooltip: 'Anomaly',
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();
                                                  if (isConnected) {
                                                    await emptyPostCallStack();
                                                    await emptyEditAPICallStack();
                                                    await emptyDeleteCallStack();
                                                  }
                                                  Get.to(
                                                      const CreateResAnomaly(),
                                                      arguments: {
                                                        "docNo": controller
                                                                .trx
                                                                .records![index]
                                                                .mpOtDocumentno ??
                                                            "",
                                                        "productId": controller
                                                                .trx
                                                                .records![index]
                                                                .mProductID
                                                                ?.id ??
                                                            0,
                                                        "productName": controller
                                                                .trx
                                                                .records![index]
                                                                .mProductID
                                                                ?.identifier ??
                                                            "",
                                                        "isConnected":
                                                            isConnected,
                                                      });
                                                },
                                                icon: const Icon(
                                                  Icons.warning,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),

                /* Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "LeadStatus".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                    future: getAllLeadStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
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
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.value.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ), */
              ],
            );
          },
          tabletBuilder: (context, constraints) {
             return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Business Partner".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption:
                                    _displayBPStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<BPRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((BPRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (BPRecords selection) {
                                  businesspartnerId = selection.id!;
                                  getBusinessPartner();
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    readOnly: true,
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
                    //maxLines: 5,
                    readOnly: true,
                    controller: ivaFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payments),
                      border: const OutlineInputBorder(),
                      labelText: 'P. IVA'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    readOnly: true,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.home),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const Divider(),
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
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: Get.arguments['date'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Contract Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);

                      date = val.substring(0, 10);

                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Technician".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<CRecords>(
                                initialValue: TextEditingValue(
                                    text: (Get.arguments["technicianName"]) ??
                                        ""),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((CRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    technicianId = selection.id!;
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    //readOnly: true,
                    controller: helpFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.badge),
                      border: const OutlineInputBorder(),
                      labelText: 'WO Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: taskFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Task'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Visibility(
                  visible: flagResources,
                  child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ExpansionTile(
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.timer_outlined,
                                  color: (productList[index]
                                                  .lITControl2DateNext)
                                              ?.substring(0, 4) ==
                                          now.year.toString()
                                      ? Colors.yellow
                                      : (productList[index].lITControl3DateNext)
                                                  ?.substring(0, 4) ==
                                              now.year.toString()
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
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
                                  icon: Icon(
                                    productList[index].eDIType?.id == 'A02'
                                        ? Icons.grid_4x4_outlined
                                        : Icons.edit,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Edit Resource',
                                  onPressed: () async {
                                    switch (productList[index].eDIType?.id) {
                                      case "A01":
                                        if (productList[index].offlineId ==
                                            null) {
                                          Get.toNamed(
                                              '/MaintenanceMpResourceSheet',
                                              arguments: {
                                                "surveyId": productList[index]
                                                    .lITSurveySheetsID
                                                    ?.id,
                                                "id": productList[index].id,
                                                "serNo":
                                                    productList[index].serNo ??
                                                        "",
                                                "prodId": productList[index]
                                                    .mProductID
                                                    ?.id,
                                                "prodName": productList[index]
                                                    .mProductID
                                                    ?.identifier,
                                                "lot": productList[index].lot,
                                                "location": productList[index]
                                                    .locationComment,
                                                "locationCode":
                                                    productList[index].value,
                                                "manYear": productList[index]
                                                    .manufacturedYear,
                                                "userName":
                                                    productList[index].userName,
                                                "serviceDate":
                                                    productList[index]
                                                        .serviceDate,
                                                "endDate":
                                                    productList[index].endDate,
                                                "manufacturer":
                                                    productList[index]
                                                        .manufacturer,
                                                "model": productList[index]
                                                    .lITProductModel,
                                                "manufacturedYear":
                                                    productList[index]
                                                        .manufacturedYear,
                                                "purchaseDate":
                                                    productList[index]
                                                        .dateOrdered,
                                                "note": productList[index].name,
                                                "resTypeId": productList[index]
                                                    .lITResourceType
                                                    ?.id,
                                                "valid":
                                                    productList[index].isValid,
                                                "offlineid": productList[index]
                                                    .offlineId,
                                                "index": index,
                                              });
                                        }

                                        break;
                                      case 'A02':
                                        Get.toNamed(
                                            '/MaintenanceMpResourceFireExtinguisherGrid',
                                            arguments: {
                                              "products": File(
                                                  '${(await getApplicationDocumentsDirectory()).path}/products.json')
                                            });
                                        break;
                                      default:
                                    }
                                    /* Get.to(
                                            const EditMaintenanceMpResource(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "productName": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "SerNo": controller
                                                  .trx.records![index].serNo,
                                              "Description": controller.trx
                                                  .records![index].description,
                                              "date3": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl3DateFrom,
                                              "date2": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl2DateFrom,
                                              "date1": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": controller.trx
                                                  .records![index].offlineId,
                                              "index": index,
                                            }); */
                                  },
                                ),
                              ),
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "NR. ${productList[index].number} L. ${productList[index].lineNo} b. ${productList[index].prodCode} M. ${productList[index].serNo}",
                                          style: const TextStyle(
                                            color:
                                                kNotifColor, /* fontWeight: FontWeight.bold */
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          productList[index]
                                                  .mProductID
                                                  ?.identifier ??
                                              "???",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          productList[index].locationComment ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      'Quantity: '.tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${productList[index].resourceQty}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ]),
                                  Visibility(
                                    visible:
                                        productList[index].toDoAction! != "OK",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: productList[index]
                                                        .toDoAction! ==
                                                    "OK"
                                                ? kNotifColor
                                                : productList[index]
                                                            .toDoAction! ==
                                                        "PR"
                                                    ? const Color.fromARGB(
                                                        255, 209, 189, 4)
                                                    : productList[index]
                                                                .toDoAction! ==
                                                            "PT"
                                                        ? Colors.orange
                                                        : productList[index]
                                                                    .toDoAction! ==
                                                                "PSG"
                                                            ? Colors.red
                                                            : productList[index]
                                                                        .toDoAction! ==
                                                                    "PX"
                                                                ? Colors.black
                                                                : kNotifColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2.5),
                                          child: Text(
                                            productList[index].toDoAction!.tr,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              children: [
                                Column(
                                  children: [
                                    Row(children: [
                                      Text('Note: '.tr),
                                      Text(productList[index].name ?? ""),
                                    ]),
                                    Row(children: [
                                      Text('Status: '.tr),
                                      Text(productList[index]
                                              .resourceStatus
                                              ?.identifier ??
                                          ""),
                                    ]),
                                    /* Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Description: '.tr),
                                      Text(
                                          productList[index].description ?? ""),
                                    ]),
                                    /* Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]), */
                                    /* Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Check Date: '.tr),
                                      Text(
                                          "${DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl1DateNext!))}"),
                                    ]),
                                    /* Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Revision Date: '.tr),
                                      Text(
                                          "${productList[index].lITControl2DateFrom != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl2DateFrom!)) : ""} - ${productList[index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl2DateNext!)) : ""}"),
                                    ]),
                                    /*  Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]), */ //DateFormat('dd-MM-yyyy').format(
                                    //DateTime.parse(controller.trx
                                    //   .records![index].jpToDoStartDate!))
                                    Row(children: [
                                      Text('Testing Date: '.tr),
                                      Text(
                                          "${productList[index].lITControl3DateFrom != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl3DateFrom!)) : ""} - ${productList[index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl3DateNext!)) : ""}"),
                                    ]),
                                    Row(children: [
                                      Text('Manufactured Year: '.tr),
                                      Text(productList[index]
                                          .manufacturedYear
                                          .toString()),
                                    ]),
                                    Row(children: [
                                      Text('Manufacturer: '.tr),
                                      Text(productList[index].manufacturer ??
                                          ""),
                                    ]),
                                    Visibility(
                                      visible: productList[index].eDIType?.id ==
                                          "A02",
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              tooltip: 'Edit',
                                              onPressed: () async {
                                                Get.to(
                                                    const EditMaintenanceMpResource(),
                                                    arguments: {
                                                      "perm":
                                                          "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",
                                                      "id":
                                                          productList[index].id,
                                                      "number":
                                                          productList[index]
                                                              .number,
                                                      "lineNo":
                                                          productList[index]
                                                              .lineNo
                                                              .toString(),
                                                      "cartel":
                                                          productList[index]
                                                              .textDetails,
                                                      "model":
                                                          productList[index]
                                                              .lITProductModel,
                                                      "dateOrder":
                                                          productList[index]
                                                              .dateOrdered,
                                                      "years":
                                                          productList[index]
                                                              .useLifeYears
                                                              .toString(),
                                                      "user": productList[index]
                                                          .userName,
                                                      "serviceDate":
                                                          productList[index]
                                                              .serviceDate,
                                                      "productName":
                                                          productList[index]
                                                              .mProductID!
                                                              .identifier,
                                                      "productId":
                                                          productList[index]
                                                              .mProductID!
                                                              .id,
                                                      "location":
                                                          productList[index]
                                                              .locationComment,
                                                      "observation":
                                                          productList[index]
                                                              .name,
                                                      "SerNo":
                                                          productList[index]
                                                              .serNo,
                                                      "barcode":
                                                          productList[index]
                                                              .prodCode,
                                                      "manufacturer":
                                                          productList[index]
                                                              .manufacturer,
                                                      "year": productList[index]
                                                          .manufacturedYear
                                                          .toString(),
                                                      "Description":
                                                          productList[index]
                                                              .description,
                                                      "date3": productList[
                                                              index]
                                                          .lITControl3DateFrom,
                                                      "date2": productList[
                                                              index]
                                                          .lITControl2DateFrom,
                                                      "date1": productList[
                                                              index]
                                                          .lITControl1DateFrom,
                                                      "offlineid":
                                                          productList[index]
                                                              .offlineId,
                                                      "index": index,
                                                    });
                                                /* controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index); */
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            /* IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Revision',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .replaceResource(index);
                                                    /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                  },
                                                  icon: const Icon(
                                                      Icons.handyman_outlined),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Testing',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateTesting(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.gavel_outlined),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Anomaly',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    if (isConnected) {
                                                      await emptyPostCallStack();
                                                      await emptyEditAPICallStack();
                                                      await emptyDeleteCallStack();
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "docNo": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mpOtDocumentno ??
                                                              "",
                                                          "productId": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID
                                                                  ?.id ??
                                                              0,
                                                          "productName": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID
                                                                  ?.identifier ??
                                                              "",
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .anomaliesCount!) !=
                                                                0
                                                            ? true
                                                            : false,
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Replace',
                                                  onPressed: () async {
                                                    controller
                                                        .replaceResourceButton(
                                                            index);
                                                    /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                  },
                                                  icon: const Icon(
                                                      Icons.find_replace),
                                                ), */
                                          ]),
                                    ),
                                    /* Visibility(
                                          visible: productList[index]
                                                  .eDIType
                                                  ?.id !=
                                              "A02",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                tooltip: 'Anomaly',
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();
                                                  if (isConnected) {
                                                    await emptyPostCallStack();
                                                    await emptyEditAPICallStack();
                                                    await emptyDeleteCallStack();
                                                  }
                                                  Get.to(
                                                      const CreateResAnomaly(),
                                                      arguments: {
                                                        "docNo": controller
                                                                .trx
                                                                .records![index]
                                                                .mpOtDocumentno ??
                                                            "",
                                                        "productId": controller
                                                                .trx
                                                                .records![index]
                                                                .mProductID
                                                                ?.id ??
                                                            0,
                                                        "productName": controller
                                                                .trx
                                                                .records![index]
                                                                .mProductID
                                                                ?.identifier ??
                                                            "",
                                                        "isConnected":
                                                            isConnected,
                                                      });
                                                },
                                                icon: const Icon(
                                                  Icons.warning,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),

                /* Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "LeadStatus".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                    future: getAllLeadStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
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
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.value.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ), */
              ],
            );
          },
          desktopBuilder: (context, constraints) {
             return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Business Partner".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllBPs(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption:
                                    _displayBPStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<BPRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((BPRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (BPRecords selection) {
                                  businesspartnerId = selection.id!;
                                  getBusinessPartner();
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    readOnly: true,
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
                    //maxLines: 5,
                    readOnly: true,
                    controller: ivaFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payments),
                      border: const OutlineInputBorder(),
                      labelText: 'P. IVA'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    readOnly: true,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.home),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const Divider(),
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
                    //locale: Locale('languageCalendar'.tr),
                    type: DateTimePickerType.date,
                    initialValue: Get.arguments['date'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Contract Date'.tr,
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);

                      date = val.substring(0, 10);

                      //print(date);
                    },
                    validator: (val) {
                      //print(val);
                      return null;
                    },
                    //onSaved: (val) => print(val),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Technician".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllSalesRep(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<CRecords>(
                                initialValue: TextEditingValue(
                                    text: (Get.arguments["technicianName"]) ??
                                        ""),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((CRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    technicianId = selection.id!;
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    //readOnly: true,
                    controller: helpFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.badge),
                      border: const OutlineInputBorder(),
                      labelText: 'WO Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    //maxLines: 5,
                    controller: taskFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Task'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ), */
                Visibility(
                  visible: flagResources,
                  child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ExpansionTile(
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.timer_outlined,
                                  color: (productList[index]
                                                  .lITControl2DateNext)
                                              ?.substring(0, 4) ==
                                          now.year.toString()
                                      ? Colors.yellow
                                      : (productList[index].lITControl3DateNext)
                                                  ?.substring(0, 4) ==
                                              now.year.toString()
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
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
                                  icon: Icon(
                                    productList[index].eDIType?.id == 'A02'
                                        ? Icons.grid_4x4_outlined
                                        : Icons.edit,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Edit Resource',
                                  onPressed: () async {
                                    switch (productList[index].eDIType?.id) {
                                      case "A01":
                                        if (productList[index].offlineId ==
                                            null) {
                                          Get.toNamed(
                                              '/MaintenanceMpResourceSheet',
                                              arguments: {
                                                "surveyId": productList[index]
                                                    .lITSurveySheetsID
                                                    ?.id,
                                                "id": productList[index].id,
                                                "serNo":
                                                    productList[index].serNo ??
                                                        "",
                                                "prodId": productList[index]
                                                    .mProductID
                                                    ?.id,
                                                "prodName": productList[index]
                                                    .mProductID
                                                    ?.identifier,
                                                "lot": productList[index].lot,
                                                "location": productList[index]
                                                    .locationComment,
                                                "locationCode":
                                                    productList[index].value,
                                                "manYear": productList[index]
                                                    .manufacturedYear,
                                                "userName":
                                                    productList[index].userName,
                                                "serviceDate":
                                                    productList[index]
                                                        .serviceDate,
                                                "endDate":
                                                    productList[index].endDate,
                                                "manufacturer":
                                                    productList[index]
                                                        .manufacturer,
                                                "model": productList[index]
                                                    .lITProductModel,
                                                "manufacturedYear":
                                                    productList[index]
                                                        .manufacturedYear,
                                                "purchaseDate":
                                                    productList[index]
                                                        .dateOrdered,
                                                "note": productList[index].name,
                                                "resTypeId": productList[index]
                                                    .lITResourceType
                                                    ?.id,
                                                "valid":
                                                    productList[index].isValid,
                                                "offlineid": productList[index]
                                                    .offlineId,
                                                "index": index,
                                              });
                                        }

                                        break;
                                      case 'A02':
                                        Get.toNamed(
                                            '/MaintenanceMpResourceFireExtinguisherGrid',
                                            arguments: {
                                              "products": File(
                                                  '${(await getApplicationDocumentsDirectory()).path}/products.json')
                                            });
                                        break;
                                      default:
                                    }
                                    /* Get.to(
                                            const EditMaintenanceMpResource(),
                                            arguments: {
                                              "id": controller
                                                  .trx.records![index].id,
                                              "productName": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .identifier,
                                              "productId": controller
                                                  .trx
                                                  .records![index]
                                                  .mProductID!
                                                  .id,
                                              "name": controller
                                                  .trx.records![index].name,
                                              "SerNo": controller
                                                  .trx.records![index].serNo,
                                              "Description": controller.trx
                                                  .records![index].description,
                                              "date3": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl3DateFrom,
                                              "date2": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl2DateFrom,
                                              "date1": controller
                                                  .trx
                                                  .records![index]
                                                  .lITControl1DateFrom,
                                              "offlineid": controller.trx
                                                  .records![index].offlineId,
                                              "index": index,
                                            }); */
                                  },
                                ),
                              ),
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "NR. ${productList[index].number} L. ${productList[index].lineNo} b. ${productList[index].prodCode} M. ${productList[index].serNo}",
                                          style: const TextStyle(
                                            color:
                                                kNotifColor, /* fontWeight: FontWeight.bold */
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          productList[index]
                                                  .mProductID
                                                  ?.identifier ??
                                              "???",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          productList[index].locationComment ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      'Quantity: '.tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${productList[index].resourceQty}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ]),
                                  Visibility(
                                    visible:
                                        productList[index].toDoAction! != "OK",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: productList[index]
                                                        .toDoAction! ==
                                                    "OK"
                                                ? kNotifColor
                                                : productList[index]
                                                            .toDoAction! ==
                                                        "PR"
                                                    ? const Color.fromARGB(
                                                        255, 209, 189, 4)
                                                    : productList[index]
                                                                .toDoAction! ==
                                                            "PT"
                                                        ? Colors.orange
                                                        : productList[index]
                                                                    .toDoAction! ==
                                                                "PSG"
                                                            ? Colors.red
                                                            : productList[index]
                                                                        .toDoAction! ==
                                                                    "PX"
                                                                ? Colors.black
                                                                : kNotifColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2.5),
                                          child: Text(
                                            productList[index].toDoAction!.tr,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              /* trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ), */
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              children: [
                                Column(
                                  children: [
                                    Row(children: [
                                      Text('Note: '.tr),
                                      Text(productList[index].name ?? ""),
                                    ]),
                                    Row(children: [
                                      Text('Status: '.tr),
                                      Text(productList[index]
                                              .resourceStatus
                                              ?.identifier ??
                                          ""),
                                    ]),
                                    /* Row(children: [
                                          const Text('SerNo: '),
                                          Text(controller
                                                  .trx.records![index].serNo ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Description: '.tr),
                                      Text(
                                          productList[index].description ?? ""),
                                    ]),
                                    /* Row(children: [
                                          const Text('Location Code: '),
                                          Text(controller
                                                  .trx.records![index].value ??
                                              "??"),
                                        ]), */
                                    /* Row(children: [
                                          const Text('Check Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl1DateFrom ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Check Date: '.tr),
                                      Text(
                                          "${DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl1DateFrom!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl1DateNext!))}"),
                                    ]),
                                    /* Row(children: [
                                          const Text('Revision Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl2DateFrom ??
                                              "??"),
                                        ]), */
                                    Row(children: [
                                      Text('Revision Date: '.tr),
                                      Text(
                                          "${productList[index].lITControl2DateFrom != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl2DateFrom!)) : ""} - ${productList[index].lITControl2DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl2DateNext!)) : ""}"),
                                    ]),
                                    /*  Row(children: [
                                          const Text('Testing Date: '),
                                          Text(controller.trx.records![index]
                                                  .lITControl3DateFrom ??
                                              "??"),
                                        ]), */ //DateFormat('dd-MM-yyyy').format(
                                    //DateTime.parse(controller.trx
                                    //   .records![index].jpToDoStartDate!))
                                    Row(children: [
                                      Text('Testing Date: '.tr),
                                      Text(
                                          "${productList[index].lITControl3DateFrom != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl3DateFrom!)) : ""} - ${productList[index].lITControl3DateNext != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(productList[index].lITControl3DateNext!)) : ""}"),
                                    ]),
                                    Row(children: [
                                      Text('Manufactured Year: '.tr),
                                      Text(productList[index]
                                          .manufacturedYear
                                          .toString()),
                                    ]),
                                    Row(children: [
                                      Text('Manufacturer: '.tr),
                                      Text(productList[index].manufacturer ??
                                          ""),
                                    ]),
                                    Visibility(
                                      visible: productList[index].eDIType?.id ==
                                          "A02",
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              tooltip: 'Edit',
                                              onPressed: () async {
                                                Get.to(
                                                    const EditMaintenanceMpResource(),
                                                    arguments: {
                                                      "perm":
                                                          "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",
                                                      "id":
                                                          productList[index].id,
                                                      "number":
                                                          productList[index]
                                                              .number,
                                                      "lineNo":
                                                          productList[index]
                                                              .lineNo
                                                              .toString(),
                                                      "cartel":
                                                          productList[index]
                                                              .textDetails,
                                                      "model":
                                                          productList[index]
                                                              .lITProductModel,
                                                      "dateOrder":
                                                          productList[index]
                                                              .dateOrdered,
                                                      "years":
                                                          productList[index]
                                                              .useLifeYears
                                                              .toString(),
                                                      "user": productList[index]
                                                          .userName,
                                                      "serviceDate":
                                                          productList[index]
                                                              .serviceDate,
                                                      "productName":
                                                          productList[index]
                                                              .mProductID!
                                                              .identifier,
                                                      "productId":
                                                          productList[index]
                                                              .mProductID!
                                                              .id,
                                                      "location":
                                                          productList[index]
                                                              .locationComment,
                                                      "observation":
                                                          productList[index]
                                                              .name,
                                                      "SerNo":
                                                          productList[index]
                                                              .serNo,
                                                      "barcode":
                                                          productList[index]
                                                              .prodCode,
                                                      "manufacturer":
                                                          productList[index]
                                                              .manufacturer,
                                                      "year": productList[index]
                                                          .manufacturedYear
                                                          .toString(),
                                                      "Description":
                                                          productList[index]
                                                              .description,
                                                      "date3": productList[
                                                              index]
                                                          .lITControl3DateFrom,
                                                      "date2": productList[
                                                              index]
                                                          .lITControl2DateFrom,
                                                      "date1": productList[
                                                              index]
                                                          .lITControl1DateFrom,
                                                      "offlineid":
                                                          productList[index]
                                                              .offlineId,
                                                      "index": index,
                                                    });
                                                /* controller
                                                              .editWorkOrderResourceDateCheck(
                                                                  isConnected,
                                                                  index); */
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            /* IconButton(
                                                  tooltip: 'Check',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateCheck(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(Icons
                                                      .check_circle_outline),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Revision',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .replaceResource(index);
                                                    /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                  },
                                                  icon: const Icon(
                                                      Icons.handyman_outlined),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Testing',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    controller
                                                        .editWorkOrderResourceDateTesting(
                                                            isConnected, index);
                                                  },
                                                  icon: const Icon(
                                                      Icons.gavel_outlined),
                                                ), */
                                            /* IconButton(
                                                  tooltip: 'Anomaly',
                                                  onPressed: () async {
                                                    var isConnected =
                                                        await checkConnection();
                                                    if (isConnected) {
                                                      await emptyPostCallStack();
                                                      await emptyEditAPICallStack();
                                                      await emptyDeleteCallStack();
                                                    }
                                                    Get.to(
                                                        const CreateResAnomaly(),
                                                        arguments: {
                                                          "id": controller
                                                              .trx
                                                              .records![index]
                                                              .id,
                                                          "docNo": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mpOtDocumentno ??
                                                              "",
                                                          "productId": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID
                                                                  ?.id ??
                                                              0,
                                                          "productName": controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .mProductID
                                                                  ?.identifier ??
                                                              "",
                                                          "isConnected":
                                                              isConnected,
                                                        });
                                                  },
                                                  icon: Stack(
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.warning,
                                                        color: Colors.red,
                                                      ),
                                                      Visibility(
                                                        visible: int.parse(controller
                                                                    .trx
                                                                    .records![
                                                                        index]
                                                                    .anomaliesCount!) !=
                                                                0
                                                            ? true
                                                            : false,
                                                        child: Positioned(
                                                          right: 1,
                                                          top: 1,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 12,
                                                              minHeight: 12,
                                                            ),
                                                            child: Text(
                                                              '${controller.trx.records![index].anomaliesCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Replace',
                                                  onPressed: () async {
                                                    controller
                                                        .replaceResourceButton(
                                                            index);
                                                    /* var isConnected =
                                                              await checkConnection();
                                                          controller
                                                              .editWorkOrderResourceDateRevision(
                                                                  isConnected,
                                                                  index); */
                                                  },
                                                  icon: const Icon(
                                                      Icons.find_replace),
                                                ), */
                                          ]),
                                    ),
                                    /* Visibility(
                                          visible: productList[index]
                                                  .eDIType
                                                  ?.id !=
                                              "A02",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                tooltip: 'Anomaly',
                                                onPressed: () async {
                                                  var isConnected =
                                                      await checkConnection();
                                                  if (isConnected) {
                                                    await emptyPostCallStack();
                                                    await emptyEditAPICallStack();
                                                    await emptyDeleteCallStack();
                                                  }
                                                  Get.to(
                                                      const CreateResAnomaly(),
                                                      arguments: {
                                                        "docNo": controller
                                                                .trx
                                                                .records![index]
                                                                .mpOtDocumentno ??
                                                            "",
                                                        "productId": controller
                                                                .trx
                                                                .records![index]
                                                                .mProductID
                                                                ?.id ??
                                                            0,
                                                        "productName": controller
                                                                .trx
                                                                .records![index]
                                                                .mProductID
                                                                ?.identifier ??
                                                            "",
                                                        "isConnected":
                                                            isConnected,
                                                      });
                                                },
                                                icon: const Icon(
                                                  Icons.warning,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),

                /* Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    child: Text(
                      "LeadStatus".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                    future: getAllLeadStatuses(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
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
                                    child: Text(
                                      list.name.toString(),
                                    ),
                                    value: list.value.toString(),
                                  );
                                }).toList(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ), */
              ],
            );
          },
        ),
      ),
    );
  }
}

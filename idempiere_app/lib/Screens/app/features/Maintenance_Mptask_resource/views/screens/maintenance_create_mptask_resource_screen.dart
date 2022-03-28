// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';

class CreateMaintenanceMpResource extends StatefulWidget {
  const CreateMaintenanceMpResource({Key? key}) : super(key: key);

  @override
  State<CreateMaintenanceMpResource> createState() =>
      _CreateMaintenanceMpResourceState();
}

class _CreateMaintenanceMpResourceState
    extends State<CreateMaintenanceMpResource> {
  Future<void> syncWorkOrder() async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_mp_ot_v?\$filter= mp_ot_ad_user_id eq $userId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage().write('workOrderSync', response.body);
      syncWorkOrderResource();
    }
  }

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/lit_mp_maintain_resource_v');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('workOrderResourceSync', response.body);
      //syncWorkOrderResourceSurveyLines();
      syncWorkOrderRefListResource();
    }
  }

  Future<void> syncWorkOrderRefListResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_Reference?\$filter= Name eq \'LIT_ResourceType\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = jsonDecode(response.body);
      var id = json["records"][0]["id"];
      var url2 = Uri.parse('$protocol://' +
          ip +
          '/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        GetStorage().write('refListResourceType', response2.body);
        syncWorkOrderRefListResourceCategory();
        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        print(response2.body);
      }
    } else {
      //print(response.body);
    }
  }

  Future<void> syncWorkOrderRefListResourceCategory() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_Reference?\$filter= Name eq \'C_BP_EDI EDI Type\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = jsonDecode(response.body);
      var id = json["records"][0]["id"];
      var url2 = Uri.parse('$protocol://' +
          ip +
          '/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        GetStorage().write('refListResourceTypeCategory', response2.body);
        syncWorkOrderResourceSurveyLines();
        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        print(response2.body);
      }
    } else {
      //print(response.body); &\$orderby=
    }
  }

  Future<void> syncWorkOrderResourceSurveyLines() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/mp_resource_survey_line?\$orderby= LineNo asc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('workOrderResourceSurveyLinesSync', response.body);
      Get.find<MaintenanceMpResourceController>().getWorkOrders();
      Get.snackbar(
        "Fatto!",
        "Il record è stato creato",
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    }
  }

  createWorkOrderResource(bool isConnected) async {
    //print(now);

    print(GetStorage().read('selectedTaskId'));

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Product_ID": {"id": productId},
      "IsActive": true,
      "ResourceType": {"id": "BP"},
      "ResourceQty": 1,
      "LIT_Control3DateFrom": date3,
      "LIT_Control2DateFrom": date2,
      "LIT_Control1DateFrom": date1,
      "Name": noteFieldController.text,
      "SerNo": sernoFieldController.text,
      "LocationComment": locationFieldController.text,
      "Value": locationCodeFieldController.text,
      "Manufacturer": manufacturerFieldController.text,
      "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
      "UseLifeYears": int.parse(useLifeYearsFieldController.text),
      "LIT_ProductModel": productModelFieldController.text,
      "Lot": lotFieldController.text,
      "DateOrdered": dateOrdered,
      "ServiceDate": firstUseDate,
      "UserName": userNameFieldController.text,
      "ProdCode": barcodeFieldController.text,
      "TextDetails": cartelFieldController.text
    });

    WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(GetStorage().read('workOrderResourceSync')));
    MProductID prod = MProductID(id: productId, identifier: productName);
    ResourceType res =
        ResourceType(id: "BP", identifier: "Parti Scheda Prodotto");

    EDIType edt = EDIType(id: Get.arguments["id"]);
    RRecords record = RRecords(
        mProductID: prod,
        mpOtDocumentno: GetStorage().read('selectedTaskDocNo'),
        resourceType: res,
        resourceQty: 1,
        eDIType: edt,
        lITControl3DateFrom: date3,
        lITControl2DateFrom: date2,
        lITControl1DateFrom: date1,
        name: noteFieldController.text,
        serNo: sernoFieldController.text,
        locationComment: locationFieldController.text,
        value: locationCodeFieldController.text,
        manufacturer: manufacturerFieldController.text,
        manufacturedYear: int.parse(manufacturedYearFieldController.text),
        useLifeYears: int.parse(useLifeYearsFieldController.text),
        lITProductModel: productModelFieldController.text,
        lot: lotFieldController.text,
        dateOrdered: dateOrdered,
        serviceDate: firstUseDate,
        userName: userNameFieldController.text,
        prodCode: barcodeFieldController.text,
        textDetails: cartelFieldController.text);

    var url = Uri.parse('http://' +
        ip +
        '/api/v1/windows/preventive-maintenance/tabs/tasks/${GetStorage().read('selectedTaskId')}/resources');
    print(msg);

    if (isConnected) {
      emptyAPICallStak();
      var response = await http.post(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 201) {
        //print("done!");
        syncWorkOrder();
      } else {
        print(response.body);
        Get.snackbar(
          "Errore!",
          "Record non creato",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      record.offlineId = GetStorage().read('postCallId');
      List<dynamic> list = [];
      if (GetStorage().read('postCallList') == null) {
        var call = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": 'http://' +
              ip +
              '/api/v1/windows/preventive-maintenance/tabs/tasks/${GetStorage().read('selectedTaskId')}/resources',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "M_Product_ID": {"id": productId},
          "IsActive": true,
          "ResourceType": {"id": "BP"},
          "ResourceQty": 1,
          "LIT_Control3DateFrom": date3,
          "LIT_Control2DateFrom": date2,
          "LIT_Control1DateFrom": date1,
          "Name": noteFieldController.text,
          "SerNo": sernoFieldController.text,
          "LocationComment": locationFieldController.text,
          "Value": locationCodeFieldController.text,
          "Manufacturer": manufacturerFieldController.text,
          "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
          "UseLifeYears": int.parse(useLifeYearsFieldController.text),
          "LIT_ProductModel": productModelFieldController.text,
          "Lot": lotFieldController.text,
          "DateOrdered": dateOrdered,
          "ServiceDate": firstUseDate,
          "UserName": userNameFieldController.text,
          "ProdCode": barcodeFieldController.text,
          "TextDetails": cartelFieldController.text
        });

        list.add(call);
      } else {
        list = GetStorage().read('postCallList');
        var call = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": 'http://' +
              ip +
              '/api/v1/windows/preventive-maintenance/tabs/tasks/${GetStorage().read('selectedTaskId')}/resources',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "M_Product_ID": {"id": productId},
          "IsActive": true,
          "ResourceType": {"id": "BP"},
          "ResourceQty": 1,
          "LIT_Control3DateFrom": date3,
          "LIT_Control2DateFrom": date2,
          "LIT_Control1DateFrom": date1,
          "Name": noteFieldController.text,
          "SerNo": sernoFieldController.text,
          "LocationComment": locationFieldController.text,
          "Value": locationCodeFieldController.text,
          "Manufacturer": manufacturerFieldController.text,
          "ManufacturedYear": int.parse(manufacturedYearFieldController.text),
          "UseLifeYears": int.parse(useLifeYearsFieldController.text),
          "LIT_ProductModel": productModelFieldController.text,
          "Lot": lotFieldController.text,
          "DateOrdered": dateOrdered,
          "ServiceDate": firstUseDate,
          "ProdCode": barcodeFieldController.text,
          "TextDetails": cartelFieldController.text
        });
        list.add(call);
      }
      GetStorage().write('postCallId', GetStorage().read('postCallId') + 1);
      GetStorage().write('postCallList', list);
      Get.snackbar(
        "Salvato!",
        "Il record è stato salvato localmente in attesa di connessione internet.",
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
      trx.records!.add(record);
      trx.rowcount = trx.rowcount! + 1;
      var data = jsonEncode(trx.toJson());
      GetStorage().write('workOrderResourceSync', data);
      Get.find<MaintenanceMpResourceController>().getWorkOrders();
    }
  }

  Future<List<Records>> getAllProducts() async {
    //print(response.body);
    var jsondecoded = jsonDecode(GetStorage().read('productSync'));

    var jsonResources = ProductJson.fromJson(jsondecoded);

    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
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
  var noteFieldController;
  var valueFieldController;
  var locationFieldController;
  var locationCodeFieldController;
  var sernoFieldController;
  var manufacturerFieldController;
  var manufacturedYearFieldController;
  var useLifeYearsFieldController;
  var productModelFieldController;
  var lotFieldController;
  var userNameFieldController;
  var barcodeFieldController;
  var cartelFieldController;
  String date3 = "";
  int dateCalc3 = 0;
  String date2 = "";
  int dateCalc2 = 0;
  String date1 = "";
  int dateCalc1 = 0;
  var productId;
  var productName;
  String dateOrdered = "";
  String firstUseDate = "";

  @override
  void initState() {
    super.initState();
    noteFieldController = TextEditingController();
    valueFieldController = TextEditingController();
    locationFieldController = TextEditingController();
    locationCodeFieldController = TextEditingController();
    sernoFieldController = TextEditingController();
    manufacturerFieldController = TextEditingController();
    manufacturedYearFieldController = TextEditingController();
    useLifeYearsFieldController = TextEditingController();
    productModelFieldController = TextEditingController();
    lotFieldController = TextEditingController();
    userNameFieldController = TextEditingController();
    barcodeFieldController = TextEditingController();
    cartelFieldController = TextEditingController();
    date3 = "";
    dateCalc3 = 0;
    date2 = "";
    dateCalc3 = 0;
    date1 = "";
    dateCalc3 = 0;
    productId = 0;
    productName = "";
    dateOrdered = "";
    firstUseDate = "";
    getAllProducts();
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
          child: Text('Add Resource'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var isConnected = await checkConnection();
                createWorkOrderResource(isConnected);
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
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Product",
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
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
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
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
                    controller: productModelFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Product Model',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: sernoFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'SerNo',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: barcodeFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Barcode',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: cartelFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Cartel',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: lotFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Lot',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: locationCodeFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'LocationCode',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: locationFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Location',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: manufacturerFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Manufacturer',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: manufacturedYearFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Manufactured Year',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: useLifeYearsFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Due Year',
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date Ordered',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        dateOrdered = val.substring(0, 10);
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'First Use Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        firstUseDate = val.substring(0, 10);
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Check Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date1 = val.substring(0, 10);
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Revision Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date2 = val.substring(0, 10);
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
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Testing Date',
                    icon: const Icon(Icons.event),
                    onChanged: (val) {
                      //print(DateTime.parse(val));
                      //print(val);
                      setState(() {
                        date3 = val.substring(0, 10);
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
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: userNameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: noteFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Note',
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

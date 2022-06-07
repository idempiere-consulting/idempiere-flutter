import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/business_partner_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/resource_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class EditMaintenanceMptask extends StatefulWidget {
  const EditMaintenanceMptask({Key? key}) : super(key: key);

  @override
  State<EditMaintenanceMptask> createState() => _EditMaintenanceMptaskState();
}

class _EditMaintenanceMptaskState extends State<EditMaintenanceMptask> {
  deleteWorkOrder() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/mp_ot/${args["id"]}');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<MaintenanceMptaskController>().getWorkOrders();
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

  editWorkOrder() async {
    //print(now);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      /* "C_DocType_ID": {"id": docId}, */
      /* "DateTrx": "${now}T00:00:00Z", */
      "C_BPartner_ID": {"identifier": businessPartnerValue},
      "C_BPartner_Location_ID": {"id": bPLocation},
      /* "AD_User_ID": {"id": GetStorage().read('userId')}, */
      "S_Resource_ID": {"identifier": resourceName},
      "DateWorkStart": date
    });
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://' + ip + '/api/v1/models/mp_ot/${args["id"]}');
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
      Get.find<MaintenanceMptaskController>().getWorkOrders();
      //print("done!");
      Get.back();
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
  }

  getResourceName() async {
    final userId = GetStorage().read('userId');
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/s_resource?\$filter=AD_User_ID eq $userId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);
      setState(() {
        resourceName = jsondecoded['records'][0]['Name'].toString();
      });
    } else {
      throw Exception("Failed to load resource name");
    }
  }

  getSelectedBPLocation(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/C_BPartner_Location?\$filter=C_BPartner_ID eq $id');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var jsondecoded = jsonDecode(response.body);

      if (jsondecoded['row-count'] != 0) {
        setState(() {
          bPLocation = jsondecoded['records'][0]['id'].toString();
        });
      } else {
        setState(() {
          bPLocation = "";
        });
      }
      //print(bPLocation);
    } else {
      throw Exception("Failed to load bp location");
    }
  }

  getDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_SysConfig?\$filter=Name eq \'LIT_Maintenance_Order_Doc_ID\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);
      setState(() {
        docId = jsondecoded['records'][0]['Value'].toString();
      });
    } else {
      throw Exception("Failed to load doctype id");
    }
  }

  Future<List<BPRecords>> getAllBusinessPartners() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/c_bpartner');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);
      var jsonBPs = BPJson.fromJson(jsondecoded);
      return jsonBPs.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }
  }

  Future<List<RRecords>> getAllResources() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/s_resource');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonResources = ResourceJson.fromJson(jsondecoded);

      return jsonResources.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<Records>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/ad_user');
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

  void fillFields() {
    businessPartnerValue = args["bPartner"];
    bPLocation = args["bPartnerLocationId"].toString();
    resourceName = args["resource"];
    //dropdownValue = args["leadStatus"];
    date = args["dateStart"];
    //salesRepFieldController.text = args["salesRep"];
  }

  String dropdownValue = "";
  String salesrepValue = "";
  String businessPartnerValue = "";
  String date = "";
  String docId = "";
  String resourceName = "";
  String bPLocation = "";

  dynamic args = Get.arguments;

  @override
  void initState() {
    dropdownValue = "N";
    businessPartnerValue = "";
    date = "";
    docId = "";
    resourceName = "";
    bPLocation = "";
    fillFields();
    super.initState();

    //getDocType();
    //getResourceName();
    //getAllResources();
  }

  static String _bPdisplayStringForOption(BPRecords option) => option.name!;

  static String _rdisplayStringForOption(RRecords option) => option.name!;

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
          Padding(
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
                    deleteWorkOrder();
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
                editWorkOrder();
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
                    initialValue: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Risorsa",
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
                    future: getAllResources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<RRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<RRecords>(
                                initialValue:
                                    TextEditingValue(text: resourceName),
                                displayStringForOption:
                                    _rdisplayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<RRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((RRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (RRecords selection) {
                                  setState(() {
                                    resourceName =
                                        _rdisplayStringForOption(selection);
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
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Business Partner",
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
                    future: getAllBusinessPartners(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                initialValue: TextEditingValue(
                                    text: businessPartnerValue),
                                displayStringForOption:
                                    _bPdisplayStringForOption,
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
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    businessPartnerValue =
                                        _bPdisplayStringForOption(selection);
                                  });

                                  getSelectedBPLocation(selection.id!);

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                    initialValue: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Risorsa",
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
                    future: getAllResources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<RRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<RRecords>(
                                initialValue:
                                    TextEditingValue(text: resourceName),
                                displayStringForOption:
                                    _rdisplayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<RRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((RRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (RRecords selection) {
                                  setState(() {
                                    resourceName =
                                        _rdisplayStringForOption(selection);
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
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Business Partner",
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
                    future: getAllBusinessPartners(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                initialValue: TextEditingValue(
                                    text: businessPartnerValue),
                                displayStringForOption:
                                    _bPdisplayStringForOption,
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
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    businessPartnerValue =
                                        _bPdisplayStringForOption(selection);
                                  });

                                  getSelectedBPLocation(selection.id!);

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                    initialValue: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Risorsa",
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
                    future: getAllResources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<RRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<RRecords>(
                                initialValue:
                                    TextEditingValue(text: resourceName),
                                displayStringForOption:
                                    _rdisplayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<RRecords>.empty();
                                  }
                                  return snapshot.data!
                                      .where((RRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (RRecords selection) {
                                  setState(() {
                                    resourceName =
                                        _rdisplayStringForOption(selection);
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
                  padding: const EdgeInsets.only(left: 40),
                  child: const Align(
                    child: Text(
                      "Business Partner",
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
                    future: getAllBusinessPartners(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<BPRecords>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<BPRecords>(
                                initialValue: TextEditingValue(
                                    text: businessPartnerValue),
                                displayStringForOption:
                                    _bPdisplayStringForOption,
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
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    businessPartnerValue =
                                        _bPdisplayStringForOption(selection);
                                  });

                                  getSelectedBPLocation(selection.id!);

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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

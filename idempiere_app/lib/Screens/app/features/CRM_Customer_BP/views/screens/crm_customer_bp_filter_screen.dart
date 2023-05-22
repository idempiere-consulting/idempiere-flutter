import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/models/businesspartnergroup_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/views/screens/crm_customer_bp_screen.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

//models

//screens

class CRMFilterCustomer extends StatefulWidget {
  const CRMFilterCustomer({Key? key}) : super(key: key);

  @override
  State<CRMFilterCustomer> createState() => _CRMFilterCustomerState();
}

class _CRMFilterCustomerState extends State<CRMFilterCustomer> {
  applyFilters() {
    if (selectedUserRadioTile > 0) {
      if (selectedUserRadioTile == 2 && salesRepId > 0) {
        Get.find<CRMCustomerBPController>().userFilter =
            " and SalesRep_ID eq $salesRepId";
      } else {
        Get.find<CRMCustomerBPController>().userFilter =
            " and SalesRep_ID eq ${GetStorage().read('userId')}";
      }
    } else {
      Get.find<CRMCustomerBPController>().userFilter = "";
    }

    if (nameFieldController.text != "") {
      Get.find<CRMCustomerBPController>().nameFilter =
          " and contains(tolower(Name),'${nameFieldController.text}')";
    } else {
      Get.find<CRMCustomerBPController>().nameFilter = "";
    }

    if (bpGroupId != "0") {
      Get.find<CRMCustomerBPController>().bpGroupFilter =
          " and C_BP_Group_ID eq $bpGroupId";
    } else {
      Get.find<CRMCustomerBPController>().bpGroupFilter = "";
    }

    Get.find<CRMCustomerBPController>().selectedUserRadioTile.value =
        selectedUserRadioTile;
    Get.find<CRMCustomerBPController>().salesRepId = salesRepId;
    Get.find<CRMCustomerBPController>().bpGroupId.value = bpGroupId;
    Get.find<CRMCustomerBPController>().salesRepName =
        salesRepFieldController.text;
    Get.find<CRMCustomerBPController>().nameValue.value =
        nameFieldController.text;

    Get.find<CRMCustomerBPController>().getCustomers();
    Get.back();
  }

  Future<List<Records>> getAllSalesRep() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= DateLastLogin neq null and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

  Future<List<BPGRecords>> getAllBPGroups() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/C_BP_Group');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerGroupJSON.fromJson(jsonDecode(response.body));
      json.records!.insert(0, BPGRecords(id: 0, name: 'All'.tr));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead bp groups");
    }

    //print(response.body);
  }

  setSelectedUserRadioTile(int val) {
    setState(() {
      selectedUserRadioTile = val;
    });
  }

  dynamic args = Get.arguments;
  int selectedUserRadioTile = 0;
  late TextEditingController salesRepFieldController;
  int salesRepId = 0;

  late TextEditingController nameFieldController;
  String bpGroupId = "0";

  @override
  void initState() {
    super.initState();

    selectedUserRadioTile = args['selectedUserRadioTile'] ?? 0;
    salesRepFieldController =
        TextEditingController(text: args['salesRepName'] ?? "");
    salesRepId = args['salesRepId'] ?? 0;
    nameFieldController = TextEditingController(text: args['name']);
    bpGroupId = args['bpGroupId'] ?? "0";
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: applyFilters, child: Text('Apply Filters'.tr)),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        centerTitle: true,
        title: Text('Filters'.tr),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'SalesRep Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  children: [
                    RadioListTile(
                      value: 0,
                      groupValue: selectedUserRadioTile,
                      title: Text("All".tr),
                      //subtitle: Text("Radio 1 Subtitle"),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      activeColor: Theme.of(context).primaryColor,

                      //selected: true,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedUserRadioTile,
                      title: Text("Mine Only".tr),
                      subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedUserRadioTile,
                      title: FutureBuilder(
                        future: getAllSalesRep(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            salesRepId = 0;
                                          });
                                        }
                                      },
                                      controller: salesRepFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'SalesRep'.tr,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return snapshot.data!.where((element) =>
                                          (element.name ?? "")
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        //leading: Icon(Icons.shopping_cart),
                                        title: Text(suggestion.name ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      salesRepFieldController.text =
                                          suggestion.name!;
                                      salesRepId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                      //subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    )
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllBPGroups(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPGRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'BP Group'.tr,
                                      //filled: true,
                                      border: const OutlineInputBorder(
                                          /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                          ),
                                      prefixIcon: const Icon(EvaIcons.list),
                                      //hintText: "search..",
                                      isDense: true,
                                      //fillColor: Theme.of(context).cardColor,
                                    ),
                                    child: DropdownButton(
                                      isDense: true,
                                      underline: const SizedBox(),
                                      hint: Text("Select a BP Group".tr),
                                      isExpanded: true,
                                      value: bpGroupId == "" ? null : bpGroupId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          bpGroupId = newValue as String;
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
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'SalesRep Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  children: [
                    RadioListTile(
                      value: 0,
                      groupValue: selectedUserRadioTile,
                      title: Text("All".tr),
                      //subtitle: Text("Radio 1 Subtitle"),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      activeColor: Theme.of(context).primaryColor,

                      //selected: true,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedUserRadioTile,
                      title: Text("Mine Only".tr),
                      subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedUserRadioTile,
                      title: FutureBuilder(
                        future: getAllSalesRep(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            salesRepId = 0;
                                          });
                                        }
                                      },
                                      controller: salesRepFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'SalesRep'.tr,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return snapshot.data!.where((element) =>
                                          (element.name ?? "")
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        //leading: Icon(Icons.shopping_cart),
                                        title: Text(suggestion.name ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      salesRepFieldController.text =
                                          suggestion.name!;
                                      salesRepId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                      //subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    )
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllBPGroups(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPGRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'BP Group'.tr,
                                      //filled: true,
                                      border: const OutlineInputBorder(
                                          /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                          ),
                                      prefixIcon: const Icon(EvaIcons.list),
                                      //hintText: "search..",
                                      isDense: true,
                                      //fillColor: Theme.of(context).cardColor,
                                    ),
                                    child: DropdownButton(
                                      isDense: true,
                                      underline: const SizedBox(),
                                      hint: Text("Select a BP Group".tr),
                                      isExpanded: true,
                                      value: bpGroupId == "" ? null : bpGroupId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          bpGroupId = newValue as String;
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
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'SalesRep Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  children: [
                    RadioListTile(
                      value: 0,
                      groupValue: selectedUserRadioTile,
                      title: Text("All".tr),
                      //subtitle: Text("Radio 1 Subtitle"),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      activeColor: Theme.of(context).primaryColor,

                      //selected: true,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: selectedUserRadioTile,
                      title: Text("Mine Only".tr),
                      subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedUserRadioTile,
                      title: FutureBuilder(
                        future: getAllSalesRep(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<Records>> snapshot) =>
                            snapshot.hasData
                                ? TypeAheadField<Records>(
                                    direction: AxisDirection.up,
                                    //getImmediateSuggestions: true,
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            salesRepId = 0;
                                          });
                                        }
                                      },
                                      controller: salesRepFieldController,
                                      //autofocus: true,

                                      decoration: InputDecoration(
                                        labelText: 'SalesRep'.tr,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(EvaIcons.search),
                                        hintText: "search..",
                                        isDense: true,
                                        fillColor: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return snapshot.data!.where((element) =>
                                          (element.name ?? "")
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        //leading: Icon(Icons.shopping_cart),
                                        title: Text(suggestion.name ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      salesRepFieldController.text =
                                          suggestion.name!;
                                      salesRepId = suggestion.id!;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                      //subtitle: Text(GetStorage().read('user')),
                      onChanged: (val) {
                        //print("Radio Tile pressed $val");
                        setSelectedUserRadioTile(val as int);
                      },
                      //activeColor: Colors.red,
                      activeColor: Theme.of(context).primaryColor,

                      selected: false,
                    )
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Fields Filter'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  childrenPadding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 10),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Name'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllBPGroups(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<BPGRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'BP Group'.tr,
                                      //filled: true,
                                      border: const OutlineInputBorder(
                                          /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                          ),
                                      prefixIcon: const Icon(EvaIcons.list),
                                      //hintText: "search..",
                                      isDense: true,
                                      //fillColor: Theme.of(context).cardColor,
                                    ),
                                    child: DropdownButton(
                                      isDense: true,
                                      underline: const SizedBox(),
                                      hint: Text("Select a BP Group".tr),
                                      isExpanded: true,
                                      value: bpGroupId == "" ? null : bpGroupId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          bpGroupId = newValue as String;
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
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

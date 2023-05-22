import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/campaign_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/sector_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';

import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

//models

//screens

class CRMFilterLead extends StatefulWidget {
  const CRMFilterLead({Key? key}) : super(key: key);

  @override
  State<CRMFilterLead> createState() => _CRMFilterLeadState();
}

class _CRMFilterLeadState extends State<CRMFilterLead> {
  applyFilters() {
    if (selectedUserRadioTile > 0) {
      Get.find<CRMLeadController>().userFilter =
          " and SalesRep_ID eq ${GetStorage().read('userId')}";
    } else {
      Get.find<CRMLeadController>().userFilter = "";
    }

    if (nameFieldController.text != "") {
      Get.find<CRMLeadController>().nameFilter =
          " and contains(tolower(Name),'${nameFieldController.text}')";
    } else {
      Get.find<CRMLeadController>().nameFilter = "";
    }

    if (mailFieldController.text != "") {
      Get.find<CRMLeadController>().mailFilter =
          " and contains(EMail,'${mailFieldController.text}')";
    } else {
      Get.find<CRMLeadController>().mailFilter = "";
    }

    if (phoneFieldController.text != "") {
      Get.find<CRMLeadController>().phoneFilter =
          " and contains(Phone,'${phoneFieldController.text}')";
    } else {
      Get.find<CRMLeadController>().phoneFilter = "";
    }

    if (sectorId != "0") {
      Get.find<CRMLeadController>().sectorFilter =
          " and lit_IndustrySector_ID eq $sectorId";
    } else {
      Get.find<CRMLeadController>().sectorFilter = "";
    }

    if (statusId != "0") {
      Get.find<CRMLeadController>().statusFilter =
          " and LeadStatus eq '$statusId'";
    } else {
      Get.find<CRMLeadController>().statusFilter = "";
    }

    if (sizeId != "0") {
      Get.find<CRMLeadController>().sizeFilter =
          " and lit_LeadSize_ID eq $statusId";
    } else {
      Get.find<CRMLeadController>().sizeFilter = "";
    }

    if (campaignId != "0") {
      Get.find<CRMLeadController>().campaignFilter =
          " and C_Campaign_ID eq $campaignId";
    } else {
      Get.find<CRMLeadController>().campaignFilter = "";
    }

    if (sourceId != "0") {
      Get.find<CRMLeadController>().sourceFilter =
          " and LeadSource eq '$sourceId'";
    } else {
      Get.find<CRMLeadController>().sourceFilter = "";
    }

    Get.find<CRMLeadController>().selectedUserRadioTile.value =
        selectedUserRadioTile;

    Get.find<CRMLeadController>().nameValue.value = nameFieldController.text;
    Get.find<CRMLeadController>().mailValue.value = mailFieldController.text;
    Get.find<CRMLeadController>().phoneValue.value = phoneFieldController.text;
    Get.find<CRMLeadController>().sectorId.value = sectorId;
    Get.find<CRMLeadController>().statusId.value = statusId;
    Get.find<CRMLeadController>().sizeId.value = sizeId;
    Get.find<CRMLeadController>().campaignId.value = campaignId;
    Get.find<CRMLeadController>().sourceId.value = sourceId;

    Get.find<CRMLeadController>().getLeads();
    Get.back();
  }

  Future<List<JRecords>> getAllSectors() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_IndustrySector');
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

      var jsonsectors = SectorJSON.fromJson(jsondecoded);

      jsonsectors.records!.insert(0, JRecords(id: 0, name: 'All'.tr));

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load sectors");
    }

    //print(list[0].eMail);

    //print(json.);
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

      json.records!.insert(0, LSRecords(value: "0", name: 'All'.tr));
      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead statuses");
    }

    //print(response.body);
  }

  Future<List<CRecords>> getAllLeadSizes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_LeadSize');
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

      var jsonsectors = CampaignJSON.fromJson(jsondecoded);

      jsonsectors.records!.insert(0, CRecords(id: 0, name: 'All'.tr));

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load sizes");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<CRecords>> getAllCampaigns() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/c_campaign');
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

      var jsonsectors = CampaignJSON.fromJson(jsondecoded);

      jsonsectors.records!.insert(0, CRecords(id: 0, name: 'All'.tr));

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load campaigns");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<LSRecords>> getAllLeadSources() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_ref_list?\$filter= AD_Reference_ID eq 53415 ');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json = LeadStatusJson.fromJson(jsonDecode(response.body));
      json.records!.insert(0, LSRecords(value: "0", name: 'All'.tr));
      return json.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load sources");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  setSelectedUserRadioTile(int val) {
    setState(() {
      selectedUserRadioTile = val;
    });
  }

  dynamic args = Get.arguments;
  int selectedUserRadioTile = 0;

  late TextEditingController nameFieldController;
  late TextEditingController mailFieldController;
  late TextEditingController phoneFieldController;

  String sectorId = "0";
  String statusId = "0";
  String sizeId = "0";
  String campaignId = "0";
  String sourceId = "0";

  @override
  void initState() {
    super.initState();

    selectedUserRadioTile = args['selectedUserRadioTile'] ?? 0;
    nameFieldController = TextEditingController(text: args['name']);
    mailFieldController = TextEditingController(text: args['mail']);
    phoneFieldController = TextEditingController(text: args['phone']);
    sectorId = args['sectorId'] ?? "0";
    statusId = args['statusId'] ?? "0";
    sizeId = args['sizeId'] ?? "0";
    campaignId = args['campaignId'] ?? "0";
    sourceId = args['sourceId'] ?? "0";
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
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: mailFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Mail'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: phoneFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Phone'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadStatuses(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<LSRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Status'.tr,
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
                                      hint: Text("Select a Lead Status".tr),
                                      isExpanded: true,
                                      value: statusId == "" ? null : statusId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          statusId = newValue as String;
                                        });

                                        //print(dropdownValue);
                                      },
                                      items: snapshot.data!.map((list) {
                                        return DropdownMenuItem<String>(
                                          value: list.value.toString(),
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllSectors(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<JRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Sector'.tr,
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
                                      hint: Text("Select a Sector".tr),
                                      isExpanded: true,
                                      value: sectorId == "" ? null : sectorId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sectorId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadSizes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<CRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Size'.tr,
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
                                      hint: Text("Select a Lead Size".tr),
                                      isExpanded: true,
                                      value: sizeId == "" ? null : sizeId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sizeId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllCampaigns(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<CRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Campaign'.tr,
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
                                      hint: Text("Select a Campaign".tr),
                                      isExpanded: true,
                                      value:
                                          campaignId == "" ? null : campaignId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          campaignId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadSources(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<LSRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Source'.tr,
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
                                      hint: Text("Select a Lead Source".tr),
                                      isExpanded: true,
                                      value: sourceId == "" ? null : sourceId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sourceId = newValue as String;
                                        });

                                        //print(dropdownValue);
                                      },
                                      items: snapshot.data!.map((list) {
                                        return DropdownMenuItem<String>(
                                          value: list.value.toString(),
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
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: mailFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Mail'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: phoneFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Phone'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadStatuses(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<LSRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Status'.tr,
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
                                      hint: Text("Select a Lead Status".tr),
                                      isExpanded: true,
                                      value: statusId == "" ? null : statusId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          statusId = newValue as String;
                                        });

                                        //print(dropdownValue);
                                      },
                                      items: snapshot.data!.map((list) {
                                        return DropdownMenuItem<String>(
                                          value: list.value.toString(),
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllSectors(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<JRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Sector'.tr,
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
                                      hint: Text("Select a Sector".tr),
                                      isExpanded: true,
                                      value: sectorId == "" ? null : sectorId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sectorId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadSizes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<CRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Size'.tr,
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
                                      hint: Text("Select a Lead Size".tr),
                                      isExpanded: true,
                                      value: sizeId == "" ? null : sizeId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sizeId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllCampaigns(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<CRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Campaign'.tr,
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
                                      hint: Text("Select a Campaign".tr),
                                      isExpanded: true,
                                      value:
                                          campaignId == "" ? null : campaignId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          campaignId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadSources(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<LSRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Source'.tr,
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
                                      hint: Text("Select a Lead Source".tr),
                                      isExpanded: true,
                                      value: sourceId == "" ? null : sourceId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sourceId = newValue as String;
                                        });

                                        //print(dropdownValue);
                                      },
                                      items: snapshot.data!.map((list) {
                                        return DropdownMenuItem<String>(
                                          value: list.value.toString(),
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
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: mailFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          //hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Mail'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: phoneFieldController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.text_fields),
                          border: const OutlineInputBorder(),
                          labelText: 'Phone'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadStatuses(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<LSRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Status'.tr,
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
                                      hint: Text("Select a Lead Status".tr),
                                      isExpanded: true,
                                      value: statusId == "" ? null : statusId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          statusId = newValue as String;
                                        });

                                        //print(dropdownValue);
                                      },
                                      items: snapshot.data!.map((list) {
                                        return DropdownMenuItem<String>(
                                          value: list.value.toString(),
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllSectors(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<JRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Sector'.tr,
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
                                      hint: Text("Select a Sector".tr),
                                      isExpanded: true,
                                      value: sectorId == "" ? null : sectorId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sectorId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadSizes(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<CRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Size'.tr,
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
                                      hint: Text("Select a Lead Size".tr),
                                      isExpanded: true,
                                      value: sizeId == "" ? null : sizeId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sizeId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllCampaigns(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<CRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Campaign'.tr,
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
                                      hint: Text("Select a Campaign".tr),
                                      isExpanded: true,
                                      value:
                                          campaignId == "" ? null : campaignId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          campaignId = newValue as String;
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
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FutureBuilder(
                        future: getAllLeadSources(),
                        builder: (BuildContext ctx,
                                AsyncSnapshot<List<LSRecords>> snapshot) =>
                            snapshot.hasData
                                ? InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Lead Source'.tr,
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
                                      hint: Text("Select a Lead Source".tr),
                                      isExpanded: true,
                                      value: sourceId == "" ? null : sourceId,
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sourceId = newValue as String;
                                        });

                                        //print(dropdownValue);
                                      },
                                      items: snapshot.data!.map((list) {
                                        return DropdownMenuItem<String>(
                                          value: list.value.toString(),
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

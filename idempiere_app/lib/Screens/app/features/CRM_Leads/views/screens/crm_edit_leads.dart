import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/campaign_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/city_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/coutry_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/region_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/sector_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

class EditLead extends StatefulWidget {
  const EditLead({Key? key}) : super(key: key);

  @override
  State<EditLead> createState() => _EditLeadState();
}

class _EditLeadState extends State<EditLead> {
  editLead() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    /* final msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Name": nameFieldController.text,
      "BPName": bPartnerFieldController.text,
      "Phone": phoneFieldController.text,
      "EMail": mailFieldController.text,
      "SalesRep_ID": {"identifier": salesrepValue},
      "LeadStatus": {"id": dropdownValue}
    }); */
    var json = {
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "Note": noteFieldController.text,
      "BPName": bPartnerFieldController.text,
      "Phone": phoneFieldController.text,
      "EMail": mailFieldController.text,
      "URL": urlFieldController.text,
      "IsSalesLead": true,
      "LeadStatus": {"id": dropdownValue},
    };

    if (salesrepValue != "") {
      json.addAll({
        "SalesRep_ID": {"identifier": salesrepValue},
      });
    }
    if (sectorValue != "") {
      json.addAll({
        "lit_IndustrySector_ID": {"id": int.parse(sectorValue)},
      });
    }
    if (sizeDropdownValue != "") {
      json.addAll({
        "lit_LeadSize_ID": {"id": int.parse(sizeDropdownValue)},
      });
    }
    if (campaignDropdownValue != "") {
      json.addAll({
        "C_Campaign_ID": {"id": int.parse(campaignDropdownValue)},
      });
    }
    if (sourceDropdownValue != "") {
      json.addAll({
        "LeadSource": {"id": sourceDropdownValue},
      });
    }
    if (addressId != 0) {
      json.addAll({
        //"C_Location_ID": {"id": addressId},
        "BP_Location_ID": {"id": addressId},
      });
    }

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user/${args["id"]}');
    //print(msg);
    var response = await http.put(
      url,
      body: jsonEncode(json),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMLeadController>().getLeads();
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
      print(response.body);
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
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user/${args["id"]}');
    //print(msg);
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<CRMLeadController>().getLeads();
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

      return json.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load campaigns");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  getAllCountries() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/c_country');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      countries = CountryJSON.fromJson(jsonDecode(response.body));
      if (countries.pagecount! > 1) {
        int index = 1;
        getAllCountriesPages(index);
      } else {
        setState(() {
          countriesDataAvailable = true;
        });
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('Countries Checked');
        }
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load cities");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  getAllCountriesPages(int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_country?\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson =
          CountryJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        countries.records!.add(element);
      }

      if (countries.pagecount! > index) {
        getAllCountriesPages(index);
      } else {
        if (kDebugMode) {
          print(countries.records!.length);
        }
        setState(() {
          countriesDataAvailable = true;
        });
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('Countries Checked');
        }
      }
    }
  }

  getAllRegions() async {
    setState(() {
      regionsDataAvailable = false;
    });
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_region?\$filter= C_Country_ID eq $countryId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      regions = RegionJSON.fromJson(jsonDecode(response.body));
      if (regions.pagecount! > 1) {
        int index = 1;
        getAllRegionsPages(index);
      } else {
        setState(() {
          regionsDataAvailable = true;
        });
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('Regions Checked');
        }
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load cities");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  getAllRegionsPages(int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_country?\$filter= C_Country_ID eq $countryId&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson =
          RegionJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        regions.records!.add(element);
      }

      if (regions.pagecount! > index) {
        getAllRegionsPages(index);
      } else {
        if (kDebugMode) {
          print(regions.records!.length);
        }
        setState(() {
          regionsDataAvailable = true;
        });
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('Regions Checked');
        }
      }
    } else {
      print(response.body);
    }
  }

  getAllCities() async {
    setState(() {
      citiesDataAvailable = false;
    });
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_city?\$filter= C_Country_ID eq $countryId and C_Region_ID eq $regionId');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      cities = CityJSON.fromJson(jsonDecode(response.body));
      if (cities.pagecount! > 1) {
        int index = 1;
        getAllCitiesPages(index);
      } else {
        setState(() {
          citiesDataAvailable = true;
        });
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('Regions Checked');
        }
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load cities");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  getAllCitiesPages(int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_country?\$filter= C_Country_ID eq $countryId&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson =
          CityJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        cities.records!.add(element);
      }

      if (cities.pagecount! > index) {
        getAllCitiesPages(index);
      } else {
        if (kDebugMode) {
          print(cities.records!.length);
        }
        setState(() {
          citiesDataAvailable = true;
        });
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('Regions Checked');
        }
      }
    } else {
      print(response.body);
    }
  }

  createNewAddress() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var json = {
      "Address1": address1FieldController.text,
      "C_Country_ID": countryId,
      "C_Region_ID": regionId,
      "C_City_ID": cityId,
      "Postal": postalCode,
      "City": city,
      "RegionName": region,
    };

    var url = Uri.parse('$protocol://$ip/api/v1/models/C_Location');
    //print(msg);
    var response = await http.post(
      url,
      body: jsonEncode(json),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      addressId = json["id"];
      addressFieldController.text =
          "${json["Address1"] ?? ""}, ${json["C_City_ID"]["identifier"]}, ${json["Postal"]} ${json["C_Region_ID"]["identifier"]}";
    } else {
      print(response.body);
    }
  }

  void fillFields() {
    nameFieldController.text = args["name"] ?? "";
    bPartnerFieldController.text = args["bpName"] ?? "";
    phoneFieldController.text = args["Tel"] ?? "";
    mailFieldController.text = args["eMail"] ?? "";
    //dropdownValue = args["leadStatus"];
    salesrepValue = args["salesRep"] ?? "";
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
  var urlFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var noteFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bpNameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var addressFieldController;
  String dropdownValue = "";
  String salesrepValue = "";
  String campaignDropdownValue = "";
  String sourceDropdownValue = "";
  String sizeDropdownValue = "";
  String sectorValue = "";

  int addressId = 0;
  // ignore: prefer_typing_uninitialized_variables
  var address1FieldController;

  bool createAddress = false;

  CountryJSON countries = CountryJSON(records: []);
  bool countriesDataAvailable = false;
  int countryId = 0;

  RegionJSON regions = RegionJSON(records: []);
  bool regionsDataAvailable = false;
  int regionId = 0;

  CityJSON cities = CityJSON(records: []);
  bool citiesDataAvailable = false;
  int cityId = 0;
  String postalCode = "";
  String region = "";
  String city = "";

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bpNameFieldController = TextEditingController(text: args["bpName"] ?? "");
    bPartnerFieldController =
        TextEditingController(text: args["businessPartner"] ?? "");
    mailFieldController = TextEditingController();
    urlFieldController = TextEditingController(text: args["url"] ?? "");
    dropdownValue = Get.arguments["leadStatus"];
    campaignDropdownValue = (args["campaign"] ?? "").toString();
    sectorValue = (args["sector"] ?? "").toString();
    sourceDropdownValue = args["source"] ?? "";
    descriptionFieldController =
        TextEditingController(text: args["description"] ?? "");
    noteFieldController = TextEditingController(text: args["note"] ?? "");
    sizeDropdownValue = (args["size"] ?? "").toString();

    addressFieldController = TextEditingController(text: args["address"] ?? "");
    address1FieldController = TextEditingController();

    addressId = 0;

    createAddress = false;

    countriesDataAvailable = false;
    countryId = 0;

    regionsDataAvailable = false;
    regionId = 0;

    citiesDataAvailable = false;
    cityId = 0;
    postalCode = "";
    region = "";
    city = "";

    fillFields();
    getAllCountries();
    getAllLeadStatuses();
  }

  static String _displayStringForOption(Records option) => option.name!;
  static String _displayCountryStringForOption(CtrRecords option) =>
      option.name!;
  static String _displayRegionStringForOption(RegRecords option) =>
      option.name!;
  static String _displayCityStringForOption(CitRecords option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Lead'.tr),
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
                editLead();
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
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Phone'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: mailFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: urlFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                      labelText: 'Website',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesRep".tr,
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
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue:
                                    TextEditingValue(text: args["salesRep"]),
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
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    salesrepValue =
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sector".tr,
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
                    future: getAllSectors(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<JRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                hint: Text("Select a Sector".tr),
                                value: sectorValue == "" ? null : sectorValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    sectorValue = newValue!;
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Lead Size".tr,
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
                    future: getAllLeadSizes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                hint: Text("Select a Size".tr),
                                value: sizeDropdownValue == ""
                                    ? null
                                    : sizeDropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    sizeDropdownValue = newValue!;
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Campaign".tr,
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
                    future: getAllCampaigns(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                hint: Text("Select a Campaign".tr),
                                value: campaignDropdownValue == ""
                                    ? null
                                    : campaignDropdownValue,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    campaignDropdownValue = newValue!;
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
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Lead Source".tr,
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
                    future: getAllLeadSources(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<LSRecords>> snapshot) =>
                        snapshot.hasData
                            ? DropdownButton(
                                hint: Text('Select a Lead Source'.tr),
                                value: sourceDropdownValue == ""
                                    ? null
                                    : sourceDropdownValue,
                                //icon: const Icon(Icons.arrow_downward),
                                elevation: 16,

                                onChanged: (String? newValue) {
                                  setState(() {
                                    sourceDropdownValue = newValue!;
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
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "LeadStatus".tr,
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
                                    value: list.value.toString(),
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
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: bpNameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.text_fields_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'BP Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: bPartnerFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.handshake_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Business Partner',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: addressFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      border: const OutlineInputBorder(),
                      labelText: 'Address'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const Divider(),
                TextButton(
                    onPressed: () {
                      setState(() {
                        createAddress = !createAddress;
                      });
                      //openAddressCreation();
                    },
                    child: createAddress
                        ? Text('Close Address Creation'.tr)
                        : Text('Open Address Creation'.tr)),
                Visibility(
                  visible: createAddress,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: address1FieldController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.edit_road),
                            border: const OutlineInputBorder(),
                            labelText: 'Street'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 40),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Country".tr,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      countriesDataAvailable
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: Autocomplete<CtrRecords>(
                                //initialValue: TextEditingValue(text: args["salesRep"]),
                                displayStringForOption:
                                    _displayCountryStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CtrRecords>.empty();
                                  }
                                  return countries.records!
                                      .where((CtrRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CtrRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    countryId = selection.id!;
                                    regionId = 0;
                                    cityId = 0;
                                    citiesDataAvailable = false;
                                  });
                                  getAllRegions();

                                  //print(salesrepValue);
                                },
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                      Visibility(
                        visible: regionsDataAvailable,
                        child: Container(
                          padding: const EdgeInsets.only(left: 40),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Region".tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      regionsDataAvailable
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: Autocomplete<RegRecords>(
                                //initialValue: TextEditingValue(text: args["salesRep"]),
                                displayStringForOption:
                                    _displayRegionStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<RegRecords>.empty();
                                  }
                                  return regions.records!
                                      .where((RegRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (RegRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    regionId = selection.id!;
                                    cityId = 0;
                                    region = selection.name ?? "";
                                  });
                                  getAllCities();
                                  //getAllRegions();

                                  //print(salesrepValue);
                                },
                              ),
                            )
                          : const SizedBox(),
                      Visibility(
                        visible: citiesDataAvailable,
                        child: Container(
                          padding: const EdgeInsets.only(left: 40),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "City".tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      citiesDataAvailable
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: Autocomplete<CitRecords>(
                                //initialValue: TextEditingValue(text: args["salesRep"]),
                                displayStringForOption:
                                    _displayCityStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<CitRecords>.empty();
                                  }
                                  return cities.records!
                                      .where((CitRecords option) {
                                    return option.name!
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (CitRecords selection) {
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    cityId = selection.id!;
                                    postalCode = selection.postal ?? "";
                                    city = selection.name ?? "";
                                  });
                                  //getAllCities();
                                  //getAllRegions();

                                  //print(salesrepValue);
                                },
                              ),
                            )
                          : const SizedBox(),
                      Visibility(
                          visible:
                              countryId != 0 && regionId != 0 && cityId != 0,
                          child: ElevatedButton(
                              onPressed: () {
                                createNewAddress();
                              },
                              child: Text('Create Address'.tr))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
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
                  child: TextField(
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: bPartnerFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Business Partner',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Phone'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: mailFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesRep".tr,
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
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue:
                                    TextEditingValue(text: args["salesRep"]),
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
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    salesrepValue =
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "LeadStatus".tr,
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
                                    value: list.value.toString(),
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
          },
          desktopBuilder: (context, constraints) {
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
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: bPartnerFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Business Partner',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Phone'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: mailFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SalesRep".tr,
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
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue:
                                    TextEditingValue(text: args["salesRep"]),
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
                                  //debugPrint(
                                  //'You just selected ${_displayStringForOption(selection)}');
                                  setState(() {
                                    salesrepValue =
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "LeadStatus".tr,
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
                                    value: list.value.toString(),
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
          },
        ),
      ),
    );
  }
}

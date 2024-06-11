import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/models/customer_bp_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/views/screens/crm_customer_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/city_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/coutry_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/region_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_rule_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/payment_term_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

class EditCRMCustomerBP extends StatefulWidget {
  const EditCRMCustomerBP({Key? key}) : super(key: key);

  @override
  State<EditCRMCustomerBP> createState() => _EditCRMCustomerBP();
}

class _EditCRMCustomerBP extends State<EditCRMCustomerBP> {
  editCustomer() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "Name": nameFieldController.text,
      "Value": valueController.text,
      "LIT_TaxID": taxFieldController.text,
      "LIT_FEPA_IPA": sdiCodeFieldController.text,
    };

    if (paymentTermId != "") {
      msg.addAll({
        "C_PaymentTerm_ID": {"id": int.parse(paymentTermId)}
      });
    }
    if (paymentRuleId != "") {
      msg.addAll({
        "PaymentRule": {"id": paymentRuleId}
      });
    }
    if (dropdownValue != "") {
      msg.addAll({
        "C_BP_Group_ID": int.parse(dropdownValue),
      });
    }
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/C_BPartner/${args["id"]}');
    //print(msg);
    var response = await http.put(
      url,
      body: jsonEncode(msg),
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

  Future<List<PTRecords>> getPaymentTerms() async {
    pTermAvailable = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_PaymentTerm?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      /* if (kDebugMode) {
        print(response.body);
      } */
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var pTerms = PaymentTermsJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      return pTerms.records!;
    } else {
      throw Exception("Failed to load load payment terms");
    }
  }

  Future<List<PRRecords>> getPaymentRules() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 195');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var pRules =
          PaymentRuleJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      return pRules.records!;
    } else {
      throw Exception("Failed to load BP Groups");
    }
  }

  Future<List<Records>> getAllBPGroups() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BP_Group?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
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
      if (kDebugMode) {
        print(response.body);
      }
    }
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
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  createNewLocation() async {
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
      locationId = json["id"];
      locationCreated = true;
      addressFieldController.text =
          "${json["Address1"] ?? ""}, ${json["C_City_ID"]["identifier"]}, ${json["Postal"]} ${json["C_Region_ID"]["identifier"]}";
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  editDefaultAddress() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var json = {
      "C_Location_ID": {"id": locationId},
    };

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location/${args["bpLocationId"]}');
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
      /* var json = jsonDecode(utf8.decode(response.bodyBytes));
      locationId = json["id"];
      locationCreated = true;
      addressFieldController.text =
          "${json["Address1"] ?? ""}, ${json["C_City_ID"]["identifier"]}, ${json["Postal"]} ${json["C_Region_ID"]["identifier"]}"; */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  createDefaultAddress() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var json = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_Location_ID": {"id": locationId},
      "IsShipTo": true,
      "IsPayFrom": true,
      "IsBillTo": true,
      "IsRemitTo": true,
      "C_BPartner_ID": {"id": args["id"]},
      "Name": args["Name"],
    };

    var url = Uri.parse('$protocol://$ip/api/v1/models/C_BPartner_Location');
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
      /* var json = jsonDecode(utf8.decode(response.bodyBytes));
      locationId = json["id"];
      locationCreated = true;
      addressFieldController.text =
          "${json["Address1"] ?? ""}, ${json["C_City_ID"]["identifier"]}, ${json["Postal"]} ${json["C_Region_ID"]["identifier"]}"; */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
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
  var taxFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var sdiCodeFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var addressFieldController;
  // ignore: prefer_typing_uninitialized_variables
  //var bPGroupController;
  String dropdownValue = "";

  bool pTermAvailable = false;
  String paymentTermId = "";

  bool pRuleAvailable = false;
  String paymentRuleId = "";

  bool createAddress = false;
  bool locationCreated = false;
  bool noAddress = false;

  late TextEditingController address1FieldController;
  late TextEditingController countryFieldController;
  late TextEditingController regionFieldController;
  late TextEditingController cityFieldController;

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

  int locationId = 0;

  @override
  void initState() {
    dropdownValue = (args["C_BP_Group_ID"]).toString();
    super.initState();
    noAddress = (args["bpLocationId"] ?? 0) == 0 ? true : false;
    createAddress = false;
    countriesDataAvailable = false;
    nameFieldController = TextEditingController();
    valueController = TextEditingController();
    taxFieldController = TextEditingController(text: args["taxID"] ?? "");
    sdiCodeFieldController = TextEditingController(text: args["SDI"] ?? "");
    addressFieldController =
        TextEditingController(text: args["addressName"] ?? "");
    address1FieldController = TextEditingController();
    countryFieldController = TextEditingController();
    regionFieldController = TextEditingController();
    cityFieldController = TextEditingController();
    pTermAvailable = false;
    paymentTermId = args["pTermId"].toString();
    paymentRuleId = args["pRuleId"].toString();
    getAllCountries();

    countriesDataAvailable = false;
    countryId = 0;

    regionsDataAvailable = false;
    regionId = 0;

    citiesDataAvailable = false;
    cityId = 0;
    postalCode = "";
    region = "";
    city = "";
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
                  if (locationCreated && noAddress) {
                    createDefaultAddress();
                  }
                  if (locationCreated && !noAddress) {
                    editDefaultAddress();
                  }
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
                              underline: const SizedBox(),
                              value: dropdownValue == "" ? null : dropdownValue,
                              isExpanded: true,
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
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: taxFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'Tax ID'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: sdiCodeFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'SDI Code'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Term'.tr,
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
                  future: getPaymentTerms(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<PTRecords>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              underline: const SizedBox(),
                              hint: Text("Select Payment Term".tr),
                              isExpanded: true,
                              value: paymentTermId == "" ? null : paymentTermId,
                              elevation: 16,
                              onChanged: (newValue) {
                                setState(() {
                                  paymentTermId = newValue as String;
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
                    'Payment Rule'.tr,
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
                  future: getPaymentRules(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<PRRecords>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              underline: const SizedBox(),
                              hint: Text("Select Payment Rule".tr),
                              isExpanded: true,
                              value: paymentRuleId == "" ? null : paymentRuleId,
                              elevation: 16,
                              onChanged: (newValue) {
                                setState(() {
                                  paymentRuleId = newValue as String;
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
                    countriesDataAvailable
                        ? /* Container(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                          ) */
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: TypeAheadField<CtrRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: countryFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Country'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return countries.records!.where((element) =>
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
                                setState(() {
                                  countryId = suggestion.id!;
                                  regionId = 0;
                                  cityId = 0;
                                  citiesDataAvailable = false;
                                  countryFieldController.text =
                                      suggestion.name ?? '';
                                });
                                getAllRegions();
                                //productName = selection.name;
                              },
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    regionsDataAvailable
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: /* Autocomplete<RegRecords>(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                            ), */
                                TypeAheadField<RegRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: regionFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Region'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return regions.records!.where((element) =>
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
                                setState(() {
                                  regionId = suggestion.id!;
                                  cityId = 0;
                                  region = suggestion.name ?? "";
                                  regionFieldController.text =
                                      suggestion.name ?? '';
                                });
                                getAllCities();
                                //productName = selection.name;
                              },
                            ))
                        : const SizedBox(),
                    citiesDataAvailable
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: /* Autocomplete<CitRecords>(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                            ), */
                                TypeAheadField<CitRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: cityFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'City'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return cities.records!.where((element) =>
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
                                setState(() {
                                  cityId = suggestion.id!;
                                  postalCode = suggestion.postal ?? "";
                                  city = suggestion.name ?? "";
                                  cityFieldController.text =
                                      suggestion.name ?? '';
                                });
                                //productName = selection.name;
                              },
                            ))
                        : const SizedBox(),
                    Visibility(
                        visible: countryId != 0 && regionId != 0 && cityId != 0,
                        child: ElevatedButton(
                            onPressed: () {
                              createNewLocation();
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
        }, tabletBuilder: (context, constraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
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
                              underline: const SizedBox(),
                              value: dropdownValue == "" ? null : dropdownValue,
                              isExpanded: true,
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
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: taxFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'Tax ID'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: sdiCodeFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'SDI Code'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Term'.tr,
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
                  future: getPaymentTerms(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<PTRecords>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              underline: const SizedBox(),
                              hint: Text("Select Payment Term".tr),
                              isExpanded: true,
                              value: paymentTermId == "" ? null : paymentTermId,
                              elevation: 16,
                              onChanged: (newValue) {
                                setState(() {
                                  paymentTermId = newValue as String;
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
                    'Payment Rule'.tr,
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
                  future: getPaymentRules(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<PRRecords>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              underline: const SizedBox(),
                              hint: Text("Select Payment Rule".tr),
                              isExpanded: true,
                              value: paymentRuleId == "" ? null : paymentRuleId,
                              elevation: 16,
                              onChanged: (newValue) {
                                setState(() {
                                  paymentRuleId = newValue as String;
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
                    countriesDataAvailable
                        ? /* Container(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                          ) */
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: TypeAheadField<CtrRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: countryFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Country'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return countries.records!.where((element) =>
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
                                setState(() {
                                  countryId = suggestion.id!;
                                  regionId = 0;
                                  cityId = 0;
                                  citiesDataAvailable = false;
                                  countryFieldController.text =
                                      suggestion.name ?? '';
                                });
                                getAllRegions();
                                //productName = selection.name;
                              },
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    regionsDataAvailable
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: /* Autocomplete<RegRecords>(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                            ), */
                                TypeAheadField<RegRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: regionFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Region'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return regions.records!.where((element) =>
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
                                setState(() {
                                  regionId = suggestion.id!;
                                  cityId = 0;
                                  region = suggestion.name ?? "";
                                  regionFieldController.text =
                                      suggestion.name ?? '';
                                });
                                getAllCities();
                                //productName = selection.name;
                              },
                            ))
                        : const SizedBox(),
                    citiesDataAvailable
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: /* Autocomplete<CitRecords>(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                            ), */
                                TypeAheadField<CitRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: cityFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'City'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return cities.records!.where((element) =>
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
                                setState(() {
                                  cityId = suggestion.id!;
                                  postalCode = suggestion.postal ?? "";
                                  city = suggestion.name ?? "";
                                  cityFieldController.text =
                                      suggestion.name ?? '';
                                });
                                //productName = selection.name;
                              },
                            ))
                        : const SizedBox(),
                    Visibility(
                        visible: countryId != 0 && regionId != 0 && cityId != 0,
                        child: ElevatedButton(
                            onPressed: () {
                              createNewLocation();
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
        }, desktopBuilder: (context, cons) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
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
                              underline: const SizedBox(),
                              value: dropdownValue == "" ? null : dropdownValue,
                              isExpanded: true,
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
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: taxFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'Tax ID'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: sdiCodeFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge),
                    border: const OutlineInputBorder(),
                    labelText: 'SDI Code'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Term'.tr,
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
                  future: getPaymentTerms(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<PTRecords>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              underline: const SizedBox(),
                              hint: Text("Select Payment Term".tr),
                              isExpanded: true,
                              value: paymentTermId == "" ? null : paymentTermId,
                              elevation: 16,
                              onChanged: (newValue) {
                                setState(() {
                                  paymentTermId = newValue as String;
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
                    'Payment Rule'.tr,
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
                  future: getPaymentRules(),
                  builder: (BuildContext ctx,
                          AsyncSnapshot<List<PRRecords>> snapshot) =>
                      snapshot.hasData
                          ? DropdownButton(
                              underline: const SizedBox(),
                              hint: Text("Select Payment Rule".tr),
                              isExpanded: true,
                              value: paymentRuleId == "" ? null : paymentRuleId,
                              elevation: 16,
                              onChanged: (newValue) {
                                setState(() {
                                  paymentRuleId = newValue as String;
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
                    countriesDataAvailable
                        ? /* Container(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                          ) */
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: TypeAheadField<CtrRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: countryFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Country'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return countries.records!.where((element) =>
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
                                setState(() {
                                  countryId = suggestion.id!;
                                  regionId = 0;
                                  cityId = 0;
                                  citiesDataAvailable = false;
                                  countryFieldController.text =
                                      suggestion.name ?? '';
                                });
                                getAllRegions();
                                //productName = selection.name;
                              },
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    regionsDataAvailable
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: /* Autocomplete<RegRecords>(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                            ), */
                                TypeAheadField<RegRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: regionFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Region'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return regions.records!.where((element) =>
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
                                setState(() {
                                  regionId = suggestion.id!;
                                  cityId = 0;
                                  region = suggestion.name ?? "";
                                  regionFieldController.text =
                                      suggestion.name ?? '';
                                });
                                getAllCities();
                                //productName = selection.name;
                              },
                            ))
                        : const SizedBox(),
                    citiesDataAvailable
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: /* Autocomplete<CitRecords>(
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
                                      .contains(
                                          textEditingValue.text.toLowerCase());
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
                            ), */
                                TypeAheadField<CitRecords>(
                              textFieldConfiguration: TextFieldConfiguration(
                                minLines: 1,
                                maxLines: 4,
                                controller: cityFieldController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: const OutlineInputBorder(),
                                  labelText: 'City'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return cities.records!.where((element) =>
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
                                setState(() {
                                  cityId = suggestion.id!;
                                  postalCode = suggestion.postal ?? "";
                                  city = suggestion.name ?? "";
                                  cityFieldController.text =
                                      suggestion.name ?? '';
                                });
                                //productName = selection.name;
                              },
                            ))
                        : const SizedBox(),
                    Visibility(
                        visible: countryId != 0 && regionId != 0 && cityId != 0,
                        child: ElevatedButton(
                            onPressed: () {
                              createNewLocation();
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
        })));
  }
}

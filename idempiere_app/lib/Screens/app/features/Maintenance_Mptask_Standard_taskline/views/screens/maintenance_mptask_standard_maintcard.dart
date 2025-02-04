import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/models/mpmaintaincontractjson.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/adreflist_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/views/screens/maintenance_mptask_standard_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/models/contracttype_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/models/maintaincard_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/models/maintaincardline_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_create_standard_maintaincard_row.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_edit_standard_maintaincard_row.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_local_json.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

class MaintenanceStandardMptaskMaintenanceCard extends StatefulWidget {
  const MaintenanceStandardMptaskMaintenanceCard({Key? key}) : super(key: key);

  @override
  State<MaintenanceStandardMptaskMaintenanceCard> createState() =>
      _MaintenanceStandardMptaskMaintenanceCardState();
}

class _MaintenanceStandardMptaskMaintenanceCardState
    extends State<MaintenanceStandardMptaskMaintenanceCard> {
  Future<void> mobileEditHeader() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/LIT_ProductCard/$cardId');

    var msg = {
      "DocumentNo": docNoFieldController.text,
      "Name": nameFieldController.text,
      "Description": descriptionFieldController.text,
      "LIT_StampField_1": lITStampField1FieldController.text,
      "LIT_StampField_2": lITStampField2FieldController.text,
      "LIT_StampField_3": lITStampField3FieldController.text,
      "LIT_StampField_4": lITStampField4FieldController.text,
      "C_ContractType_ID": {"id": int.parse(contractTypeId)},
      "Revision": revisionFieldController.text,
      "SerNo": serNoFieldController.text,
      "DueDate": dueDate,
      "ValidFrom": dateFrom,
      "ValidTo": dateTo,
      "note2": note2FieldController.text,
    };

    var response = await http.put(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
      }
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

  editManualNote() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    Map<String, dynamic> msg = {
      "ManualNote": manualNoteFieldController.text,
    };

    if (paymentRuleId != "") {
      msg.addAll({
        "PaymentRule": {"id": paymentRuleId},
      });
    }
    final protocol = GetStorage().read('protocol');

    const filename = "workorder";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    WorkOrderLocalJson wo =
        WorkOrderLocalJson.fromJson(jsonDecode(file.readAsStringSync()));

    for (var element in wo.records!) {
      if (element.id == args["id"]) {
        element.manualNote = manualNoteFieldController.text;
      }
    }

    var url =
        Uri.parse('$protocol://$ip/api/v1/models/mp_ot/${args["MpOTID"]}');
    if (await checkConnection()) {
      emptyAPICallStak();
      var response = await http.put(
        url,
        body: jsonEncode(msg),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonEncode(wo.toJson());
        file.writeAsStringSync(data);
        Get.find<MaintenanceMptaskStandardController>().getWorkOrders();
        //print("done!");
        //Get.back();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        //print(response.statusCode);
      }
    } else {
      var data = jsonEncode(wo.toJson());
      file.writeAsStringSync(data);
      Get.find<MaintenanceMptaskController>().getWorkOrders();
      Map calls = {};
      if (GetStorage().read('storedEditAPICalls') == null) {
        calls['$protocol://$ip/api/v1/models/mp_ot/${args["id"]}'] =
            jsonEncode(msg);
      } else {
        calls = GetStorage().read('storedEditAPICalls');
        calls['$protocol://$ip/api/v1/models/mp_ot/${args["id"]}'] = msg;
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

  editPaidAmt() async {
    //print(now);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    var msg = jsonEncode({
      "PaidAmt": double.parse(paidAmtFieldController.text),
    });

    final protocol = GetStorage().read('protocol');

    var url =
        Uri.parse('$protocol://$ip/api/v1/models/mp_ot/${args["MpOTID"]}');

    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.find<MaintenanceMptaskStandardController>().syncWorkOrder();
      //print("done!");
      //Get.back();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      //print(response.statusCode);
    }
  }

  Future<List<CTRecords>> getAllContracttypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_ContractType?\$orderby= Name');
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

      var jsonsectors = ContractTypeJSON.fromJson(jsondecoded);

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load contract types");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<ADRRecords>> getAllPaymentRule() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_ref_list?\$filter= AD_Reference_ID eq 195');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          ADRefListJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      List<ADRRecords> pRuleList = json.records!;

      List<String> pRuleFilterList = await getPaymentRuleFilter();

      for (var i = 0; i < json.records!.length; i++) {
        if (pRuleFilterList.contains(json.records![i].value)) {
          pRuleList.removeWhere(
              (element) => element.value == json.records![i].value);
        }
      }

      /* for (var record in json.records!) {
        if (pRuleFilterList.contains(record.value)) {
          pRuleList.removeWhere((element) => element.value == record.value);
        }
      } */

      print(pRuleFilterList);

      return pRuleList;
    } else {
      //print(response.body);
      throw Exception("Failed to load sales reps");
    }
  }

  Future<List<String>> getPaymentRuleFilter() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_SysConfig?\$filter= Value eq \'LIT_WO_SHEET_STANDARD_PAYMENTRULE_VIEW\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          ADRefListJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      return json.records![0].description!.split('-');
    } else {
      //print(response.body);
      //throw Exception("Failed to load sales reps");
      return [];
    }
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    jsonbps.records!.removeWhere((element) => element.isCustomer == false);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getMaintain() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/MP_Maintain?\$filter= MP_Maintain_ID eq ${args["maintainId"]}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = MPMaintainContractJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.records!.isNotEmpty) {
        cardId = json.records![0].litProductCardID?.id ?? 0;
        getMaintainCard();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getMaintainCard() async {
    setState(() {
      dateAvailable = false;
    });
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_ProductCard?\$filter= LIT_ProductCard_ID eq $cardId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      trx = MaintainCardJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (trx.records!.isNotEmpty) {
        setState(() {
          bpSearchFieldController.text =
              trx.records![0].cBPartnerID?.identifier ?? "";

          contractTypeId =
              (trx.records![0].cContractTypeID?.id ?? "").toString();
          docNoFieldController.text = trx.records![0].documentNo ?? "";
          nameFieldController.text = trx.records![0].name ?? "";
          descriptionFieldController.text = trx.records![0].description ?? "";
          lITStampField1FieldController.text =
              trx.records![0].lITStampField1 ?? "";
          lITStampField2FieldController.text =
              trx.records![0].lITStampField2 ?? "";
          lITStampField3FieldController.text =
              trx.records![0].lITStampField3 ?? "";
          lITStampField4FieldController.text =
              trx.records![0].lITStampField4 ?? "";
          dateFrom = trx.records![0].validFrom ?? "";
          dateTo = trx.records![0].validTo ?? "";
          dueDate = trx.records![0].dueDate ?? "";
          dateAvailable = true;
          serNoFieldController.text = trx.records![0].serNo ?? "";
          revisionFieldController.text = trx.records![0].revision ?? "";
          note2FieldController.text = trx.records![0].note2 ?? "";
        });

        getmaintainCardLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getmaintainCardLines() async {
    setState(() {
      linesAvailable = true;
    });
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_ProductCardLine?\$filter= LIT_ProductCard_ID eq $cardId and IsActive eq true');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      trxLines = MaintainCardLineJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        linesAvailable = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  var args = Get.arguments;

  // MOBILE VARIABLES
  int cardId = 0;
  late TextEditingController docNoFieldController;
  late TextEditingController bpSearchFieldController;
  int businessPartnerId = 0;
  late TextEditingController nameFieldController;
  late TextEditingController descriptionFieldController;
  late TextEditingController lITStampField1FieldController;
  late TextEditingController lITStampField2FieldController;
  late TextEditingController lITStampField3FieldController;
  late TextEditingController lITStampField4FieldController;
  late TextEditingController paidAmtFieldController;
  late TextEditingController requestFieldController;
  late TextEditingController noteFieldController;
  late TextEditingController manualNoteFieldController;
  late TextEditingController note2FieldController;
  String contractTypeId = "";
  String paymentRuleId = "";
  bool dateAvailable = false;
  String dateFrom = "";
  String dateTo = "";
  String dueDate = "";
  late TextEditingController serNoFieldController;
  late TextEditingController revisionFieldController;
  MaintainCardJSON trx = MaintainCardJSON(records: []);
  MaintainCardLineJSON trxLines = MaintainCardLineJSON(records: []);
  bool linesAvailable = false;

  @override
  void initState() {
    super.initState();
    docNoFieldController = TextEditingController();
    bpSearchFieldController = TextEditingController();
    businessPartnerId = 0;
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    lITStampField1FieldController = TextEditingController();
    lITStampField2FieldController = TextEditingController();
    lITStampField3FieldController = TextEditingController();
    lITStampField4FieldController = TextEditingController();
    contractTypeId = "";
    paymentRuleId = Get.arguments["paymentRuleId"] ?? "";
    dateFrom = "";
    dateTo = "";
    dueDate = "";
    paidAmtFieldController =
        TextEditingController(text: (Get.arguments["paidAmt"]).toString());
    requestFieldController =
        TextEditingController(text: Get.arguments["request"]);
    noteFieldController = TextEditingController(text: Get.arguments["note"]);
    manualNoteFieldController =
        TextEditingController(text: Get.arguments["manualNote"]);
    note2FieldController = TextEditingController();
    dateAvailable = false;
    serNoFieldController = TextEditingController();
    revisionFieldController = TextEditingController();
    linesAvailable = false;
    getMaintain();
    getAllContracttypes();
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Maintenance Card'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                mobileEditHeader();
                editManualNote();
                editPaidAmt();
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
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
                      readOnly: true,
                      minLines: 1,
                      maxLines: 1,
                      controller: bpSearchFieldController,
                      decoration: InputDecoration(
                        labelText: 'Business Partner'.tr,
                        //filled: true,
                        border: const OutlineInputBorder(
                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                            ),
                        prefixIcon: const Icon(EvaIcons.search),
                        //hintText: "search..",
                        isDense: true,
                        //fillColor: Theme.of(context).cardColor,
                      ),
                    )),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Extra Costs'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField1FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Diritto Chiamata €'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField2FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Uscita Tecnico €'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField3FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Int. Ridotto €'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField4FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Manodopera'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: serNoFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Alarm Height'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: note2FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: revisionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Password'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllContracttypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Contract Type'.tr,
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
                                  hint: Text("Select a Contract Type".tr),
                                  isExpanded: true,
                                  value: contractTypeId == ""
                                      ? null
                                      : contractTypeId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      contractTypeId = newValue as String;
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
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllPaymentRule(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<ADRRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Payment Rule'.tr,
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
                                  hint: Text("Select a Payment Rule".tr),
                                  isExpanded: true,
                                  value: paymentRuleId == ""
                                      ? null
                                      : paymentRuleId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    print(newValue);
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: dateAvailable
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 2.5),
                                child: DateTimePicker(
                                  locale: Locale('language'.tr, 'LANGUAGE'.tr),
                                  decoration: InputDecoration(
                                    labelText: 'Date Contract From'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(Icons.event),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),

                                  type: DateTimePickerType.date,
                                  initialValue: dateFrom,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  timeLabelText: 'Date Contract From'.tr,
                                  icon: const Icon(Icons.event),
                                  onChanged: (val) {
                                    setState(() {
                                      dateFrom = val;
                                    });
                                  },
                                  validator: (val) {
                                    //print(val);
                                    return null;
                                  },
                                  // ignore: avoid_print
                                  onSaved: (val) => print(val),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Flexible(
                        child: dateAvailable
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 2.5),
                                child: DateTimePicker(
                                  locale: Locale('language'.tr, 'LANGUAGE'.tr),
                                  decoration: InputDecoration(
                                    labelText: 'Date End'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(Icons.event),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),

                                  type: DateTimePickerType.date,
                                  initialValue: dateTo,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  timeLabelText: 'Date End'.tr,
                                  icon: const Icon(Icons.event),
                                  onChanged: (val) {
                                    setState(() {
                                      dateTo = val;
                                    });
                                  },
                                  validator: (val) {
                                    //print(val);
                                    return null;
                                  },
                                  // ignore: avoid_print
                                  onSaved: (val) => print(val),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: dateAvailable
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 2.5),
                                child: DateTimePicker(
                                  locale: Locale('language'.tr, 'LANGUAGE'.tr),
                                  decoration: InputDecoration(
                                    labelText: 'Due Date'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(Icons.event),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),

                                  type: DateTimePickerType.date,
                                  initialValue: dueDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  timeLabelText: 'Due Date'.tr,
                                  icon: const Icon(Icons.event),
                                  onChanged: (val) {
                                    setState(() {
                                      dueDate = val;
                                    });
                                  },
                                  validator: (val) {
                                    //print(val);
                                    return null;
                                  },
                                  // ignore: avoid_print
                                  onSaved: (val) => print(val),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 2.5),
                        child: TextField(
                          //readOnly: true,

                          minLines: 1,
                          maxLines: 1,
                          controller: paidAmtFieldController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Paid Amt'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: requestFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Request Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity To Do'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: manualNoteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity Done'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Maintain Card Rows".tr),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                          tooltip: 'Add Row'.tr,
                          onPressed: () {
                            Get.to(
                                () => CreateMaintainCardRow(
                                      getMaintainCardLines:
                                          getmaintainCardLines,
                                    ),
                                arguments: {
                                  "cardId": cardId,
                                });
                          },
                          icon: const Icon(Icons.add)),
                    )
                  ],
                ),
                linesAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: trxLines.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
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
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Edit Row'.tr,
                                    onPressed: () {
                                      Get.to(
                                          () => EditMaintainCardRow(
                                                getMaintainCardLines:
                                                    getmaintainCardLines,
                                              ),
                                          arguments: {
                                            "cardId": cardId,
                                            "cardLineId":
                                                trxLines.records![index].id,
                                            "lineNo":
                                                trxLines.records![index].line ??
                                                    0,
                                            "productId": trxLines
                                                    .records![index]
                                                    .mProductID
                                                    ?.id ??
                                                0,
                                            "productName": trxLines
                                                    .records![index]
                                                    .mProductID
                                                    ?.identifier ??
                                                "",
                                            "qtyBOM": trxLines
                                                    .records![index].qtyBOM ??
                                                1.0,
                                            "name":
                                                trxLines.records![index].name ??
                                                    "",
                                            "description": trxLines
                                                    .records![index]
                                                    .description ??
                                                "",
                                            "productToId": trxLines
                                                    .records![index]
                                                    .mProductToID
                                                    ?.id ??
                                                0,
                                            "productToName": trxLines
                                                    .records![index]
                                                    .mProductToID
                                                    ?.identifier ??
                                                "",
                                            "qty":
                                                trxLines.records![index].qty ??
                                                    0,
                                            "dateFrom": trxLines.records![index]
                                                    .validFrom ??
                                                "",
                                            "dateTo": trxLines
                                                    .records![index].validTo ??
                                                "",
                                          });
                                    },
                                  ),
                                ),
                                title: Text(
                                  trxLines.records![index].mProductID
                                          ?.identifier ??
                                      "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          (trxLines.records![index].qtyBOM ?? 0)
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Battery".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          trxLines.records![index].mProductToID
                                                  ?.identifier ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          (trxLines.records![index].qty ?? 0)
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Install Date".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${trxLines.records![index].validFrom} ${trxLines.records![index].validTo != null ? "- ${trxLines.records![index].validTo}" : "- N/A"}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: const [],
                              ),
                            ),
                          );
                        },
                      )
                    : const CircularProgressIndicator()
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
                    minLines: 1,
                    maxLines: 5,
                    controller: docNoFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Document N°'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextField(
                      readOnly: true,
                      minLines: 1,
                      maxLines: 1,
                      controller: bpSearchFieldController,
                      decoration: InputDecoration(
                        labelText: 'Business Partner'.tr,
                        //filled: true,
                        border: const OutlineInputBorder(
                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                            ),
                        prefixIcon: const Icon(EvaIcons.search),
                        //hintText: "search..",
                        isDense: true,
                        //fillColor: Theme.of(context).cardColor,
                      ),
                    )),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Extra Costs'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField1FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Diritto Chiamata €'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField2FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Uscita Tecnico €'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField3FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Int. Ridotto €'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: lITStampField4FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Manodopera'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: serNoFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Alarm Height'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: note2FieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Note'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    controller: revisionFieldController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.text_fields),
                      border: const OutlineInputBorder(),
                      labelText: 'Password'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllContracttypes(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CTRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Contract Type'.tr,
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
                                  hint: Text("Select a Contract Type".tr),
                                  isExpanded: true,
                                  value: contractTypeId == ""
                                      ? null
                                      : contractTypeId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    setState(() {
                                      contractTypeId = newValue as String;
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
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: getAllPaymentRule(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<ADRRecords>> snapshot) =>
                        snapshot.hasData
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Payment Rule'.tr,
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
                                  hint: Text("Select a Payment Rule".tr),
                                  isExpanded: true,
                                  value: paymentRuleId == ""
                                      ? null
                                      : paymentRuleId,
                                  elevation: 16,
                                  onChanged: (newValue) {
                                    print(newValue);
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
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: dateAvailable
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 2.5),
                                child: DateTimePicker(
                                  locale: Locale('language'.tr, 'LANGUAGE'.tr),
                                  decoration: InputDecoration(
                                    labelText: 'Date Contract From'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(Icons.event),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),

                                  type: DateTimePickerType.date,
                                  initialValue: dateFrom,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  timeLabelText: 'Date Contract From'.tr,
                                  icon: const Icon(Icons.event),
                                  onChanged: (val) {
                                    setState(() {
                                      dateFrom = val;
                                    });
                                  },
                                  validator: (val) {
                                    //print(val);
                                    return null;
                                  },
                                  // ignore: avoid_print
                                  onSaved: (val) => print(val),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Flexible(
                        child: dateAvailable
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 2.5),
                                child: DateTimePicker(
                                  locale: Locale('language'.tr, 'LANGUAGE'.tr),
                                  decoration: InputDecoration(
                                    labelText: 'Date End'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(Icons.event),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),

                                  type: DateTimePickerType.date,
                                  initialValue: dateTo,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  timeLabelText: 'Date End'.tr,
                                  icon: const Icon(Icons.event),
                                  onChanged: (val) {
                                    setState(() {
                                      dateTo = val;
                                    });
                                  },
                                  validator: (val) {
                                    //print(val);
                                    return null;
                                  },
                                  // ignore: avoid_print
                                  onSaved: (val) => print(val),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: dateAvailable
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 2.5),
                                child: DateTimePicker(
                                  locale: Locale('language'.tr, 'LANGUAGE'.tr),
                                  decoration: InputDecoration(
                                    labelText: 'Due Date'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(Icons.event),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),

                                  type: DateTimePickerType.date,
                                  initialValue: dueDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  timeLabelText: 'Due Date'.tr,
                                  icon: const Icon(Icons.event),
                                  onChanged: (val) {
                                    setState(() {
                                      dueDate = val;
                                    });
                                  },
                                  validator: (val) {
                                    //print(val);
                                    return null;
                                  },
                                  // ignore: avoid_print
                                  onSaved: (val) => print(val),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 2.5),
                        child: TextField(
                          //readOnly: true,

                          minLines: 1,
                          maxLines: 1,
                          controller: paidAmtFieldController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.-]"))
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.text_fields),
                            border: const OutlineInputBorder(),
                            labelText: 'Paid Amt'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: requestFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Request Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: noteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity To Do'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: manualNoteFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Activity Done'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Maintain Card Rows".tr),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                          tooltip: 'Add Row'.tr,
                          onPressed: () {
                            Get.to(
                                () => CreateMaintainCardRow(
                                      getMaintainCardLines:
                                          getmaintainCardLines,
                                    ),
                                arguments: {
                                  "cardId": cardId,
                                });
                          },
                          icon: const Icon(Icons.add)),
                    )
                  ],
                ),
                linesAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: trxLines.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
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
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Edit Row'.tr,
                                    onPressed: () {
                                      Get.to(
                                          () => EditMaintainCardRow(
                                                getMaintainCardLines:
                                                    getmaintainCardLines,
                                              ),
                                          arguments: {
                                            "cardId": cardId,
                                            "cardLineId":
                                                trxLines.records![index].id,
                                            "lineNo":
                                                trxLines.records![index].line ??
                                                    0,
                                            "productId": trxLines
                                                    .records![index]
                                                    .mProductID
                                                    ?.id ??
                                                0,
                                            "productName": trxLines
                                                    .records![index]
                                                    .mProductID
                                                    ?.identifier ??
                                                "",
                                            "qtyBOM": trxLines
                                                    .records![index].qtyBOM ??
                                                1.0,
                                            "name":
                                                trxLines.records![index].name ??
                                                    "",
                                            "description": trxLines
                                                    .records![index]
                                                    .description ??
                                                "",
                                            "productToId": trxLines
                                                    .records![index]
                                                    .mProductToID
                                                    ?.id ??
                                                0,
                                            "productToName": trxLines
                                                    .records![index]
                                                    .mProductToID
                                                    ?.identifier ??
                                                "",
                                            "qty":
                                                trxLines.records![index].qty ??
                                                    0,
                                            "dateFrom": trxLines.records![index]
                                                    .validFrom ??
                                                "",
                                            "dateTo": trxLines
                                                    .records![index].validTo ??
                                                "",
                                          });
                                    },
                                  ),
                                ),
                                title: Text(
                                  trxLines.records![index].mProductID
                                          ?.identifier ??
                                      "???",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          (trxLines.records![index].qtyBOM ?? 0)
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Battery".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          trxLines.records![index].mProductToID
                                                  ?.identifier ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Qty".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          (trxLines.records![index].qty ?? 0)
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Install Date".tr}: ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${trxLines.records![index].validFrom} ${trxLines.records![index].validTo != null ? "- ${trxLines.records![index].validTo}" : "- N/A"}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: const [],
                              ),
                            ),
                          );
                        },
                      )
                    : const CircularProgressIndicator()
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: 4,
                      mainAxisCellCount: 1,
                      child: SingleChildScrollView(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      //margin: const EdgeInsets.all(10),
                                      child: TextField(
                                        minLines: 1,
                                        maxLines: 5,
                                        controller: docNoFieldController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          prefixIcon:
                                              const Icon(Icons.text_fields),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Document N°'.tr,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextField(
                                            readOnly: true,
                                            minLines: 1,
                                            maxLines: 1,
                                            controller: bpSearchFieldController,
                                            decoration: InputDecoration(
                                              labelText: 'Business Partner'.tr,
                                              //filled: true,
                                              border: const OutlineInputBorder(
                                                  /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                                  ),
                                              prefixIcon:
                                                  const Icon(EvaIcons.search),
                                              //hintText: "search..",
                                              isDense: true,
                                              //fillColor: Theme.of(context).cardColor,
                                            ),
                                          )),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 5,
                                          controller: nameFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Name'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: FutureBuilder(
                                          future: getAllContracttypes(),
                                          builder: (BuildContext ctx,
                                                  AsyncSnapshot<List<CTRecords>>
                                                      snapshot) =>
                                              snapshot.hasData
                                                  ? InputDecorator(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Contract Type'.tr,
                                                        //filled: true,
                                                        border: const OutlineInputBorder(
                                                            /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                                                            ),
                                                        prefixIcon: const Icon(
                                                            EvaIcons.list),
                                                        //hintText: "search..",
                                                        isDense: true,
                                                        //fillColor: Theme.of(context).cardColor,
                                                      ),
                                                      child: DropdownButton(
                                                        isDense: true,
                                                        underline:
                                                            const SizedBox(),
                                                        hint: Text(
                                                            "Select a Contract Type"
                                                                .tr),
                                                        isExpanded: true,
                                                        value: contractTypeId ==
                                                                ""
                                                            ? null
                                                            : contractTypeId,
                                                        elevation: 16,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            contractTypeId =
                                                                newValue
                                                                    as String;
                                                          });

                                                          //print(dropdownValue);
                                                        },
                                                        items: snapshot.data!
                                                            .map((list) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: list.id
                                                                .toString(),
                                                            child: Text(
                                                              list.name
                                                                  .toString(),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    /* Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 5,
                                          controller: nameFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Name'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ), */
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller:
                                              descriptionFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Extra Costs'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller:
                                              lITStampField1FieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Diritto Chiamata €'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(left:10,top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller:
                                              lITStampField2FieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Uscita Tecnico €'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller:
                                              lITStampField3FieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Int. Ridotto €'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller:
                                              lITStampField4FieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Manodopera'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 5,
                                          controller: revisionFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Password'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: dateAvailable
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: DateTimePicker(
                                                locale: Locale('language'.tr,
                                                    'LANGUAGE'.tr),
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Date Contract From'.tr,
                                                  //filled: true,
                                                  border: const OutlineInputBorder(
                                                      /* borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none, */
                                                      ),
                                                  prefixIcon:
                                                      const Icon(Icons.event),
                                                  //hintText: "search..",
                                                  isDense: true,
                                                  //fillColor: Theme.of(context).cardColor,
                                                ),

                                                type: DateTimePickerType.date,
                                                initialValue: dateFrom,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                timeLabelText:
                                                    'Date Contract From'.tr,
                                                icon: const Icon(Icons.event),
                                                onChanged: (val) {
                                                  setState(() {
                                                    dateFrom = val;
                                                  });
                                                },
                                                validator: (val) {
                                                  //print(val);
                                                  return null;
                                                },
                                                // ignore: avoid_print
                                                onSaved: (val) => print(val),
                                              ),
                                            )
                                          : const CircularProgressIndicator(),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: dateAvailable
                                            ? DateTimePicker(
                                                locale: Locale('language'.tr,
                                                    'LANGUAGE'.tr),
                                                decoration: InputDecoration(
                                                  labelText: 'Date End'.tr,
                                                  //filled: true,
                                                  border: const OutlineInputBorder(
                                                      /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                                                      ),
                                                  prefixIcon:
                                                      const Icon(Icons.event),
                                                  //hintText: "search..",
                                                  isDense: true,
                                                  //fillColor: Theme.of(context).cardColor,
                                                ),

                                                type: DateTimePickerType.date,
                                                initialValue: dateTo,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                timeLabelText: 'Date End'.tr,
                                                icon: const Icon(Icons.event),
                                                onChanged: (val) {
                                                  setState(() {
                                                    dateTo = val;
                                                  });
                                                },
                                                validator: (val) {
                                                  //print(val);
                                                  return null;
                                                },
                                                // ignore: avoid_print
                                                onSaved: (val) => print(val),
                                              )
                                            : const CircularProgressIndicator(),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: dateAvailable
                                            ? DateTimePicker(
                                                locale: Locale('language'.tr,
                                                    'LANGUAGE'.tr),
                                                decoration: InputDecoration(
                                                  labelText: 'Due Date'.tr,
                                                  //filled: true,
                                                  border: const OutlineInputBorder(
                                                      /* borderRadius: BorderRadius.circular(10),
                                                      borderSide: BorderSide.none, */
                                                      ),
                                                  prefixIcon:
                                                      const Icon(Icons.event),
                                                  //hintText: "search..",
                                                  isDense: true,
                                                  //fillColor: Theme.of(context).cardColor,
                                                ),

                                                type: DateTimePickerType.date,
                                                initialValue: dueDate,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                timeLabelText: 'Due Date'.tr,
                                                icon: const Icon(Icons.event),
                                                onChanged: (val) {
                                                  setState(() {
                                                    dueDate = val;
                                                  });
                                                },
                                                validator: (val) {
                                                  //print(val);
                                                  return null;
                                                },
                                                // ignore: avoid_print
                                                onSaved: (val) => print(val),
                                              )
                                            : const CircularProgressIndicator(),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller: note2FieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Note'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: TextField(
                                          readOnly: true,
                                          minLines: 1,
                                          maxLines: 3,
                                          controller: requestFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Request Description'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 3,
                                          controller: manualNoteFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Activity Done'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: TextField(
                                          //readOnly: true,

                                          minLines: 1,
                                          maxLines: 1,
                                          controller: paidAmtFieldController,
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[0-9.-]"))
                                          ],
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Paid Amt'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: FutureBuilder(
                                          future: getAllPaymentRule(),
                                          builder: (BuildContext ctx,
                                                  AsyncSnapshot<
                                                          List<ADRRecords>>
                                                      snapshot) =>
                                              snapshot.hasData
                                                  ? InputDecorator(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Payment Rule'.tr,
                                                        //filled: true,
                                                        border: const OutlineInputBorder(
                                                            /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                                            ),
                                                        prefixIcon: const Icon(
                                                            EvaIcons.list),
                                                        //hintText: "search..",
                                                        isDense: true,
                                                        //fillColor: Theme.of(context).cardColor,
                                                      ),
                                                      child: DropdownButton(
                                                        isDense: true,
                                                        underline:
                                                            const SizedBox(),
                                                        hint: Text(
                                                            "Select a Payment Rule"
                                                                .tr),
                                                        isExpanded: true,
                                                        value:
                                                            paymentRuleId == ""
                                                                ? null
                                                                : paymentRuleId,
                                                        elevation: 16,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            paymentRuleId =
                                                                newValue
                                                                    as String;
                                                          });

                                                          //print(dropdownValue);
                                                        },
                                                        items: snapshot.data!
                                                            .map((list) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: list.value
                                                                .toString(),
                                                            child: Text(
                                                              list.name
                                                                  .toString(),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: 5,
                                          controller: serNoFieldController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon:
                                                const Icon(Icons.text_fields),
                                            border: const OutlineInputBorder(),
                                            labelText: 'Alarm Height'.tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 4,
                      mainAxisCellCount: 1,
                      child: linesAvailable
                          ? SingleChildScrollView(
                              child: DataTable(
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: IconButton(
                                        onPressed: () {
                                          Get.to(
                                              () => CreateMaintainCardRow(
                                                    getMaintainCardLines:
                                                        getmaintainCardLines,
                                                  ),
                                              arguments: {
                                                "cardId": cardId,
                                              });
                                        },
                                        icon: const Icon(Icons.add)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Product'.tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Qty'.tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Battery'.tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        '${'Qty'.tr} 2',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Date From'.tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Date To'.tr,
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: trxLines.records!
                                    .map((e) => DataRow(cells: [
                                          DataCell(
                                            IconButton(
                                                onPressed: () {
                                                  Get.to(
                                                      () => EditMaintainCardRow(
                                                            getMaintainCardLines:
                                                                getmaintainCardLines,
                                                          ),
                                                      arguments: {
                                                        "cardId": cardId,
                                                        "cardLineId": e.id,
                                                        "lineNo": e.line ?? 0,
                                                        "productId":
                                                            e.mProductID?.id ??
                                                                0,
                                                        "productName": e
                                                                .mProductID
                                                                ?.identifier ??
                                                            "",
                                                        "qtyBOM":
                                                            e.qtyBOM ?? 1.0,
                                                        "name": e.name ?? "",
                                                        "description":
                                                            e.description ?? "",
                                                        "productToId": e
                                                                .mProductToID
                                                                ?.id ??
                                                            0,
                                                        "productToName": e
                                                                .mProductToID
                                                                ?.identifier ??
                                                            "",
                                                        "qty": e.qty ?? 0,
                                                        "dateFrom":
                                                            e.validFrom ?? "",
                                                        "dateTo":
                                                            e.validTo ?? "",
                                                      });
                                                },
                                                icon: const Icon(Icons.edit)),
                                          ),
                                          DataCell(
                                            Text(
                                                e.mProductID?.identifier ?? ""),
                                          ),
                                          DataCell(
                                              Text((e.qtyBOM ?? 0).toString())),
                                          DataCell(
                                            Text(e.mProductToID?.identifier ??
                                                ""),
                                          ),
                                          DataCell(
                                              Text((e.qty ?? 0).toString())),
                                          DataCell(Text(e.validFrom ?? "0")),
                                          DataCell(Text(e.validTo ?? "")),
                                        ]))
                                    .toList(),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

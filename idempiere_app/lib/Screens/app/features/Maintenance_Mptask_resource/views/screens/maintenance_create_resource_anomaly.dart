import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_List/models/anomaly_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/anomaly_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/attachmentlist_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/bom_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/bom_line_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/locator_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/anomaly_image.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_barcode/views/screens/maintenance_mptask_resource_barcode_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CreateResAnomaly extends StatefulWidget {
  const CreateResAnomaly({Key? key}) : super(key: key);

  @override
  State<CreateResAnomaly> createState() => _CreateResAnomalyState();
}

class _CreateResAnomalyState extends State<CreateResAnomaly> {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  createResAnomaly(bool isConnected) async {
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/LIT_NC/');

    const filename = "anomalies";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    const filename2 = "workorderresource";
    final file2 = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename2.json');

    var res = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file2.readAsStringSync()));
    if (isConnected) {
      String authorization =
          'Bearer ${GetStorage().read('token')}'; //selectedTaskId

      var msg = jsonEncode({
        "AD_Org_ID": {"id": GetStorage().read("organizationid")},
        "AD_Client_ID": {
          "id": GetStorage().read("clientid")
        }, //selectedWorkOrderId
        //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
        "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
        "MP_Maintain_Resource_ID": {"id": args["id"]},
        "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
        "AD_User_ID": {"id": GetStorage().read("userId")},
        "Name": "anomaly",
        "Description": noteFieldController.text,
        "IsInvoiced": isCharged,
        "LIT_IsReplaced": isReplacedNow,
        "M_Product_ID": {"id": replacementId},
        "DateDoc": "${formattedDate}T00:00:00Z",
        "LIT_IsManagedByCustomer": manByCustomer,
        "IsClosed": isClosed,
      });

      if (replacementId == 0) {
        msg = jsonEncode({
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
          "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
          "MP_Maintain_Resource_ID": {"id": args["id"]},
          "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
          "AD_User_ID": {"id": GetStorage().read("userId")},
          "Name": "anomaly",
          "Description": noteFieldController.text,
          "IsInvoiced": isCharged,
          "LIT_IsReplaced": isReplacedNow,
          "DateDoc": "${formattedDate}T00:00:00Z",
          "LIT_IsManagedByCustomer": manByCustomer,
          "IsClosed": isClosed,
        });
      }

      if (replacementId == 0) {
        msg = jsonEncode({
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
          "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
          "MP_Maintain_Resource_ID": {"id": args["id"]},
          "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
          "AD_User_ID": {"id": GetStorage().read("userId")},
          "Name": "anomaly",
          "Description": noteFieldController.text,
          "IsInvoiced": isCharged,
          "LIT_IsReplaced": isReplacedNow,
          "DateDoc": "${formattedDate}T00:00:00Z",
          "LIT_IsManagedByCustomer": manByCustomer,
          "IsClosed": isClosed,
        });
      }

      if (manByCustomer) {
        msg = jsonEncode({
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
          "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
          "MP_Maintain_Resource_ID": {"id": args["id"]},
          "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
          "AD_User_ID": {"id": GetStorage().read("userId")},
          "Name": "anomaly",
          "Description": noteFieldController.text,
          "IsInvoiced": isCharged,
          "LIT_IsReplaced": isReplacedNow,
          "DateDoc": "${formattedDate}T00:00:00Z",
          "LIT_IsManagedByCustomer": manByCustomer,
          "IsClosed": isClosed,
        });
      }

      //print(msg);
      var response = await http.post(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 201) {
        for (var element in res.records!) {
          if (element.id == Get.arguments["id"]) {
            element.anomaliesCount =
                (int.parse(element.anomaliesCount!) + 1).toString();
          }
        }
        file2.writeAsStringSync(jsonEncode(res.toJson()));
        try {
          Get.find<MaintenanceMpResourceController>()
              .syncSingleResource(args["id"]);
        } catch (e) {
          if (kDebugMode) {
            print('no page');
          }
        }
        try {
          Get.find<MaintenanceMpResourceBarcodeController>()
              .syncSingleResource(args["id"]);
        } catch (e) {
          if (kDebugMode) {
            print('no page');
          }
        }

        var json = AnomalyJson.fromJson(jsonDecode(file.readAsStringSync()));
        var record =
            ANRecords.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        json.records!.add(record);

        file.writeAsStringSync(jsonEncode(json.toJson()));
        Get.back();
        var json2 = jsonDecode(response.body);
        if (attachment.attachments!.isNotEmpty) {
          sendTicketAttachedImage(json2["id"]);
          //print(response.body);
        }
        //print("done!");
        Get.snackbar(
          "Done!".tr,
          "The record has been created".tr,
          duration: const Duration(milliseconds: 800),
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
          "Record not created".tr,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      var record = ANRecords();
      var json = AnomalyJson.fromJson(jsonDecode(file.readAsStringSync()));

      record.offlineId = GetStorage().read('postCallId');
      record.mPMaintainResourceID = MPMaintainResourceID.fromJson({
        "MP_Maintain_Resource_ID": {"id": args["id"]}
      });
      record.lITNCFaultTypeID = LITNCFaultTypeID.fromJson({
        "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)}
      });
      record.aDUserID = ADUserID3.fromJson({
        "AD_User_ID": {"id": GetStorage().read("userId")}
      });
      record.description = noteFieldController.text;
      record.isInvoiced = isCharged;
      record.lITIsReplaced = isReplacedNow;
      if (manByCustomer) {
        record.mProductID = AMProductID.fromJson({
          "M_Product_ID": {"id": replacementId},
        });
      }

      record.dateDoc = "${formattedDate}T00:00:00Z";
      record.lITIsManagedByCustomer = manByCustomer;
      record.isClosed = isClosed;

      List<dynamic> list = [];

      var msg = jsonEncode({
        "offlineid": GetStorage().read('postCallId'),
        "url": '$protocol://$ip/api/v1/models/LIT_NC/',
        "AD_Org_ID": {"id": GetStorage().read("organizationid")},
        "AD_Client_ID": {
          "id": GetStorage().read("clientid")
        }, //selectedWorkOrderId
        //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
        "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
        "MP_Maintain_Resource_ID": {"id": args["id"]},
        "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
        "AD_User_ID": {"id": GetStorage().read("userId")},
        "Name": "anomaly",
        "Description": noteFieldController.text,
        "IsInvoiced": isCharged,
        "LIT_IsReplaced": isReplacedNow,
        "M_Product_ID": {"id": replacementId},
        "DateDoc": "${formattedDate}T00:00:00Z",
        "LIT_IsManagedByCustomer": manByCustomer,
        "IsClosed": isClosed,
        "IsValid": isValid,
      });

      if (replacementId == 0) {
        msg = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": '$protocol://$ip/api/v1/models/LIT_NC/',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
          "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
          "MP_Maintain_Resource_ID": {"id": args["id"]},
          "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
          "AD_User_ID": {"id": GetStorage().read("userId")},
          "Name": "anomaly",
          "Description": noteFieldController.text,
          "IsInvoiced": isCharged,
          "LIT_IsReplaced": isReplacedNow,
          "DateDoc": "${formattedDate}T00:00:00Z",
          "LIT_IsManagedByCustomer": manByCustomer,
          "IsClosed": isClosed,
        });
      }

      if (manByCustomer) {
        msg = jsonEncode({
          "offlineid": GetStorage().read('postCallId'),
          "url": '$protocol://$ip/api/v1/models/LIT_NC/',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          //"MP_Maintain_Task_ID": {"id": GetStorage().read("selectedTaskId")},
          "MP_OT_ID": {"id": GetStorage().read("selectedWorkOrderId")},
          "MP_Maintain_Resource_ID": {"id": args["id"]},
          "LIT_NCFaultType_ID": {"id": int.parse(dropdownValue)},
          "AD_User_ID": {"id": GetStorage().read("userId")},
          "Name": "anomaly",
          "Description": noteFieldController.text,
          "IsInvoiced": isCharged,
          "LIT_IsReplaced": isReplacedNow,
          "DateDoc": "${formattedDate}T00:00:00Z",
          "LIT_IsManagedByCustomer": manByCustomer,
          "IsClosed": isClosed,
        });
      }
      if (GetStorage().read('postCallList') == null) {
        list.add(msg);
      } else {
        list = GetStorage().read('postCallList');

        list.add(msg);
      }
      GetStorage().write('postCallId', GetStorage().read('postCallId') + 1);
      GetStorage().write('postCallList', list);
      Get.snackbar(
        "Saved!".tr,
        "The record has been saved locally waiting for internet connection".tr,
        icon: const Icon(
          Icons.save,
          color: Colors.yellow,
        ),
      );
      json.records!.add(record);
      //json.rowcount = json.rowcount! + 1;
      var data = jsonEncode(json.toJson());
      file.writeAsStringSync(data);
      try {
        Get.find<MaintenanceMpResourceController>().getWorkOrders();
      } catch (e) {
        if (kDebugMode) {
          print("no page");
        }
      }
      try {
        Get.find<MaintenanceMpResourceBarcodeController>().getWorkOrders();
      } catch (e) {
        if (kDebugMode) {
          print("no page");
        }
      }
    }
  }

  attachImage() async {
    setState(() {
      attachmentData = false;
    });

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    /* if (result != null) {
      //File file = File(result.files.first.bytes!);
      setState(() {
        image64 = base64.encode(result.files.first.bytes!);
        imageName = result.files.first.name;
      });
      //print(image64);
      //print(imageName);
    } */

    if (result != null) {
      for (var element in result.files) {
        attachment.attachments!.add(Attachment(
            name: element.name, value: base64.encode(element.bytes!)));
      }
    }

    setState(() {
      attachmentData = true;
    });
  }

  sendTicketAttachedImage(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    for (var element in attachment.attachments!) {
      final msg = jsonEncode({"name": element.name, "data": element.value});

      var url =
          Uri.parse('$protocol://$ip/api/v1/models/LIT_NC/$id/attachments');

      var response = await http.post(
        url,
        body: msg,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
      } else {
        //print(response.body);
      }
    }
  }

  getAnomalyTypes() async {
    const filename = "anomalytype";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    //print(response.body);
    var json = AnomalyTypeJson.fromJson(jsonDecode(file.readAsStringSync()));

    list = json.records!;
    list.insert(0, ARecords(id: 0, name: ""));

    for (var element in list) {
      if (element.name == 'Parte Mancante') {
        missingPartId = element.id.toString();
      }
    }

    setState(() {
      anomalyTypesAvailable = true;
    });
  }

  getLocators() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Locator?\$filter= M_Warehouse_ID eq ${GetStorage().read('warehouseid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      const filename = "userpreferences";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      var userpref = jsonDecode(file.readAsStringSync());
      if (userpref["row-count"] > 0 &&
          userpref["records"][0]["M_Locator_ID"] != null) {
        locatorInitialValue = TextEditingValue(
            text: userpref["records"][0]["M_Locator_ID"]["identifier"]);
      } else {
        locatorInitialValue = const TextEditingValue(text: "");
      }

      //print(response.body);
      var json =
          LocatorJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      listLocators = json.records!;

      setState(() {
        locatorAvailable = true;
      });
    } else {
      throw Exception("Failed to load locators");
    }
  }

  getProductStock(int id) async {
    const filename = "userpreferences";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var userpref = jsonDecode(file.readAsStringSync());

    var locId = "";

    if (userpref["row-count"] > 0 &&
        userpref["records"][0]["M_Locator_ID"] != null) {
      locationId = userpref["records"][0]["M_Locator_ID"]["id"];
      locId =
          "and M_Locator_ID eq ${userpref["records"][0]["M_Locator_ID"]["id"]}";
    }
    //print(GetStorage().read('userPreferencesSync'));
    if (id != 0) {
      locId = "and M_Locator_ID eq $locationId";
    }

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_StorageOnHand?\$filter= M_Product_ID eq ${args["productId"]} $locId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json["row-count"] > 0) {
        stockFieldController.text = json["records"][0]["QtyOnHand"].toString();
      }
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getProductBOM() async {
    /* final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/PP_Product_BOM?\$filter= M_Product_ID eq ${args["productId"]}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    ); */

    const filename = "productsBOM";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var json = ProductBOMJson.fromJson(jsonDecode(file.readAsStringSync()));

    json.records!
        .retainWhere((element) => element.mProductID?.id == args["productId"]);

    //print(response.body);
    //var json = jsonDecode(utf8.decode(response.bodyBytes));
    const filename3 = "products";
    final file3 = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename3.json');
    var jsonResources =
        ProductJson.fromJson(jsonDecode(file3.readAsStringSync()));

    bomList = [];

    for (var i = 0; i < jsonResources.records!.length; i++) {
      bomList.add(jsonResources.records![i]);
    }

    /* if (json.records!.isNotEmpty) {
      getProductBOMLines(json.records![0].id!);
    } */
    setState(() {
      missingPartFlag = true;
    });
  }

  getProductBOMLines(int id) async {
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    const filename2 = "productsBOMline";
    final file2 = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename2.json');
    /* final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/PP_Product_BOMLine?\$filter= PP_Product_BOM_ID eq $id');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    ); */

    //print(response.body);
    // ignore: unused_local_variable
    var json = BOMLineJson.fromJson(jsonDecode(file2.readAsStringSync()));
    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    bomList = [];

    for (var i = 0; i < jsonResources.records!.length; i++) {
      bomList.add(jsonResources.records![i]);
    }

    /* for (var element in json.records!) {                             ////////////////////////////COMMENTATO MOMENTANEAMENTE
      for (var i = 0; i < jsonResources.records!.length; i++) {
        if (element.mProductCategoryID?.id ==
            jsonResources.records![i].mProductCategoryID?.id) {
          bomList.add(jsonResources.records![i]);
        }
      }
      //print(element.mProductCategoryID?.identifier ?? "nothing");
    } */
    setState(() {
      missingPartFlag = true;
    });
  }

  initializeAttachmentsList() {
    setState(() {
      attachmentData = false;
    });
    //attachmentData = false;
    attachment = AttachmentListJson.fromJson({"attachments": []});
    setState(() {
      attachmentData = true;
    });
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

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  /* var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var bPartnerFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var phoneFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var mailFieldController;
  String dropdownValue = "";
  String salesrepValue = ""; */
  String imageName = "";
  String image64 = "";
  late TextEditingController productFieldController;
  late TextEditingController stockFieldController;
  late TextEditingController noteFieldController;
  late List<ARecords> list;
  late List<LRecords> listLocators;
  String dropdownValue = "";
  bool anomalyTypesAvailable = false;
  bool locatorAvailable = false;
  bool isCharged = false;
  bool isReplacedNow = false;
  bool isClosed = false;
  bool manByCustomer = false;
  bool isValid = false;
  late String missingPartId;
  List<Records> bomList = [];
  bool missingPartFlag = false;
  int locationId = 0;
  int replacementId = 0;
  late TextEditingValue locatorInitialValue;
  late AttachmentListJson attachment;
  bool attachmentData = false;

  @override
  void initState() {
    attachmentData = false;
    initializeAttachmentsList();
    productFieldController = TextEditingController();
    stockFieldController = TextEditingController();
    noteFieldController = TextEditingController();
    bomList = [];
    missingPartFlag = false;
    manByCustomer = false;
    super.initState();
    anomalyTypesAvailable = false;
    locatorAvailable = false;
    isCharged = false;
    isReplacedNow = false;
    isClosed = false;
    isValid = false;
    productFieldController.text = args["productName"] ?? "";
    stockFieldController.text = "0";
    list = [];
    listLocators = [];
    dropdownValue = "0";
    image64 = "";
    imageName = "";

    getAnomalyTypes();
    if (Get.arguments["isConnected"]) {
      getProductStock(0);
      getLocators();
    }

    /* nameFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    bPartnerFieldController = TextEditingController();
    mailFieldController = TextEditingController();
    dropdownValue = "N"; */
    //fillFields();
  }

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  static String _displayLocatorStringForOption(LRecords option) =>
      "${option.value}";

  //static String _displayStringForOption(Records option) => option.name!;
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Anomaly'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //createResAnomaly();
                Get.offNamed('/MaintenanceMptaskAnomalyList', arguments: {
                  "id": Get.arguments["id"],
                });
              },
              icon: const Icon(
                Icons.list,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                createResAnomaly(await checkConnection());
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Anomaly Type".tr,
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
                  child: anomalyTypesAvailable
                      ? DropdownButton(
                          value: dropdownValue,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              missingPartFlag = false;
                              dropdownValue = newValue!;
                            });
                            if (kDebugMode) {
                              print(newValue);
                            }

                            /* if (newValue == missingPartId) {
                              getProductBOM();
                            } */
                            getProductBOM();
                          },
                          items: list
                              .map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name ?? "???",
                                  ),
                                );
                              })
                              .toSet()
                              .toList(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Product'.tr,
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
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Visibility(
                  visible: /* missingPartFlag && */ /*  manByCustomer != true */
                      false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Replacement".tr,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: /* missingPartFlag && manByCustomer != true */ false,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: missingPartFlag
                          ? Autocomplete<Records>(
                              displayStringForOption: _displayStringForOption,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<Records>.empty();
                                }
                                return bomList.where((Records option) {
                                  return ("${option.value}_${option.name}")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (Records selection) {
                                //print(salesrepValue);
                                replacementId = selection.id!;
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
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
                Visibility(
                  visible: /* locatorAvailable && manByCustomer != true */
                      false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Stock Area".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: /* locatorAvailable && manByCustomer != true */
                      false,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: locatorAvailable
                          ? Autocomplete<LRecords>(
                              initialValue: locatorInitialValue,
                              displayStringForOption:
                                  _displayLocatorStringForOption,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<LRecords>.empty();
                                }
                                return listLocators.where((LRecords option) {
                                  return ("${option.value}")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (LRecords selection) {
                                getProductStock(selection.id!);
                                //print(salesrepValue);
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                ),
                Visibility(
                  visible: /* manByCustomer != true */ false,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      readOnly: true,
                      controller: stockFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Stock'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
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
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Valid'.tr),
                  value: isValid,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isValid = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                IconButton(
                    onPressed: () {
                      attachImage();
                    },
                    icon: Icon(
                      Icons.attach_file,
                      color: image64 != "" ? Colors.green : Colors.white,
                    )),
                ListView.builder(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: attachment.attachments!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 8.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                          onTap: () {
                            Get.to(const AnomalyImage(), arguments: {
                              "base64": attachment.attachments![index].value
                            });
                          },
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                attachmentData = false;
                              });

                              attachment.attachments!.removeAt(index);
                              setState(() {
                                attachmentData = true;
                              });
                            },
                          ),
                          title: Text(
                            attachment.attachments![index].name ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Anomaly Type".tr,
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
                  child: anomalyTypesAvailable
                      ? DropdownButton(
                          value: dropdownValue,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              missingPartFlag = false;
                              dropdownValue = newValue!;
                            });
                            if (kDebugMode) {
                              print(newValue);
                            }

                            /* if (newValue == missingPartId) {
                              getProductBOM();
                            } */
                            getProductBOM();
                          },
                          items: list
                              .map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name ?? "???",
                                  ),
                                );
                              })
                              .toSet()
                              .toList(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Product'.tr,
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
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Visibility(
                  visible: /* missingPartFlag && */ /*  manByCustomer != true */
                      false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Replacement".tr,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: /* missingPartFlag && manByCustomer != true */ false,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: missingPartFlag
                          ? Autocomplete<Records>(
                              displayStringForOption: _displayStringForOption,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<Records>.empty();
                                }
                                return bomList.where((Records option) {
                                  return ("${option.value}_${option.name}")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (Records selection) {
                                //print(salesrepValue);
                                replacementId = selection.id!;
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
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
                Visibility(
                  visible: /* locatorAvailable && manByCustomer != true */
                      false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Stock Area".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: /* locatorAvailable && manByCustomer != true */
                      false,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: locatorAvailable
                          ? Autocomplete<LRecords>(
                              initialValue: locatorInitialValue,
                              displayStringForOption:
                                  _displayLocatorStringForOption,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<LRecords>.empty();
                                }
                                return listLocators.where((LRecords option) {
                                  return ("${option.value}")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (LRecords selection) {
                                getProductStock(selection.id!);
                                //print(salesrepValue);
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                ),
                Visibility(
                  visible: /* manByCustomer != true */ false,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      readOnly: true,
                      controller: stockFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Stock'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
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
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Valid'.tr),
                  value: isValid,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isValid = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                IconButton(
                    onPressed: () {
                      attachImage();
                    },
                    icon: Icon(
                      Icons.attach_file,
                      color: image64 != "" ? Colors.green : Colors.white,
                    )),
                ListView.builder(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: attachment.attachments!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 8.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                          onTap: () {
                            Get.to(const AnomalyImage(), arguments: {
                              "base64": attachment.attachments![index].value
                            });
                          },
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                attachmentData = false;
                              });

                              attachment.attachments!.removeAt(index);
                              setState(() {
                                attachmentData = true;
                              });
                            },
                          ),
                          title: Text(
                            attachment.attachments![index].name ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
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
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Anomaly Type".tr,
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
                  child: anomalyTypesAvailable
                      ? DropdownButton(
                          value: dropdownValue,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              missingPartFlag = false;
                              dropdownValue = newValue!;
                            });
                            if (kDebugMode) {
                              print(newValue);
                            }

                            /* if (newValue == missingPartId) {
                              getProductBOM();
                            } */
                            getProductBOM();
                          },
                          items: list
                              .map((list) {
                                return DropdownMenuItem<String>(
                                  value: list.id.toString(),
                                  child: Text(
                                    list.name ?? "???",
                                  ),
                                );
                              })
                              .toSet()
                              .toList(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: productFieldController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_pin_outlined),
                      border: const OutlineInputBorder(),
                      labelText: 'Product'.tr,
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
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Visibility(
                  visible: /* missingPartFlag && */ /*  manByCustomer != true */
                      false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Replacement".tr,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: /* missingPartFlag && manByCustomer != true */ false,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: missingPartFlag
                          ? Autocomplete<Records>(
                              displayStringForOption: _displayStringForOption,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<Records>.empty();
                                }
                                return bomList.where((Records option) {
                                  return ("${option.value}_${option.name}")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (Records selection) {
                                //print(salesrepValue);
                                replacementId = selection.id!;
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
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
                Visibility(
                  visible: /* locatorAvailable && manByCustomer != true */
                      false,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Stock Area".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: /* locatorAvailable && manByCustomer != true */
                      false,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: locatorAvailable
                          ? Autocomplete<LRecords>(
                              initialValue: locatorInitialValue,
                              displayStringForOption:
                                  _displayLocatorStringForOption,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<LRecords>.empty();
                                }
                                return listLocators.where((LRecords option) {
                                  return ("${option.value}")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (LRecords selection) {
                                getProductStock(selection.id!);
                                //print(salesrepValue);
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                ),
                Visibility(
                  visible: /* manByCustomer != true */ false,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      readOnly: true,
                      controller: stockFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Stock'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
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
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: Text('Is Valid'.tr),
                  value: isValid,
                  activeColor: kPrimaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isValid = value!;
                      //GetStorage().write('checkboxLogin', checkboxState);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                IconButton(
                    onPressed: () {
                      attachImage();
                    },
                    icon: Icon(
                      Icons.attach_file,
                      color: image64 != "" ? Colors.green : Colors.white,
                    )),
                ListView.builder(
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: attachment.attachments!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 8.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                          onTap: () {
                            Get.to(const AnomalyImage(), arguments: {
                              "base64": attachment.attachments![index].value
                            });
                          },
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                attachmentData = false;
                              });

                              attachment.attachments!.removeAt(index);
                              setState(() {
                                attachmentData = true;
                              });
                            },
                          ),
                          title: Text(
                            attachment.attachments![index].name ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}

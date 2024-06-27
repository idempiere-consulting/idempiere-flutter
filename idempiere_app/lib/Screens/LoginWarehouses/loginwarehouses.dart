import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/models/mpmaintaincontractjson.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_List/models/anomaly_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/anomaly_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/bom_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/bom_line_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_survey_lines_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/models/workorder_task_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/models/businespartnerjson.dart';
import 'package:idempiere_app/constants.dart';
import 'package:path_provider/path_provider.dart';

class LoginWarehouses extends StatefulWidget {
  const LoginWarehouses({Key? key}) : super(key: key);

  @override
  State<LoginWarehouses> createState() => _LoginWarehousesState();
}

class _LoginWarehousesState extends State<LoginWarehouses> {
  syncData() {
    /* showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Text("Syncing data with iDempiere...".tr),
            ],
          ),
        );
      },
    ); */

    var syncPerm = GetStorage().read("permission3");
    //print('permessi $syncPerm');
    if ((GetStorage().read('isjpTODOSync') ?? true) &&
        (syncPerm != null && syncPerm != "" ? syncPerm[0] == 'Y' : true)) {
      jpTODOSync = true;
      syncJPTODO();
    }
    if ((GetStorage().read('isUserPreferencesSync') ?? true) &&
        (syncPerm != null && syncPerm != "" ? syncPerm[1] == 'Y' : true)) {
      userPreferencesSync = true;
      syncUserPreferences();
    }
    if ((GetStorage().read('isBusinessPartnerSync') ?? true) &&
        (syncPerm != null && syncPerm != "" ? syncPerm[2] == 'Y' : true)) {
      businessPartnerSync = true;
      syncBusinessPartner();
    }
    if ((GetStorage().read('isProductSync') ?? true) &&
        (syncPerm != null && syncPerm != "" ? syncPerm[3] == 'Y' : true)) {
      productSync = true;
      syncProduct();
      //syncProductBOM();
    }
    if ((GetStorage().read('isWorkOrderSync') ?? true) &&
        (syncPerm != null && syncPerm != "" ? syncPerm[4] == 'Y' : true)) {
      workOrderSync = true;
      syncWorkOrder();
      syncCartelFormat();
      syncResourceSubCategory();
      syncWorkOrderRefListResource();
      syncWorkOrderRefListResourceCategory();
      syncWorkOrderListResourceGroup();
    }
  }

  syncJPTODO() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/jp_todo');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      const filename = "calendar";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);

      //GetStorage().write('jpTODOSync', response.body);
      if (kDebugMode) {
        print('jpToDo Checked');
      }
      jpTODOSync = false;
      checkSyncData();
    } else {
      jpTODOSync = false;
      checkSyncData();
    }
  }

  syncUserPreferences() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_UserPreference?\$filter= AD_User_ID eq ${GetStorage().read('userId')}');
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
      file.writeAsString(response.body);

      userPreferencesSync = false;
      if (kDebugMode) {
        print('User Preferences Checked');
      }
      checkSyncData();
    }
  }

  syncBusinessPartner() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncBusinessPartnerPages(json, index);
      } else {
        const filename = "businesspartner";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        syncADOrgInfo();
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('BusinessPartner Checked');
        }
        checkSyncData();
      }
    }
  }

  syncBusinessPartnerPages(BusinessPartnerJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      //print(pageJson.records?.length);
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncBusinessPartnerPages(json, index);
      } else {
        if (kDebugMode) {
          print("pages done $index");
          print(json.records!.length);
        }
        const filename = "businesspartner";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        syncADOrgInfo();
        //businessPartnerSync = false;
        if (kDebugMode) {
          print('BusinessPartner Checked');
        }
        checkSyncData();
      }
    }
  }

  syncADOrgInfo() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_orginfo?\$filter= AD_Org_ID eq ${GetStorage().read("organizationid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      const filename = "adorginfo";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);
      businessPartnerSync = false;
      //userPreferencesSync = false;
      if (kDebugMode) {
        print('ADOrgInfo Checked');
      }
      checkSyncData();
    }
  }

  syncProduct() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_product?\$filter= IsSelfService eq Y and AD_Client_ID eq ${GetStorage().read('clientid')}');

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
          ProductJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncProductPages(json, index);
      } else {
        const filename = "products";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncProductBOM();
        if (kDebugMode) {
          print('Products Checked');
        }
        //checkSyncData();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  syncProductPages(ProductJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_product?\$filter= IsSelfService eq Y and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
          ProductJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncProductPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "products";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //productSync = false;
        syncProductBOM();
        if (kDebugMode) {
          print('Products Checked');
        }
        //checkSyncData();
      }
    }
  }

  Future<void> syncProductBOM() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/PP_Product_BOM');

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
          ProductBOMJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncProductBOMPages(json, index);
      } else {
        const filename = "productsBOM";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncProductBOMLines();
        if (kDebugMode) {
          print('ProductsBOM Checked');
        }
        //checkSyncData();
      }
    }
  }

  syncProductBOMPages(ProductBOMJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/PP_Product_BOM?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
          ProductBOMJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncProductBOMPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "productsBOM";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //productSync = false;
        syncProductBOMLines();
        if (kDebugMode) {
          print('ProductsBOM Checked');
        }
        //checkSyncData();
      }
    }
  }

  Future<void> syncProductBOMLines() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/PP_Product_BOMLine');

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
          BOMLineJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncProductBOMLinesPages(json, index);
      } else {
        const filename = "productsBOMline";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncAnomalies();
        if (kDebugMode) {
          print('ProductsBOMline Checked');
        }
        //checkSyncData();
      }
    }
  }

  syncProductBOMLinesPages(BOMLineJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/PP_Product_BOMLine?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
          BOMLineJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncProductBOMLinesPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "productsBOMline";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        syncAnomalies();
        //productSync = false;
        if (kDebugMode) {
          print('ProductsBOMline Checked');
        }
        //checkSyncData();
      }
    }
  }

  Future<void> syncAnomalies() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/LIT_NC');

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
          AnomalyJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncAnomaliesPages(json, index);
      } else {
        const filename = "anomalies";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncAnomalyTypes();
        if (kDebugMode) {
          print('Anomalies Checked');
        }
        //checkSyncData();
      }
    } else {
      productSync = false;
      checkSyncData();
    }
  }

  syncAnomaliesPages(AnomalyJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_NC?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
          AnomalyJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncAnomaliesPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "anomalies";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //productSync = false;
        syncAnomalyTypes();
        if (kDebugMode) {
          print('Anomalies Checked');
        }
        //checkSyncData();
      }
    }
  }

  Future<void> syncAnomalyTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/LIT_NCFaultType');

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
          AnomalyTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncAnomalyTypePages(json, index);
      } else {
        const filename = "anomalytype";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        productSync = false;
        if (kDebugMode) {
          print('Anomaly type Checked');
        }
        checkSyncData();
      }
    }
  }

  syncAnomalyTypePages(AnomalyTypeJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_NCFaultType?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
          AnomalyTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncAnomalyTypePages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "anomalytype";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        productSync = false;
        if (kDebugMode) {
          print('Anomaly type Checked');
        }
        checkSyncData();
      }
    }
  }

  Future<void> syncWorkOrder() async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_v?\$filter= mp_ot_ad_user_id eq $userId or maintain_documentno eq \'SEDE\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      //print(utf8.decode(response.bodyBytes));
      /* const filename = "workorder";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(utf8.decode(response.bodyBytes));
      //GetStorage().write('workOrderSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('WorkOrder Checked');
      }
      syncWorkOrderResource(); */
      print('pagine wo');
      var json = WorkOrderLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderPages(json, index);
      } else {
        const filename = "workorder";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncWorkOrderResource();
        if (kDebugMode) {
          print('WorkOrder Checked');
        }
        //checkSyncData();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  Future<void> syncWorkOrderPages(WorkOrderLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_v?\$filter= mp_ot_ad_user_id eq $userId or maintain_documentno eq \'SEDE\'&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorder";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        syncWorkOrderResource();
        if (kDebugMode) {
          print('WorkOrder Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  Future<void> syncCartelFormat() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_cartel_format?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      //print(utf8.decode(response.bodyBytes));
      const filename = "cartelformat";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(utf8.decode(response.bodyBytes));
      //GetStorage().write('workOrderSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('Cartel Format Checked');
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> syncResourceSubCategory() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_M_Product_SubCategory?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      //print(utf8.decode(response.bodyBytes));
      const filename = "resourcesubcategory";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(utf8.decode(response.bodyBytes));
      //GetStorage().write('workOrderSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('Resource SubCategory Checked');
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} or AD_User_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourcePages(json, index);
      } else {
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncMaintain();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
      }
      //syncWorkOrderResourceSurveyLines();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  syncWorkOrderResourcePages(WorkOrderResourceLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} or AD_User_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderResourcePages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        syncMaintain();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  Future<void> syncMaintain() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        //print(response.body);
      }
      var json = MPMaintainContractJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncMaintainPages(json, index);
      } else {
        const filename = "maintain";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;
        syncWorkOrderTask();
        if (kDebugMode) {
          print('Maintain Checked');
        }
        //checkSyncData();
      }
      //syncWorkOrderResourceSurveyLines();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  syncMaintainPages(MPMaintainContractJSON json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = MPMaintainContractJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncMaintainPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "maintain";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        syncWorkOrderTask();
        if (kDebugMode) {
          print('Maintain Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  Future<void> syncWorkOrderTask() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_task_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        //print(response.body);
      }
      var json = WorkOrderTaskLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderTaskPages(json, index);
      } else {
        const filename = "workordertask";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        syncWorkOrderResourceSurveyLines();
        //productSync = false;
        if (kDebugMode) {
          print('WorkOrderTask Checked');
        }
        //checkSyncData();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  syncWorkOrderTaskPages(WorkOrderTaskLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_task_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderTaskLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderTaskPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workordertask";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        if (kDebugMode) {
          print('WorkOrderTask page Checked');
        }
        //checkSyncData();
        syncWorkOrderResourceSurveyLines();
        //syncWorkOrderTask();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      workOrderSync = false;
      checkSyncData();
    }
  }

  Future<void> syncWorkOrderListResourceGroup() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_resourcegroup/');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      //print(response2.body);
      const filename = "listresourcegroup";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);
      /*  GetStorage()
            .write('refListResourceType', utf8.decode(response2.bodyBytes)); */
      if (kDebugMode) {
        print('ListResourceGroup Checked');
      }

      /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> syncWorkOrderRefListResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'MP ResourceType\'');

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
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        const filename = "reflistresourcetype";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(response2.body);
        /*  GetStorage()
            .write('refListResourceType', utf8.decode(response2.bodyBytes)); */
        if (kDebugMode) {
          print('refListResourceType Checked');
        }

        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body);
    }
  }

  Future<void> syncWorkOrderRefListResourceCategory() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'C_BP_EDI EDI Type\'');

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
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        const filename = "reflistresourcetypecategory";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(response2.body);
        /* GetStorage().write(
            'refListResourceTypeCategory', utf8.decode(response2.bodyBytes)); */
        if (kDebugMode) {
          print('refListResourceTypeCategory Checked');
        }

        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body); &\$orderby=
    }
  }

  Future<void> syncWorkOrderResourceSurveyLines() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey_line?\$orderby= LineNo asc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourceSurveyLinesPages(json, index);
      } else {
        const filename = "workorderresourcesurveylines";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        workOrderSync = false;
        if (kDebugMode) {
          print('workOrderResourceSurveyLinesSync Checked');
        }
        checkSyncData();
      }
    } else {
      print(response.body);
    }
  }

  syncWorkOrderResourceSurveyLinesPages(
      WorkOrderResourceSurveyLinesJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey_line?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}&\$orderby= LineNo asc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderResourceSurveyLinesPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorderresourcesurveylines";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        workOrderSync = false;
        if (kDebugMode) {
          print('workOrderResourceSurveyLinesSync Checked');
        }
        checkSyncData();
      }
    } else {
      print(response.body);
    }
  }

  checkSyncData() {
    if (businessPartnerSync == false &&
        userPreferencesSync == false &&
        productSync == false &&
        jpTODOSync == false &&
        workOrderSync == false) {
      var value = "0";
      List<dynamic> list = GetStorage().read('permission');
      for (var i = 0; i < list.length; i++) {
        if (int.parse(list[i], radix: 16)
                .toRadixString(2)
                .padLeft(8, "0")
                .toString()[4] ==
            "1") {
          value = i.toString();
        }
      }
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      GetStorage().write('lastLoginDate', date.toString());
      switch (value) {
        case "0":
          Get.offAllNamed("/Dashboard");
          break;
        case "2":
          Get.offAllNamed("/CRM");
          break;
        case "8":
          Get.offAllNamed("/SalesOrder");
          break;
        case "22":
          Get.offAllNamed("/Maintenance");
          break;
        case "24":
          Get.offAllNamed("/MaintenanceMptask");
          break;
        case "31":
          Get.offAllNamed("/MaintenanceMptaskStandard");
          break;
        case "32":
          Get.offAllNamed("/PortalMp");
          break;
        case "51":
          Get.offAllNamed("/PortalMpSalesOrderB2B");
          break;
        case "52":
          Get.offAllNamed("/TrainingCourse");
          break;
        case "69":
          Get.offAllNamed("/SupplychainLoadUnload");
          break;
        default:
          Get.offAllNamed("/Dashboard");
          break;
      }
    }
  }

  getLoginPermission() async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= AD_User_ID eq $userId');

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
      if (json["records"][0]["IsMobileEnabled"] == true) {
        String permissions = json["records"][0]["lit_mobilerole"];
        String permissions2 = json["records"][0]["lit_mobile_perm"] ?? "";
        String permissions3 = json["records"][0]["LIT_MobileChartRole"] ?? "";
        List<String> list = permissions.split("-");
        GetStorage().write('permission', list);
        GetStorage().write('permission2', permissions2);
        GetStorage().write('permission3', permissions3);
        if (GetStorage().read('checkboxSyncDataLogin') == false) {
          var value = "0";
          List<dynamic> list = GetStorage().read('permission');
          for (var i = 0; i < list.length; i++) {
            if (int.parse(list[i], radix: 16)
                    .toRadixString(2)
                    .padLeft(8, "0")
                    .toString()[4] ==
                "1") {
              value = i.toString();
            }
          }
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          GetStorage().write('lastLoginDate', date.toString());
          switch (value) {
            case "0":
              Get.offAllNamed("/Dashboard");
              break;
            case "2":
              Get.offAllNamed("/CRM");
              break;
            case "8":
              Get.offAllNamed("/SalesOrder");
              break;
            case "22":
              Get.offAllNamed("/Maintenance");
              break;
            case "24":
              Get.offAllNamed("/MaintenanceMptask");
              break;
            case "32":
              Get.offAllNamed("/PortalMp");
              break;
            case "51":
              Get.offAllNamed("/PortalMpSalesOrderB2B");
              break;
            case "52":
              Get.offAllNamed("/TrainingCourse");
              break;
            case "69":
              Get.offAllNamed("/SupplychainLoadUnload");
              break;
            default:
              Get.offAllNamed("/Dashboard");
              break;
          }
        } else {
          syncData();
        }
      } else {
        Get.snackbar(
          "Error!".tr,
          "Account without valid authentication code".tr,
          icon: const Icon(
            Icons.lock,
            color: Colors.red,
          ),
        );
      }
    }
  }

  _getAuthToken(warehouseid) async {
    String ip = GetStorage().read('ip');
    String clientid = GetStorage().read('clientid');
    String roleid = GetStorage().read('roleid');
    String organizationid = GetStorage().read('organizationid');
    String authorization = 'Bearer ' + GetStorage().read('token1');
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse('$protocol://$ip/api/v1/auth/tokens');
    final msg = jsonEncode({
      "clientId": clientid,
      "roleId": roleid,
      "organizationId": organizationid,
      "warehouseId": warehouseid,
      "language": GetStorage().read('language') ?? "it_IT"
    });
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
      body: msg,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      GetStorage().write('warehouseid', warehouseid);
      // ignore: unused_local_variable
      //print(response.body);
      var json = jsonDecode(response.body);
      GetStorage().write('token', json['token']);
      GetStorage().write('userId', json['userId']);
      //Get.offAllNamed('/Dashboard');
      getLoginPermission();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Token');
    }
  }

  Future<List> _getWarehousesList(BuildContext context) async {
    String ip = GetStorage().read('ip');
    String clientid = GetStorage().read('clientid');
    String roleid = GetStorage().read('roleid');
    String organizationid = GetStorage().read('organizationid');
    String authorization = 'Bearer ' + GetStorage().read('token1');
    final protocol = GetStorage().read('protocol');
    // ignore: unused_local_variable
    List posts = [];
    var url = Uri.parse('$protocol://$ip/api/v1/auth/warehouses?client=' +
        clientid +
        '&role=' +
        roleid +
        '&organization=' +
        organizationid);

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      var json = jsonDecode(response.body);
      List posts = json['warehouses'];

      posts.removeWhere(
          (element) => (element['name'] as String).contains('Deposito'));

      if (posts.length == 1) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  Text("Syncing data with iDempiere...".tr),
                ],
              ),
            );
          },
        );
        GetStorage().write('warehouseid', posts[0]['id'].toString());
        _getAuthToken(posts[0]['id'].toString());
      }

      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load warehouse');
    }
  }

  bool userPreferencesSync = false;
  bool businessPartnerSync = false;
  bool productSync = false;
  bool jpTODOSync = false;
  bool workOrderSync = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Select Warehouse'.tr),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            height: size.height,
            width: double.infinity,
            child: FutureBuilder(
                future: _getWarehousesList(context),
                builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                    snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, index) => Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                tileColor: kPrimaryLightColor,
                                contentPadding: const EdgeInsets.all(10),
                                title: Center(
                                  child: Text(
                                    snapshot.data![index]['name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const CircularProgressIndicator(),
                                            Text(
                                                "Syncing data with iDempiere..."
                                                    .tr),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  GetStorage().write('warehouseid',
                                      snapshot.data![index]['id'].toString());
                                  _getAuthToken(
                                      snapshot.data![index]['id'].toString());
                                },
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )),
          ),
        ));
  }
}

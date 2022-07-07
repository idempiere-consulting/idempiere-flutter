import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:idempiere_app/constants.dart';

class LoginWarehouses extends StatefulWidget {
  const LoginWarehouses({Key? key}) : super(key: key);

  @override
  State<LoginWarehouses> createState() => _LoginWarehousesState();
}

class _LoginWarehousesState extends State<LoginWarehouses> {
  syncData() {
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
    if (GetStorage().read('isjpTODOSync') ?? true) {
      jpTODOSync = true;
      syncJPTODO();
    }
    if (GetStorage().read('isUserPreferencesSync') ?? true) {
      userPreferencesSync = true;
      syncUserPreferences();
    }
    if (GetStorage().read('isBusinessPartnerSync') ?? true) {
      businessPartnerSync = true;
      syncBusinessPartner();
    }
    if (GetStorage().read('isProductSync') ?? true) {
      productSync = true;
      syncProduct();
    }
    if (GetStorage().read('isWorkOrderSync') ?? true) {
      workOrderSync = true;
      syncWorkOrder();
      syncWorkOrderRefListResource();
      syncWorkOrderRefListResourceCategory();
    }
  }

  syncJPTODO() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/jp_todo');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage().write('jpTODOSync', response.body);
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
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/AD_UserPreference?\$filter= AD_User_ID eq ${GetStorage().read('userId')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage()
          .write('userPreferencesSync', utf8.decode(response.bodyBytes));
      userPreferencesSync = false;
      if (kDebugMode) {
        print('User Preferences Checked');
      }
      checkSyncData();
    }
  }

  syncBusinessPartner() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage()
          .write('businessPartnerSync', utf8.decode(response.bodyBytes));
      businessPartnerSync = false;
      if (kDebugMode) {
        print('BusinessPartner Checked');
      }
      checkSyncData();
    }
  }

  syncProduct() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage().write('productSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('Products Checked');
      }
      productSync = false;
      checkSyncData();
    }
  }

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
      GetStorage().write('workOrderSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('WorkOrder Checked');
      }
      syncWorkOrderResource();
    } else {
      workOrderSync = false;
      checkSyncData();
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
      GetStorage()
          .write('workOrderResourceSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('WorkOrderResource Checked');
      }
      syncWorkOrderResourceSurveyLines();
    } else {
      workOrderSync = false;
      checkSyncData();
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
        GetStorage()
            .write('refListResourceType', utf8.decode(response2.bodyBytes));
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
        GetStorage().write(
            'refListResourceTypeCategory', utf8.decode(response2.bodyBytes));
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
      GetStorage().write(
          'workOrderResourceSurveyLinesSync', utf8.decode(response.bodyBytes));
      if (kDebugMode) {
        print('workOrderResourceSurveyLinesSync Checked');
      }

      workOrderSync = false;
      checkSyncData();
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
        case "32":
          Get.offAllNamed("/TicketClient");
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
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/ad_user?\$filter= AD_User_ID eq $userId');

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
        List<String> list = permissions.split("-");
        GetStorage().write('permission', list);
        if (GetStorage().read('products') != null) {
          Get.offAllNamed('/Dashboard');
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

    var url = Uri.parse('$protocol://' + ip + '/api/v1/auth/tokens');
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

  Future<List> _getWarehousesList() async {
    String ip = GetStorage().read('ip');
    String clientid = GetStorage().read('clientid');
    String roleid = GetStorage().read('roleid');
    String organizationid = GetStorage().read('organizationid');
    String authorization = 'Bearer ' + GetStorage().read('token1');
    final protocol = GetStorage().read('protocol');
    // ignore: unused_local_variable
    List posts = [];
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/auth/warehouses?client=' +
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
      var posts = json['warehouses'];

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
                future: _getWarehousesList(),
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

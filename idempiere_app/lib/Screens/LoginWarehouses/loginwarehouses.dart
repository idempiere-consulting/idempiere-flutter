import 'dart:convert';
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
            children: const [
              CircularProgressIndicator(),
              Text("Syncing data with iDempiere..."),
            ],
          ),
        );
      },
    );
    if (GetStorage().read('isBusinessPartnerSync') ?? true) {
      syncBusinessPartner();
    }
    if (GetStorage().read('isProductSync') ?? true) {
      syncProduct();
    }
  }

  syncBusinessPartner() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/c_bpartner?\$filter= AD_Client_ID eq 1000000');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage().write('businessPartnerSync', response.body);
      businessPartnerSync = true;
      setState(() {
        percentage = percentage + 50;
      });
      checkSyncData();
    }
  }

  syncProduct() async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= AD_Client_ID eq 1000000');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      GetStorage().write('productSync', response.body);
      productSync = true;
      setState(() {
        percentage = percentage + 50;
      });
      checkSyncData();
    }
  }

  checkSyncData() {
    if (businessPartnerSync == true && productSync == true) {
      Get.offAllNamed("/Dashboard");
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
          "Errore!",
          "Account senza Codice di Autenticazione valido",
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

  bool businessPartnerSync = false;
  bool productSync = false;
  int percentage = 0;

  @override
  void initState() {
    super.initState();
    percentage = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Select Warehouse'),
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

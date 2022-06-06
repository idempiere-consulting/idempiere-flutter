import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/LoginOrganizations/loginorganizations_screen.dart';
import 'package:idempiere_app/constants.dart';

class LoginRoles extends StatefulWidget {
  const LoginRoles({Key? key}) : super(key: key);

  @override
  State<LoginRoles> createState() => _LoginRolesState();
}

class _LoginRolesState extends State<LoginRoles> {
  Future<List> _getRolesList() async {
    String ip = GetStorage().read('ip');
    String clientid = GetStorage().read('clientid');
    String authorization = 'Bearer ' + GetStorage().read('token1');
    final protocol = GetStorage().read('protocol');
    // ignore: unused_local_variable
    List posts = [];
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/auth/roles?client=' + clientid);

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
      var json = jsonDecode(response.body);
      var posts = json['roles'];

      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load role');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //getRoles(authorization, clientid);
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Select Roles'.tr),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            height: size.height,
            width: double.infinity,
            child: FutureBuilder(
                future: _getRolesList(),
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
                                  GetStorage().write('roleid',
                                      snapshot.data![index]['id'].toString());
                                  GetStorage().write('rolename',
                                      snapshot.data![index]['name'].toString());
                                  /* Navigator.pushNamed(
                                      context, '/loginorganization'); */
                                  Get.to(() => const LoginOrganizations());
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

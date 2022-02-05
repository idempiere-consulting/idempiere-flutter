import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:idempiere_app/Screens/LoginRoles/loginroles_screen.dart';
import 'package:idempiere_app/constants.dart';

class LoginClient extends StatefulWidget {
  const LoginClient({Key? key}) : super(key: key);

  @override
  State<LoginClient> createState() => _LoginClientState();
}

class _LoginClientState extends State<LoginClient> {
  Future<List> _getClientList() async {
    var json = jsonDecode(GetStorage().read('clientlist'));
    var posts = json['clients'];

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //getRoles(authorization, clientid);
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Select Client'),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            height: size.height,
            width: double.infinity,
            child: FutureBuilder(
                future: _getClientList(),
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
                                  GetStorage().write('clientid',
                                      snapshot.data![index]['id'].toString());
                                  GetStorage().write('clientname',
                                      snapshot.data![index]['name'].toString());
                                  /* Navigator.pushNamed(
                                      context, '/loginorganization'); */
                                  Get.to(() => const LoginRoles());
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

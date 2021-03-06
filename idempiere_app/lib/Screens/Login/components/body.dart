import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:idempiere_app/Json_Classes/Authentication/get_1st_token_json.dart';
import 'package:idempiere_app/Screens/Login/components/background.dart';
import 'package:idempiere_app/Screens/LoginClient/loginclient_screen.dart';
//import 'package:idempiere_app/Screens/LoginRoles/loginroles_screen.dart';
import 'package:idempiere_app/components/rounded_button.dart';
import 'package:idempiere_app/components/rounded_input_field.dart';
import 'package:idempiere_app/components/rounded_password_field.dart';
import 'package:idempiere_app/constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // ignore: prefer_typing_uninitialized_variables
  var checkboxState = true;
  // ignore: prefer_typing_uninitialized_variables
  var userFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var passwordFieldController;
  final ip = GetStorage().read('ip');
  final user = GetStorage().read('user');
  final password = GetStorage().read('password');

  @override
  void initState() {
    super.initState();
    userFieldController = TextEditingController();
    passwordFieldController = TextEditingController();
    checkSavedLogin();
    checkboxState = GetStorage().read('checkboxLogin') ?? true;
    if (GetStorage().read('postCallId') == null) {
      GetStorage().write('postCallId', 1);
    }
  }

  getLoginPermission() async {
    var value = "0";
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ' + GetStorage().read('token');
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
        /* print(int.parse(list[0], radix: 16)
            .toRadixString(2)
            .padLeft(4, "0")
            .toString()); */
        GetStorage().write('permission', list);
        GetStorage().write('checkboxLogin', checkboxState);
        /* DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        GetStorage().write('lastLoginDate', date.toString());
        Get.offAllNamed('/Dashboard'); */
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

  checkSavedLogin() {
    //print(GetStorage().read("maial"));
    if (user != null && password != null) {
      setState(() {
        userFieldController.text = user;
        passwordFieldController.text = password;
      });
    }
  }

  postUserData(context, checkboxState, ip) async {
    var isConnected = await checkLoginConnection();

    if (isConnected) {
      GetStorage().write("isOffline", false);
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse('$protocol://' + ip + '/api/v1/auth/tokens');
      final msg = jsonEncode({
        "userName": userFieldController.text,
        "password": passwordFieldController.text
      }); //"userName": "Flavia Lonardi", "password": "Fl@via2021"
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: msg,
      );
      var jsonFinal = LoginAuthentication.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        jsonFinal = LoginAuthentication.fromJson(jsonDecode(response.body));
        GetStorage().write('user', userFieldController.text);
        GetStorage().write('password', passwordFieldController.text);

        //int intValue = jsonFinal.clients[0].id;
        //String stringValue = intValue.toString();
        //GetStorage().write('clientid', stringValue);
        GetStorage().write('token1', jsonFinal.token);
        if (checkboxState == false &&
            GetStorage().read('ip') != null &&
            GetStorage().read('token1') != null &&
            GetStorage().read('roleid') != null &&
            GetStorage().read('organizationid') != null &&
            GetStorage().read('warehouseid') != null &&
            GetStorage().read('clientid') != null) {
          String ip = GetStorage().read('ip');
          String clientid = GetStorage().read('clientid');
          String roleid = GetStorage().read('roleid');
          String organizationid = GetStorage().read('organizationid');
          String warehouseid = GetStorage().read('warehouseid');
          String authorization = 'Bearer ' + GetStorage().read('token1');

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
            // ignore: unused_local_variable
            var json = jsonDecode(response.body);
            //print(json);
            GetStorage().write("token", json["token"]);
            GetStorage().write("userId", json["userId"]);
            //Get.offAndToNamed("/Dashboard");
            getLoginPermission();
          } else {
            // If the server did not return a 200 OK response,
            // then throw an exception.
            throw Exception('Failed to load Token');
          }
        } else {
          /* Navigator.pushNamed(
          context,
          '/loginroles',
        ); */
          GetStorage().write('checkboxLogin', checkboxState);
          GetStorage().write('clientlist', response.body);
          Get.to(() => const LoginClient());
        }
      }
    } else {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      var lastdate = GetStorage().read('lastLoginDate');

      if (date.toString() == lastdate) {
        GetStorage().write('checkboxLogin', checkboxState);
        GetStorage().write("isOffline", true);
        Get.offAllNamed('/Dashboard');
        Get.snackbar(
          "Offline!",
          "You are offline due to no internet connection, there will be limitations.".tr,
          icon: const Icon(
            Icons.wifi_lock,
            color: Colors.red,
          ),
        );
      } else {
        Get.snackbar(
          "Offline!",
          "You are offline due to no internet connection and not your last login is not recent enough.".tr,
          icon: const Icon(
            Icons.lock,
            color: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.asset(
            "assets/icons/idempiere_logo_login.png",
            height: size.height * 0.35,
          ),
          RoundedInputField(
            controller: userFieldController,
            hintText: "User",
            onChanged: (value) {},
          ),
          RoundedPasswordField(
            controller: passwordFieldController,
            onChanged: (value) {},
          ),
          RoundedButton(
            text: "LOGIN",
            press: () {
              postUserData(context, checkboxState, ip);
            },
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: size.width >= kDesktopBreakPoint
                ? size.width * 0.2
                : size.width * 0.8,
            child: CheckboxListTile(
              title: Text('Select roles'.tr),
              value: checkboxState,
              activeColor: kPrimaryColor,
              onChanged: (bool? value) {
                setState(() {
                  checkboxState = value!;
                  //GetStorage().write('checkboxLogin', checkboxState);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ],
      ),
    );
  }
}

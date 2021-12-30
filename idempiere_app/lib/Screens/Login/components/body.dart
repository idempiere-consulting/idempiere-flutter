import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idempiere_app/Json_Classes/Authentication/get_1st_token_json.dart';
import 'package:idempiere_app/Screens/Login/components/background.dart';
import 'package:idempiere_app/Screens/LoginRoles/loginroles_screen.dart';
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
  var checkboxState;
  final userFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final ip = GetStorage().read('ip');
  final user = GetStorage().read('user');
  final password = GetStorage().read('password');

  @override
  void initState() {
    super.initState();
    checkboxState = GetStorage().read('checkboxLogin') ?? false;
  }

  checkSavedLogin() {
    //print(GetStorage().read("maial"));
    if (user != null && password != null) {
      userFieldController.text = user;
      passwordFieldController.text = password;
    }
  }

  postUserData(context, checkboxState, ip) async {
    var url = Uri.parse('http://' + ip + '/api/v1/auth/tokens');
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

      int intValue = jsonFinal.clients[0].id;
      String stringValue = intValue.toString();
      GetStorage().write('clientid', stringValue);
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

        var url = Uri.parse('http://' + ip + '/api/v1/auth/tokens');
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
          Get.offAndToNamed("/Dashboard");
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
        Get.to(() => const LoginRoles());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    checkSavedLogin();
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SvgPicture.asset(
            "assets/icons/login.svg",
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
              title: const Text('Select roles'),
              value: checkboxState,
              activeColor: kPrimaryColor,
              onChanged: (bool? value) {
                setState(() {
                  checkboxState = value!;
                });
                GetStorage().write('checkboxLogin', checkboxState);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ],
      ),
    );
  }
}

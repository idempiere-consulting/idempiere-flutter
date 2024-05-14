import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/IdempiereUrlSet/idempiere_set_url.dart';
import 'package:idempiere_app/Screens/Login/login_screen.dart';
import 'package:idempiere_app/components/rounded_button.dart';
import 'package:idempiere_app/constants.dart';

import 'background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    Size size = MediaQuery.of(context).size;
    if (GetStorage().read('protocol') == null) {
      GetStorage().write('protocol', 'http');
    }
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "iDempiere Consulting",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.network(
              "$protocol://$ip/resources/templates/black/images/M_WELCOMELOGO.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN".tr,
              press: () {
                Get.to(() => const LoginScreen());
              },
            ),
            RoundedButton(
              text: "SET IDEMPIERE URL".tr,
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Get.to(() => const IdempiereUrl());
                //Navigator.pushNamed(context, '/seturl');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "build: 1.3.4.10_2024-05-10",
                  style: TextStyle(fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

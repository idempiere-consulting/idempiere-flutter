import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:idempiere_app/Screens/IdempiereUrlSet/idempiere_set_url.dart';
import 'package:idempiere_app/Screens/Login/login_screen.dart';
import 'package:idempiere_app/components/rounded_button.dart';
import 'package:idempiere_app/constants.dart';

import 'background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Get.to(() => const LoginScreen());
                //Navigator.pushNamed(context, '/loginscreen');
              },
            ),
            RoundedButton(
              text: "SET IDEMPIERE URL",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Get.to(() => const IdempiereUrl());
                //Navigator.pushNamed(context, '/seturl');
              },
            ),
          ],
        ),
      ),
    );
  }
}

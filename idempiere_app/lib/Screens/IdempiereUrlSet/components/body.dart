import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/IdempiereUrlSet/components/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idempiere_app/components/rounded_button.dart';
import 'package:idempiere_app/components/rounded_input_field.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final myController = TextEditingController();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        children: <Widget>[
          const Text(
            " ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          RoundedInputField(
            controller: myController,
            hintText: "indirizzo ip ",
            onChanged: (value) {},
          ),
          RoundedButton(
            text: "SAVE",
            press: () {
              box.write('ip', myController.text);
              /* Navigator.pop(
                context,
              ); */
              Get.back();
            },
          )
        ],
      ),
    );
  }
}

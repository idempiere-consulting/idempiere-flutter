import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/IdempiereUrlSet/components/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/components/rounded_button.dart';
import 'package:idempiere_app/components/rounded_input_field.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final json = {
    "types": [
      {"id": "it_IT", "name": "it_IT"},
      {"id": "en_US", "name": "en_US"},
    ]
  };

  changeAppLanguage(String lang) {
    switch (lang) {
      case "it_IT":
        Get.updateLocale(const Locale('it', 'IT'));
        break;
      case "en_US":
        Get.updateLocale(const Locale('en', 'US'));
        break;
      default:
    }
  }

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  late List<Types> dropDownList;
  // ignore: prefer_typing_uninitialized_variables
  var myController;
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    dropDownList = getTypes()!;
    myController = TextEditingController();
    dropdownValue = GetStorage().read('language') ?? "it_IT";
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('changelang'.tr),
              DropdownButton(
                value: dropdownValue,
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                  changeAppLanguage(dropdownValue);
                  //print(dropdownValue);
                },
                items: dropDownList.map((list) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      list.name.toString(),
                    ),
                    value: list.id,
                  );
                }).toList(),
              ),
            ],
          ),
          RoundedButton(
            text: "SAVE",
            press: () {
              GetStorage().write('ip', myController.text);
              GetStorage().write('language', dropdownValue);
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

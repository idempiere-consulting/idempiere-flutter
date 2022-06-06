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
  /* testApi() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
    }
  } */

  final json = {
    "types": [
      {"id": "it_IT", "name": "Italiano"},
      {"id": "en_US", "name": "English"},
    ]
  };

  final json2 = {
    "types": [
      {"id": "http", "name": "Http"},
      {"id": "https", "name": "Https"},
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

  List<Types>? getProtocolTypes() {
    var dJson = TypeJson.fromJson(json2);

    return dJson.types;
  }

  late List<Types> dropDownList;
  late List<Types> protocolDropDownList;
  // ignore: prefer_typing_uninitialized_variables
  var myController;
  String dropdownValue = "";
  String protocolDropdownValue = "";
  @override
  void initState() {
    super.initState();
    //testApi();
    dropDownList = getTypes()!;
    protocolDropDownList = getProtocolTypes()!;
    myController = TextEditingController();
    myController.text = GetStorage().read('ip') ?? "";
    dropdownValue = GetStorage().read('language') ?? "it_IT";
    protocolDropdownValue = GetStorage().read('protocol') ?? "http";
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
            hintText: "AddressIP".tr,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text("Protocol ".tr),
              DropdownButton(
                value: protocolDropdownValue,
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    protocolDropdownValue = newValue!;
                  });
                  GetStorage().write('protocol', protocolDropdownValue);
                  //print(dropdownValue);
                },
                items: protocolDropDownList.map((list) {
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

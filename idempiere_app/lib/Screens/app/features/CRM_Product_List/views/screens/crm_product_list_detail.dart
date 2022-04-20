import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;

import '../../../Maintenance_Mptask_resource/models/product_json.dart';

class ProductListDetail extends StatefulWidget {
  const ProductListDetail({Key? key}) : super(key: key);

  @override
  State<ProductListDetail> createState() => _ProductListDetailState();
}

class _ProductListDetailState extends State<ProductListDetail> {
  Future<void> getProduct() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= M_Product_ID eq ${args["id"]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);

      var json = ProductJson.fromJson(jsonDecode(response.body));
      valueFieldController.text = json.records![0].value;
      nameFieldController.text = json.records![0].name;
      descriptionFieldController.text = json.records![0].description ?? "";
      if (json.records![0].discontinued != true) {
        setState(() {
          flagAvailable = true;
        });
      }
      setState(() {
        flagVisible = true;
      });
    } else {
      print(response.body);
    }

    //print(list[0].eMail);

    //print(json.);
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var valueFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var helpFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var flagAvailable;
  // ignore: prefer_typing_uninitialized_variables
  var flagVisible;

  @override
  void initState() {
    flagVisible = false;
    flagAvailable = false;
    super.initState();

    nameFieldController = TextEditingController();
    valueFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    helpFieldController = TextEditingController();
    getProduct();
  }
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: valueFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Value',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: descriptionFieldController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: helpFieldController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Help',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: flagVisible,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: flagAvailable
                            ? const Text("Available")
                            : const Text("Not Available"),
                        style: ButtonStyle(
                          backgroundColor: flagAvailable
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.red),
                        ),
                      )),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return const Text("desktop visual WIP");
          },
          desktopBuilder: (context, constraints) {
            return const Text("tablet visual WIP");
          },
        ),
      ),
    );
  }
}

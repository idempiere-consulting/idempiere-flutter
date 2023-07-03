// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
//import 'dart:developer';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/infocount_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/models/product_unloaded_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';

class MaintenanceMptaskProductUnloaded extends StatefulWidget {
  const MaintenanceMptaskProductUnloaded({Key? key}) : super(key: key);

  @override
  State<MaintenanceMptaskProductUnloaded> createState() =>
      _MaintenanceMptaskInfoState();
}

class _MaintenanceMptaskInfoState
    extends State<MaintenanceMptaskProductUnloaded> {
  getProductsUnloaded() async {
    //print('hello');
    setState(() {
      dataAvailable = false;
    });
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '${'$protocol://' + ip}/api/v1/models/lit_draftjournal_v?\$filter=  MP_Maintain_ID eq ${Get.arguments["id"]}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      trx = ProductUnloadedJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        dataAvailable = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  deleteProductUnloaded(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('${'$protocol://' + ip}/api/v1/models/lit_draftjournal/$id');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      getProductsUnloaded();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  bool dataAvailable = false;
  ProductUnloadedJSON trx = ProductUnloadedJSON(records: []);

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getProductsUnloaded();
    //getWorkOrderInfo();
    //print('hello');
  }

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(Get.arguments["docN"]),
              Text('Product Unloaded'.tr),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                dataAvailable
                    ? ListView.builder(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: trx.records!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Delete record'.tr,
                                    onPressed: () {
                                      deleteProductUnloaded(
                                          trx.records![index].id!);
                                      //log("info button pressed");
                                    },
                                  ),
                                ),
                                title: Text(
                                  trx.records![index].mPMaintainResourceID
                                          ?.identifier ??
                                      "N/A",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Row(
                                  children: <Widget>[
                                    const Icon(Icons.linear_scale,
                                        color: Colors.yellowAccent),
                                    Expanded(
                                      child: Text(
                                        trx.records![index].mProductID
                                                ?.identifier ??
                                            "N/A",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                /* trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30.0,
                                  ), */
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                children: [
                                  Column(
                                    children: [],
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : CircularProgressIndicator(),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
        ),
      ),
    );
  }
}

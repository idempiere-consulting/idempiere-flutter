import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource/models/employeepresence_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

class HumanResourceAttendanceListScreen extends StatefulWidget {
  const HumanResourceAttendanceListScreen({Key? key}) : super(key: key);

  @override
  State<HumanResourceAttendanceListScreen> createState() =>
      _HumanResourceAttendanceListScreenState();
}

class _HumanResourceAttendanceListScreenState
    extends State<HumanResourceAttendanceListScreen> {
  Future<void> getEmployeesPresence() async {
    setState(() {});
    employeePresenceAvailable = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_empl_presence_v?\$filter= presente neq \'SAB/DOM\'${args['organizationId'] != "" ? " and AD_Org_ID eq ${args['organizationId']}" : ""}${args['employeeId'] != 0 ? " and AD_User2_ID eq ${args['employeeId']}" : ""}${args['type'] != "0" ? " and presente eq '${args['type']}'" : ""}${args["dateRange"]}${args['type'] == "ATTENDED".tr ? " and DailyCapacity neq Qty" : ""}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //print(args['type']);
      employeePresence = EmployeePresenceJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      /* employeePresence.records!
          .removeWhere((element) => element.presente == 'SAB/DOM'); */

      for (var element in employeePresence.records!) {
        if (orgList.isEmpty) {
          orgList.add(element.aDOrgID!.identifier!);
          orgListId.add(element.aDOrgID!.id!);
        }
        if ((orgList
            .where((record) => record == element.aDOrgID!.identifier!)
            .isEmpty)) {
          orgList.add(element.aDOrgID!.identifier!);
          orgListId.add(element.aDOrgID!.id!);
        }
      }

      setState(() {
        employeePresenceAvailable = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  var args = Get.arguments;

  EmployeePresenceJSON employeePresence = EmployeePresenceJSON(records: []);

  List<String> orgList = [];

  List<int> orgListId = [];

  bool employeePresenceAvailable = false;
  @override
  void initState() {
    super.initState();
    employeePresenceAvailable = false;
    getEmployeesPresence();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Attendance'.tr),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: orgList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          child: ExpansionTile(
                            title: Text(
                              orgList[index],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            childrenPadding: const EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            children: [
                              ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: employeePresence.records!.length,
                                  itemBuilder:
                                      (BuildContext context, int index2) {
                                    return orgListId[index] ==
                                            employeePresence
                                                .records![index2].aDOrgID?.id
                                        ? ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: kSpacing),
                                            leading: Text(
                                              employeePresence
                                                  .records![index2].presente!,
                                              style: TextStyle(
                                                  color: employeePresence
                                                                  .records![
                                                                      index2]
                                                                  .presente ==
                                                              'PRESENTE' &&
                                                          (employeePresence
                                                                          .records![
                                                                              index2]
                                                                          .qty ??
                                                                      0)
                                                                  .toDouble() !=
                                                              (employeePresence
                                                                          .records![
                                                                              index2]
                                                                          .dailyCapacity ??
                                                                      0)
                                                                  .toDouble()
                                                      ? Colors.yellow
                                                      : employeePresence
                                                                  .records![
                                                                      index2]
                                                                  .presente ==
                                                              'PRESENTE'
                                                          ? kNotifColor
                                                          : employeePresence
                                                                      .records![
                                                                          index2]
                                                                      .presente ==
                                                                  'ASSENTE'
                                                              ? Colors.redAccent
                                                              : Colors.yellow),
                                            ),
                                            title: Text(
                                              employeePresence.records![index2]
                                                      .aDUser2ID?.identifier ??
                                                  'N/A',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: kFontColorPallets[0],
                                              ),
                                            ),
                                            subtitle: Text(
                                              employeePresence
                                                  .records![index2].day!
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: kFontColorPallets[2],
                                              ),
                                            ),
                                            trailing: Text(
                                                '${employeePresence.records![index2].qty ?? 0} Ore'),
                                          )
                                        : const SizedBox();
                                  }),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

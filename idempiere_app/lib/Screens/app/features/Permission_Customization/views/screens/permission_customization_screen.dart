// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/lead.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_create_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_edit_leads.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_create_tasks.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_lead_filters_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/salestagejson.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/list_profil_image.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_report_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/project_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/shared_components/search_field.dart';
import 'package:idempiere_app/Screens/app/shared_components/selection_button.dart';
import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/today_text.dart';
import 'package:idempiere_app/Screens/app/utils/helpers/app_helpers.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/permission_customization_binding.dart';

// controller
part '../../controllers/permission_customization_controller.dart';

// models
part '../../models/profile.dart';

// component
//part '../components/active_project_card.dart';
part '../components/header.dart';
//part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class PermissionCustomizationScreen
    extends GetView<PermissionCustomizationController> {
  const PermissionCustomizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        drawer: /* (ResponsiveBuilder.isDesktop(context))
            ? null
            : */
            Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: kSpacing),
            child: _Sidebar(data: controller.getSelectedProject()),
          ),
        ),
        body: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),

                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: FutureBuilder(
                    future: controller.getAllLoginUsers(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<CRecords>> snapshot) =>
                        snapshot.hasData
                            ? TypeAheadField<CRecords>(
                                direction: AxisDirection.down,
                                //getImmediateSuggestions: true,
                                textFieldConfiguration: TextFieldConfiguration(
                                  onChanged: (value) {
                                    if (value == "") {
                                      controller.userId = 0;
                                    }
                                  },
                                  controller: controller.userFieldController,
                                  //autofocus: true,

                                  decoration: InputDecoration(
                                    labelText: 'User'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.search),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  return snapshot.data!.where((element) =>
                                      (element.name ?? "")
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    //leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.name ?? ""),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  controller.userFieldController.text =
                                      suggestion.name!;
                                  controller.userId = suggestion.id!;
                                  controller.hexToBinPermissionString(
                                      suggestion.litmobilerole ?? "");
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            controller.binToHexPermissionString();
                          },
                          child: Text("Save".tr)),
                      ElevatedButton(
                          onPressed: () {
                            controller.copyPermissionFromUser();
                          },
                          child: Text("Copy From".tr)),
                    ],
                  ),
                ),

                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[0].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[0].value = value!;
                              controller.binaryPermList[0] =
                                  "${controller.binaryPermList[0].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[0].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [],
                    ),
                  ),
                ),

                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'CRM',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[2].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[2].value = value!;
                              controller.binaryPermList[2] =
                                  "${controller.binaryPermList[2].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[2].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Ordine di V.',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[50].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[50].value = value!;
                                controller.binaryPermList[50] =
                                    "${controller.binaryPermList[50].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[50].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Lead',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[3].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[3].value = value!;
                                controller.binaryPermList[3] =
                                    "${controller.binaryPermList[3].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[3].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Contatti',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[4].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[4].value = value!;
                                controller.binaryPermList[4] =
                                    "${controller.binaryPermList[4].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[4].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Clienti',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[5].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[5].value = value!;
                                controller.binaryPermList[5] =
                                    "${controller.binaryPermList[5].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[5].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Task',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[6].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[6].value = value!;
                                controller.binaryPermList[6] =
                                    "${controller.binaryPermList[6].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[6].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Opportunità',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[7].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[7].value = value!;
                                controller.binaryPermList[7] =
                                    "${controller.binaryPermList[7].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[7].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Offerta di Vendita',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[8].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[8].value = value!;
                                controller.binaryPermList[8] =
                                    "${controller.binaryPermList[8].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[8].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Listino Prodotti',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[9].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[9].value = value!;
                                controller.binaryPermList[9] =
                                    "${controller.binaryPermList[9].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[9].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Documento di Trasporto',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[10].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[10].value = value!;
                                controller.binaryPermList[10] =
                                    "${controller.binaryPermList[10].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[10].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Fattura di Vendita',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[11].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[11].value = value!;
                                controller.binaryPermList[11] =
                                    "${controller.binaryPermList[11].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[11].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Incasso',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[12].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[12].value = value!;
                                controller.binaryPermList[12] =
                                    "${controller.binaryPermList[12].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[12].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Provvigione',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Lettura'.tr),
                              value: controller.boolAccessList[13].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[13].value = value!;
                                controller.binaryPermList[13] =
                                    "${controller.binaryPermList[13].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[13].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Partite Aperte',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Lettura'.tr),
                              value: controller.boolAccessList[14].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[14].value = value!;
                                controller.binaryPermList[14] =
                                    "${controller.binaryPermList[14].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[14].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Listino Prezzi',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Lettura'.tr),
                              value: controller.boolAccessList[15].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[15].value = value!;
                                controller.binaryPermList[15] =
                                    "${controller.binaryPermList[15].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[15].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Contratti di Vendita',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Lettura'.tr),
                              value: controller.boolAccessList[21].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[21].value = value!;
                                controller.binaryPermList[21] =
                                    "${controller.binaryPermList[21].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[21].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'POS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Lettura'.tr),
                              value: controller.boolAccessList[126].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[126].value = value!;
                                controller.binaryPermList[126] =
                                    "${controller.binaryPermList[126].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[126].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Scrivania',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[16].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[16].value = value!;
                              controller.binaryPermList[16] =
                                  "${controller.binaryPermList[16].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[16].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Gestione Documenti',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[20].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[20].value = value!;
                                controller.binaryPermList[20] =
                                    "${controller.binaryPermList[20].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[20].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Manutenzione',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[22].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[22].value = value!;
                              controller.binaryPermList[22] =
                                  "${controller.binaryPermList[22].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[22].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Calendario',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[0].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[0].value = value!;
                                controller.binaryPermList[0] =
                                    "${controller.binaryPermList[0].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[0].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Ordini di lavoro',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[24].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[24].value = value!;
                                controller.binaryPermList[24] =
                                    "${controller.binaryPermList[24].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[24].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Worck Order',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[31].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[31].value = value!;
                                controller.binaryPermList[31] =
                                    "${controller.binaryPermList[31].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[31].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Anomalia',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[25].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[25].value = value!;
                                controller.binaryPermList[25] =
                                    "${controller.binaryPermList[25].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[25].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Mag. furgone',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[26].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[26].value = value!;
                                controller.binaryPermList[26] =
                                    "${controller.binaryPermList[26].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[26].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Prelievo magazzino',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[27].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[27].value = value!;
                                controller.binaryPermList[27] =
                                    "${controller.binaryPermList[27].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[27].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Shipment customer',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[10].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[10].value = value!;
                                controller.binaryPermList[10] =
                                    "${controller.binaryPermList[10].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[10].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Carico scheda Tecnica',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[29].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[29].value = value!;
                                controller.binaryPermList[29] =
                                    "${controller.binaryPermList[29].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[29].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Impianto di Manutenzione',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[30].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[30].value = value!;
                                controller.binaryPermList[30] =
                                    "${controller.binaryPermList[30].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[30].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Portale Cliente',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[32].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[32].value = value!;
                              controller.binaryPermList[32] =
                                  "${controller.binaryPermList[32].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[32].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Formazione e Corso',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[43].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[43].value = value!;
                                controller.binaryPermList[43] =
                                    "${controller.binaryPermList[43].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[43].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Ordine di Vendita B2B',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[51].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[51].value = value!;
                                controller.binaryPermList[51] =
                                    "${controller.binaryPermList[51].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[51].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Acquisti',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[58].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[58].value = value!;
                              controller.binaryPermList[58] =
                                  "${controller.binaryPermList[58].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[58].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Lead Fornitori',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[59].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[59].value = value!;
                                controller.binaryPermList[59] =
                                    "${controller.binaryPermList[59].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[59].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Contratto di Acquisto',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[62].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[62].value = value!;
                                controller.binaryPermList[62] =
                                    "${controller.binaryPermList[62].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[62].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Richiesta di Acquisto',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[62].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[62].value = value!;
                                controller.binaryPermList[62] =
                                    "${controller.binaryPermList[62].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[62].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Logistica',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[63].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[63].value = value!;
                              controller.binaryPermList[63] =
                                  "${controller.binaryPermList[63].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[63].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Prodotto',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[64].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[64].value = value!;
                                controller.binaryPermList[64] =
                                    "${controller.binaryPermList[64].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[64].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Inventario',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[68].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[68].value = value!;
                                controller.binaryPermList[68] =
                                    "${controller.binaryPermList[68].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[68].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Entrata Merce',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[66].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[66].value = value!;
                                controller.binaryPermList[66] =
                                    "${controller.binaryPermList[66].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[66].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Carico/Scarico',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[69].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[69].value = value!;
                                controller.binaryPermList[69] =
                                    "${controller.binaryPermList[69].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[69].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Inventario con Lotto',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[70].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[70].value = value!;
                                controller.binaryPermList[70] =
                                    "${controller.binaryPermList[70].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[70].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Cambio Impinato del Disp.',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[71].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[71].value = value!;
                                controller.binaryPermList[71] =
                                    "${controller.binaryPermList[71].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[71].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Manutenzione blocco e sblocco contenitore',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[72].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[72].value = value!;
                                controller.binaryPermList[72] =
                                    "${controller.binaryPermList[72].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[72].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Produzione',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[77].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[77].value = value!;
                              controller.binaryPermList[77] =
                                  "${controller.binaryPermList[77].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[77].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Ordine di produzione',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[78].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[78].value = value!;
                                controller.binaryPermList[78] =
                                    "${controller.binaryPermList[78].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[78].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Stato avanzamento produzione',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[82].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[82].value = value!;
                                controller.binaryPermList[82] =
                                    "${controller.binaryPermList[82].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[82].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Risorse Umane',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[94].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[94].value = value!;
                              controller.binaryPermList[94] =
                                  "${controller.binaryPermList[94].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[94].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Scheda dipendente',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[99].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[99].value = value!;
                                controller.binaryPermList[99] =
                                    "${controller.binaryPermList[99].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[99].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Dipendente',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[105].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[105].value = value!;
                              controller.binaryPermList[105] =
                                  "${controller.binaryPermList[105].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[105].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Formazione e Corso',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[52].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[52].value = value!;
                              controller.binaryPermList[52] =
                                  "${controller.binaryPermList[52].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[52].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Presenza Corsi',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[53].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[53].value = value!;
                                controller.binaryPermList[53] =
                                    "${controller.binaryPermList[53].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[53].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Quiz',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[54].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[54].value = value!;
                                controller.binaryPermList[54] =
                                    "${controller.binaryPermList[54].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[54].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Analisi test',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[55].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[55].value = value!;
                                controller.binaryPermList[55] =
                                    "${controller.binaryPermList[55].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[55].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Lista corsi',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[56].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[56].value = value!;
                                controller.binaryPermList[56] =
                                    "${controller.binaryPermList[56].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[56].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Accounting',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[85].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[85].value = value!;
                              controller.binaryPermList[85] =
                                  "${controller.binaryPermList[85].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[85].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Cespite',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[131].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[131].value = value!;
                                controller.binaryPermList[131] =
                                    "${controller.binaryPermList[131].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[131].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ExpansionTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Progetto',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: Text('Accesso'.tr),
                            value: controller.boolAccessList[135].value,
                            activeColor: kPrimaryColor,
                            onChanged: (bool? value) {
                              controller.boolAccessList[135].value = value!;
                              controller.binaryPermList[135] =
                                  "${controller.binaryPermList[135].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[135].substring(2)}";
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Cespite',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
                            CheckboxListTile(
                              title: Text('Accesso'.tr),
                              value: controller.boolAccessList[131].value,
                              activeColor: kPrimaryColor,
                              onChanged: (bool? value) {
                                controller.boolAccessList[131].value = value!;
                                controller.binaryPermList[131] =
                                    "${controller.binaryPermList[131].substring(0, 1)}${value ? "1" : "0"}${controller.binaryPermList[131].substring(2)}";
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */

                //const SizedBox(height: kSpacing),
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */

                //const SizedBox(height: kSpacing),
              ]);
            },
            desktopBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader2(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                /* _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing), */

                //const SizedBox(height: kSpacing),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const Expanded(child: _Header()),
        ],
      ),
    );
  }

  Widget _buildHeader2({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          Row(
            children: [
              if (onPressedMenu != null)
                Padding(
                  padding: const EdgeInsets.only(right: kSpacing),
                  child: IconButton(
                    onPressed: onPressedMenu,
                    icon: const Icon(EvaIcons.menu),
                    tooltip: "menu",
                  ),
                ),
              Expanded(
                child: _ProfilTile(
                  data: controller.getProfil(),
                  onPressedNotification: () {},
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Expanded(child: _Header()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalUndone: 10,
                      totalTaskInProress: 2,
                    ),
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "1st Sprint",
                      doneTask: 5,
                      percent: .3,
                      task: 3,
                      undoneTask: 2,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalUndone: 10,
                    totalTaskInProress: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "1st Sprint",
                    doneTask: 5,
                    percent: .3,
                    task: 3,
                    undoneTask: 2,
                  ),
                ),
              ],
            ),
    );
  }

  /* Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: _OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget _buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  } */

  Widget _buildProfile({required _Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ProfilTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }

  Widget _buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }
}

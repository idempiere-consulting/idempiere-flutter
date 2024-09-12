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
                      title: const Text(
                        'CRM',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
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
                      title: const Text(
                        'Scrivania',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      childrenPadding: const EdgeInsets.all(10),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Ticket',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: const EdgeInsets.all(10),
                          children: [
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

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/project_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/shared_components/search_field.dart';
import 'package:idempiere_app/Screens/app/shared_components/selection_button.dart';
import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/today_text.dart';
import 'package:idempiere_app/Screens/app/utils/helpers/app_helpers.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:http/http.dart' as http;

// binding
part '../../bindings/maintenance_mptask_resource_fire_extinguisher_binding.dart';

// controller
part '../../controllers/maintenance_mptask_resource_fire_extinguisher_controller.dart';

// models
part '../../models/profile.dart';

// component
part '../components/active_project_card.dart';
part '../components/header.dart';
part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class MaintenanceMpResourceFireExtinguisherScreen
    extends GetView<MaintenanceMpResourceFireExtinguisherController> {
  const MaintenanceMpResourceFireExtinguisherScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                /* List<PlutoRow> newRows = [];
                //controller.handleAddRows();
                PlutoRow row = PlutoRow(cells: {
                  'N°': PlutoCell(value: '1'),
                  'Location': PlutoCell(value: 'tetto'),
                  'Barcode': PlutoCell(value: '1238121039'),
                  'SerialNo': PlutoCell(value: 'm23456nv'),
                  'Cartel': PlutoCell(value: 'cartello n 25 x estintori'),
                  'Manufacturer': PlutoCell(value: 'Colombini'),
                  'Year': PlutoCell(value: 2015),
                  'ShutDownType': PlutoCell(value: 'A'),
                  'Type': PlutoCell(value: 'INOX'),
                  'Check': PlutoCell(value: '2022-12-24'),
                  'Revision': PlutoCell(value: '2022-12-25'),
                  'Testing': PlutoCell(value: '2022-12-26'),
                  'Observations': PlutoCell(value: 'non funziona niente :c'),
                });

                newRows.add(row);

                controller.stateManager.appendRows(newRows); */
              },
              icon: const Icon(Icons.delete_sweep_rounded),
            ),
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            Text("${GetStorage().read('selectedTaskDocNo')}"),
            Text("${GetStorage().read('selectedTaskBP')}"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Container(
              height: size.height,
              width: size.width,
              //padding: const EdgeInsets.all(15),
              child: PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                columnGroups: controller.columnGroups,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  controller.stateManager = event.stateManager;
                  controller.getWorkOrders();
                },
                onChanged: (PlutoGridOnChangedEvent event) {
                  controller.handleEditTextRows(
                      event.row?.cells['id']?.value,
                      event.value,
                      event.column!.field,
                      event.row?.cells['index']?.value);
                },
                configuration: const PlutoGridConfiguration(
                  enableColumnBorder: true,
                ),
              ),
            );
          },
          tabletBuilder: (context, constraints) {
            return Container(
              height: size.height,
              width: size.width,
              //padding: const EdgeInsets.all(15),
              child: PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                columnGroups: controller.columnGroups,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  controller.stateManager = event.stateManager;
                  controller.getWorkOrders();
                },
                onChanged: (PlutoGridOnChangedEvent event) {
                  controller.handleEditTextRows(
                      event.row?.cells['id']?.value,
                      event.value,
                      event.column!.field,
                      event.row?.cells['index']?.value);
                },
                configuration: const PlutoGridConfiguration(
                  enableColumnBorder: true,
                ),
              ),
            );
          },
          desktopBuilder: (context, constraints) {
            return Container(
              height: size.height,
              width: size.width,
              //padding: const EdgeInsets.all(15),
              child: PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                columnGroups: controller.columnGroups,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  controller.stateManager = event.stateManager;
                  controller.getWorkOrders();
                },
                onChanged: (PlutoGridOnChangedEvent event) {
                  controller.handleEditTextRows(
                      event.row?.cells['id']?.value,
                      event.value,
                      event.column!.field,
                      event.row?.cells['index']?.value);
                },
                configuration: const PlutoGridConfiguration(
                  enableColumnBorder: true,
                ),
              ),
            );
          },
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
}
